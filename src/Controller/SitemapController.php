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
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class SitemapController extends AbstractController
{
    #[Route('/sitemap.xml', name: 'app_sitemap', defaults: ['_format' => 'xml'])]
    public function index(
        ArticleRepository $articleRepository,
        PageRepository $pageRepository,
        CategorieRepository $categorieRepository,
        ServiceRepository $serviceRepository,
        EventRepository $eventRepository,
        ProductRepository $productRepository,
        PortfolioItemRepository $portfolioItemRepository,
        DirectoryEntryRepository $directoryEntryRepository,
        SiteContext $siteContext,
    ): Response {
        $articles = $articleRepository->findAllPublishedForSitemap();
        $pages = $pageRepository->findAllPublishedForSitemap();
        $categories = $categorieRepository->findAll();
        $services = $siteContext->hasModule('services') ? $serviceRepository->findAllActive() : [];
        $events = $siteContext->hasModule('events') ? $eventRepository->findAllActiveForSitemap() : [];
        $products = $siteContext->hasModule('catalogue') ? $productRepository->findForSitemap() : [];
        $portfolioItems = $siteContext->hasModule('portfolio') ? $portfolioItemRepository->findAllActiveForSitemap() : [];
        $directoryEntries = $siteContext->hasModule('directory') ? $directoryEntryRepository->findAllActiveForSitemap() : [];
        $hasFaq = $siteContext->hasModule('faq');

        $legalPages = $pageRepository->findAllSystemPages();

        $response = $this->render('sitemap/index.xml.twig', [
            'articles' => $articles,
            'pages' => $pages,
            'categories' => $categories,
            'services' => $services,
            'events' => $events,
            'products' => $products,
            'portfolioItems' => $portfolioItems,
            'directoryEntries' => $directoryEntries,
            'legalPages' => $legalPages,
            'hasFaq' => $hasFaq,
        ]);

        $response->headers->set('Content-Type', 'application/xml');

        return $response;
    }
}
