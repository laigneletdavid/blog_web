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
        'frais-acquisition' => [
            'titre' => "Frais d'acquisition",
            'chapo' => "Estimer les frais d'un achat immobilier, dans l'ancien comme dans le neuf.",
            'resume' => "Droits de mutation, émoluments, débours : le détail de ce que l'on appelle « frais de notaire ».",
        ],
        'donation' => [
            'titre' => 'Donation',
            'chapo' => 'Mesurer la fiscalité d\'une donation selon le lien de parenté.',
            'resume' => 'Abattements, barème progressif et rappel des donations antérieures.',
        ],
        'succession' => [
            'titre' => 'Succession',
            'chapo' => 'Apprécier les droits dus par chaque héritier.',
            'resume' => 'Part taxable, abattement applicable et barème selon le lien avec le défunt.',
        ],
        'plus-value' => [
            'titre' => 'Plus-value immobilière',
            'chapo' => "Évaluer l'imposition à la revente d'un bien.",
            'resume' => "Abattements pour durée de détention, impôt sur le revenu et prélèvements sociaux.",
        ],
        'viager' => [
            'titre' => 'Viager',
            'chapo' => 'Répartir un prix entre bouquet et rente.',
            'resume' => "Valeur occupée, droit d'usage et d'habitation, rente mensuelle.",
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
            'seo' => $this->seoService->resolveForPage($simulateur['titre']),
        ]);
    }
}
