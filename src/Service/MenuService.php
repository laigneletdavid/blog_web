<?php

namespace App\Service;

use App\Entity\Menu;
use App\Enum\VisibilityEnum;
use App\Repository\MenuRepository;
use Symfony\Bundle\SecurityBundle\Security;

class MenuService
{
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
        $menus = $this->menuRepository->findMenuVisible();

        return array_filter($menus, fn (Menu $menu) => $this->isMenuAccessible($menu));
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
