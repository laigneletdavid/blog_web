<?php

namespace App\Controller;

use App\Service\CartService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class CartController extends AbstractController
{
    public function __construct(
        private readonly CartService $cartService,
        private readonly SiteContext $siteContext,
    ) {
    }

    #[Route('/panier', name: 'app_cart', methods: ['GET'])]
    public function index(): Response
    {
        if (!$this->siteContext->hasModule('ecommerce')) {
            throw $this->createNotFoundException();
        }

        return $this->render('cart/index.html.twig', [
            'items' => $this->cartService->getItems(),
            'totalHT' => $this->cartService->getTotalHT(),
            'totalTTC' => $this->cartService->getTotalTTC(),
            'totalVAT' => $this->cartService->getTotalVAT(),
            'displayHT' => $this->siteContext->getCurrentSite()?->isCatalogDisplayHT() ?? false,
        ]);
    }

    #[Route('/panier/ajouter', name: 'app_cart_add', methods: ['POST'])]
    public function add(Request $request): Response
    {
        if (!$this->siteContext->hasModule('ecommerce')) {
            throw $this->createNotFoundException();
        }

        $productId = $request->request->getInt('productId');
        $variantId = $request->request->getInt('variantId') ?: null;
        $qty = max(1, $request->request->getInt('qty', 1));

        $this->cartService->add($productId, $variantId, $qty);

        if ($request->isXmlHttpRequest()) {
            return new JsonResponse([
                'count' => $this->cartService->getCount(),
                'message' => 'Produit ajoute au panier',
            ]);
        }

        $this->addFlash('success', 'Produit ajoute au panier.');

        return $this->redirectToRoute('app_cart');
    }

    #[Route('/panier/modifier', name: 'app_cart_update', methods: ['POST'])]
    public function update(Request $request): Response
    {
        if (!$this->siteContext->hasModule('ecommerce')) {
            throw $this->createNotFoundException();
        }

        $key = $request->request->getString('key');
        $qty = $request->request->getInt('qty');

        $this->cartService->update($key, $qty);

        return $this->redirectToRoute('app_cart');
    }

    #[Route('/panier/supprimer', name: 'app_cart_remove', methods: ['POST'])]
    public function remove(Request $request): Response
    {
        if (!$this->siteContext->hasModule('ecommerce')) {
            throw $this->createNotFoundException();
        }

        $key = $request->request->getString('key');
        $this->cartService->remove($key);

        if ($request->isXmlHttpRequest()) {
            return new JsonResponse([
                'count' => $this->cartService->getCount(),
            ]);
        }

        return $this->redirectToRoute('app_cart');
    }

    /**
     * Endpoint AJAX pour le badge compteur header.
     */
    #[Route('/panier/count', name: 'app_cart_count', methods: ['GET'])]
    public function count(): JsonResponse
    {
        return new JsonResponse([
            'count' => $this->cartService->getCount(),
        ]);
    }
}
