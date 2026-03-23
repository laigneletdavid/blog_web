<?php

namespace App\Service;

use App\Entity\Product;
use App\Entity\ProductVariant;
use App\Repository\ProductRepository;
use App\Repository\ProductVariantRepository;
use Symfony\Component\HttpFoundation\RequestStack;

class CartService
{
    private const SESSION_KEY = 'cart';

    public function __construct(
        private readonly RequestStack $requestStack,
        private readonly ProductRepository $productRepository,
        private readonly ProductVariantRepository $variantRepository,
    ) {
    }

    /**
     * Ajoute un produit au panier.
     */
    public function add(int $productId, ?int $variantId = null, int $qty = 1): void
    {
        $cart = $this->getCart();
        $key = $this->buildKey($productId, $variantId);

        if (isset($cart[$key])) {
            $cart[$key]['qty'] += $qty;
        } else {
            $cart[$key] = [
                'productId' => $productId,
                'variantId' => $variantId,
                'qty' => $qty,
            ];
        }

        $this->saveCart($cart);
    }

    /**
     * Met a jour la quantite d'une ligne.
     */
    public function update(string $key, int $qty): void
    {
        $cart = $this->getCart();

        if ($qty <= 0) {
            unset($cart[$key]);
        } elseif (isset($cart[$key])) {
            $cart[$key]['qty'] = $qty;
        }

        $this->saveCart($cart);
    }

    /**
     * Supprime une ligne du panier.
     */
    public function remove(string $key): void
    {
        $cart = $this->getCart();
        unset($cart[$key]);
        $this->saveCart($cart);
    }

    /**
     * Vide le panier.
     */
    public function clear(): void
    {
        $this->saveCart([]);
    }

    /**
     * Retourne les lignes du panier avec les entites hydratees.
     *
     * @return array<array{product: Product, variant: ?ProductVariant, qty: int, unitPriceHT: float, vatRate: float, lineTotalHT: float, lineTotalTTC: float, key: string}>
     */
    public function getItems(): array
    {
        $cart = $this->getCart();
        $items = [];

        foreach ($cart as $key => $line) {
            $product = $this->productRepository->find($line['productId']);
            if (!$product || !$product->isActive()) {
                continue;
            }

            $variant = null;
            if ($line['variantId']) {
                $variant = $this->variantRepository->find($line['variantId']);
                if ($variant && !$variant->isActive()) {
                    $variant = null;
                }
            }

            $unitPriceHT = $variant?->getPriceHT() ?? $product->getPriceHT();
            if ($unitPriceHT === null) {
                continue;
            }

            $vatRate = (float) $product->getVatRate();
            $lineTotalHT = $unitPriceHT * $line['qty'];
            $lineTotalTTC = $lineTotalHT * (1 + $vatRate / 100);

            $items[] = [
                'product' => $product,
                'variant' => $variant,
                'qty' => $line['qty'],
                'unitPriceHT' => $unitPriceHT,
                'vatRate' => $vatRate,
                'lineTotalHT' => $lineTotalHT,
                'lineTotalTTC' => $lineTotalTTC,
                'key' => $key,
            ];
        }

        return $items;
    }

    public function getTotalHT(): float
    {
        return array_sum(array_map(fn (array $item) => $item['lineTotalHT'], $this->getItems()));
    }

    public function getTotalTTC(): float
    {
        return array_sum(array_map(fn (array $item) => $item['lineTotalTTC'], $this->getItems()));
    }

    public function getTotalVAT(): float
    {
        return $this->getTotalTTC() - $this->getTotalHT();
    }

    public function getCount(): int
    {
        $cart = $this->getCart();

        return array_sum(array_column($cart, 'qty'));
    }

    public function isEmpty(): bool
    {
        return $this->getCount() === 0;
    }

    /**
     * Cree le snapshot JSON des items pour la commande (fige les prix).
     */
    public function buildOrderItems(): array
    {
        $snapshot = [];

        foreach ($this->getItems() as $item) {
            $snapshot[] = [
                'productId' => $item['product']->getId(),
                'title' => $item['product']->getTitle(),
                'variant' => $item['variant']?->getLabel(),
                'qty' => $item['qty'],
                'unitPriceHT' => $item['unitPriceHT'],
                'vatRate' => $item['vatRate'],
                'lineTotalTTC' => round($item['lineTotalTTC'], 2),
            ];
        }

        return $snapshot;
    }

    private function buildKey(int $productId, ?int $variantId): string
    {
        return $variantId ? "{$productId}_{$variantId}" : (string) $productId;
    }

    private function getCart(): array
    {
        return $this->requestStack->getSession()->get(self::SESSION_KEY, []);
    }

    private function saveCart(array $cart): void
    {
        $this->requestStack->getSession()->set(self::SESSION_KEY, $cart);
    }
}
