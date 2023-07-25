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
use App\Repository\SiteRepository;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Dashboard;
use EasyCorp\Bundle\EasyAdminBundle\Config\MenuItem;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractDashboardController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;


class DashboardController extends AbstractDashboardController
{
    public function __construct(
        private AdminUrlGenerator $adminUrlGenerator,
        private SiteRepository $siteRepository
    )
    {
    }

    #[Route('/admin', name: 'admin')]
    public function index(): Response
    {
        $site = $this->siteRepository->find('1');

        return $this->render('admin/dashboard.html.twig', [
            'title_admin' => 'Bienvenue sur votre espace d\'administration',
            'site' => $site,
        ]);

    }

    public function configureDashboard(): Dashboard
    {
        $site = null;
        $site = $this->siteRepository->find('1');
        if ($site !== null) {
            $site_name = $this->siteRepository->find('1')->getName();
        }
        else {
            $site_name = 'Administration';
        }

        return Dashboard::new()
            ->setTitle($site_name)
            ->setLocales(['fr']);
    }

    public function configureMenuItems(): iterable
    {

        yield MenuItem::section('Navigation');

        yield MenuItem::linkToUrl('Tableau de bord', 'fa fa-gauge', $this->generateUrl('admin'));
        yield MenuItem::linkToUrl('Aller sur le site', 'fa fa-undo', $this->generateUrl('app_home'));

        yield MenuItem::section('Réglages');

        // Identité du site
        if ($this->isGranted('ROLE_ADMIN')) {
            yield MenuItem::linkToCrud('Identité du site', 'fas fa-gear', Site::class)
                ->setAction(Crud::PAGE_DETAIL)->setEntityId(1);
        }

        // Gestion des articles
        if ($this->isGranted('ROLE_AUTHOR')) {
            yield MenuItem::subMenu('Articles', 'fas fa-newspaper')->setSubItems([
                MenuItem::linkToCrud('Tous les articles', 'fas fa-newspaper', Article::class),
                MenuItem::linkToCrud('Ajouter un article', 'fas fa-plus', Article::class)->setAction(Crud::PAGE_NEW),
                MenuItem::linkToCrud('Catégories', 'fas fa-list', Categorie::class),
            ]);
        }
        else if ($this->isGranted('ROLE_CORRECTOR')) {
            yield MenuItem::subMenu('Articles', 'fas fa-newspaper')->setSubItems([
                MenuItem::linkToCrud('Tous les articles', 'fas fa-newspaper', Article::class),
            ]);
        }

        // Gestion des pages
        if ($this->isGranted('ROLE_AUTHOR')) {
            yield MenuItem::subMenu('Pages', 'fas fa-file')->setSubItems([
                MenuItem::linkToCrud('Toutes les pages', 'fas fa-file', Page::class),
                MenuItem::linkToCrud('Ajouter une page', 'fas fa-plus', Page::class)->setAction(Crud::PAGE_NEW),
            ]);
        }
        else if ($this->isGranted('ROLE_CORRECTOR')) {
            yield MenuItem::subMenu('Pages', 'fas fa-file')->setSubItems([
                MenuItem::linkToCrud('Toutes les pages', 'fas fa-file', Page::class),
            ]);
        }

        //Gestion des médias
        if ($this->isGranted('ROLE_AUTHOR')) {
            yield MenuItem::subMenu('Media', 'fas fa-photo-video')->setSubItems([
                MenuItem::linkToCrud('Toutes les médias', 'fas fa-photo-video', Media::class),
                MenuItem::linkToCrud('Ajouter un média', 'fas fa-plus', Media::class)->setAction(Crud::PAGE_NEW),
            ]);
        }

        // Gestion des menus, Utilisateurs et Commenatires
        if ($this->isGranted('ROLE_ADMIN')) {
            yield MenuItem::subMenu('Menus', 'fas fa-bars')->setSubItems([
                MenuItem::linkToCrud('Tous les liens du menu', 'fas fa-bars', Menu::class)
                    ->setController(MenuCrudController::class),
                MenuItem::linkToCrud('Une page', 'fas fa-plus', Menu::class)
                    ->setController(MenuPageCrudController::class)
                    ->setQueryParameter('target', 'page'),
                MenuItem::linkToCrud('Une catégorie', 'fas fa-plus', Menu::class)
                    ->setController(MenuCategoriesCrudController::class)
                    ->setQueryParameter('target', 'categorie'),

                MenuItem::linkToCrud('Un article', 'fas fa-plus', Menu::class)
                    ->setController(MenuArticleCrudController::class)
                    ->setQueryParameter('target', 'article'),
            ]);

            yield MenuItem::subMenu('Utilisateurs', 'fas fa-user')->setSubItems([
                MenuItem::linkToCrud('Toutes les utilisateurs', 'fas fa-user', User::class),
                MenuItem::linkToCrud('Ajouter un utilisateur', 'fas fa-plus', User::class)->setAction(Crud::PAGE_NEW),
            ]);

            yield MenuItem::linkToCrud('Commentaires', 'fas fa-comment', Comment::class);
        }

        yield MenuItem::section('Aide & Formation');

        yield MenuItem::linkToRoute('Aide', 'fa fa-question', 'app_home');

        yield MenuItem::linkToUrl('Formation', 'fab fa-leanpub', 'https://google.com');

        yield MenuItem::linkToRoute('Contact support', 'fa fa-envelope', 'app_home');
    }

    public function url(){
       $url_site = $this->adminUrlGenerator
            ->setController(SiteCrudController::class)
            ->setAction(Action::INDEX)
            ->generateUrl();
        $url_page = $this->adminUrlGenerator
            ->setController(PageCrudController::class)
            ->setAction(Action::INDEX)
            ->generateUrl();
        $url_blog = $this->adminUrlGenerator
            ->setController(ArticleCrudController::class)
            ->setAction(Action::INDEX)
            ->generateUrl();

    }

}
