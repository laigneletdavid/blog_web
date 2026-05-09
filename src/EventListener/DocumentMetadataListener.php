<?php

namespace App\EventListener;

use App\Entity\Document;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsEntityListener;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\Events;
use Symfony\Component\Mime\MimeTypes;

#[AsEntityListener(event: Events::postPersist, entity: Document::class)]
#[AsEntityListener(event: Events::postUpdate, entity: Document::class)]
class DocumentMetadataListener
{
    private bool $processing = false;

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly string $documentDirectory,
    ) {
    }

    public function postPersist(Document $document): void
    {
        $this->extract($document);
    }

    public function postUpdate(Document $document): void
    {
        $this->extract($document);
    }

    private function extract(Document $document): void
    {
        if ($this->processing) {
            return;
        }

        $fileName = $document->getFileName();
        if (!$fileName) {
            return;
        }

        $path = $this->documentDirectory . '/' . $fileName;
        if (!is_file($path)) {
            return;
        }

        $extension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION)) ?: null;
        $size = @filesize($path);
        $size = $size === false ? null : $size;

        $mimeType = (new MimeTypes())->guessMimeType($path);

        $changed = false;

        if ($document->getExtension() !== $extension) {
            $document->setExtension($extension);
            $changed = true;
        }

        if ($document->getSize() !== $size) {
            $document->setSize($size);
            $changed = true;
        }

        if ($document->getMimeType() !== $mimeType) {
            $document->setMimeType($mimeType);
            $changed = true;
        }

        if (!$changed) {
            return;
        }

        $this->processing = true;
        try {
            $this->em->flush();
        } finally {
            $this->processing = false;
        }
    }
}
