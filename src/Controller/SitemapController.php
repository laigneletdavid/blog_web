<?php

namespace App\Controller;

use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\EventRepository;
use App\Repository\PageRepository;
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
        SiteContext $siteContext,
    ): Response {
        $articles = $articleRepository->findAllPublishedForSitemap();
        $pages = $pageRepository->findAllPublishedForSitemap();
        $categories = $categorieRepository->findAll();
        $services = $siteContext->hasModule('services') ? $serviceRepository->findAllActive() : [];
        $events = $siteContext->hasModule('events') ? $eventRepository->findAllActiveForSitemap() : [];

        $response = $this->render('sitemap/index.xml.twig', [
            'articles' => $articles,
            'pages' => $pages,
            'categories' => $categories,
            'services' => $services,
            'events' => $events,
        ]);

        $response->headers->set('Content-Type', 'application/xml');

        return $response;
    }
}
