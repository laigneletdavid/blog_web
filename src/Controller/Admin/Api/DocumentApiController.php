<?php

namespace App\Controller\Admin\Api;

use App\Entity\Document;
use App\Repository\DocumentRepository;
use App\Service\DocumentService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Symfony\Component\String\Slugger\SluggerInterface;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\Validator\Validator\ValidatorInterface;

/**
 * API interne pour l'editeur TipTap.
 * Bibliotheque de documents (PDF, DOCX, ZIP...) + upload direct depuis l'editeur.
 */
#[IsGranted('ROLE_AUTHOR')]
class DocumentApiController extends AbstractController
{
    public function __construct(
        private readonly DocumentService $documentService,
        private readonly DocumentRepository $documentRepository,
        private readonly EntityManagerInterface $em,
        private readonly SluggerInterface $slugger,
        private readonly ValidatorInterface $validator,
    ) {
    }

    #[Route('/admin/api/document/list', name: 'admin_api_document_list', methods: ['GET'])]
    public function list(Request $request): JsonResponse
    {
        $query = trim((string) $request->query->get('q', ''));
        $documents = $this->documentRepository->search($query !== '' ? $query : null, 200);

        return $this->json(array_map(fn (Document $d) => $this->serialize($d), $documents));
    }

    #[Route('/admin/api/document/upload', name: 'admin_api_document_upload', methods: ['POST'])]
    public function upload(Request $request): JsonResponse
    {
        $uploaded = $request->files->get('file');
        $name = trim((string) $request->request->get('name', ''));

        if (!$uploaded) {
            return $this->json(['error' => 'Aucun fichier recu.'], 400);
        }

        $violations = $this->validator->validate($uploaded, new File(
            maxSize: DocumentService::MAX_FILE_SIZE_BYTES,
            extensions: DocumentService::ALLOWED_EXTENSIONS,
            extensionsMessage: 'Format non autorise.',
        ));

        if (count($violations) > 0) {
            return $this->json(['error' => $violations[0]->getMessage()], 400);
        }

        $originalName = $uploaded->getClientOriginalName();
        $extension = strtolower($uploaded->getClientOriginalExtension() ?: pathinfo($originalName, PATHINFO_EXTENSION));
        $baseSlug = $this->slugger->slug(pathinfo($originalName, PATHINFO_FILENAME))->lower()->toString() ?: 'document';
        $fileName = sprintf('%s-%s.%s', $baseSlug, bin2hex(random_bytes(6)), $extension);

        $directory = $this->documentService->getDocumentDirectory();
        if (!is_dir($directory)) {
            @mkdir($directory, 0775, true);
        }

        try {
            $uploaded->move($directory, $fileName);
        } catch (\Throwable $e) {
            return $this->json(['error' => 'Echec de l\'upload : ' . $e->getMessage()], 500);
        }

        $document = (new Document())
            ->setName($name !== '' ? $name : pathinfo($originalName, PATHINFO_FILENAME))
            ->setFileName($fileName);

        $this->em->persist($document);
        $this->em->flush();
        // Le listener postPersist a deja extrait extension/mime/size et flush a nouveau.

        return $this->json($this->serialize($document), 201);
    }

    /**
     * @return array<string, mixed>
     */
    private function serialize(Document $document): array
    {
        $size = $document->getSize();

        return [
            'id' => $document->getId(),
            'name' => $document->getName(),
            'file_name' => $document->getFileName(),
            'extension' => $document->getExtension(),
            'mime' => $document->getMimeType(),
            'size' => $size,
            'size_human' => $this->documentService->formatSize($size),
            'icon' => $this->documentService->iconForExtension($document->getExtension()),
            'url' => '/documents/files/' . $document->getFileName(),
        ];
    }
}
