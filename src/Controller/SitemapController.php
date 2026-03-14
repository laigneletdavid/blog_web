<?php

namespace App\Controller;

use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\PageRepository;
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
    ): Response {
        $articles = $articleRepository->findAllPublishedForSitemap();
        $pages = $pageRepository->findAllPublishedForSitemap();
        $categories = $categorieRepository->findAll();

        $response = $this->render('sitemap/index.xml.twig', [
            'articles' => $articles,
            'pages' => $pages,
            'categories' => $categories,
        ]);

        $response->headers->set('Content-Type', 'application/xml');

        return $response;
    }
}
