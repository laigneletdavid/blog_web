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
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\Exception\TransportExceptionInterface;
use Symfony\Component\RateLimiter\RateLimiterFactory;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Espace client : depot de pieces a destination de l'etude.
 *
 * Le lot livre un script autonome qui passait par mail(). Il rejoint ici la
 * mecanique du CMS -- jeton de session, pot de miel, limitation de cadence,
 * reCAPTCHA, trace en base -- et son envoi passe par le transport configure.
 *
 * Les pieces ne sont jamais ecrites sur le disque du site : PHP les garde
 * dans son repertoire temporaire pendant la requete, elles sont lues pour
 * etre jointes au courriel, et disparaissent a la fin de la requete.
 *
 * Reserve connue, signalee a l'etude par ecrit : le courrier electronique
 * ne chiffre que le transport. Les pieces se posent en clair chez le
 * prestataire d'envoi puis dans la boite du destinataire.
 */
class EspaceClientController extends AbstractController
{
    /** Formats acceptes, verifies sur le contenu reel et non sur l'extension. */
    private const TYPES = [
        'application/pdf' => 'pdf',
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
    ];

    private const TAILLE_FICHIER = 8 * 1024 * 1024;
    private const TAILLE_TOTALE = 20 * 1024 * 1024;
    private const NOMBRE_MAX = 12;

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
            'taille_fichier' => self::TAILLE_FICHIER,
            'taille_totale' => self::TAILLE_TOTALE,
            'nombre_max' => self::NOMBRE_MAX,
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
            'taille_fichier' => self::TAILLE_FICHIER,
            'taille_totale' => self::TAILLE_TOTALE,
            'nombre_max' => self::NOMBRE_MAX,
            'erreurs' => $erreurs,
            'saisie' => $request->request->all(),
        ]);
    }

    /**
     * Rend une redirection quand le depot est parti, null pour reafficher la
     * page avec ses erreurs et la saisie du visiteur.
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
        // Au-dela de post_max_size, PHP jette la requete avant nous : plus de
        // champs, plus de fichiers, mais un entete de longueur bien rempli.
        // Sans ce test le visiteur lirait "session expiree", ce qui est faux.
        if (0 === $request->request->count() && (int) $request->server->get('CONTENT_LENGTH') > 0) {
            $erreurs[] = sprintf(
                'Votre envoi dépasse ce que le serveur accepte en une fois (%s). '
                .'Transmettez vos pièces en plusieurs dépôts.',
                \ini_get('post_max_size') ?: 'limite inconnue'
            );

            return null;
        }

        if (!$this->isCsrfTokenValid('depot_documents', (string) $request->request->get('_token'))) {
            $erreurs[] = 'Votre session a expiré. Merci de renvoyer votre dépôt.';

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
        if (!$request->request->getBoolean('consentement')) {
            $erreurs[] = 'Merci de confirmer la transmission de vos documents à l’étude.';
        }

        /** @var list<UploadedFile> $fichiers */
        $fichiers = array_filter($request->files->all()['documents'] ?? []);
        if (!$fichiers) {
            $erreurs[] = 'Aucun document n’a été reçu.';
        }

        $pieces = $erreurs ? [] : $this->verifierFichiers($fichiers, $erreurs);

        if ($erreurs) {
            return null;
        }

        // La liste accompagne les pieces : si une passerelle de messagerie
        // retire une piece jointe en route, l'etude sait ce qui manque.
        $listePieces = '';
        foreach ($pieces as $piece) {
            $listePieces .= sprintf(
                '<li>%s <small>(%d Ko)</small></li>',
                htmlspecialchars($piece['nom'], ENT_QUOTES, 'UTF-8'),
                (int) ceil($piece['taille'] / 1024)
            );
        }

        $html = sprintf(
            '<p><strong>Dépôt de pièces depuis le site.</strong></p>'
            .'<p><strong>Déposant :</strong> %s (%s)</p>'
            .'<p><strong>Téléphone :</strong> %s</p>'
            .'<p><strong>Référence de dossier :</strong> %s</p><hr>'
            .'<p><strong>Message</strong></p><p>%s</p>'
            .'<p><strong>Pièces jointes : %d</strong></p><ul>%s</ul>',
            htmlspecialchars($nom, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars($email, ENT_QUOTES, 'UTF-8'),
            htmlspecialchars('' !== $telephone ? $telephone : 'Non précisé', ENT_QUOTES, 'UTF-8'),
            htmlspecialchars('' !== $reference ? $reference : 'Non précisée', ENT_QUOTES, 'UTF-8'),
            '' !== $message ? nl2br(htmlspecialchars($message, ENT_QUOTES, 'UTF-8')) : 'Aucun message.',
            \count($pieces),
            $listePieces
        );

        $destinataire = $siteContext->getCurrentSite()?->getEmail() ?? 'contact@comwebsolutions.fr';
        $sujet = sprintf(
            '[%s] Dépôt documentaire%s',
            $mailer->getSiteName(),
            '' !== $reference ? ' — '.$reference : ''
        );

        $courriel = $mailer->createEmail($sujet)->replyTo($email)->to($destinataire)->html($html);
        foreach ($pieces as $piece) {
            $courriel->attachFromPath($piece['chemin'], $piece['nom'], $piece['type']);
        }

        try {
            $mailer->send($courriel);
        } catch (TransportExceptionInterface) {
            // Le service d'envoi plafonne la taille de ses requetes : un depot
            // accepte ici peut lui rester en travers. On le dit plutot que de
            // laisser croire a une transmission reussie.
            $erreurs[] = 'La transmission a échoué. Essayez avec moins de pièces, '
                .'ou joignez l’étude directement.';

            return null;
        }

        $this->enregistrer($request, $em, $sessions, $nom, $email, $reference, $message, $pieces);

        return $this->redirectToRoute('app_espace_client', ['envoye' => 1]);
    }

    /**
     * Verifie chaque piece sur son contenu reel, pas sur son extension.
     *
     * @param list<UploadedFile> $fichiers
     * @param list<string>       $erreurs
     *
     * @return list<array{chemin: string, nom: string, type: string, taille: int}>
     */
    private function verifierFichiers(array $fichiers, array &$erreurs): array
    {
        if (\count($fichiers) > self::NOMBRE_MAX) {
            $erreurs[] = sprintf('Pas plus de %d fichiers par envoi.', self::NOMBRE_MAX);

            return [];
        }

        $pieces = [];
        $total = 0;

        foreach ($fichiers as $fichier) {
            if (!$fichier instanceof UploadedFile || !$fichier->isValid()) {
                $erreurs[] = 'Un fichier n’a pas pu être reçu.';

                return [];
            }

            $taille = (int) $fichier->getSize();
            $total += $taille;

            if ($taille <= 0 || $taille > self::TAILLE_FICHIER) {
                $erreurs[] = sprintf('Chaque fichier doit peser moins de %d Mo.', self::TAILLE_FICHIER >> 20);

                return [];
            }
            if ($total > self::TAILLE_TOTALE) {
                $erreurs[] = sprintf('L’ensemble des fichiers doit peser moins de %d Mo.', self::TAILLE_TOTALE >> 20);

                return [];
            }

            // Le type est lu dans le fichier, une extension ne prouve rien.
            $type = $fichier->getMimeType();
            if (null === $type || !isset(self::TYPES[$type])) {
                $erreurs[] = 'Seuls les fichiers PDF, JPEG et PNG sont acceptés.';

                return [];
            }

            $nom = preg_replace('/[^A-Za-z0-9._ -]/u', '_', $fichier->getClientOriginalName() ?: '');
            $pieces[] = [
                'chemin' => $fichier->getPathname(),
                'nom' => '' !== (string) $nom ? (string) $nom : 'document.'.self::TYPES[$type],
                'type' => $type,
                'taille' => $taille,
            ];
        }

        return $pieces;
    }

    /**
     * Garde une trace du depot dans l'administration. Les pieces, elles, ne
     * sont pas conservees : seule leur liste l'est.
     *
     * @param list<array{nom: string, taille: int}> $pieces
     */
    private function enregistrer(
        Request $request,
        EntityManagerInterface $em,
        StatSessionRepository $sessions,
        string $nom,
        string $email,
        string $reference,
        string $message,
        array $pieces,
    ): void {
        $session = null;
        $jeton = $request->cookies->get('_bw_sid');
        if ($jeton) {
            $session = $sessions->findOneBy(['sessionToken' => $jeton]);
        }

        $lignes = array_map(
            static fn (array $p) => sprintf('- %s (%d Ko)', $p['nom'], (int) ceil($p['taille'] / 1024)),
            $pieces
        );

        $corps = "Référence : ".('' !== $reference ? $reference : 'Non précisée')."\n\n"
            ."Pièces transmises :\n".implode("\n", $lignes)."\n\n"
            .('' !== $message ? $message : 'Aucun message.');

        $trace = new ContactMessage();
        $trace->setName(mb_substr($nom, 0, 100));
        $trace->setFirstname('');
        $trace->setEmail($email);
        $trace->setSubject(mb_substr('Dépôt documentaire'.('' !== $reference ? ' — '.$reference : ''), 0, 255));
        $trace->setMessage($corps);
        $trace->setIpHash(hash('sha256', ($request->getClientIp() ?? '0.0.0.0').date('Y-m-d')));
        $trace->setSourcePage($request->getPathInfo());
        $trace->setSession($session);
        $em->persist($trace);

        $conversion = new StatConversion();
        $conversion->setSession($session);
        $conversion->setType('form_submit');
        $conversion->setPageUrl($request->getPathInfo());
        $conversion->setDetail(sprintf('Dépôt documentaire : %d pièce(s)', \count($pieces)));
        $em->persist($conversion);

        $em->flush();
    }
}
