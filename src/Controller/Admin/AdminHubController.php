<?php

namespace App\Controller\Admin;

use App\Service\AdminModeService;
use App\Service\ContentHubService;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

/**
 * Pages de regroupement de l'admin simplifiee : "Contenus" (tous les types de
 * contenu dans une liste) et "Reglages" (ce qu'on regle une fois).
 */
class AdminHubController extends AbstractController
{
    public function __construct(
        private readonly ContentHubService $contentHub,
        private readonly SiteContext $siteContext,
        private readonly AdminModeService $adminMode,
        private readonly AdminUrlGenerator $adminUrlGenerator,
    ) {
    }

    #[Route('/admin/contenus', name: 'admin_contents')]
    #[IsGranted('ROLE_AUTHOR')]
    public function contents(Request $request): Response
    {
        $types = $this->contentHub->getTypes();
        $type = $request->query->getString('type');
        $type = isset($types[$type]) ? $type : null;
        $search = trim($request->query->getString('q'));

        return $this->render('admin/hub/contents.html.twig', [
            'types' => $types,
            'currentType' => $type,
            'search' => $search,
            'items' => $this->contentHub->getItems($type, $search),
            'counts' => $this->contentHub->countByType(),
        ]);
    }

    #[Route('/admin/reglages', name: 'admin_settings')]
    #[IsGranted('ROLE_ADMIN')]
    public function settings(): Response
    {
        $siteId = $this->siteContext->getCurrentSiteId();
        $expert = $this->adminMode->isExpert();
        $has = fn (string $module) => $this->siteContext->hasModule($module);

        $cards = [
            ['title' => 'Identité du site', 'text' => 'Nom, accroche, logo, adresse, téléphone, réseaux sociaux', 'icon' => 'fa-building', 'url' => $this->crudUrl(SiteCrudController::class, Action::EDIT, $siteId)],
            ['title' => 'Menu du site', 'text' => 'Les liens affichés en haut et en bas de vos pages', 'icon' => 'fa-bars', 'url' => $this->generateUrl('admin_menu_manager')],
            ['title' => 'Utilisateurs', 'text' => 'Qui peut se connecter et écrire', 'icon' => 'fa-users', 'url' => $this->crudUrl(UserCrudController::class)],
        ];

        // Categories et etiquettes : un seul endroit pour tous les classements
        $classements = [];
        if ($has('blog')) {
            $classements[] = ['label' => 'Catégories du blog', 'url' => $this->crudUrl(CategorieCrudController::class)];
        }
        $classements[] = ['label' => 'Étiquettes', 'url' => $this->crudUrl(TagCrudController::class)];
        if ($expert) {
            $classements[] = ['label' => 'Familles d\'étiquettes', 'url' => $this->crudUrl(TagGroupCrudController::class)];
        }
        if ($has('faq')) {
            $classements[] = ['label' => 'Catégories de la FAQ', 'url' => $this->crudUrl(FaqCategoryCrudController::class)];
        }
        if ($has('portfolio')) {
            $classements[] = ['label' => 'Catégories des réalisations', 'url' => $this->crudUrl(PortfolioCategoryCrudController::class)];
        }
        if ($has('catalogue')) {
            $classements[] = ['label' => 'Catégories du catalogue', 'url' => $this->crudUrl(ProductCategoryCrudController::class)];
        }
        if ($has('directory')) {
            $classements[] = ['label' => 'Catégories de l\'annuaire', 'url' => $this->crudUrl(DirectoryCategoryCrudController::class)];
        }

        $expertCards = [];
        if ($expert) {
            $expertCards[] = ['title' => 'Abonnés à la lettre', 'text' => 'Liste, export et désinscriptions', 'icon' => 'fa-envelope', 'url' => $this->crudUrl(SubscriberCrudController::class)];
            if ($this->isGranted('ROLE_SUPER_ADMIN')) {
                $expertCards[] = ['title' => 'Modules', 'text' => 'Activer blog, services, FAQ, boutique…', 'icon' => 'fa-puzzle-piece', 'url' => $this->crudUrl(ModulesCrudController::class, Action::EDIT, $siteId)];
            }
        }

        return $this->render('admin/hub/settings.html.twig', [
            'cards' => $cards,
            'classements' => $classements,
            'expertCards' => $expertCards,
        ]);
    }

    private function crudUrl(string $crud, string $action = Action::INDEX, ?int $id = null): string
    {
        $generator = $this->adminUrlGenerator->unsetAll()
            ->setDashboard(DashboardController::class)
            ->setController($crud)
            ->setAction($action);

        if ($id !== null) {
            $generator->setEntityId($id);
        }

        return $generator->generateUrl();
    }
}
