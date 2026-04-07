<?php

namespace App\EventListener;

use App\Entity\Site;
use App\Service\FaviconGeneratorService;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsEntityListener;
use Doctrine\ORM\Event\PostPersistEventArgs;
use Doctrine\ORM\Event\PostUpdateEventArgs;
use Doctrine\ORM\Events;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;

#[AsEntityListener(event: Events::postPersist, entity: Site::class)]
#[AsEntityListener(event: Events::postUpdate, entity: Site::class)]
class SiteLogoListener
{
    private const MAX_LOGO_HEIGHT = 128;

    public function __construct(
        private readonly FaviconGeneratorService $faviconGenerator,
        private readonly string $mediaDirectory,
    ) {
    }

    public function postPersist(Site $site, PostPersistEventArgs $args): void
    {
        $this->generateFavicons($site);
    }

    public function postUpdate(Site $site, PostUpdateEventArgs $args): void
    {
        $this->generateFavicons($site);
    }

    private function generateFavicons(Site $site): void
    {
        $logo = $site->getLogo();
        if ($logo === null) {
            return;
        }

        // Generate favicons from the original (high-res) logo first
        $this->faviconGenerator->generateFromLogo($logo);
        $this->faviconGenerator->generateWebManifest($site);
        $this->faviconGenerator->generateBrowserConfig($site);

        // Then downscale the logo for web display
        $this->downscaleLogo($logo->getFileName());

        // Also downscale dark logo if present
        $logoDark = $site->getLogoDark();
        if ($logoDark !== null) {
            $this->downscaleLogo($logoDark->getFileName());
        }
    }

    private function downscaleLogo(?string $fileName): void
    {
        if ($fileName === null) {
            return;
        }

        $path = $this->mediaDirectory . '/' . $fileName;
        if (!file_exists($path)) {
            return;
        }

        try {
            $manager = new ImageManager(new Driver());
            $image = $manager->read($path);

            if ($image->height() <= self::MAX_LOGO_HEIGHT) {
                return;
            }

            $image->scale(height: self::MAX_LOGO_HEIGHT);
            $extension = strtolower(pathinfo($path, PATHINFO_EXTENSION));
            match ($extension) {
                'png' => $image->toPng()->save($path),
                'gif' => $image->toGif()->save($path),
                default => $image->toJpeg(90)->save($path),
            };
        } catch (\Throwable) {
            // Silent failure — original remains untouched
        }
    }
}
