<?php

namespace App\Service;

use App\Entity\Media;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;

class MediaProcessorService
{
    private const SUPPORTED_EXTENSIONS = ['jpg', 'jpeg', 'png', 'gif'];
    private const WEBP_QUALITY = 85;
    private const MAX_WIDTH = 1920;
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
     * Returns ['webp' => filename, 'width' => int, 'height' => int] or null on failure.
     */
    public function process(Media $media, bool $force = false): ?array
    {
        $fileName = $media->getFileName();
        if (!$fileName || !$this->isSupported($fileName)) {
            return null;
        }

        $sourcePath = $this->mediaDirectory . '/' . $fileName;
        if (!file_exists($sourcePath)) {
            return null;
        }

        $this->downscaleOriginal($sourcePath);

        $dimensions = $this->readDimensions($sourcePath);

        $baseName = pathinfo($fileName, PATHINFO_FILENAME);
        $webpFileName = $baseName . '.webp';
        $webpPath = $this->mediaDirectory . '/' . $webpFileName;

        $needsConversion = $force
            || !file_exists($webpPath)
            || filemtime($webpPath) < filemtime($sourcePath);

        if (!$needsConversion) {
            $this->generateResponsiveSizes($sourcePath, $baseName, $force);

            return ['webp' => $webpFileName, ...$dimensions];
        }

        try {
            $manager = new ImageManager(new Driver());
            $image = $manager->read($sourcePath);
            $encoded = $image->toWebp(self::WEBP_QUALITY);
            $encoded->save($webpPath);

            $this->generateResponsiveSizes($sourcePath, $baseName, $force);

            return ['webp' => $webpFileName, ...$dimensions];
        } catch (\Throwable) {
            return null;
        }
    }

    public function readDimensions(string $sourcePath): array
    {
        $size = @getimagesize($sourcePath);
        if ($size) {
            return ['width' => $size[0], 'height' => $size[1]];
        }

        return ['width' => null, 'height' => null];
    }

    private function downscaleOriginal(string $sourcePath): void
    {
        try {
            $manager = new ImageManager(new Driver());
            $image = $manager->read($sourcePath);

            if ($image->width() > self::MAX_WIDTH) {
                $image->scale(width: self::MAX_WIDTH);
                $extension = strtolower(pathinfo($sourcePath, PATHINFO_EXTENSION));
                match ($extension) {
                    'png' => $image->toPng()->save($sourcePath),
                    'gif' => $image->toGif()->save($sourcePath),
                    default => $image->toJpeg(90)->save($sourcePath),
                };
            }
        } catch (\Throwable) {
            // Silent failure — original remains untouched
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
