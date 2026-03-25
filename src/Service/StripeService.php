<?php

namespace App\Service;

use App\Entity\Order;
use Stripe\Checkout\Session;
use Stripe\Stripe;
use Stripe\Webhook;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class StripeService
{
    public function __construct(
        private readonly string $stripeSecretKey,
        private readonly string $stripeWebhookSecret,
        private readonly UrlGeneratorInterface $urlGenerator,
        private readonly SiteContext $siteContext,
    ) {
    }

    /**
     * Cree une Stripe Checkout Session pour une commande.
     * Retourne l'URL de redirection vers Stripe.
     */
    public function createCheckoutSession(Order $order): string
    {
        Stripe::setApiKey($this->getSecretKey());

        $lineItems = [];
        foreach ($order->getItems() as $item) {
            $unitAmountTTC = (int) round($item['unitPriceHT'] * (1 + $item['vatRate'] / 100) * 100);

            $lineItems[] = [
                'price_data' => [
                    'currency' => 'eur',
                    'unit_amount' => $unitAmountTTC,
                    'product_data' => [
                        'name' => $item['title'] . ($item['variant'] ? ' — ' . $item['variant'] : ''),
                    ],
                ],
                'quantity' => $item['qty'],
            ];
        }

        $session = Session::create([
            'payment_method_types' => ['card'],
            'line_items' => $lineItems,
            'mode' => 'payment',
            'customer_email' => $order->getCustomerEmail(),
            'client_reference_id' => $order->getReference(),
            'metadata' => [
                'order_reference' => $order->getReference(),
                'order_id' => $order->getId(),
            ],
            'success_url' => $this->urlGenerator->generate(
                'app_checkout_confirmation',
                ['reference' => $order->getReference()],
                UrlGeneratorInterface::ABSOLUTE_URL
            ),
            'cancel_url' => $this->urlGenerator->generate(
                'app_checkout_cancel',
                ['reference' => $order->getReference()],
                UrlGeneratorInterface::ABSOLUTE_URL
            ),
        ]);

        return $session->url;
    }

    /**
     * Verifie et decode un evenement webhook Stripe.
     *
     * @throws \Stripe\Exception\SignatureVerificationException
     */
    public function constructWebhookEvent(string $payload, string $sigHeader): \Stripe\Event
    {
        return Webhook::constructEvent($payload, $sigHeader, $this->getWebhookSecret());
    }

    public function isConfigured(): bool
    {
        $key = $this->getSecretKey();

        return $key !== '' && $key !== 'sk_test_CHANGEME' && str_starts_with($key, 'sk_');
    }

    public function getPublicKey(): string
    {
        return $this->siteContext->getCurrentSite()?->getStripePublicKey() ?: '';
    }

    /**
     * Resout la cle secrete : Site > .env
     */
    private function getSecretKey(): string
    {
        $siteKey = $this->siteContext->getCurrentSite()?->getStripeSecretKey();

        if ($siteKey && str_starts_with($siteKey, 'sk_')) {
            return $siteKey;
        }

        return $this->stripeSecretKey;
    }

    /**
     * Resout le webhook secret : Site > .env
     */
    private function getWebhookSecret(): string
    {
        $siteSecret = $this->siteContext->getCurrentSite()?->getStripeWebhookSecret();

        if ($siteSecret && str_starts_with($siteSecret, 'whsec_')) {
            return $siteSecret;
        }

        return $this->stripeWebhookSecret;
    }
}
