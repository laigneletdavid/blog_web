<?php

namespace App\Controller\Admin\Api;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_AUTHOR')]
class IconApiController extends AbstractController
{
    #[Route('/admin/api/icons', name: 'admin_api_icons', methods: ['GET'])]
    public function list(Request $request): JsonResponse
    {
        $projectDir = $this->getParameter('kernel.project_dir');
        $iconsDir = $projectDir . '/public/icons';
        $q = mb_strtolower(trim($request->query->get('q', '')));

        if (!is_dir($iconsDir)) {
            return $this->json([]);
        }

        $icons = [];
        foreach (glob($iconsDir . '/*.svg') ?: [] as $file) {
            $name = basename($file, '.svg');
            if ($q !== '' && !str_contains(mb_strtolower($name), $q)) {
                continue;
            }
            $icons[] = [
                'name' => $name,
                'url' => '/icons/' . $name . '.svg',
            ];
        }

        sort($icons);

        return $this->json($icons);
    }
}
