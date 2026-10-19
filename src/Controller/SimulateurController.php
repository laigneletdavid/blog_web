<?php

namespace App\Controller;

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
            'resume' => "Droits de mutation, emoluments, debours : le detail de ce que l'on appelle « frais de notaire ».",
        ],
        'donation' => [
            'titre' => 'Donation',
            'chapo' => 'Mesurer la fiscalite d\'une donation selon le lien de parente.',
            'resume' => 'Abattements, bareme progressif et rappel des donations anterieures.',
        ],
        'succession' => [
            'titre' => 'Succession',
            'chapo' => 'Apprecier les droits dus par chaque heritier.',
            'resume' => 'Part taxable, abattement applicable et bareme selon le lien avec le defunt.',
        ],
        'plus-value' => [
            'titre' => 'Plus-value immobiliere',
            'chapo' => "Evaluer l'imposition a la revente d'un bien.",
            'resume' => "Abattements pour duree de detention, impot sur le revenu et prelevements sociaux.",
        ],
        'viager' => [
            'titre' => 'Viager',
            'chapo' => 'Repartir un prix entre bouquet et rente.',
            'resume' => "Valeur occupee, droit d'usage et d'habitation, rente mensuelle.",
        ],
    ];

    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
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
            'seo' => $this->seoService->resolveForPage($simulateur['titre']),
        ]);
    }
}
