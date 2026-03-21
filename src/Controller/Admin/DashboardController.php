<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Comment;
use App\Entity\Event;
use App\Entity\Media;
use App\Entity\Page;
use App\Entity\Service;
use App\Entity\Site;
use App\Entity\SiteGalleryItem;
use App\Entity\Tag;
use App\Entity\User;
use App\Repository\MenuRepository;
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
    ) {
    }

    #[Route('/admin', name: 'admin')]
    public function index(): Response
    {
        $site = $this->siteContext->getCurrentSite();

        return $this->render('admin/dashboard.html.twig', [
            'title_admin' => $site?->getName() ?? 'Blog & Web',
            'site' => $site,
        ]);
    }

    #[Route('/admin/menu-manager', name: 'admin_menu_manager')]
    #[IsGranted('ROLE_ADMIN')]
    public function menuManager(MenuRepository $menuRepository): Response
    {
        return $this->render('admin/menu/sortable.html.twig', [
            'menus' => $menuRepository->findAllOrdered(),
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
            throw $this->createNotFoundException('Apercu non disponible.');
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
                yield MenuItem::linkToCrud('Articles', 'fas fa-newspaper', Article::class);
                yield MenuItem::linkToCrud('Categories', 'fas fa-list', Categorie::class);
                yield MenuItem::linkToCrud('Tags', 'fas fa-tags', Tag::class);
            }
            yield MenuItem::linkToCrud('Pages', 'fas fa-file', Page::class);
            yield MenuItem::linkToCrud('Medias', 'fas fa-photo-video', Media::class);
        } elseif ($this->isGranted('ROLE_CORRECTOR')) {
            if ($this->siteContext->hasModule('blog')) {
                yield MenuItem::linkToCrud('Articles', 'fas fa-newspaper', Article::class);
            }
            yield MenuItem::linkToCrud('Pages', 'fas fa-file', Page::class);
        }

        if ($this->isGranted('ROLE_ADMIN') && $this->siteContext->hasModule('services')) {
            yield MenuItem::linkToCrud('Services', 'fas fa-concierge-bell', Service::class);
        }

        if ($this->isGranted('ROLE_ADMIN') && $this->siteContext->hasModule('events')) {
            yield MenuItem::linkToCrud('Événements', 'fas fa-calendar-days', Event::class);
        }

        if ($this->siteContext->hasModule('blog')) {
            yield MenuItem::linkToCrud('Commentaires', 'fas fa-comment', Comment::class);
        }

        // --- Administration (ROLE_ADMIN) ---
        if ($this->isGranted('ROLE_ADMIN')) {
            yield MenuItem::section('Administration');

            yield MenuItem::linkToCrud('Identite du site', 'fas fa-gear', Site::class)
                ->setController(SiteCrudController::class)
                ->setAction(Crud::PAGE_EDIT)
                ->setEntityId($this->siteContext->getCurrentSiteId());

            yield MenuItem::linkToRoute('Navigation', 'fas fa-bars', 'admin_menu_manager');

            yield MenuItem::linkToCrud('Utilisateurs', 'fas fa-user', User::class);
        }

        // --- Apparence (ROLE_FREELANCE+) ---
        if ($this->isGranted('ROLE_FREELANCE')) {
            yield MenuItem::section('Apparence');

            yield MenuItem::linkToRoute('Catalogue de themes', 'fas fa-palette', 'admin_theme_browser');

            yield MenuItem::linkToCrud('Reglages du theme', 'fas fa-sliders', Site::class)
                ->setController(ThemeSettingsCrudController::class)
                ->setAction(Crud::PAGE_EDIT)
                ->setEntityId($this->siteContext->getCurrentSiteId());

            yield MenuItem::linkToCrud('Images du theme', 'fas fa-images', SiteGalleryItem::class)
                ->setController(ThemeImagesCrudController::class);

            if ($this->isGranted('ROLE_SUPER_ADMIN')) {
                yield MenuItem::linkToCrud('Modules', 'fas fa-puzzle-piece', Site::class)
                    ->setController(ModulesCrudController::class)
                    ->setAction(Crud::PAGE_EDIT)
                    ->setEntityId($this->siteContext->getCurrentSiteId());
            }
        }

        // --- Aide ---
        yield MenuItem::section('Aide');
        yield MenuItem::linkToRoute('Aide', 'fa fa-question-circle', 'app_home');
    }

    public function configureAssets(): Assets
    {
        return parent::configureAssets()
            ->addWebpackEncoreEntry('admin_editor')
            ->addWebpackEncoreEntry('admin_menu')
            ->addWebpackEncoreEntry('admin_fonts');
    }
}
