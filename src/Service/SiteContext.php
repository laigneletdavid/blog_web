<?php

namespace App\Service;

use App\Entity\Site;
use App\Repository\SiteRepository;

/**
 * Résout le site courant.
 *
 * Pour l'instant : retourne find(1) (mode clone = 1 site par instance).
 * Quand on passera en multi-tenant : résoudre via le domaine (request host).
 */
class SiteContext
{
    private ?Site $currentSite = null;
    private bool $loaded = false;

    public function __construct(
        private readonly SiteRepository $siteRepository,
    ) {
    }

    public function getCurrentSite(): ?Site
    {
        if (!$this->loaded) {
            $this->currentSite = $this->siteRepository->find(1);
            $this->loaded = true;
        }

        return $this->currentSite;
    }

    /**
     * Retourne l'ID du site courant (utile pour EasyAdmin setEntityId).
     */
    public function getCurrentSiteId(): ?int
    {
        return $this->getCurrentSite()?->getId();
    }
}
