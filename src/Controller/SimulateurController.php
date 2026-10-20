<?php

namespace App\Controller;

use App\Service\BaremeNotarial;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Simulateurs de l'etude.
 *
 * Ces pages portent des formulaires et du calcul : elles ne peuvent pas vivre
 * dans le contenu editorial, que l'assainisseur HTML debarrasse -- a juste
 * titre -- de ses script, form et input. Elles sont donc servies par des
 * gabarits, et leur bareme est versionne avec le code plutot que saisi.
 *
 * Les montants affiches restent indicatifs : seule l'etude engage un chiffre.
 */
class SimulateurController extends AbstractController
{
    /**
     * Les simulateurs proposes, dans l'ordre d'affichage.
     *
     * @var array<string, array{titre: string, chapo: string, resume: string}>
     */
    private const SIMULATEURS = [
        'plus-value' => [
            'titre' => 'Plus-value immobilière',
            'chapo' => "Évaluer l'imposition à la revente d'un bien.",
            'resume' => 'Estimez la plus-value et les principaux impôts associés.',
        ],
        'frais-acquisition' => [
            'titre' => "Frais d'acquisition",
            'chapo' => "Estimer les frais d'un achat immobilier, dans l'ancien comme dans le neuf.",
            'resume' => 'Calculez une première estimation des frais liés à votre acquisition.',
        ],
        'viager' => [
            'titre' => 'Viager',
            'chapo' => 'Répartir un prix entre bouquet et rente.',
            'resume' => 'Obtenez une estimation pédagogique du bouquet et de la rente.',
        ],
        'succession' => [
            'titre' => 'Succession',
            'chapo' => 'Apprécier les droits dus par chaque héritier.',
            'resume' => 'Estimez les droits de succession à partir de votre situation.',
        ],
        'donation' => [
            'titre' => 'Donation',
            'chapo' => "Mesurer la fiscalité d'une donation selon le lien de parenté.",
            'resume' => "Estimez les droits et principaux frais d'une donation.",
        ],
    ];

    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
        private readonly BaremeNotarial $bareme,
    ) {
    }

    #[Route('/simulateurs', name: 'app_simulateurs')]
    public function index(): Response
    {
        return $this->render('simulateur/index.html.twig', [
            'title_page' => 'Simulateurs',
            'simulateurs' => self::SIMULATEURS,
            'seo' => $this->seoService->resolveForPage('Simulateurs'),
        ]);
    }

    #[Route('/simulateurs/{slug}', name: 'app_simulateur_show')]
    public function show(string $slug): Response
    {
        $simulateur = self::SIMULATEURS[$slug] ?? null;
        if ($simulateur === null) {
            throw $this->createNotFoundException('Simulateur introuvable.');
        }

        return $this->render('simulateur/' . $slug . '.html.twig', [
            'title_page' => $simulateur['titre'],
            'simulateur' => $simulateur,
            'slug' => $slug,
            'bareme' => $this->bareme,
            // Les valeurs chiffrees partent en JSON dans le script de la page :
            // aucun taux ne doit plus etre ecrit en dur dans un gabarit.
            'bareme_valeurs' => $this->bareme->pour($slug),
            'seo' => $this->seoService->resolveForPage($simulateur['titre']),
        ]);
    }
}
