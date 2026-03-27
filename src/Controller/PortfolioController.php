<?php

namespace App\Controller;

use App\Repository\PortfolioCategoryRepository;
use App\Repository\PortfolioItemRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class PortfolioController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/realisations', name: 'app_portfolio_index')]
    public function index(
        Request $request,
        PortfolioItemRepository $portfolioItemRepository,
        PortfolioCategoryRepository $portfolioCategoryRepository,
    ): Response {
        if (!$this->siteContext->hasModule('portfolio')) {
            throw $this->createNotFoundException();
        }

        $categories = $portfolioCategoryRepository->findAllActive();
        $categorySlug = $request->query->get('categorie');
        $activeCategory = null;

        if ($categorySlug) {
            foreach ($categories as $cat) {
                if ($cat->getSlug() === $categorySlug) {
                    $activeCategory = $cat;
                    break;
                }
            }
        }

        $items = $activeCategory
            ? $portfolioItemRepository->findActiveByCategory($activeCategory)
            : $portfolioItemRepository->findAllActive();

        return $this->render('portfolio/index.html.twig', [
            'title_page' => 'Nos realisations',
            'items' => $items,
            'categories' => $categories,
            'activeCategory' => $activeCategory,
            'seo' => $this->seoService->resolveForPage('Portfolio'),
        ]);
    }

    #[Route('/realisation/{slug}', name: 'app_portfolio_show')]
    public function show(
        string $slug,
        PortfolioItemRepository $portfolioItemRepository,
    ): Response {
        if (!$this->siteContext->hasModule('portfolio')) {
            throw $this->createNotFoundException();
        }

        $item = $portfolioItemRepository->findOneActiveBySlug($slug);
        if (!$item) {
            throw $this->createNotFoundException('Realisation introuvable.');
        }

        return $this->render('portfolio/show.html.twig', [
            'title_page' => $item->getTitle(),
            'item' => $item,
            'seo' => $this->seoService->resolve($item),
        ]);
    }
}
