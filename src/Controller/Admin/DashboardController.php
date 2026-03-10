<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Comment;
use App\Entity\Media;
use App\Entity\Menu;
use App\Entity\Page;
use App\Entity\Site;
use App\Entity\User;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Assets;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Dashboard;
use EasyCorp\Bundle\EasyAdminBundle\Config\MenuItem;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractDashboardController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class DashboardController extends AbstractDashboardController
{
    public function __construct(
        private AdminUrlGenerator $adminUrlGenerator,
        private SiteContext $siteContext,
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
            yield MenuItem::linkToCrud('Articles', 'fas fa-newspaper', Article::class);
            yield MenuItem::linkToCrud('Catégories', 'fas fa-list', Categorie::class);
            yield MenuItem::linkToCrud('Pages', 'fas fa-file', Page::class);
            yield MenuItem::linkToCrud('Médias', 'fas fa-photo-video', Media::class);
        } elseif ($this->isGranted('ROLE_CORRECTOR')) {
            yield MenuItem::linkToCrud('Articles', 'fas fa-newspaper', Article::class);
            yield MenuItem::linkToCrud('Pages', 'fas fa-file', Page::class);
        }

        yield MenuItem::linkToCrud('Commentaires', 'fas fa-comment', Comment::class);

        // --- Administration (ROLE_ADMIN) ---
        if ($this->isGranted('ROLE_ADMIN')) {
            yield MenuItem::section('Administration');

            yield MenuItem::linkToCrud('Identité du site', 'fas fa-gear', Site::class)
                ->setAction(Crud::PAGE_DETAIL)
                ->setEntityId($this->siteContext->getCurrentSiteId());

            yield MenuItem::linkToCrud('Navigation', 'fas fa-bars', Menu::class);

            yield MenuItem::linkToCrud('Utilisateurs', 'fas fa-user', User::class);
        }

        // --- Aide ---
        yield MenuItem::section('Aide');
        yield MenuItem::linkToRoute('Aide', 'fa fa-question-circle', 'app_home');
    }

    public function configureAssets(): Assets
    {
        return parent::configureAssets()
            ->addCssFile('build/app.css');
    }
}
