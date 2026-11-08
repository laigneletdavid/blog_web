<?php

namespace App\Controller;

use App\Enum\SystemPageEnum;
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
    private const SECTIONS = ['pages', 'misc', 'articles', 'categories', 'services', 'products', 'events', 'portfolio', 'directory', 'tags'];

    public function __construct(
        private readonly ArticleRepository $articleRepository,
        private readonly PageRepository $pageRepository,
        private readonly CategorieRepository $categorieRepository,
        private readonly ServiceRepository $serviceRepository,
        private readonly EventRepository $eventRepository,
        private readonly ProductRepository $productRepository,
        private readonly PortfolioItemRepository $portfolioItemRepository,
        private readonly DirectoryEntryRepository $directoryEntryRepository,
        private readonly TagRepository $tagRepository,
        private readonly SiteContext $siteContext,
    ) {
    }

    /**
     * Sitemap index : liste des sous-sitemaps qui ont au moins une URL.
     * Google refuse un <urlset> vide (« Balise XML manquante »), d'ou le
     * filtre : un site sans page editoriale n'annonce pas sitemap-pages.
     */
    #[Route('/sitemap.xml', name: 'app_sitemap', defaults: ['_format' => 'xml'])]
    public function index(): Response
    {
        $sitemaps = array_values(array_filter(self::SECTIONS, fn (string $type) => $this->buildUrls($type) !== []));

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
    public function section(string $type): Response
    {
        $response = $this->render('sitemap/section.xml.twig', [
            'urls' => $this->buildUrls($type),
        ]);
        $response->headers->set('Content-Type', 'application/xml');

        return $response;
    }

    private function buildUrls(string $type): array
    {
        $siteContext = $this->siteContext;

        return match ($type) {
            'articles' => $siteContext->hasModule('blog') ? $this->buildArticleUrls($this->articleRepository) : [],
            'pages' => $this->buildPageUrls($this->pageRepository),
            'categories' => $siteContext->hasModule('blog') ? $this->buildCategoryUrls($this->categorieRepository) : [],
            'services' => $this->buildServiceUrls($this->serviceRepository, $siteContext),
            'products' => $this->buildProductUrls($this->productRepository, $siteContext),
            'events' => $this->buildEventUrls($this->eventRepository, $siteContext),
            'portfolio' => $this->buildPortfolioUrls($this->portfolioItemRepository, $siteContext),
            'directory' => $this->buildDirectoryUrls($this->directoryEntryRepository, $siteContext),
            'tags' => $this->buildTagUrls($this->tagRepository, $siteContext),
            'misc' => $this->buildMiscUrls($this->pageRepository, $siteContext),
            default => throw new NotFoundHttpException('Sitemap section not found.'),
        };
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

        // Pages legales (systeme) : servies par LegalController sous leur
        // type de route (« politique-de-confidentialite »), pas sous leur slug
        // (« politique-confidentialite ») qui repond 404
        foreach ($repo->findSystemPagesForSitemap() as $legalPage) {
            $systemPage = SystemPageEnum::tryFrom((string) $legalPage->getSystemKey());
            if ($systemPage === null) {
                continue;
            }

            $urls[] = [
                'loc' => $this->generateUrl('app_legal_page', ['type' => $systemPage->routeType()]),
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
        if ($siteContext->hasModule('blog')) {
            $urls[] = [
                'loc' => $this->generateUrl('app_article_show_all'),
                'changefreq' => 'daily',
                'priority' => '0.7',
            ];
        }

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
