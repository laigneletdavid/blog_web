<?php

namespace App\Service;

use App\Entity\User;
use Symfony\Bundle\SecurityBundle\Security;

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
            'element' => '#dashboardTip',
            'popover' => [
                'title' => 'Bienvenue sur votre tableau de bord',
                'description' => 'C\'est votre point d\'arrivée à chaque connexion. Vous y retrouvez les statistiques de fréquentation, vos derniers articles et des raccourcis vers les actions courantes.',
            ],
        ];

        $steps[] = [
            'element' => '.bw-kpi:first-child',
            'popover' => [
                'title' => 'Vos statistiques en un coup d\'œil',
                'description' => 'Ces indicateurs vous montrent la fréquentation du site, le nombre d\'articles et de pages publiés. Ils se mettent à jour automatiquement.',
            ],
        ];

        $steps[] = [
            'element' => '.bw-quick-actions',
            'popover' => [
                'title' => 'Actions rapides',
                'description' => 'Créez un nouvel article, une page, ou ajoutez un média en un clic. Ces raccourcis vous font gagner du temps au quotidien.',
            ],
        ];

        $steps[] = [
            'element' => '.tour-menu-dashboard',
            'popover' => [
                'title' => 'Le menu principal',
                'description' => 'Ce menu vous accompagne sur toutes les pages de l\'admin. Il est organisé par sections : contenu, modules, réglages.',
                'side' => 'right',
            ],
        ];

        if ($this->security->isGranted('ROLE_AUTHOR')) {
            if ($this->siteContext->hasModule('blog')) {
                $steps[] = [
                    'element' => '.tour-menu-blog',
                    'popover' => [
                        'title' => 'Gérer votre blog',
                        'description' => 'Créez et modifiez vos articles, organisez-les par catégories. L\'éditeur vous permet de mettre en forme vos textes comme dans un traitement de texte.',
                        'side' => 'right',
                    ],
                ];
            }

            $steps[] = [
                'element' => '.tour-menu-pages',
                'popover' => [
                    'title' => 'Vos pages',
                    'description' => 'Les pages fonctionnent comme les articles : même éditeur, même logique. Une seule façon de faire pour tout le site.',
                    'side' => 'right',
                ],
            ];

            $steps[] = [
                'element' => '.tour-menu-medias',
                'popover' => [
                    'title' => 'Médiathèque',
                    'description' => 'Toutes vos images sont centralisées ici. Elles sont automatiquement converties en WebP pour un chargement plus rapide.',
                    'side' => 'right',
                ],
            ];

            $steps[] = [
                'element' => '.tour-menu-documents',
                'popover' => [
                    'title' => 'Documents',
                    'description' => 'Ajoutez vos PDF, plaquettes et tarifs ici. Insérez-les ensuite dans vos articles via le bouton Document de l\'éditeur. Si vous mettez à jour un fichier, tous les articles qui l\'incluent se mettent à jour automatiquement.',
                    'side' => 'right',
                ],
            ];
        }

        if ($this->security->isGranted('ROLE_ADMIN')) {
            $steps[] = [
                'element' => '.tour-menu-classification',
                'popover' => [
                    'title' => 'Classification',
                    'description' => 'Organisez vos contenus avec des tags et des familles de tags. Les tags sont partagés entre modules : un même tag peut relier un article, un service et un événement.',
                    'side' => 'right',
                ],
            ];
            $activeModules = $this->getActiveModuleSteps();
            if (!empty($activeModules)) {
                $steps[] = [
                    'element' => '.tour-menu-modules-section',
                    'popover' => [
                        'title' => 'Vos modules',
                        'description' => 'BlogWeb fonctionne par modules activés selon vos besoins : ' . implode(', ', $activeModules) . '. Chaque module se gère de la même façon.',
                        'side' => 'right',
                    ],
                ];
            }

            $steps[] = [
                'element' => '.tour-menu-site-identity',
                'popover' => [
                    'title' => 'Identité du site',
                    'description' => 'Nom du site, description, coordonnées, logo — tout se configure ici. Ces informations apparaissent sur le site public et dans les résultats Google.',
                    'side' => 'right',
                ],
            ];

            $steps[] = [
                'element' => '.tour-menu-navigation',
                'popover' => [
                    'title' => 'Gestion de la navigation',
                    'description' => 'Organisez votre menu par glisser-déposer. Ajoutez des liens vers vos pages, catégories ou URLs externes.',
                    'side' => 'right',
                ],
            ];

            $apparenceDesc = 'Changez les couleurs, les polices, les images du thème. C\'est ici que votre identité visuelle prend forme — la structure est fournie, le design reste le vôtre.';
            if ($this->security->isGranted('ROLE_FREELANCE')) {
                $apparenceDesc = 'Changez de thème via le catalogue, personnalisez les couleurs, les polices et les images. C\'est ici que votre identité visuelle prend forme — la structure est fournie, le design reste le vôtre.';
            }

            $steps[] = [
                'element' => '.tour-menu-apparence',
                'popover' => [
                    'title' => 'Personnaliser l\'apparence',
                    'description' => $apparenceDesc,
                    'side' => 'right',
                ],
                'expandSubmenu' => true,
            ];
        }

        $steps[] = [
            'element' => '.tour-menu-visit-site',
            'popover' => [
                'title' => 'Voir le résultat',
                'description' => 'Ce lien ouvre votre site public dans un nouvel onglet. Le va-et-vient admin ↔ site, c\'est votre quotidien : vous montez côté admin, vous vérifiez côté site.',
                'side' => 'right',
            ],
        ];

        $steps[] = [
            'element' => '.tour-menu-guide',
            'popover' => [
                'title' => 'Besoin d\'aide ?',
                'description' => 'Le guide complet est toujours accessible ici. Vous pouvez aussi relancer cette visite guidée à tout moment depuis ce menu.',
                'side' => 'right',
            ],
        ];

        return $steps;
    }

    private function getActiveModuleSteps(): array
    {
        $labels = [];
        $map = [
            'services' => 'Services',
            'events' => 'Événements',
            'catalogue' => 'Catalogue',
            'faq' => 'FAQ',
            'portfolio' => 'Portfolio',
            'directory' => 'Annuaire',
        ];

        foreach ($map as $module => $label) {
            if ($this->siteContext->hasModule($module)) {
                $labels[] = $label;
            }
        }

        return $labels;
    }
}
