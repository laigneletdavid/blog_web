<?php

namespace App\Controller;

use App\Repository\ProductCategoryRepository;
use App\Repository\ProductRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class ProductController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/catalogue', name: 'app_product_index')]
    public function index(
        Request $request,
        ProductRepository $productRepository,
        ProductCategoryRepository $categoryRepository,
    ): Response {
        if (!$this->siteContext->hasModule('catalogue')) {
            throw $this->createNotFoundException();
        }

        $categorySlug = $request->query->get('categorie');
        $sort = $request->query->get('tri');

        $category = null;
        if ($categorySlug) {
            $category = $categoryRepository->findOneActiveBySlug($categorySlug);
            if (!$category) {
                throw $this->createNotFoundException('Categorie introuvable.');
            }
        }

        $products = $category
            ? $productRepository->findByCategory($category, $sort)
            : $productRepository->findAllActive($sort);

        $categories = $categoryRepository->findAllActive();

        $titlePage = $category ? $category->getName() : 'Catalogue';

        return $this->render('product/index.html.twig', [
            'title_page' => $titlePage,
            'products' => $products,
            'productCategories' => $categories,
            'currentCategory' => $category,
            'currentSort' => $sort,
            'site' => $this->siteContext->getCurrentSite(),
            'seo' => $category
                ? $this->seoService->resolveForPage($category->getName())
                : $this->seoService->resolveForPage('Catalogue'),
        ]);
    }

    #[Route('/catalogue/categorie/{slug}', name: 'app_product_category')]
    public function category(
        string $slug,
        Request $request,
        ProductRepository $productRepository,
        ProductCategoryRepository $categoryRepository,
    ): Response {
        if (!$this->siteContext->hasModule('catalogue')) {
            throw $this->createNotFoundException();
        }

        $category = $categoryRepository->findOneActiveBySlug($slug);
        if (!$category) {
            throw $this->createNotFoundException('Categorie introuvable.');
        }

        $sort = $request->query->get('tri');
        $products = $productRepository->findByCategory($category, $sort);
        $categories = $categoryRepository->findAllActive();

        return $this->render('product/index.html.twig', [
            'title_page' => $category->getName(),
            'products' => $products,
            'productCategories' => $categories,
            'currentCategory' => $category,
            'currentSort' => $sort,
            'site' => $this->siteContext->getCurrentSite(),
            'seo' => $this->seoService->resolveForPage($category->getName()),
        ]);
    }

    #[Route('/catalogue/{slug}', name: 'app_product_show')]
    public function show(string $slug, ProductRepository $productRepository): Response
    {
        if (!$this->siteContext->hasModule('catalogue')) {
            throw $this->createNotFoundException();
        }

        $product = $productRepository->findOneActiveBySlug($slug);
        if (!$product) {
            throw $this->createNotFoundException('Produit introuvable.');
        }

        $relatedProducts = $productRepository->findRelated($product, 4);
        $site = $this->siteContext->getCurrentSite();

        return $this->render('product/show.html.twig', [
            'title_page' => $product->getTitle(),
            'product' => $product,
            'relatedProducts' => $relatedProducts,
            'site' => $site,
            'displayHT' => $site?->isCatalogDisplayHT() ?? false,
            'seo' => $this->seoService->resolve($product),
        ]);
    }
}
