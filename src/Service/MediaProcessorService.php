<?php

namespace App\Service;

use App\Entity\Media;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;

class MediaProcessorService
{
    private const SUPPORTED_EXTENSIONS = ['jpg', 'jpeg', 'png', 'gif'];
    private const WEBP_QUALITY = 85;
    public const RESPONSIVE_SIZES = [480, 800, 1200];

    public function __construct(
        private readonly string $mediaDirectory,
    ) {
    }

    public function isSupported(string $fileName): bool
    {
        $extension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

        return in_array($extension, self::SUPPORTED_EXTENSIONS, true);
    }

    /**
     * Convert an image to WebP and generate responsive sizes.
     * Returns the WebP filename or null on failure.
     */
    public function process(Media $media, bool $force = false): ?string
    {
        $fileName = $media->getFileName();
        if (!$fileName || !$this->isSupported($fileName)) {
            return null;
        }

        $sourcePath = $this->mediaDirectory . '/' . $fileName;
        if (!file_exists($sourcePath)) {
            return null;
        }

        $baseName = pathinfo($fileName, PATHINFO_FILENAME);
        $webpFileName = $baseName . '.webp';
        $webpPath = $this->mediaDirectory . '/' . $webpFileName;

        $needsConversion = $force
            || !file_exists($webpPath)
            || filemtime($webpPath) < filemtime($sourcePath);

        if (!$needsConversion) {
            $this->generateResponsiveSizes($sourcePath, $baseName, $force);

            return $webpFileName;
        }

        try {
            $manager = new ImageManager(new Driver());
            $image = $manager->read($sourcePath);
            $encoded = $image->toWebp(self::WEBP_QUALITY);
            $encoded->save($webpPath);

            $this->generateResponsiveSizes($sourcePath, $baseName, $force);

            return $webpFileName;
        } catch (\Throwable) {
            return null;
        }
    }

    public function generateResponsiveSizes(string $sourcePath, string $baseName, bool $force = false): void
    {
        try {
            $manager = new ImageManager(new Driver());
            $originalWidth = $manager->read($sourcePath)->width();

            foreach (self::RESPONSIVE_SIZES as $targetWidth) {
                if ($originalWidth <= $targetWidth) {
                    continue;
                }

                $sizedPath = $this->mediaDirectory . '/' . $baseName . '-' . $targetWidth . 'w.webp';

                if (!$force && file_exists($sizedPath) && filemtime($sizedPath) >= filemtime($sourcePath)) {
                    continue;
                }

                $resized = $manager->read($sourcePath)
                    ->scale(width: $targetWidth)
                    ->toWebp(self::WEBP_QUALITY);
                $resized->save($sizedPath);
            }
        } catch (\Throwable) {
            // Silent failure — originals remain available
        }
    }
}
