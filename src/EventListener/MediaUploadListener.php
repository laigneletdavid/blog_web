<?php

namespace App\EventListener;

use App\Entity\Media;
use App\Service\MediaProcessorService;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsEntityListener;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\Events;

#[AsEntityListener(event: Events::postPersist, entity: Media::class)]
#[AsEntityListener(event: Events::postUpdate, entity: Media::class)]
class MediaUploadListener
{
    private bool $processing = false;

    public function __construct(
        private readonly MediaProcessorService $mediaProcessor,
        private readonly EntityManagerInterface $em,
    ) {
    }

    public function postPersist(Media $media): void
    {
        $this->processMedia($media);
    }

    public function postUpdate(Media $media): void
    {
        $this->processMedia($media);
    }

    private function processMedia(Media $media): void
    {
        if ($this->processing) {
            return;
        }

        $this->processing = true;

        try {
            $result = $this->mediaProcessor->process($media);

            if ($result === null) {
                return;
            }

            $changed = false;

            if ($result['webp'] && $result['webp'] !== $media->getWebpFileName()) {
                $media->setWebpFileName($result['webp']);
                $changed = true;
            }

            if ($result['width'] && $result['width'] !== $media->getWidth()) {
                $media->setWidth($result['width']);
                $media->setHeight($result['height']);
                $changed = true;
            }

            if ($changed) {
                $this->em->flush();
            }
        } finally {
            $this->processing = false;
        }
    }
}
