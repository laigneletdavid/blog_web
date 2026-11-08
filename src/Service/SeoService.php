<?php

namespace App\Service;

use App\Entity\Site;
use App\Repository\OptionRepository;

class SeoService
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly ?OptionRepository $optionRepository = null,
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
        $imageMedia = $this->resolveImageMedia($entity);
        $image = $imageMedia?->getFileName() ?? $this->resolveSiteImage($site);

        return [
            'title' => $title,
            'description' => $description,
            'keywords' => method_exists($entity, 'getSeoKeywords') ? ($entity->getSeoKeywords() ?? '') : '',
            'noIndex' => method_exists($entity, 'isNoIndex') ? $entity->isNoIndex() : false,
            'canonicalUrl' => method_exists($entity, 'getCanonicalUrl') ? $entity->getCanonicalUrl() : null,
            'image' => $image,
            'imageWidth' => $imageMedia?->getWidth(),
            'imageHeight' => $imageMedia?->getHeight(),
            'imageAlt' => $imageMedia?->getAlt() ?? $title,
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
        $imageMedia = $site?->getOgImage() ?? $site?->getHeroImage() ?? $site?->getLogo();

        return [
            'title' => $site?->getDefaultSeoTitle() ?? $site?->getName() ?? 'Blog&Web',
            'description' => $site?->getDefaultSeoDescription() ?? '',
            'keywords' => '',
            'noIndex' => false,
            'canonicalUrl' => null,
            'image' => $imageMedia?->getFileName(),
            'imageWidth' => $imageMedia?->getWidth(),
            'imageHeight' => $imageMedia?->getHeight(),
            'imageAlt' => $imageMedia?->getAlt() ?? $site?->getName() ?? 'Blog&Web',
            'type' => 'website',
            'publishedAt' => null,
            'createdAt' => null,
            'updatedAt' => null,
        ];
    }

    /**
     * SEO generique pour les pages sans entite (contact, etc.).
     *
     * $description : la meta description propre a la page, « %s » remplace par le
     * nom du site. Sans elle, la description par defaut du site, celle de la home :
     * a eviter, Google y voit du contenu duplique.
     */
    public function resolveForPage(string $pageTitle, ?string $description = null, ?string $cle = null): array
    {
        $site = $this->siteContext->getCurrentSite();
        $siteName = $site?->getName() ?? 'Blog&Web';
        $imageMedia = $site?->getOgImage() ?? $site?->getHeroImage() ?? $site?->getLogo();

        // Titre et description propres au site pour cette page systeme (FAQ,
        // Contact, Blog...) : options seo.<cle>.title et seo.<cle>.description.
        // Le titre est pris tel quel ; sans option, rendu par defaut ci-dessous.
        $titreSite = $cle !== null ? $this->option('seo.' . $cle . '.title') : null;
        $descriptionSite = $cle !== null ? $this->option('seo.' . $cle . '.description') : null;

        return [
            'title' => $titreSite ?? $pageTitle . ' — ' . $siteName,
            'description' => $descriptionSite ?? ($description !== null ? sprintf($description, $siteName) : ($site?->getDefaultSeoDescription() ?? '')),
            'keywords' => '',
            'noIndex' => false,
            'canonicalUrl' => null,
            'image' => $imageMedia?->getFileName(),
            'imageWidth' => $imageMedia?->getWidth(),
            'imageHeight' => $imageMedia?->getHeight(),
            'imageAlt' => $imageMedia?->getAlt() ?? $pageTitle . ' — ' . $siteName,
            'type' => 'website',
            'publishedAt' => null,
            'createdAt' => null,
            'updatedAt' => null,
        ];
    }

    private function option(string $name): ?string
    {
        $valeur = $this->optionRepository?->findOneBy(['name' => $name])?->getValue();

        return ($valeur !== null && trim($valeur) !== '') ? trim($valeur) : null;
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
            return $entityTitle . ' — ' . $siteName;
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

        // Fallback sur featured_text (articles) ou shortDescription (services)
        if (method_exists($entity, 'getFeaturedText') && $entity->getFeaturedText()) {
            return $entity->getFeaturedText();
        }

        if (method_exists($entity, 'getShortDescription') && $entity->getShortDescription()) {
            return $entity->getShortDescription();
        }

        return $site?->getDefaultSeoDescription() ?? '';
    }

    private function resolveImageMedia(object $entity): ?\App\Entity\Media
    {
        if (method_exists($entity, 'getFeaturedMedia') && $entity->getFeaturedMedia()) {
            return $entity->getFeaturedMedia();
        }

        if (method_exists($entity, 'getImage') && $entity->getImage()) {
            return $entity->getImage();
        }

        $site = $this->siteContext->getCurrentSite();

        return $site?->getOgImage() ?? $site?->getHeroImage() ?? $site?->getLogo();
    }

    /**
     * Fallback chain pour l'image OG du site : ogImage > heroImage > logo.
     */
    private function resolveSiteImage(?Site $site): ?string
    {
        return $site?->getOgImage()?->getFileName()
            ?? $site?->getHeroImage()?->getFileName()
            ?? $site?->getLogo()?->getFileName();
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
