<?php

namespace App\Controller;

use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\EventRepository;
use App\Repository\PageRepository;
use App\Repository\DirectoryEntryRepository;
use App\Repository\PortfolioItemRepository;
use App\Repository\ProductRepository;
use App\Repository\ServiceRepository;
use App\Repository\TagRepository;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Routing\Attribute\Route;

class SitemapController extends AbstractController
{
    /**
     * Sitemap index : liste des sous-sitemaps disponibles selon les modules actifs.
     */
    #[Route('/sitemap.xml', name: 'app_sitemap', defaults: ['_format' => 'xml'])]
    public function index(SiteContext $siteContext): Response
    {
        $sitemaps = ['pages', 'articles', 'categories', 'misc'];

        if ($siteContext->hasModule('services')) {
            $sitemaps[] = 'services';
        }
        if ($siteContext->hasModule('catalogue')) {
            $sitemaps[] = 'products';
        }
        if ($siteContext->hasModule('events')) {
            $sitemaps[] = 'events';
        }
        if ($siteContext->hasModule('portfolio')) {
            $sitemaps[] = 'portfolio';
        }
        if ($siteContext->hasModule('directory')) {
            $sitemaps[] = 'directory';
        }
        if ($siteContext->hasModule('blog')) {
            $sitemaps[] = 'tags';
        }

        $response = $this->render('sitemap/index.xml.twig', [
            'sitemaps' => $sitemaps,
        ]);
        $response->headers->set('Content-Type', 'application/xml');

        return $response;
    }

    /**
     * Sous-sitemap par type d'entite.
     */
    #[Route('/sitemap-{type}.xml', name: 'app_sitemap_section', defaults: ['_format' => 'xml'])]
    public function section(
        string $type,
        ArticleRepository $articleRepository,
        PageRepository $pageRepository,
        CategorieRepository $categorieRepository,
        ServiceRepository $serviceRepository,
        EventRepository $eventRepository,
        ProductRepository $productRepository,
        PortfolioItemRepository $portfolioItemRepository,
        DirectoryEntryRepository $directoryEntryRepository,
        TagRepository $tagRepository,
        SiteContext $siteContext,
    ): Response {
        $urls = match ($type) {
            'articles' => $this->buildArticleUrls($articleRepository),
            'pages' => $this->buildPageUrls($pageRepository),
            'categories' => $this->buildCategoryUrls($categorieRepository),
            'services' => $this->buildServiceUrls($serviceRepository, $siteContext),
            'products' => $this->buildProductUrls($productRepository, $siteContext),
            'events' => $this->buildEventUrls($eventRepository, $siteContext),
            'portfolio' => $this->buildPortfolioUrls($portfolioItemRepository, $siteContext),
            'directory' => $this->buildDirectoryUrls($directoryEntryRepository, $siteContext),
            'tags' => $this->buildTagUrls($tagRepository, $siteContext),
            'misc' => $this->buildMiscUrls($pageRepository, $siteContext),
            default => throw new NotFoundHttpException('Sitemap section not found.'),
        };

        $response = $this->render('sitemap/section.xml.twig', [
            'urls' => $urls,
        ]);
        $response->headers->set('Content-Type', 'application/xml');

        return $response;
    }

    // ──────────────────────────────────────────────
    //  Builders par type
    // ──────────────────────────────────────────────

    private function buildArticleUrls(ArticleRepository $repo): array
    {
        $urls = [];
        foreach ($repo->findAllPublishedForSitemap() as $article) {
            $urls[] = [
                'loc' => $this->generateUrl('app_article_show', ['slug' => $article->getSlug()]),
                'lastmod' => $article->getUpdatedAt() ?? $article->getCreatedAt(),
                'changefreq' => 'weekly',
                'priority' => '0.8',
            ];
        }

        return $urls;
    }

    private function buildPageUrls(PageRepository $repo): array
    {
        $urls = [];

        // Pages editoriales
        foreach ($repo->findAllPublishedForSitemap() as $page) {
            $urls[] = [
                'loc' => $this->generateUrl('app_page_show', ['slug' => $page->getSlug()]),
                'lastmod' => $page->getUpdatedAt() ?? $page->getCreatedAt(),
                'changefreq' => 'monthly',
                'priority' => '0.6',
            ];
        }

        // Pages legales (systeme)
        foreach ($repo->findAllSystemPages() as $legalPage) {
            $urls[] = [
                'loc' => '/' . $legalPage->getSlug(),
                'lastmod' => $legalPage->getUpdatedAt() ?? $legalPage->getCreatedAt(),
                'changefreq' => 'yearly',
                'priority' => '0.3',
            ];
        }

        return $urls;
    }

    private function buildCategoryUrls(CategorieRepository $repo): array
    {
        $urls = [];
        foreach ($repo->findAllForSitemap() as $categorie) {
            $urls[] = [
                'loc' => $this->generateUrl('app_categorie_show', ['slug' => $categorie->getSlug()]),
                'changefreq' => 'weekly',
                'priority' => '0.5',
            ];
        }

        return $urls;
    }

    private function buildServiceUrls(ServiceRepository $repo, SiteContext $siteContext): array
    {
        if (!$siteContext->hasModule('services')) {
            return [];
        }

        $urls = [];
        foreach ($repo->findAllActiveForSitemap() as $service) {
            $urls[] = [
                'loc' => $this->generateUrl('app_service_show', ['slug' => $service->getSlug()]),
                'changefreq' => 'monthly',
                'priority' => '0.6',
            ];
        }

        return $urls;
    }

    private function buildProductUrls(ProductRepository $repo, SiteContext $siteContext): array
    {
        if (!$siteContext->hasModule('catalogue')) {
            return [];
        }

        $urls = [];
        foreach ($repo->findForSitemap() as $product) {
            $urls[] = [
                'loc' => $this->generateUrl('app_product_show', ['slug' => $product->getSlug()]),
                'changefreq' => 'weekly',
                'priority' => '0.7',
            ];
        }

        return $urls;
    }

    private function buildEventUrls(EventRepository $repo, SiteContext $siteContext): array
    {
        if (!$siteContext->hasModule('events')) {
            return [];
        }

        $urls = [];
        foreach ($repo->findAllActiveForSitemap() as $event) {
            $urls[] = [
                'loc' => $this->generateUrl('app_event_show', ['slug' => $event->getSlug()]),
                'lastmod' => $event->getDateStart(),
                'changefreq' => 'weekly',
                'priority' => '0.6',
            ];
        }

        return $urls;
    }

    private function buildPortfolioUrls(PortfolioItemRepository $repo, SiteContext $siteContext): array
    {
        if (!$siteContext->hasModule('portfolio')) {
            return [];
        }

        $urls = [];
        foreach ($repo->findAllActiveForSitemap() as $item) {
            $urls[] = [
                'loc' => $this->generateUrl('app_portfolio_show', ['slug' => $item->getSlug()]),
                'changefreq' => 'monthly',
                'priority' => '0.6',
            ];
        }

        return $urls;
    }

    private function buildDirectoryUrls(DirectoryEntryRepository $repo, SiteContext $siteContext): array
    {
        if (!$siteContext->hasModule('directory')) {
            return [];
        }

        $urls = [];
        foreach ($repo->findAllActiveForSitemap() as $entry) {
            $urls[] = [
                'loc' => $this->generateUrl('app_directory_show', ['slug' => $entry->getSlug()]),
                'changefreq' => 'monthly',
                'priority' => '0.5',
            ];
        }

        return $urls;
    }

    private function buildTagUrls(TagRepository $repo, SiteContext $siteContext): array
    {
        if (!$siteContext->hasModule('blog')) {
            return [];
        }

        $urls = [];
        foreach ($repo->findAllForSitemap() as $tag) {
            $urls[] = [
                'loc' => $this->generateUrl('app_tag_show', ['slug' => $tag->getSlug()]),
                'changefreq' => 'weekly',
                'priority' => '0.4',
            ];
        }

        return $urls;
    }

    private function buildMiscUrls(PageRepository $pageRepository, SiteContext $siteContext): array
    {
        $urls = [];

        // Accueil
        $urls[] = [
            'loc' => $this->generateUrl('app_home'),
            'changefreq' => 'daily',
            'priority' => '1.0',
        ];

        // Blog index
        $urls[] = [
            'loc' => $this->generateUrl('app_article_show_all'),
            'changefreq' => 'daily',
            'priority' => '0.7',
        ];

        // Contact
        $urls[] = [
            'loc' => $this->generateUrl('app_contact'),
            'changefreq' => 'monthly',
            'priority' => '0.4',
        ];

        // FAQ
        if ($siteContext->hasModule('faq')) {
            $urls[] = [
                'loc' => $this->generateUrl('app_faq_index'),
                'changefreq' => 'monthly',
                'priority' => '0.5',
            ];
        }

        return $urls;
    }
}
