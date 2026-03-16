<?php

namespace App\EventListener;

use App\Entity\Media;
use App\Service\MediaProcessorService;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsEntityListener;
use Doctrine\ORM\Events;

#[AsEntityListener(event: Events::postPersist, entity: Media::class)]
#[AsEntityListener(event: Events::postUpdate, entity: Media::class)]
class MediaUploadListener
{
    public function __construct(
        private readonly MediaProcessorService $mediaProcessor,
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
        $webpFileName = $this->mediaProcessor->process($media);

        if ($webpFileName) {
            $media->setWebpFileName($webpFileName);
        }
    }
}
