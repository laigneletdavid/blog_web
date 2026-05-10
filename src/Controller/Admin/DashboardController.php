<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Comment;
use App\Entity\Event;
use App\Entity\Faq;
use App\Entity\FaqCategory;
use App\Entity\Media;
use App\Entity\Page;
use App\Entity\Order;
use App\Entity\PortfolioCategory;
use App\Entity\DirectoryCategory;
use App\Entity\DirectoryEntry;
use App\Entity\Document;
use App\Entity\PortfolioItem;
use App\Entity\Product;
use App\Entity\ProductCategory;
use App\Entity\Service;
use App\Entity\Site;
use App\Entity\SiteGalleryItem;
use App\Entity\Tag;
use App\Entity\TagGroup;
use App\Entity\Subscriber;
use App\Entity\User;
use App\Repository\MenuRepository;
use App\Service\AdminStatsService;
use App\Service\SiteContext;
use App\Service\ThemeService;
use App\Controller\Admin\ModulesCrudController;
use App\Controller\Admin\SiteCrudController;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Assets;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Dashboard;
use EasyCorp\Bundle\EasyAdminBundle\Config\MenuItem;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractDashboardController;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

class DashboardController extends AbstractDashboardController
{
    public function __construct(
        private AdminUrlGenerator $adminUrlGenerator,
        private SiteContext $siteContext,
        private ThemeService $themeService,
        private \App\Repository\OrderRepository $orderRepository,
        private AdminStatsService $adminStatsService,
    ) {
    }

    #[Route('/admin', name: 'admin')]
    public function index(): Response
    {
        $site = $this->siteContext->getCurrentSite();

        // Filtres top pages
        $request = $this->container->get('request_stack')->getCurrentRequest();
        $topPagesPeriod = $request?->query->getString('period', 'month') ?? 'month';
        $topPagesYear = $request?->query->getInt('year', (int) date('Y')) ?? (int) date('Y');

        $stats = $this->adminStatsService->getDashboardStats($topPagesPeriod, $topPagesYear);

        $ecommerceStats = null;
        if ($this->isGranted('ROLE_ADMIN') && $this->siteContext->hasModule('ecommerce')) {
            $ecommerceStats = [
                'recentOrders' => $this->orderRepository->findRecent(5),
                'revenueThisMonth' => $this->orderRepository->revenueThisMonth(),
                'countPaidThisMonth' => $this->orderRepository->countPaidThisMonth(),
            ];
        }

        // Années disponibles pour le filtre
        $currentYear = (int) date('Y');
        $availableYears = range($currentYear, $currentYear - 3);

        return $this->render('admin/dashboard.html.twig', [
            'title_admin' => $site?->getName() ?? 'Blog & Web',
            'site' => $site,
            'stats' => $stats,
            'ecommerceStats' => $ecommerceStats,
            'topPagesPeriod' => $topPagesPeriod,
            'topPagesYear' => $topPagesYear,
            'availableYears' => $availableYears,
        ]);
    }

    #[Route('/admin/guide', name: 'admin_guide')]
    #[IsGranted('ROLE_AUTHOR')]
    public function guide(): Response
    {
        return $this->render('admin/guide/index.html.twig', [
            'site' => $this->siteContext->getCurrentSite(),
        ]);
    }

    #[Route('/admin/menu-manager', name: 'admin_menu_manager')]
    #[IsGranted('ROLE_ADMIN')]
    public function menuManager(
        MenuRepository $menuRepository,
        \App\Repository\PageRepository $pageRepository,
        \App\Repository\CategorieRepository $categorieRepository,
        \App\Repository\ServiceRepository $serviceRepository,
        \Symfony\Component\Security\Csrf\CsrfTokenManagerInterface $csrfTokenManager,
    ): Response {
        $site = $this->siteContext->getCurrentSite();
        $enabledModules = $site?->getEnabledModules() ?? [];

        // Build sources for the left panel
        $systemPages = [
            ['name' => 'Accueil', 'route' => 'app_home'],
            ['name' => 'Contact', 'route' => 'app_contact'],
        ];

        // Legal pages
        foreach ($pageRepository->findAllSystemPages() as $page) {
            $systemPages[] = [
                'name' => $page->getTitle(),
                'pageId' => $page->getId(),
                'target' => 'page',
            ];
        }

        // Module routes
        $moduleRoutes = [];
        $moduleMap = [
            'blog' => ['name' => 'Blog', 'route' => 'app_article_show_all'],
            'services' => ['name' => 'Services', 'route' => 'app_service_index'],
            'catalogue' => ['name' => 'Catalogue', 'route' => 'app_product_index'],
            'events' => ['name' => 'Événements', 'route' => 'app_event_index'],
            'directory' => ['name' => 'Annuaire', 'route' => 'app_directory'],
            'faq' => ['name' => 'FAQ', 'route' => 'app_faq_index'],
            'portfolio' => ['name' => 'Portfolio', 'route' => 'app_portfolio_index'],
        ];
        foreach ($moduleMap as $module => $info) {
            if (in_array($module, $enabledModules, true)) {
                $moduleRoutes[] = $info;
            }
        }

        $services = [];
        if (in_array('services', $enabledModules, true)) {
            $services = $serviceRepository->findBy(['isActive' => true], ['position' => 'ASC']);
        }

        return $this->render('admin/menu/sortable.html.twig', [
            'menus' => [
                'header' => $menuRepository->findByLocationAllItems('header'),
                'footer_nav' => $menuRepository->findByLocationAllItems('footer_nav'),
                'footer_legal' => $menuRepository->findByLocationAllItems('footer_legal'),
            ],
            'sources' => [
                'system_pages' => $systemPages,
                'custom_pages' => $pageRepository->findCustomPages(),
                'categories' => $categorieRepository->findAll(),
                'modules' => $moduleRoutes,
                'services' => $services,
            ],
            'locations' => \App\Enum\MenuLocationEnum::choices(),
            'csrf_token' => $csrfTokenManager->getToken('menu_reorder')->getValue(),
        ]);
    }

    #[Route('/admin/theme-browser', name: 'admin_theme_browser')]
    #[IsGranted('ROLE_FREELANCE')]
    public function themeBrowser(): Response
    {
        $site = $this->siteContext->getCurrentSite();

        return $this->render('admin/themes/browser.html.twig', [
            'themes' => $this->themeService->getAvailableThemes(),
            'currentTheme' => $site?->getTemplate() ?? 'default',
            'site' => $site,
        ]);
    }

    #[Route('/admin/theme-activate/{slug}', name: 'admin_theme_activate', methods: ['POST'])]
    #[IsGranted('ROLE_FREELANCE')]
    public function themeActivate(
        string $slug,
        Request $request,
        EntityManagerInterface $em,
    ): Response {
        $site = $this->siteContext->getCurrentSite();
        if (!$site) {
            $this->addFlash('error', 'Aucun site configure.');
            return $this->redirectToRoute('admin_theme_browser');
        }

        if (!$this->isCsrfTokenValid('theme_activate_' . $slug, $request->request->get('_token'))) {
            $this->addFlash('error', 'Token CSRF invalide.');
            return $this->redirectToRoute('admin_theme_browser');
        }

        $theme = $this->themeService->getTheme($slug);
        if (!$theme) {
            $this->addFlash('error', 'Theme introuvable.');
            return $this->redirectToRoute('admin_theme_browser');
        }

        $site->setTemplate($slug);

        // Les couleurs/polices du site ne sont PAS ecrasees.
        // Le theme fournit ses propres defaults via theme.yaml.
        // Si le site a des couleurs custom (non null), elles restent en surcouche.
        // Si elles sont null, les defaults du nouveau theme s'appliquent automatiquement.

        $em->flush();
        $this->themeService->clearCache();

        $this->addFlash('success', 'Theme "' . ($theme['name'] ?? $slug) . '" active avec succes.');

        return $this->redirectToRoute('admin_theme_browser');
    }

    #[Route('/admin/theme-preview/{slug}', name: 'admin_theme_preview')]
    #[IsGranted('ROLE_FREELANCE')]
    public function themePreview(string $slug): Response
    {
        $path = $this->getParameter('kernel.project_dir') . '/templates/themes/' . $slug . '/preview.png';

        if (!file_exists($path)) {
            throw $this->createNotFoundException('Aperçu non disponible.');
        }

        return new BinaryFileResponse($path);
    }

    #[Route('/theme-css/{slug}', name: 'app_theme_css')]
    public function themeCss(string $slug): Response
    {
        $path = $this->getParameter('kernel.project_dir') . '/templates/themes/' . $slug . '/theme.css';

        if (!file_exists($path)) {
            return new Response('', 204);
        }

        $response = new BinaryFileResponse($path);
        $response->headers->set('Content-Type', 'text/css');
        $response->headers->set('Cache-Control', 'public, max-age=3600');

        return $response;
    }

    public function configureDashboard(): Dashboard
    {
        return Dashboard::new()
            ->setTitle('<img src="public/images/BlogWebbeta.svg" alt="Blog & Web"/>')
            ->setLocales(['fr'])
            ->setFaviconPath('images/favicon-16x16.png')
            ->disableDarkMode();
    }

    public function configureMenuItems(): iterable
    {
        // --- Navigation ---
        yield MenuItem::linkToUrl('Tableau de bord', 'fa fa-gauge', $this->generateUrl('admin'));
        yield MenuItem::linkToUrl('Aller sur le site', 'fa fa-external-link-alt', $this->generateUrl('app_home'));

        // --- Contenu ---
        yield MenuItem::section('Contenu');

        if ($this->isGranted('ROLE_AUTHOR')) {
            if ($this->siteContext->hasModule('blog')) {
                yield MenuItem::subMenu('Blog', 'fas fa-newspaper')->setSubItems([
                    MenuItem::linkToCrud('Articles', 'fas fa-pen-to-square', Article::class),
                    MenuItem::linkToCrud('Catégories', 'fas fa-folder-open', Categorie::class),
                ]);
                // Tags geres dans Contenu > Classification (transverse multi-modules, ROLE_ADMIN)
            }
            yield MenuItem::linkToCrud('Pages', 'fas fa-file-lines', Page::class);
            yield MenuItem::linkToCrud('Medias', 'fas fa-photo-video', Media::class);
            yield MenuItem::linkToCrud('Documents', 'fas fa-file-arrow-down', Document::class);

            // Classification transverse (tags partages entre modules + familles)
            if ($this->isGranted('ROLE_ADMIN')) {
                yield MenuItem::subMenu('Classification', 'fas fa-layer-group')->setSubItems([
                    MenuItem::linkToCrud('Tags', 'fas fa-tags', Tag::class),
                    MenuItem::linkToCrud('Familles de tags', 'fas fa-object-group', TagGroup::class),
                ]);
            }
        } elseif ($this->isGranted('ROLE_AUTHOR')) {
            if ($this->siteContext->hasModule('blog')) {
                yield MenuItem::linkToCrud('Articles', 'fas fa-newspaper', Article::class);
            }
            yield MenuItem::linkToCrud('Pages', 'fas fa-file-lines', Page::class);
        }

        // --- Modules (si au moins un module actif hors blog) ---
        $hasModules = $this->isGranted('ROLE_ADMIN') && (
            $this->siteContext->hasModule('services')
            || $this->siteContext->hasModule('events')
            || $this->siteContext->hasModule('catalogue')
            || $this->siteContext->hasModule('ecommerce')
            || $this->siteContext->hasModule('faq')
            || $this->siteContext->hasModule('portfolio')
            || $this->siteContext->hasModule('directory')
        );

        if ($hasModules) {
            yield MenuItem::section('Modules');

            if ($this->siteContext->hasModule('services')) {
                yield MenuItem::linkToCrud('Services', 'fas fa-concierge-bell', Service::class);
            }
            if ($this->siteContext->hasModule('events')) {
                yield MenuItem::linkToCrud('Evenements', 'fas fa-calendar-days', Event::class);
            }
            if ($this->siteContext->hasModule('catalogue')) {
                yield MenuItem::subMenu('Catalogue', 'fas fa-store')->setSubItems([
                    MenuItem::linkToCrud('Produits', 'fas fa-box-open', Product::class),
                    MenuItem::linkToCrud('Catégories', 'fas fa-folder-tree', ProductCategory::class),
                ]);
            }
            if ($this->siteContext->hasModule('ecommerce')) {
                yield MenuItem::linkToCrud('Commandes', 'fas fa-shopping-bag', Order::class);
            }
            if ($this->siteContext->hasModule('faq')) {
                yield MenuItem::subMenu('FAQ', 'fas fa-circle-question')->setSubItems([
                    MenuItem::linkToCrud('Questions', 'fas fa-question', Faq::class),
                    MenuItem::linkToCrud('Catégories', 'fas fa-folder-open', FaqCategory::class),
                ]);
            }
            if ($this->siteContext->hasModule('portfolio')) {
                yield MenuItem::subMenu('Portfolio', 'fas fa-images')->setSubItems([
                    MenuItem::linkToCrud('Realisations', 'fas fa-briefcase', PortfolioItem::class),
                    MenuItem::linkToCrud('Catégories', 'fas fa-folder-open', PortfolioCategory::class),
                ]);
            }
            if ($this->siteContext->hasModule('directory')) {
                yield MenuItem::subMenu('Annuaire', 'fas fa-address-book')->setSubItems([
                    MenuItem::linkToCrud('Fiches', 'fas fa-id-card', DirectoryEntry::class),
                    MenuItem::linkToCrud('Catégories', 'fas fa-folder-open', DirectoryCategory::class),
                ]);
            }
        }

        // --- Communaute ---
        $hasCommunity = $this->siteContext->hasModule('blog') || $this->isGranted('ROLE_ADMIN');
        if ($hasCommunity) {
            yield MenuItem::section('Communaute');

            if ($this->siteContext->hasModule('blog')) {
                yield MenuItem::linkToCrud('Commentaires', 'fas fa-comments', Comment::class);
            }
            if ($this->isGranted('ROLE_ADMIN')) {
                yield MenuItem::linkToCrud('Utilisateurs', 'fas fa-users', User::class);
            }
            yield MenuItem::linkToCrud('Abonnes', 'fas fa-envelope', Subscriber::class);
        }

        // --- Reglages (ROLE_ADMIN+) ---
        if ($this->isGranted('ROLE_ADMIN')) {
            yield MenuItem::section('Réglages');

            yield MenuItem::linkToCrud('Identité du site', 'fas fa-building', Site::class)
                ->setController(SiteCrudController::class)
                ->setAction(Crud::PAGE_EDIT)
                ->setEntityId($this->siteContext->getCurrentSiteId());

            yield MenuItem::linkToRoute('Navigation', 'fas fa-bars', 'admin_menu_manager');
        }

        if ($this->isGranted('ROLE_ADMIN')) {
            // Menu Apparence : reglages + images accessibles des ROLE_ADMIN
            // (couleurs, polices, hero, about, galerie, logos, temoignages).
            // Le catalogue de themes reste reserve a ROLE_FREELANCE+
            // (changer de theme = decision technique critique).
            $apparenceItems = [
                MenuItem::linkToCrud('Réglages du thème', 'fas fa-sliders', Site::class)
                    ->setController(ThemeSettingsCrudController::class)
                    ->setAction(Crud::PAGE_EDIT)
                    ->setEntityId($this->siteContext->getCurrentSiteId()),
                MenuItem::linkToCrud('Images du theme', 'fas fa-images', SiteGalleryItem::class)
                    ->setController(ThemeImagesCrudController::class),
            ];

            if ($this->isGranted('ROLE_FREELANCE')) {
                array_unshift(
                    $apparenceItems,
                    MenuItem::linkToRoute('Catalogue de themes', 'fas fa-swatchbook', 'admin_theme_browser'),
                );
            }

            yield MenuItem::subMenu('Apparence', 'fas fa-palette')->setSubItems($apparenceItems);

            if ($this->isGranted('ROLE_SUPER_ADMIN')) {
                yield MenuItem::linkToCrud('Modules', 'fas fa-puzzle-piece', Site::class)
                    ->setController(ModulesCrudController::class)
                    ->setAction(Crud::PAGE_EDIT)
                    ->setEntityId($this->siteContext->getCurrentSiteId());
            }
        }

        // --- Aide ---
        yield MenuItem::section('Aide');
        yield MenuItem::linkToRoute('Guide', 'fas fa-book-open', 'admin_guide');
    }

    public function configureAssets(): Assets
    {
        return parent::configureAssets()
            ->addWebpackEncoreEntry('admin_editor')
            ->addWebpackEncoreEntry('admin_menu')
            ->addWebpackEncoreEntry('admin_fonts')
            ->addWebpackEncoreEntry('admin_icons')
            ->addWebpackEncoreEntry('admin_dashboard');
    }
}
