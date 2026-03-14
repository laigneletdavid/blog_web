<?php

namespace App\EventListener;

use App\Entity\Media;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsEntityListener;
use Doctrine\ORM\Events;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;

#[AsEntityListener(event: Events::postPersist, entity: Media::class)]
#[AsEntityListener(event: Events::postUpdate, entity: Media::class)]
class MediaUploadListener
{
    private const SUPPORTED_EXTENSIONS = ['jpg', 'jpeg', 'png', 'gif'];
    private const WEBP_QUALITY = 85;

    public function __construct(
        private readonly string $mediaDirectory,
    ) {
    }

    public function postPersist(Media $media): void
    {
        $this->convertToWebp($media);
    }

    public function postUpdate(Media $media): void
    {
        $this->convertToWebp($media);
    }

    private function convertToWebp(Media $media): void
    {
        $fileName = $media->getFileName();
        if (!$fileName) {
            return;
        }

        $extension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));
        if (!in_array($extension, self::SUPPORTED_EXTENSIONS, true)) {
            return;
        }

        $sourcePath = $this->mediaDirectory . '/' . $fileName;
        if (!file_exists($sourcePath)) {
            return;
        }

        $webpFileName = pathinfo($fileName, PATHINFO_FILENAME) . '.webp';
        $webpPath = $this->mediaDirectory . '/' . $webpFileName;

        // Ne pas reconvertir si le webp existe deja et est plus recent
        if (file_exists($webpPath) && filemtime($webpPath) >= filemtime($sourcePath)) {
            $media->setWebpFileName($webpFileName);
            return;
        }

        try {
            $manager = new ImageManager(new Driver());
            $image = $manager->read($sourcePath);
            $encoded = $image->toWebp(self::WEBP_QUALITY);
            $encoded->save($webpPath);

            $media->setWebpFileName($webpFileName);
        } catch (\Throwable) {
            // Conversion echouee silencieusement — l'original reste disponible
        }
    }
}
