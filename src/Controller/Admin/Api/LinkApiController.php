<?php

namespace App\Controller\Admin\Api;

use App\Enum\ModuleEnum;
use App\Enum\StaticPageEnum;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\DirectoryEntryRepository;
use App\Repository\EventRepository;
use App\Repository\PageRepository;
use App\Repository\PortfolioItemRepository;
use App\Repository\ProductRepository;
use App\Repository\ServiceRepository;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;
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
        ProductRepository $productRepository,
        EventRepository $eventRepository,
        PortfolioItemRepository $portfolioItemRepository,
        DirectoryEntryRepository $directoryEntryRepository,
        SiteContext $siteContext,
    ): JsonResponse {
        $q = mb_strtolower(trim($request->query->get('q', '')));
        $links = [];

        // Raccourcis : pages en dur (home, contact, index modules actifs...)
        foreach (StaticPageEnum::cases() as $staticPage) {
            $module = $staticPage->requiredModule();
            if ($module !== null && !$siteContext->hasModule($module)) {
                continue;
            }
            try {
                $url = $this->generateUrl($staticPage->routeName());
            } catch (\Exception) {
                continue; // route non enregistree (module desactive cote routing)
            }
            $links[] = [
                'type' => 'Raccourci',
                'title' => $staticPage->label(),
                'url' => $url,
            ];
        }

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
        if ($siteContext->hasModule(ModuleEnum::SERVICES)) {
            foreach ($serviceRepository->findBy(['isActive' => true], ['position' => 'ASC']) as $service) {
                $links[] = [
                    'type' => 'Service',
                    'title' => $service->getTitle(),
                    'url' => $this->generateUrl('app_service_show', ['slug' => $service->getSlug()]),
                ];
            }
        }

        // Produits (catalogue + ecommerce)
        if ($siteContext->hasModule(ModuleEnum::CATALOGUE) || $siteContext->hasModule(ModuleEnum::ECOMMERCE)) {
            foreach ($productRepository->findBy(['isActive' => true], ['title' => 'ASC'], 100) as $product) {
                $links[] = [
                    'type' => 'Produit',
                    'title' => $product->getTitle(),
                    'url' => $this->generateUrl('app_product_show', ['slug' => $product->getSlug()]),
                ];
            }
        }

        // Evenements
        if ($siteContext->hasModule(ModuleEnum::EVENTS)) {
            foreach ($eventRepository->findBy(['isActive' => true], ['dateStart' => 'DESC'], 50) as $event) {
                $links[] = [
                    'type' => 'Evenement',
                    'title' => $event->getTitle(),
                    'url' => $this->generateUrl('app_event_show', ['slug' => $event->getSlug()]),
                ];
            }
        }

        // Realisations (portfolio)
        if ($siteContext->hasModule(ModuleEnum::PORTFOLIO)) {
            foreach ($portfolioItemRepository->findBy(['isActive' => true], ['position' => 'ASC'], 100) as $item) {
                $links[] = [
                    'type' => 'Realisation',
                    'title' => $item->getTitle(),
                    'url' => $this->generateUrl('app_portfolio_show', ['slug' => $item->getSlug()]),
                ];
            }
        }

        // Annuaire (membres)
        if ($siteContext->hasModule(ModuleEnum::DIRECTORY)) {
            foreach ($directoryEntryRepository->findBy(['isActive' => true], ['lastName' => 'ASC']) as $entry) {
                $links[] = [
                    'type' => 'Membre',
                    'title' => $entry->getDisplayName(),
                    'url' => $this->generateUrl('app_directory_show', ['slug' => $entry->getSlug()]),
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
