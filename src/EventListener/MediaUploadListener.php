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
        // Guard against infinite loop (flush triggers postUpdate again)
        if ($this->processing) {
            return;
        }

        $this->processing = true;

        try {
            $webpFileName = $this->mediaProcessor->process($media);

            if ($webpFileName && $webpFileName !== $media->getWebpFileName()) {
                $media->setWebpFileName($webpFileName);
                $this->em->flush();
            }
        } finally {
            $this->processing = false;
        }
    }
}
