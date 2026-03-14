<?php

namespace App\Service;

use App\Entity\Site;

class SeoService
{
    public function __construct(
        private readonly SiteContext $siteContext,
    ) {
    }

    public function getCurrentSite(): ?Site
    {
        return $this->siteContext->getCurrentSite();
    }

    /**
     * Resout les donnees SEO pour une entite (Article, Page, Categorie).
     * Fallback : entity.seoTitle -> entity.title/name -> site.defaultSeoTitle -> site.name
     */
    public function resolve(object $entity): array
    {
        $site = $this->siteContext->getCurrentSite();

        $title = $this->resolveTitle($entity, $site);
        $description = $this->resolveDescription($entity, $site);
        $image = $this->resolveImage($entity);

        return [
            'title' => $title,
            'description' => $description,
            'keywords' => method_exists($entity, 'getSeoKeywords') ? ($entity->getSeoKeywords() ?? '') : '',
            'noIndex' => method_exists($entity, 'isNoIndex') ? $entity->isNoIndex() : false,
            'canonicalUrl' => method_exists($entity, 'getCanonicalUrl') ? $entity->getCanonicalUrl() : null,
            'image' => $image,
            'type' => $this->resolveType($entity),
            'publishedAt' => method_exists($entity, 'getPublishedAt') ? $entity->getPublishedAt() : null,
            'createdAt' => method_exists($entity, 'getCreatedAt') ? $entity->getCreatedAt() : null,
            'updatedAt' => method_exists($entity, 'getUpdatedAt') ? $entity->getUpdatedAt() : null,
        ];
    }

    /**
     * SEO pour la page d'accueil (pas d'entite specifique).
     */
    public function resolveForHome(): array
    {
        $site = $this->siteContext->getCurrentSite();

        return [
            'title' => $site?->getDefaultSeoTitle() ?? $site?->getName() ?? 'Blog&Web',
            'description' => $site?->getDefaultSeoDescription() ?? '',
            'keywords' => '',
            'noIndex' => false,
            'canonicalUrl' => null,
            'image' => $site?->getLogo()?->getFileName(),
            'type' => 'website',
            'publishedAt' => null,
            'createdAt' => null,
            'updatedAt' => null,
        ];
    }

    /**
     * SEO generique pour les pages sans entite (contact, etc.).
     */
    public function resolveForPage(string $pageTitle): array
    {
        $site = $this->siteContext->getCurrentSite();
        $siteName = $site?->getName() ?? 'Blog&Web';

        return [
            'title' => $pageTitle . ' - ' . $siteName,
            'description' => $site?->getDefaultSeoDescription() ?? '',
            'keywords' => '',
            'noIndex' => false,
            'canonicalUrl' => null,
            'image' => $site?->getLogo()?->getFileName(),
            'type' => 'website',
            'publishedAt' => null,
            'createdAt' => null,
            'updatedAt' => null,
        ];
    }

    private function resolveTitle(object $entity, ?Site $site): string
    {
        // 1. seoTitle de l'entite
        if (method_exists($entity, 'getSeoTitle') && $entity->getSeoTitle()) {
            return $entity->getSeoTitle();
        }

        // 2. title ou name de l'entite
        $entityTitle = null;
        if (method_exists($entity, 'getTitle')) {
            $entityTitle = $entity->getTitle();
        } elseif (method_exists($entity, 'getName')) {
            $entityTitle = $entity->getName();
        }

        if ($entityTitle) {
            $siteName = $site?->getName() ?? 'Blog&Web';
            return $entityTitle . ' - ' . $siteName;
        }

        // 3. Titre SEO par defaut du site
        if ($site?->getDefaultSeoTitle()) {
            return $site->getDefaultSeoTitle();
        }

        // 4. Nom du site
        return $site?->getName() ?? 'Blog&Web';
    }

    private function resolveDescription(object $entity, ?Site $site): string
    {
        if (method_exists($entity, 'getSeoDescription') && $entity->getSeoDescription()) {
            return $entity->getSeoDescription();
        }

        // Fallback sur featured_text pour les articles
        if (method_exists($entity, 'getFeaturedText') && $entity->getFeaturedText()) {
            return $entity->getFeaturedText();
        }

        return $site?->getDefaultSeoDescription() ?? '';
    }

    private function resolveImage(object $entity): ?string
    {
        if (method_exists($entity, 'getFeaturedMedia') && $entity->getFeaturedMedia()) {
            return $entity->getFeaturedMedia()->getFileName();
        }

        $site = $this->siteContext->getCurrentSite();
        return $site?->getLogo()?->getFileName();
    }

    private function resolveType(object $entity): string
    {
        $class = (new \ReflectionClass($entity))->getShortName();

        return match ($class) {
            'Article' => 'article',
            default => 'website',
        };
    }
}
