<?php

namespace App\Controller\Admin\Api;

use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\PageRepository;
use App\Repository\ServiceRepository;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_AUTHOR')]
class LinkApiController extends AbstractController
{
    #[Route('/admin/api/links', name: 'admin_api_links', methods: ['GET'])]
    public function list(
        Request $request,
        PageRepository $pageRepository,
        ArticleRepository $articleRepository,
        CategorieRepository $categorieRepository,
        ServiceRepository $serviceRepository,
        SiteContext $siteContext,
    ): JsonResponse {
        $q = mb_strtolower(trim($request->query->get('q', '')));
        $links = [];

        // Pages
        foreach ($pageRepository->findBy(['published' => true], ['title' => 'ASC']) as $page) {
            $links[] = [
                'type' => 'Page',
                'title' => $page->getTitle(),
                'url' => $this->generateUrl('app_page_show', ['slug' => $page->getSlug()]),
            ];
        }

        // Articles
        foreach ($articleRepository->findBy(['published' => true], ['created_at' => 'DESC'], 50) as $article) {
            $links[] = [
                'type' => 'Article',
                'title' => $article->getTitle(),
                'url' => $this->generateUrl('app_article_show', ['slug' => $article->getSlug()]),
            ];
        }

        // Categories
        foreach ($categorieRepository->findBy([], ['name' => 'ASC']) as $categorie) {
            $links[] = [
                'type' => 'Categorie',
                'title' => $categorie->getName(),
                'url' => $this->generateUrl('app_categorie_show', ['slug' => $categorie->getSlug()]),
            ];
        }

        // Services
        if ($siteContext->hasModule('services')) {
            foreach ($serviceRepository->findBy(['isActive' => true], ['position' => 'ASC']) as $service) {
                $links[] = [
                    'type' => 'Service',
                    'title' => $service->getTitle(),
                    'url' => $this->generateUrl('app_service_show', ['slug' => $service->getSlug()]),
                ];
            }
        }

        // Filter by search query
        if ($q !== '') {
            $links = array_values(array_filter($links, function ($link) use ($q) {
                return str_contains(mb_strtolower($link['title']), $q)
                    || str_contains(mb_strtolower($link['url']), $q);
            }));
        }

        return $this->json($links);
    }
}
