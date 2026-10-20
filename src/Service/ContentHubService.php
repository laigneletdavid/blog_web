<?php

namespace App\Service;

use App\Controller\Admin\ArticleCrudController;
use App\Controller\Admin\DashboardController;
use App\Controller\Admin\DirectoryEntryCrudController;
use App\Controller\Admin\EventCrudController;
use App\Controller\Admin\FaqCrudController;
use App\Controller\Admin\LandingCrudController;
use App\Controller\Admin\PageCrudController;
use App\Controller\Admin\PortfolioItemCrudController;
use App\Controller\Admin\ProductCrudController;
use App\Controller\Admin\ServiceCrudController;
use App\Entity\Article;
use App\Entity\DirectoryEntry;
use App\Entity\Event;
use App\Entity\Faq;
use App\Entity\Page;
use App\Entity\PortfolioItem;
use App\Entity\Product;
use App\Entity\Service;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use Symfony\Bundle\SecurityBundle\Security;

/**
 * Page "Contenus" de l'admin : tous les contenus editables (articles, pages,
 * services, evenements...) dans une seule liste, selon les modules actifs et
 * les droits du compte. Chaque ligne renvoie vers le formulaire EasyAdmin du type.
 */
class ContentHubService
{
    private const MAX_PER_TYPE = 300;

    /**
     * module : module requis (null = toujours) ; role : role minimal.
     * hint : sous-titre du bouton "Creer".
     */
    private const TYPES = [
        'article' => ['label' => 'Article', 'plural' => 'Articles', 'entity' => Article::class, 'crud' => ArticleCrudController::class, 'module' => 'blog', 'role' => 'ROLE_AUTHOR', 'create' => 'Un article', 'hint' => 'Une actualité, un conseil'],
        'page' => ['label' => 'Page', 'plural' => 'Pages', 'entity' => Page::class, 'crud' => PageCrudController::class, 'module' => null, 'role' => 'ROLE_AUTHOR', 'create' => 'Une page', 'hint' => 'Présentation, tarifs, contact…'],
        'service' => ['label' => 'Service', 'plural' => 'Services', 'entity' => Service::class, 'crud' => ServiceCrudController::class, 'module' => 'services', 'role' => 'ROLE_ADMIN', 'create' => 'Un service', 'hint' => 'Une prestation, une expertise'],
        'event' => ['label' => 'Événement', 'plural' => 'Événements', 'entity' => Event::class, 'crud' => EventCrudController::class, 'module' => 'events', 'role' => 'ROLE_ADMIN', 'create' => 'Un événement', 'hint' => 'Une date à l\'agenda'],
        'portfolio' => ['label' => 'Réalisation', 'plural' => 'Réalisations', 'entity' => PortfolioItem::class, 'crud' => PortfolioItemCrudController::class, 'module' => 'portfolio', 'role' => 'ROLE_ADMIN', 'create' => 'Une réalisation', 'hint' => 'Un projet à montrer'],
        'product' => ['label' => 'Produit', 'plural' => 'Produits', 'entity' => Product::class, 'crud' => ProductCrudController::class, 'module' => 'catalogue', 'role' => 'ROLE_ADMIN', 'create' => 'Un produit', 'hint' => 'Une fiche du catalogue'],
        'faq' => ['label' => 'Question', 'plural' => 'FAQ', 'entity' => Faq::class, 'crud' => FaqCrudController::class, 'module' => 'faq', 'role' => 'ROLE_ADMIN', 'create' => 'Une question', 'hint' => 'Pour la foire aux questions'],
        'directory' => ['label' => 'Fiche', 'plural' => 'Annuaire', 'entity' => DirectoryEntry::class, 'crud' => DirectoryEntryCrudController::class, 'module' => 'directory', 'role' => 'ROLE_ADMIN', 'create' => 'Une fiche', 'hint' => 'Un membre de l\'annuaire'],
        'landing' => ['label' => 'Landing', 'plural' => 'Landing pages', 'entity' => Page::class, 'crud' => LandingCrudController::class, 'module' => 'marketing', 'role' => 'ROLE_ADMIN', 'create' => 'Une landing page', 'hint' => 'Une page de campagne'],
    ];

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly SiteContext $siteContext,
        private readonly Security $security,
        private readonly AdminUrlGenerator $adminUrlGenerator,
    ) {
    }

    /**
     * Types visibles pour ce compte et ce site, dans l'ordre d'affichage.
     *
     * @return array<string, array{key: string, label: string, plural: string, create: string, hint: string, newUrl: string}>
     */
    public function getTypes(): array
    {
        $types = [];
        foreach (self::TYPES as $key => $def) {
            if ($def['module'] !== null && !$this->siteContext->hasModule($def['module'])) {
                continue;
            }
            if (!$this->security->isGranted($def['role'])) {
                continue;
            }
            $types[$key] = [
                'key' => $key,
                'label' => $def['label'],
                'plural' => $def['plural'],
                'create' => $def['create'],
                'hint' => $def['hint'],
                'newUrl' => $this->url($def['crud'], Action::NEW),
            ];
        }

        return $types;
    }

    /**
     * @return list<array{type: string, typeLabel: string, title: string, published: bool, date: ?\DateTimeInterface, editUrl: string}>
     */
    public function getItems(?string $type = null, ?string $search = null): array
    {
        $items = [];
        foreach ($this->getTypes() as $key => $typeInfo) {
            if ($type !== null && $type !== $key) {
                continue;
            }
            $def = self::TYPES[$key];

            $qb = $this->em->getRepository($def['entity'])->createQueryBuilder('e')
                ->orderBy('e.id', 'DESC')
                ->setMaxResults(self::MAX_PER_TYPE);

            // Pages et landing pages partagent l'entite Page, distinguees par le gabarit
            if ($key === 'page') {
                $qb->andWhere('e.template != :landing OR e.template IS NULL')->setParameter('landing', 'landing');
            } elseif ($key === 'landing') {
                $qb->andWhere('e.template = :landing')->setParameter('landing', 'landing');
            }

            foreach ($qb->getQuery()->getResult() as $entity) {
                $title = $this->titleOf($entity);
                if ($search !== null && $search !== '' && mb_stripos($title, $search) === false) {
                    continue;
                }

                $items[] = [
                    'type' => $key,
                    'typeLabel' => $typeInfo['label'],
                    'title' => $title,
                    'published' => $this->isPublished($entity),
                    'date' => $this->dateOf($entity),
                    'editUrl' => $this->url($def['crud'], Action::EDIT, $entity->getId()),
                ];
            }
        }

        // Les plus recemment modifies d'abord ; sans date, apres, dans l'ordre de creation
        usort($items, static function (array $a, array $b): int {
            if ($a['date'] === null || $b['date'] === null) {
                return ($a['date'] === null) <=> ($b['date'] === null);
            }

            return $b['date'] <=> $a['date'];
        });

        return $items;
    }

    /**
     * @return array<string, int> nombre de contenus par type
     */
    public function countByType(): array
    {
        $counts = [];
        foreach ($this->getItems() as $item) {
            $counts[$item['type']] = ($counts[$item['type']] ?? 0) + 1;
        }

        return $counts;
    }

    private function url(string $crud, string $action, ?int $id = null): string
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

    private function titleOf(object $entity): string
    {
        foreach (['getTitle', 'getDisplayName'] as $getter) {
            if (method_exists($entity, $getter) && $entity->$getter()) {
                return (string) $entity->$getter();
            }
        }

        return method_exists($entity, '__toString') ? (string) $entity : '#' . $entity->getId();
    }

    private function isPublished(object $entity): bool
    {
        if (method_exists($entity, 'isPublished')) {
            return (bool) $entity->isPublished();
        }

        return method_exists($entity, 'isActive') && $entity->isActive();
    }

    private function dateOf(object $entity): ?\DateTimeInterface
    {
        foreach (['getUpdatedAt', 'getCreatedAt'] as $getter) {
            if (method_exists($entity, $getter) && $entity->$getter() instanceof \DateTimeInterface) {
                return $entity->$getter();
            }
        }

        return null;
    }
}
