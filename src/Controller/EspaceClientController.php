<?php

namespace App\Controller;

use App\Entity\ContactMessage;
use App\Entity\StatConversion;
use App\Repository\StatSessionRepository;
use App\Service\RecaptchaValidator;
use App\Service\SeoService;
use App\Service\SiteContext;
use App\Service\SystemMailerService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\Exception\TransportExceptionInterface;
use Symfony\Component\RateLimiter\RateLimiterFactory;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Espace client : demande d'acces securise.
 *
 * Le visiteur ne depose plus de piece ici. Il laisse ses coordonnees et
 * demande un acces ; l'etude ouvre pour lui un espace securise, lui en
 * transmet le lien, et le code de connexion lui parvient par SMS.
 *
 * Ce site ne porte donc aucun document, et n'envoie ni lien ni code : il
 * transmet une demande, rien de plus. Le reste se passe dans l'outil de
 * l'etude.
 *
 * C'est ce qui leve la reserve ecrite a l'etude lors du premier montage :
 * un depot par formulaire finissait en piece jointe, et voyageait donc en
 * clair chez le prestataire d'envoi puis dans la boite du destinataire.
 * Plus rien de tel ici.
 */
class EspaceClientController extends AbstractController
{
    public function __construct(
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/espace-client', name: 'app_espace_client')]
    public function index(RecaptchaValidator $recaptcha): Response
    {
        return $this->render('espace-client/index.html.twig', [
            'title_page' => 'Espace client',
            'seo' => $this->seoService->resolveForPage('Espace client'),
            'recaptcha_site_key' => $recaptcha->isEnabled() ? $recaptcha->getSiteKey() : null,
        ]);
    }

    #[Route('/espace-client/transmettre', name: 'app_espace_client_envoi', methods: ['POST'])]
    public function transmettre(
        Request $request,
        RecaptchaValidator $recaptcha,
        SystemMailerService $mailer,
        SiteContext $siteContext,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        #[Autowire(service: 'limiter.contact_limiter')] RateLimiterFactory $limiter,
    ): Response {
        $erreurs = [];
        $reponse = $this->traiter($request, $recaptcha, $mailer, $siteContext, $em, $sessions, $limiter, $erreurs);

        if (null !== $reponse) {
            return $reponse;
        }

        return $this->render('espace-client/index.html.twig', [
            'title_page' => 'Espace client',
            'seo' => $this->seoService->resolveForPage('Espace client'),
            'recaptcha_site_key' => $recaptcha->isEnabled() ? $recaptcha->getSiteKey() : null,
            'erreurs' => $erreurs,
            'saisie' => $request->request->all(),
        ]);
    }

    /**
     * Rend une redirection quand la demande est partie, null pour reafficher
     * la page avec ses erreurs et la saisie du visiteur.
     *
     * @param list<string> $erreurs
     */
    private function traiter(
        Request $request,
        RecaptchaValidator $recaptcha,
        SystemMailerService $mailer,
        SiteContext $siteContext,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        RateLimiterFactory $limiter,
        array &$erreurs,
    ): ?Response {
        if (!$this->isCsrfTokenValid('demande_acces', (string) $request->request->get('_token'))) {
            $erreurs[] = 'Votre session a expiré. Merci de renvoyer votre demande.';

            return null;
        }

        // Pot de miel : le champ est hors ecran, seul un robot le remplit.
        if ('' !== trim((string) $request->request->get('website', ''))) {
            return $this->redirectToRoute('app_espace_client', ['envoye' => 1]);
        }

        if (!$recaptcha->validate($request->request->get('g-recaptcha-response'), 'contact')) {
            $erreurs[] = 'La vérification anti-spam a échoué. Veuillez réessayer.';

            return null;
        }

        if (!$limiter->create($request->getClientIp())->consume()->isAccepted()) {
            $erreurs[] = 'Trop d’envois successifs. Veuillez réessayer dans quelques minutes.';

            return null;
        }

        $nom = trim((string) $request->request->get('nom', ''));
        $email = trim((string) $request->request->get('email', ''));
        $telephone = trim((string) $request->request->get('telephone', ''));
        $reference = trim((string) $request->request->get('reference', ''));
        $message = mb_substr(trim((string) $request->request->get('message', '')), 0, 2000);

        if ('' === $nom || mb_strlen($nom) > 120) {
            $erreurs[] = 'Merci d’indiquer votre nom et votre prénom.';
        }
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $erreurs[] = 'Merci d’indiquer une adresse e-mail valide.';
        }
        // Le code de connexion part par SMS : sans numero, l'etude ne peut
        // pas ouvrir l'acces. On verifie qu'il reste assez de chiffres pour
        // etre un numero, sans presumer de sa forme ni de son pays.
        if (preg_match_all('/\d/', $telephone) < 9) {
            $erreurs[] = 'Merci d’indiquer un numéro de téléphone portable : le code de connexion y sera envoyé.';
        }
        if (!$request->request->getBoolean('consentement')) {
            $erreurs[] = 'Merci de confirmer votre demande d’accès.';
        }

        if ($erreurs) {
            return null;
        }

        $html = sprintf(
            '<p><strong>Demande d’accès sécurisé depuis le site.</strong></p>'
            .'<p><strong>Demandeur :</strong> %s (%s)</p>'
            .'<p><strong>Téléphone portable :</strong> %s</p>'
            .'<p><strong>Référence de dossier :</strong> %s</p><hr>'
            .'<p><strong>Documents annoncés</strong></p><p>%s</p>'
            .'<p>Ouvrir l’accès depuis l’outil de l’étude, puis transmettre le lien à '
            .'l’adresse ci-dessus. Le code part sur le portable indiqué.</p>',
            htmlspecialchars($nom, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars($email, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars($telephone, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars('' !== $reference ? $reference : 'Non précisée', ENT_QUOTES, 'UTF-8'),
            '' !== $message ? nl2br(htmlspecialchars($message, ENT_QUOTES, 'UTF-8')) : 'Non précisé.'
        );

        $destinataire = $siteContext->getCurrentSite()?->getEmail() ?? 'contact@comwebsolutions.fr';
        $sujet = sprintf(
            '[%s] Demande d’accès sécurisé%s',
            $mailer->getSiteName(),
            '' !== $reference ? ' — '.$reference : ''
        );

        try {
            $mailer->send($mailer->createEmail($sujet)->replyTo($email)->to($destinataire)->html($html));
        } catch (TransportExceptionInterface) {
            $erreurs[] = 'La transmission a échoué. Merci de joindre l’étude directement.';

            return null;
        }

        $this->enregistrer($request, $em, $sessions, $nom, $email, $telephone, $reference, $message);

        return $this->redirectToRoute('app_espace_client', ['envoye' => 1]);
    }

    /**
     * Garde une trace de la demande dans l'administration.
     */
    private function enregistrer(
        Request $request,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        string $nom,
        string $email,
        string $telephone,
        string $reference,
        string $message,
    ): void {
        $session = null;
        $jeton = $request->cookies->get('_bw_sid');
        if ($jeton) {
            $session = $sessions->findOneBy(['sessionToken' => $jeton]);
        }

        $corps = "Téléphone : ".$telephone."\n\n"
            ."Référence : ".('' !== $reference ? $reference : 'Non précisée')."\n\n"
            ."Documents annoncés :\n".('' !== $message ? $message : 'Non précisé.');

        $trace = new ContactMessage();
        $trace->setName(mb_substr($nom, 0, 100));
        $trace->setFirstname('');
        $trace->setEmail($email);
        $trace->setSubject(mb_substr('Demande d’accès sécurisé'.('' !== $reference ? ' — '.$reference : ''), 0, 255));
        $trace->setMessage($corps);
        $trace->setIpHash(hash('sha256', ($request->getClientIp() ?? '0.0.0.0').date('Y-m-d')));
        $trace->setSourcePage($request->getPathInfo());
        $trace->setSession($session);
        $em->persist($trace);

        $conversion = new StatConversion();
        $conversion->setType('form_submit');
        $conversion->setPageUrl($request->getPathInfo());
        $conversion->setDetail('Demande d’accès sécurisé');
        $conversion->setSession($session);
        $em->persist($conversion);

        $em->flush();
    }
}
