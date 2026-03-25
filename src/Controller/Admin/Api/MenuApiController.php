<?php

namespace App\Controller\Admin\Api;

use App\Entity\Menu;
use App\Repository\CategorieRepository;
use App\Repository\MenuRepository;
use App\Repository\PageRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class MenuApiController extends AbstractController
{
    #[Route('/admin/api/menu/reorder', name: 'admin_api_menu_reorder', methods: ['POST'])]
    public function reorder(
        Request $request,
        MenuRepository $menuRepository,
        EntityManagerInterface $em,
    ): JsonResponse {
        if (!$this->isCsrfTokenValid('menu_reorder', $request->headers->get('X-CSRF-Token'))) {
            return $this->json(['error' => 'Invalid CSRF token'], 403);
        }

        $data = json_decode($request->getContent(), true);
        if (!is_array($data) || !isset($data['items'])) {
            return $this->json(['error' => 'Invalid payload'], 400);
        }

        foreach ($data['items'] as $item) {
            $menu = $menuRepository->find($item['id']);
            if ($menu === null) {
                continue;
            }

            $menu->setMenuOrder((int) $item['position']);

            $parentId = $item['parentId'] ?? null;
            if ($parentId !== null) {
                $parent = $menuRepository->find($parentId);
                $menu->setParent($parent);
            } else {
                $menu->setParent(null);
            }
        }

        $em->flush();

        return $this->json(['success' => true]);
    }

    #[Route('/admin/api/menu/toggle-visibility/{id}', name: 'admin_api_menu_toggle_visibility', methods: ['POST'])]
    public function toggleVisibility(
        int $id,
        Request $request,
        MenuRepository $menuRepository,
        EntityManagerInterface $em,
    ): JsonResponse {
        if (!$this->isCsrfTokenValid('menu_reorder', $request->headers->get('X-CSRF-Token'))) {
            return $this->json(['error' => 'Invalid CSRF token'], 403);
        }

        $menu = $menuRepository->find($id);
        if ($menu === null) {
            return $this->json(['error' => 'Menu not found'], 404);
        }

        $menu->setIsVisible(!$menu->isIsVisible());
        $em->flush();

        return $this->json(['success' => true, 'visible' => $menu->isIsVisible()]);
    }

    #[Route('/admin/api/menu/add', name: 'admin_api_menu_add', methods: ['POST'])]
    public function add(
        Request $request,
        MenuRepository $menuRepository,
        PageRepository $pageRepository,
        CategorieRepository $categorieRepository,
        EntityManagerInterface $em,
    ): JsonResponse {
        if (!$this->isCsrfTokenValid('menu_reorder', $request->headers->get('X-CSRF-Token'))) {
            return $this->json(['error' => 'Invalid CSRF token'], 403);
        }

        $data = json_decode($request->getContent(), true);
        if (!is_array($data) || empty($data['name']) || empty($data['location'])) {
            return $this->json(['error' => 'Name and location required'], 400);
        }

        $menu = new Menu();
        $menu->setName($data['name']);
        $menu->setLocation($data['location']);
        $menu->setIsVisible(true);
        $menu->setMenuOrder($menuRepository->getNextOrder($data['location']));
        $menu->setTarget($data['target'] ?? 'url');

        // Link to page
        if (!empty($data['pageId'])) {
            $page = $pageRepository->find($data['pageId']);
            if ($page) {
                $menu->setPage($page);
                $menu->setTarget('page');
            }
        }

        // Link to categorie
        if (!empty($data['categorieId'])) {
            $cat = $categorieRepository->find($data['categorieId']);
            if ($cat) {
                $menu->setCategorie($cat);
                $menu->setTarget('categorie');
            }
        }

        // Route (for modules)
        if (!empty($data['route'])) {
            $menu->setRoute($data['route']);
            $menu->setRouteParams($data['routeParams'] ?? null);
            $menu->setTarget('route');
        }

        // Custom URL
        if (!empty($data['url'])) {
            $menu->setUrl($data['url']);
            $menu->setTarget('url');
        }

        // Empty parent (for dropdown menus)
        if (($data['target'] ?? '') === 'parent') {
            $menu->setTarget('url');
            $menu->setUrl('#');
        }

        $em->persist($menu);
        $em->flush();

        return $this->json([
            'success' => true,
            'item' => [
                'id' => $menu->getId(),
                'name' => $menu->getName(),
                'target' => $menu->getTarget(),
                'location' => $menu->getLocation(),
                'isSystem' => $menu->isSystem(),
                'isVisible' => $menu->isIsVisible(),
                'url' => $menu->getUrl(),
                'route' => $menu->getRoute(),
                'pageId' => $menu->getPage()?->getId(),
                'categorieId' => $menu->getCategorie()?->getId(),
            ],
        ]);
    }

    #[Route('/admin/api/menu/delete/{id}', name: 'admin_api_menu_delete', methods: ['POST'])]
    public function delete(
        int $id,
        Request $request,
        MenuRepository $menuRepository,
        EntityManagerInterface $em,
    ): JsonResponse {
        if (!$this->isCsrfTokenValid('menu_reorder', $request->headers->get('X-CSRF-Token'))) {
            return $this->json(['error' => 'Invalid CSRF token'], 403);
        }

        $menu = $menuRepository->find($id);
        if ($menu === null) {
            return $this->json(['error' => 'Menu not found'], 404);
        }

        if ($menu->isSystem()) {
            return $this->json(['error' => 'Cannot delete system menu item'], 403);
        }

        // Detach children before removing
        foreach ($menu->getChildren() as $child) {
            $child->setParent(null);
        }

        $em->remove($menu);
        $em->flush();

        return $this->json(['success' => true]);
    }

    #[Route('/admin/api/menu/rename/{id}', name: 'admin_api_menu_rename', methods: ['POST'])]
    public function rename(
        int $id,
        Request $request,
        MenuRepository $menuRepository,
        EntityManagerInterface $em,
    ): JsonResponse {
        if (!$this->isCsrfTokenValid('menu_reorder', $request->headers->get('X-CSRF-Token'))) {
            return $this->json(['error' => 'Invalid CSRF token'], 403);
        }

        $data = json_decode($request->getContent(), true);
        if (!is_array($data) || empty($data['name'])) {
            return $this->json(['error' => 'Name required'], 400);
        }

        $menu = $menuRepository->find($id);
        if ($menu === null) {
            return $this->json(['error' => 'Menu not found'], 404);
        }

        $menu->setName($data['name']);
        $em->flush();

        return $this->json(['success' => true, 'name' => $menu->getName()]);
    }
}
