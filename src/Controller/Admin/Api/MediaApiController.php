<?php

namespace App\Controller\Admin\Api;

use App\Repository\MediaRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

/**
 * API interne pour l'editeur TipTap.
 * Fournit la liste des medias pour la modal d'insertion d'images.
 */
#[IsGranted('ROLE_AUTHOR')]
class MediaApiController extends AbstractController
{
    #[Route('/admin/api/media/list', name: 'admin_api_media_list', methods: ['GET'])]
    public function list(MediaRepository $mediaRepository): JsonResponse
    {
        $medias = $mediaRepository->findAll();

        $data = array_map(static fn($media) => [
            'id' => $media->getId(),
            'name' => $media->getName(),
            'file_name' => $media->getFileName(),
        ], $medias);

        return $this->json($data);
    }
}
