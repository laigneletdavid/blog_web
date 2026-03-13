<?php

namespace App\Controller\Admin\Api;

use App\Repository\MenuRepository;
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
        $token = $request->headers->get('X-CSRF-Token');
        if (!$this->isCsrfTokenValid('menu_reorder', $token)) {
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
        $token = $request->headers->get('X-CSRF-Token');
        if (!$this->isCsrfTokenValid('menu_reorder', $token)) {
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
}
