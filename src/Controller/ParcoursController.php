<?php

namespace App\Controller;

use App\Entity\ContactMessage;
use App\Entity\StatConversion;
use App\Repository\StatSessionRepository;
use App\Service\DossierCatalogue;
use App\Service\RecaptchaValidator;
use App\Service\SeoService;
use App\Service\SiteContext;
use App\Service\SystemMailerService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\RateLimiter\RateLimiterFactory;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Pages de parcours de l'etude.
 *
 * Elles partent du besoin plutot que de la branche du droit : un visiteur qui
 * veut vendre une maison n'a pas a savoir que cela releve du droit immobilier.
 * Leur mise en page vient du lot livre, elles sont donc servies par des
 * gabarits et non par le contenu editorial.
 *
 * Les deux formulaires du lot n'etaient pas branches : l'un n'avait pas
 * d'action, l'autre appelait un script PHP autonome qui passait par mail().
 * Ils rejoignent ici la mecanique du CMS -- pot de miel, limitation de
 * cadence, reCAPTCHA, message en base et conversion statistique -- pour que
 * l'etude retrouve ses demandes dans son administration.
 */
class ParcoursController extends AbstractController
{
    /** Les motifs proposes a la prise de rendez-vous, repris du lot. */
    private const OBJETS = [
        'Vente ou acquisition immobilière',
        'Succession',
        'Donation / transmission',
        'Couple / mariage / PACS',
        'Patrimoine / SCI',
        'Entreprise',
        'Droit rural',
        'Autre demande',
    ];

    /** Les preferences d'horaire proposees, reprises du lot. */
    private const PREFERENCES = ['Matin', 'Après-midi', 'Indifférent'];

    public function __construct(
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/votre-projet', name: 'app_votre_projet')]
    public function votreProjet(): Response
    {
        return $this->render('parcours/votre-projet.html.twig', [
            'title_page' => 'Votre projet',
            'seo' => $this->seoService->resolveForPage('Votre projet'),
        ]);
    }

    #[Route('/prendre-rendez-vous', name: 'app_rendez_vous', methods: ['GET', 'POST'])]
    public function rendezVous(
        Request $request,
        RecaptchaValidator $recaptcha,
        SystemMailerService $mailer,
        SiteContext $siteContext,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        #[Autowire(service: 'limiter.contact_limiter')] RateLimiterFactory $limiter,
    ): Response {
        $erreurs = [];

        if ($request->isMethod('POST')) {
            $reponse = $this->traiterRendezVous($request, $recaptcha, $mailer, $siteContext, $em, $sessions, $limiter, $erreurs);
            if (null !== $reponse) {
                return $reponse;
            }
        }

        return $this->render('parcours/rendez-vous.html.twig', [
            'title_page' => 'Prendre rendez-vous',
            'objets' => self::OBJETS,
            'preferences' => self::PREFERENCES,
            'seo' => $this->seoService->resolveForPage('Prendre rendez-vous'),
            'recaptcha_site_key' => $recaptcha->isEnabled() ? $recaptcha->getSiteKey() : null,
            'saisie' => $request->isMethod('POST') ? $request->request->all() : [],
            'erreurs' => $erreurs,
            'envoye' => $request->query->getBoolean('envoye'),
        ]);
    }

    /**
     * Rend une redirection quand la demande est partie, null pour reafficher
     * le formulaire avec ses erreurs et la saisie du visiteur.
     *
     * Les messages restent dans la page : le CMS affiche ses alertes au-dessus
     * du contenu, donc par-dessus le bandeau sombre de cette page.
     *
     * @param list<string> $erreurs
     */
    private function traiterRendezVous(
        Request $request,
        RecaptchaValidator $recaptcha,
        SystemMailerService $mailer,
        SiteContext $siteContext,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        RateLimiterFactory $limiter,
        array &$erreurs,
    ): ?Response {
        if (!$this->isCsrfTokenValid('rendez_vous', (string) $request->request->get('_token'))) {
            $erreurs[] = 'Votre session a expiré. Merci de renvoyer votre demande.';

            return null;
        }

        // Pot de miel : le champ est hors ecran, seul un robot le remplit.
        // On remercie sans rien enregistrer, pour ne pas le renseigner.
        if ('' !== trim((string) $request->request->get('website', ''))) {
            return $this->redirectToRoute('app_rendez_vous', ['envoye' => 1]);
        }

        if (!$recaptcha->validate($request->request->get('g-recaptcha-response'), 'contact')) {
            $erreurs[] = 'La vérification anti-spam a échoué. Veuillez réessayer.';

            return null;
        }

        if (!$limiter->create($request->getClientIp())->consume()->isAccepted()) {
            $erreurs[] = 'Trop de demandes envoyées. Veuillez réessayer dans quelques minutes.';

            return null;
        }

        $nom = trim((string) $request->request->get('nom', ''));
        $telephone = trim((string) $request->request->get('telephone', ''));
        $email = trim((string) $request->request->get('email', ''));
        $objet = trim((string) $request->request->get('objet', ''));
        $jour = trim((string) $request->request->get('jour', ''));
        $preference = trim((string) $request->request->get('preference', ''));
        $message = trim((string) $request->request->get('message', ''));

        if ('' === $nom || mb_strlen($nom) > 100) {
            $erreurs[] = 'Merci d’indiquer votre nom et votre prénom.';
        }
        if ('' === $telephone || mb_strlen($telephone) > 30) {
            $erreurs[] = 'Merci d’indiquer un numéro de téléphone.';
        }
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $erreurs[] = 'Merci d’indiquer une adresse e-mail valide.';
        }
        if (!in_array($objet, self::OBJETS, true)) {
            $erreurs[] = 'Merci de choisir l’objet de votre rendez-vous.';
        }
        if ('' !== $jour && !$this->estUneDate($jour)) {
            $erreurs[] = 'Le jour souhaité n’est pas une date valide.';
        }
        if ('' !== $preference && !in_array($preference, self::PREFERENCES, true)) {
            $erreurs[] = 'La préférence d’horaire n’est pas reconnue.';
        }
        if (mb_strlen($message) > 3000) {
            $erreurs[] = 'Votre message dépasse la longueur autorisée.';
        }

        if ($erreurs) {
            return null;
        }

        $corps = [
            'Téléphone' => $telephone,
            'Objet du rendez-vous' => $objet,
            'Jour souhaité' => '' !== $jour ? $jour : 'Non précisé',
            'Préférence' => '' !== $preference ? $preference : 'Non précisée',
        ];

        $html = '';
        foreach ($corps as $intitule => $valeur) {
            $html .= sprintf(
                '<p><strong>%s :</strong> %s</p>',
                htmlspecialchars($intitule, ENT_QUOTES, 'UTF-8'),
                htmlspecialchars($valeur, ENT_QUOTES, 'UTF-8')
            );
        }
        $html .= sprintf(
            '<p><strong>Demandeur :</strong> %s (%s)</p><hr><p>%s</p>',
            htmlspecialchars($nom, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars($email, ENT_QUOTES, 'UTF-8'),
            '' !== $message ? nl2br(htmlspecialchars($message, ENT_QUOTES, 'UTF-8')) : 'Aucune précision.'
        );

        $destinataire = $siteContext->getCurrentSite()?->getEmail() ?? 'contact@comwebsolutions.fr';
        $mailer->send(
            $mailer->createEmail(sprintf('[%s] Rendez-vous : %s', $mailer->getSiteName(), $objet))
                ->replyTo($email)
                ->to($destinataire)
                ->html($html)
        );

        $texte = '';
        foreach ($corps as $intitule => $valeur) {
            $texte .= $intitule.' : '.$valeur."\n";
        }
        $texte .= "\n".('' !== $message ? $message : 'Aucune précision.');

        $this->enregistrer($request, $em, $sessions, [
            'nom' => $nom,
            'email' => $email,
            'sujet' => 'Rendez-vous : '.$objet,
            'message' => $texte,
            'conversion' => 'Rendez-vous : '.$objet,
        ]);

        return $this->redirectToRoute('app_rendez_vous', ['envoye' => 1]);
    }

    #[Route('/demarrer-un-dossier', name: 'app_demarrer_dossier')]
    public function demarrerDossier(DossierCatalogue $catalogue, RecaptchaValidator $recaptcha): Response
    {
        return $this->render('parcours/demarrer-dossier.html.twig', [
            'title_page' => 'Démarrer un dossier',
            'entrees' => $catalogue->entrees(),
            'catalogue' => $catalogue->all(),
            'seo' => $this->seoService->resolveForPage('Démarrer un dossier'),
            'recaptcha_site_key' => $recaptcha->isEnabled() ? $recaptcha->getSiteKey() : null,
        ]);
    }

    /**
     * Transmission de la preparation construite par le questionnaire.
     *
     * Le navigateur poste ses reponses ; les intitules des questions et la
     * liste des pieces, eux, sont relus dans le catalogue a partir de la cle
     * du projet. Rien de ce qui part dans le courriel ne vient de la requete
     * sans avoir ete reconnu.
     */
    #[Route('/demarrer-un-dossier/transmettre', name: 'app_demarrer_dossier_envoi', methods: ['POST'])]
    public function transmettreDossier(
        Request $request,
        DossierCatalogue $catalogue,
        RecaptchaValidator $recaptcha,
        SystemMailerService $mailer,
        SiteContext $siteContext,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        #[Autowire(service: 'limiter.contact_limiter')] RateLimiterFactory $limiter,
    ): JsonResponse {
        $refus = static fn (int $code, string $message) => new JsonResponse(
            ['ok' => false, 'message' => $message],
            $code
        );

        if (!$this->isCsrfTokenValid('demarrer_dossier', (string) $request->request->get('_token'))) {
            return $refus(403, 'Votre session a expiré. Merci de recharger la page.');
        }

        if ('' !== trim((string) $request->request->get('website', ''))) {
            return $refus(400, 'Envoi refusé.');
        }

        if (!$recaptcha->validate($request->request->get('g-recaptcha-response'), 'contact')) {
            return $refus(400, 'La vérification anti-spam a échoué. Veuillez réessayer.');
        }

        if (!$limiter->create($request->getClientIp())->consume()->isAccepted()) {
            return $refus(429, 'Trop de demandes envoyées. Veuillez réessayer dans quelques minutes.');
        }

        $cle = (string) $request->request->get('projet', '');
        $parcours = $catalogue->get($cle);
        if (null === $parcours) {
            return $refus(422, 'Le projet choisi n’est pas reconnu.');
        }

        $nom = trim((string) $request->request->get('nom', ''));
        $telephone = trim((string) $request->request->get('telephone', ''));
        $email = trim((string) $request->request->get('email', ''));
        $message = trim((string) $request->request->get('message', ''));

        if ('' === $nom || mb_strlen($nom) > 100 || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return $refus(422, 'Veuillez vérifier votre nom et votre adresse e-mail.');
        }
        if (!$request->request->getBoolean('consentement')) {
            return $refus(422, 'Veuillez confirmer la transmission à l’étude.');
        }

        $reponses = $catalogue->relire($cle, $request->request->all('reponses'));
        $cochees = $catalogue->pieces($cle, $request->request->all('pieces'));
        $message = mb_substr($message, 0, 3000);

        $html = sprintf(
            '<p><strong>Projet :</strong> %s</p><p><strong>Demandeur :</strong> %s (%s)</p><p><strong>Téléphone :</strong> %s</p>',
            htmlspecialchars($parcours['label'], ENT_QUOTES, 'UTF-8'),
            htmlspecialchars($nom, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars($email, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars('' !== $telephone ? $telephone : 'Non précisé', ENT_QUOTES, 'UTF-8')
        );
        $html .= '<hr><p><strong>Réponses</strong></p>'.$this->liste(array_map(
            static fn (array $ligne) => $ligne[0].' : '.$ligne[1],
            $reponses
        ), 'Aucune réponse complémentaire.');
        $html .= '<p><strong>Précision</strong></p><p>'
            .('' !== $message ? nl2br(htmlspecialchars($message, ENT_QUOTES, 'UTF-8')) : 'Aucune précision.').'</p>';
        $html .= '<p><strong>Pièces indicatives</strong></p>'.$this->liste($parcours['docs'], 'Aucune.');
        if ($cochees) {
            $html .= '<p><strong>Pièces cochées par le visiteur</strong></p>'.$this->liste($cochees, '');
        }

        $destinataire = $siteContext->getCurrentSite()?->getEmail() ?? 'contact@comwebsolutions.fr';
        $sujet = sprintf('[%s] Préparation de dossier — %s', $mailer->getSiteName(), $parcours['label']);

        $mailer->send(
            $mailer->createEmail($sujet)->replyTo($email)->to($destinataire)->html($html)
        );

        // Copie au visiteur, uniquement s'il l'a demandee.
        if ($request->request->getBoolean('copie')) {
            $mailer->send(
                $mailer->createEmail('Votre préparation de dossier — '.$mailer->getSiteName())
                    ->to($email)
                    ->html('<p>Bonjour '.htmlspecialchars($nom, ENT_QUOTES, 'UTF-8').',</p>'
                        .'<p>Voici la copie de la préparation que vous venez de transmettre à l’étude.</p>'
                        .'<hr>'.$html)
            );
        }

        $texte = 'Projet : '.$parcours['label']."\nTéléphone : ".('' !== $telephone ? $telephone : 'Non précisé')."\n\n";
        foreach ($reponses as [$intitule, $valeur]) {
            $texte .= $intitule.' : '.$valeur."\n";
        }
        if ('' !== $message) {
            $texte .= "\nPrécision : ".$message."\n";
        }
        if ($cochees) {
            $texte .= "\nPièces cochées :\n- ".implode("\n- ", $cochees)."\n";
        }

        $this->enregistrer($request, $em, $sessions, [
            'nom' => $nom,
            'email' => $email,
            'sujet' => 'Préparation de dossier : '.$parcours['label'],
            'message' => $texte,
            'conversion' => 'Dossier : '.$parcours['label'],
        ]);

        return new JsonResponse(['ok' => true, 'message' => 'Préparation transmise.']);
    }

    /**
     * @param list<string> $elements
     */
    private function liste(array $elements, string $siVide): string
    {
        if (!$elements) {
            return '' !== $siVide ? '<p>'.$siVide.'</p>' : '';
        }

        $html = '<ul>';
        foreach ($elements as $element) {
            $html .= '<li>'.htmlspecialchars($element, ENT_QUOTES, 'UTF-8').'</li>';
        }

        return $html.'</ul>';
    }

    /**
     * Enregistre la demande comme message de contact et comme conversion,
     * de la meme maniere que le formulaire de contact du CMS.
     *
     * @param array{nom: string, email: string, sujet: string, message: string, conversion: string} $donnees
     */
    private function enregistrer(
        Request $request,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        array $donnees,
    ): void {
        $session = null;
        $jeton = $request->cookies->get('_bw_sid');
        if ($jeton) {
            $session = $sessions->findOneBy(['sessionToken' => $jeton]);
        }

        $message = new ContactMessage();
        // Le lot ne demande qu'un champ « nom & prenom » : on le garde entier
        // plutot que de deviner ou le couper. Le prenom reste vide.
        $message->setName(mb_substr($donnees['nom'], 0, 100));
        $message->setFirstname('');
        $message->setEmail($donnees['email']);
        $message->setSubject(mb_substr($donnees['sujet'], 0, 255));
        $message->setMessage($donnees['message']);
        $message->setIpHash(hash('sha256', ($request->getClientIp() ?? '0.0.0.0').date('Y-m-d')));
        $message->setSourcePage($request->getPathInfo());
        $message->setSession($session);
        $em->persist($message);

        $conversion = new StatConversion();
        $conversion->setSession($session);
        $conversion->setType('form_submit');
        $conversion->setPageUrl($request->getPathInfo());
        $conversion->setDetail($donnees['conversion']);
        $em->persist($conversion);

        $em->flush();
    }

    private function estUneDate(string $valeur): bool
    {
        $date = \DateTimeImmutable::createFromFormat('Y-m-d', $valeur);

        return false !== $date && $date->format('Y-m-d') === $valeur;
    }
}
