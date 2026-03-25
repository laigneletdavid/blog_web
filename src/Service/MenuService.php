<?php

namespace App\Service;

use App\Entity\Menu;
use App\Enum\VisibilityEnum;
use App\Repository\MenuRepository;
use Symfony\Bundle\SecurityBundle\Security;

class MenuService
{
    /** @var array<string, Menu[]>|null */
    private ?array $allMenus = null;

    public function __construct(
        private MenuRepository $menuRepository,
        private Security $security,
    ) {
    }

    /**
     * @return Menu[]
     */
    public function findMenuTwig(): array
    {
        return $this->findByLocation('header');
    }

    /**
     * @return Menu[]
     */
    public function findByLocation(string $location): array
    {
        $all = $this->loadAll();
        $menus = $all[$location] ?? [];

        return array_values(array_filter($menus, fn (Menu $menu) => $this->isMenuAccessible($menu)));
    }

    /**
     * Load all locations in a single query, cached for the request.
     *
     * @return array<string, Menu[]>
     */
    private function loadAll(): array
    {
        if ($this->allMenus === null) {
            $this->allMenus = $this->menuRepository->findAllLocationsCached();
        }

        return $this->allMenus;
    }

    private function isMenuAccessible(Menu $menu): bool
    {
        $page = $menu->getPage();
        if ($page !== null) {
            $visibility = VisibilityEnum::tryFrom($page->getVisibility()) ?? VisibilityEnum::PUBLIC;
            $requiredRole = $visibility->requiredRole();
            if ($requiredRole !== null && !$this->security->isGranted($requiredRole)) {
                return false;
            }
        }

        $article = $menu->getArticle();
        if ($article !== null) {
            $visibility = VisibilityEnum::tryFrom($article->getVisibility()) ?? VisibilityEnum::PUBLIC;
            $requiredRole = $visibility->requiredRole();
            if ($requiredRole !== null && !$this->security->isGranted($requiredRole)) {
                return false;
            }
        }

        return true;
    }
}
