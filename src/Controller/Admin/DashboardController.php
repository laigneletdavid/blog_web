<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Comment;
use App\Entity\ContactMessage;
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
use App\Service\SiteContext;
use App\Service\ThemeService;
use App\Service\WalkthroughService;
use App\Controller\Admin\ModulesCrudController;
use App\Controller\Admin\SeoSettingsCrudController;
use App\Controller\Admin\SiteCrudController;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Assets;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Dashboard;
use EasyCorp\Bundle\EasyAdminBundle\Config\MenuItem;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractDashboardController;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
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
        private WalkthroughService $walkthroughService,
        private \App\Repository\ContactMessageRepository $contactMessageRepository,
        private \App\Service\AdminTodoService $adminTodoService,
        private \App\Service\ContentHubService $contentHub,
        private \App\Repository\PageViewRepository $pageViewRepository,
        private \App\Service\StatService $statService,
    ) {
    }

    #[Route('/admin', name: 'admin')]
    public function index(): Response
    {
        $site = $this->siteContext->getCurrentSite();

        $ecommerceStats = null;
        if ($this->isGranted('ROLE_ADMIN') && $this->siteContext->hasModule('ecommerce')) {
            $ecommerceStats = [
                'recentOrders' => $this->orderRepository->findRecent(5),
                'revenueThisMonth' => $this->orderRepository->revenueThisMonth(),
                'countPaidThisMonth' => $this->orderRepository->countPaidThisMonth(),
            ];
        }

        $tourSteps = $this->walkthroughService->getStepsForCurrentUser();
        $user = $this->getUser();
        $tourCompleted = $user instanceof User && $user->isTourCompleted();

        // Pages les plus vues : periode choisie par les pastilles (?period=)
        $topPagesPeriods = [
            'today' => "Aujourd'hui",
            'week' => 'Cette semaine',
            'month' => 'Ce mois',
            'year' => 'Cette année',
            'all' => 'Depuis le début',
        ];
        $request = $this->container->get('request_stack')->getCurrentRequest();
        $topPagesPeriod = $request?->query->getString('period', 'month') ?? 'month';
        if (!isset($topPagesPeriods[$topPagesPeriod])) {
            $topPagesPeriod = 'month';
        }
        $isAdmin = $this->isGranted('ROLE_ADMIN');

        // Accueil "a faire" : les taches d'abord, les chiffres detailles sont dans Statistiques
        $recent = array_values(array_filter(
            $this->contentHub->getItems(),
            static fn (array $item) => $item['date'] !== null,
        ));

        return $this->render('admin/dashboard.html.twig', [
            'title_admin' => $site?->getName() ?? 'Blog & Web',
            'site' => $site,
            'types' => $this->contentHub->getTypes(),
            'todos' => $this->adminTodoService->getTodos(),
            'figures' => $this->isGranted('ROLE_ADMIN') ? $this->adminTodoService->getKeyFigures() : null,
            // Vues, visiteurs uniques et robots, jour par jour (graphique de admin-dashboard.js)
            'dailyStats' => $this->isGranted('ROLE_ADMIN') ? $this->pageViewRepository->dailyStats(30) : null,
            'hasStats' => $this->siteContext->hasModule('marketing'),
            'statsSummary' => $isAdmin ? $this->statService->dashboardSummary() : null,
            'topPages' => $isAdmin ? $this->pageViewRepository->topPages(10, $topPagesPeriod) : null,
            'topPagesPeriod' => $topPagesPeriod,
            'topPagesPeriods' => $topPagesPeriods,
            'recent' => array_slice($recent, 0, 5),
            'ecommerceStats' => $ecommerceStats,
            'tourSteps' => $tourSteps,
            'tourCompleted' => $tourCompleted,
        ]);
    }

    #[Route('/admin/api/tour/complete', name: 'admin_tour_complete', methods: ['POST'])]
    #[IsGranted('ROLE_AUTHOR')]
    public function tourComplete(EntityManagerInterface $em): JsonResponse
    {
        $user = $this->getUser();
        if ($user instanceof User) {
            $user->setTourCompleted(true);
            $em->flush();
        }

        return new JsonResponse(['ok' => true]);
    }

    #[Route('/admin/api/tour/reset', name: 'admin_tour_reset', methods: ['POST'])]
    #[IsGranted('ROLE_AUTHOR')]
    public function tourReset(EntityManagerInterface $em): JsonResponse
    {
        $user = $this->getUser();
        if ($user instanceof User) {
            $user->setTourCompleted(false);
            $em->flush();
        }

        return new JsonResponse(['ok' => true]);
    }

    /**
     * Bascule mode simple / mode expert, enregistree sur le compte.
     */
    #[Route('/admin/mode-expert', name: 'admin_expert_toggle', methods: ['POST'])]
    #[IsGranted('ROLE_AUTHOR')]
    public function toggleExpert(Request $request, EntityManagerInterface $em): Response
    {
        $user = $this->getUser();
        if ($user instanceof User && $this->isCsrfTokenValid('admin_expert', $request->request->getString('_token'))) {
            $user->setAdminExpert(!$user->isAdminExpert());
            $em->flush();
        }

        // Retour sur la page d'origine, uniquement si elle est sur ce site
        $referer = $request->headers->get('referer');
        if ($referer !== null && str_starts_with($referer, $request->getSchemeAndHttpHost() . '/admin')) {
            return $this->redirect($referer);
        }

        return $this->redirectToRoute('admin');
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
            ->setTitle('<img src="/images/logo-blogweb.png" alt="Blog & Web" class="bw-admin-logo"/>')
            ->setLocales(['fr'])
            ->setFaviconPath('images/favicon-16x16.png')
            ->disableDarkMode();
    }

    /**
     * Menu par tache, pas par type de donnees : 8 entrees au plus.
     * Les classements (categories, tags), utilisateurs et modules sont regroupes
     * dans Reglages ; les types de contenu dans Contenus.
     */
    public function configureMenuItems(): iterable
    {
        yield MenuItem::linkToDashboard('Accueil', 'fas fa-house')
            ->setCssClass('tour-menu-dashboard');

        if ($this->isGranted('ROLE_AUTHOR')) {
            yield MenuItem::linkToRoute('Contenus', 'fas fa-file-lines', 'admin_contents')
                ->setCssClass('tour-menu-contents');
            yield MenuItem::linkToCrud('Médias', 'fas fa-image', Media::class)
                ->setCssClass('tour-menu-medias');
        }

        if ($this->isGranted('ROLE_ADMIN')) {
            $unread = $this->contactMessageRepository->countUnread();
            $messages = MenuItem::linkToCrud('Messages', 'fas fa-inbox', ContactMessage::class)
                ->setCssClass('tour-menu-messages');
            if ($unread > 0) {
                $messages->setBadge($unread, 'danger');
            }
            yield $messages;

            if ($this->siteContext->hasModule('ecommerce')) {
                yield MenuItem::linkToCrud('Commandes', 'fas fa-bag-shopping', Order::class);
            }

            if ($this->siteContext->hasModule('marketing')) {
                yield MenuItem::linkToRoute('Statistiques', 'fas fa-chart-column', 'admin_stats_index')
                    ->setCssClass('tour-menu-stats');
            }

            yield MenuItem::linkToCrud('Référencement', 'fas fa-magnifying-glass', Site::class)
                ->setController(SeoSettingsCrudController::class)
                ->setAction(Crud::PAGE_EDIT)
                ->setEntityId($this->siteContext->getCurrentSiteId())
                ->setCssClass('tour-menu-seo');

            yield MenuItem::linkToCrud('Apparence', 'fas fa-palette', Site::class)
                ->setController(ThemeSettingsCrudController::class)
                ->setAction(Crud::PAGE_EDIT)
                ->setEntityId($this->siteContext->getCurrentSiteId())
                ->setCssClass('tour-menu-apparence');

            yield MenuItem::linkToRoute('Réglages', 'fas fa-gear', 'admin_settings')
                ->setCssClass('tour-menu-settings');
        }

        yield MenuItem::section();
        yield MenuItem::linkToUrl('Voir mon site', 'fas fa-arrow-up-right-from-square', $this->generateUrl('app_home'))
            ->setLinkTarget('_blank')
            ->setCssClass('tour-menu-visit-site');
        yield MenuItem::linkToRoute('Aide', 'fas fa-circle-question', 'admin_guide')
            ->setCssClass('tour-menu-guide');
    }

    public function configureAssets(): Assets
    {
        return parent::configureAssets()
            ->addWebpackEncoreEntry('admin_editor')
            ->addWebpackEncoreEntry('admin_menu')
            ->addWebpackEncoreEntry('admin_fonts')
            ->addWebpackEncoreEntry('admin_icons')
            ->addWebpackEncoreEntry('admin_dashboard')
            ->addWebpackEncoreEntry('admin_walkthrough')
            ->addWebpackEncoreEntry('admin_stats')
            ->addWebpackEncoreEntry('admin_simple');
    }
}
