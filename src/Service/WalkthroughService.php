<?php

namespace App\Service;

use App\Entity\User;
use Symfony\Bundle\SecurityBundle\Security;

/**
 * Visite guidee de l'admin : une etape par zone de l'accueil et par entree du menu.
 * Les selecteurs suivent les classes posees dans DashboardController et le layout admin.
 */
class WalkthroughService
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly Security $security,
    ) {
    }

    public function getStepsForCurrentUser(): array
    {
        $user = $this->security->getUser();
        if (!$user instanceof User) {
            return [];
        }

        $steps = [];

        $steps[] = [
            'element' => '.bw-dashboard .bw-panel',
            'popover' => [
                'title' => 'Ce qui vous attend',
                'description' => 'À chaque connexion, l\'accueil liste ce qui demande votre attention : messages à lire, brouillons à finir, pistes pour votre référencement. Chaque ligne a son bouton pour s\'en occuper.',
            ],
        ];

        $steps[] = [
            'element' => '.bw-create',
            'popover' => [
                'title' => 'Créer',
                'description' => 'Un article, une page, un service : tout commence ici.',
            ],
        ];

        if ($this->security->isGranted('ROLE_AUTHOR')) {
            $steps[] = [
                'element' => '.tour-menu-contents',
                'popover' => [
                    'title' => 'Vos contenus',
                    'description' => 'Tous vos contenus au même endroit' . $this->contentTypesSentence() . '. Filtrez par type, cherchez par titre, cliquez pour modifier.',
                    'side' => 'right',
                ],
            ];

            $steps[] = [
                'element' => '.tour-menu-medias',
                'popover' => [
                    'title' => 'Médias',
                    'description' => 'Vos images, et vos documents à télécharger (PDF, plaquettes). Donnez à chaque image un texte alternatif : il est lu par Google et par les personnes malvoyantes.',
                    'side' => 'right',
                ],
            ];
        }

        if ($this->security->isGranted('ROLE_ADMIN')) {
            $steps[] = [
                'element' => '.tour-menu-messages',
                'popover' => [
                    'title' => 'Messages',
                    'description' => 'Les demandes envoyées depuis votre formulaire de contact. Le chiffre rouge indique les messages non lus.',
                    'side' => 'right',
                ],
            ];

            if ($this->siteContext->hasModule('marketing')) {
                $steps[] = [
                    'element' => '.tour-menu-stats',
                    'popover' => [
                        'title' => 'Statistiques',
                        'description' => 'Combien de visiteurs, d\'où ils viennent, ce qu\'ils regardent.',
                        'side' => 'right',
                    ],
                ];
            }

            $steps[] = [
                'element' => '.tour-menu-seo',
                'popover' => [
                    'title' => 'Référencement',
                    'description' => 'Dites ce que vous proposez, à qui et où vous voulez être trouvé. Le bilan en haut de page vous indique quoi améliorer.',
                    'side' => 'right',
                ],
            ];

            $steps[] = [
                'element' => '.tour-menu-apparence',
                'popover' => [
                    'title' => 'Apparence',
                    'description' => 'Logo, couleurs, polices et images de votre site. La structure est fournie, le style reste le vôtre.',
                    'side' => 'right',
                ],
            ];

            $steps[] = [
                'element' => '.tour-menu-settings',
                'popover' => [
                    'title' => 'Réglages',
                    'description' => 'Ce qu\'on règle une fois : identité du site, menu, catégories, utilisateurs. C\'est ici, et dans l\'édition d\'un contenu, qu\'apparaît le mode expert pour les réglages techniques.',
                    'side' => 'right',
                ],
            ];
        }

        $steps[] = [
            'element' => '.bw-expert-toggle',
            'popover' => [
                'title' => 'Mode expert',
                'description' => 'Par défaut, l\'admin n\'affiche que l\'essentiel. Le mode expert ajoute les réglages techniques : adresse des pages, options avancées de référencement, modules.',
                'side' => 'right',
            ],
        ];

        $steps[] = [
            'element' => '.tour-menu-visit-site',
            'popover' => [
                'title' => 'Voir le résultat',
                'description' => 'Ouvre votre site dans un nouvel onglet, pour vérifier ce que voient vos visiteurs.',
                'side' => 'right',
            ],
        ];

        $steps[] = [
            'element' => '.tour-menu-guide',
            'popover' => [
                'title' => 'Besoin d\'aide ?',
                'description' => 'Le guide complet est toujours accessible ici, et cette visite peut être relancée depuis l\'accueil.',
                'side' => 'right',
            ],
        ];

        return $steps;
    }

    /**
     * " : articles, pages, services..." selon les modules actifs.
     */
    private function contentTypesSentence(): string
    {
        $labels = [];
        $map = [
            'blog' => 'articles',
            null => 'pages',
            'services' => 'services',
            'events' => 'événements',
            'portfolio' => 'réalisations',
            'catalogue' => 'produits',
            'faq' => 'questions',
            'directory' => 'fiches de l\'annuaire',
        ];

        foreach ($map as $module => $label) {
            if ($module === '' || $this->siteContext->hasModule($module)) {
                $labels[] = $label;
            }
        }

        if (count($labels) < 2) {
            return '';
        }

        $last = array_pop($labels);

        return ' : ' . implode(', ', $labels) . ' et ' . $last;
    }
}
