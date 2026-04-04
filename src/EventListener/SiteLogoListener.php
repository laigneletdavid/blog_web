<?php

namespace App\EventListener;

use App\Entity\Site;
use App\Service\FaviconGeneratorService;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsEntityListener;
use Doctrine\ORM\Event\PostPersistEventArgs;
use Doctrine\ORM\Event\PostUpdateEventArgs;
use Doctrine\ORM\Events;

#[AsEntityListener(event: Events::postPersist, entity: Site::class)]
#[AsEntityListener(event: Events::postUpdate, entity: Site::class)]
class SiteLogoListener
{
    public function __construct(
        private readonly FaviconGeneratorService $faviconGenerator,
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

        $this->faviconGenerator->generateFromLogo($logo);
        $this->faviconGenerator->generateWebManifest($site);
        $this->faviconGenerator->generateBrowserConfig($site);
    }
}
