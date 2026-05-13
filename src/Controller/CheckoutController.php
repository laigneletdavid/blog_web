<?php

namespace App\Controller;

use App\Entity\Order;
use App\Enum\OrderStatusEnum;
use App\Enum\PaymentMethodEnum;
use App\Form\CheckoutType;
use App\Service\CartService;
use App\Service\SiteContext;
use App\Service\StripeService;
use App\Service\SystemMailerService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class CheckoutController extends AbstractController
{
    public function __construct(
        private readonly CartService $cartService,
        private readonly SiteContext $siteContext,
        private readonly EntityManagerInterface $em,
        private readonly SystemMailerService $systemMailer,
        private readonly StripeService $stripeService,
    ) {
    }

    #[Route('/commander', name: 'app_checkout', methods: ['GET', 'POST'])]
    public function index(Request $request): Response
    {
        if (!$this->siteContext->hasModule('ecommerce')) {
            throw $this->createNotFoundException();
        }

        if ($this->cartService->isEmpty()) {
            $this->addFlash('warning', 'Votre panier est vide.');

            return $this->redirectToRoute('app_cart');
        }

        $form = $this->createForm(CheckoutType::class, null, [
            'stripe_configured' => $this->stripeService->isConfigured(),
        ]);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $data = $form->getData();
            $paymentMethod = PaymentMethodEnum::from($data['paymentMethod']);

            $order = new Order();
            $order->setReference(Order::generateReference());
            $order->setCustomerFirstName($data['firstName']);
            $order->setCustomerLastName($data['lastName']);
            $order->setCustomerEmail($data['email']);
            $order->setCustomerPhone($data['phone']);
            $order->setCustomerMessage($data['message']);
            $order->setItems($this->cartService->buildOrderItems());
            $order->setTotalHT($this->cartService->getTotalHT());
            $order->setTotalVAT($this->cartService->getTotalVAT());
            $order->setTotalTTC($this->cartService->getTotalTTC());
            $order->setPaymentMethod($paymentMethod);
            $order->setStatus(OrderStatusEnum::PENDING);

            $this->em->persist($order);
            $this->em->flush();

            if ($paymentMethod === PaymentMethodEnum::STRIPE && $this->stripeService->isConfigured()) {
                try {
                    $checkoutUrl = $this->stripeService->createCheckoutSession($order);
                    $order->setStripeSessionId($checkoutUrl);
                    $this->em->flush();

                    $this->cartService->clear();

                    return $this->redirect($checkoutUrl);
                } catch (\Throwable $e) {
                    $order->setPaymentMethod(PaymentMethodEnum::MANUAL);
                    $this->em->flush();

                    $this->addFlash('warning', 'Le paiement en ligne est temporairement indisponible. Votre commande a ete enregistree en paiement manuel.');
                }
            }

            $this->sendConfirmationEmails($order);
            $this->cartService->clear();

            return $this->redirectToRoute('app_checkout_confirmation', ['reference' => $order->getReference()]);
        }

        return $this->render('checkout/index.html.twig', [
            'form' => $form,
            'items' => $this->cartService->getItems(),
            'totalHT' => $this->cartService->getTotalHT(),
            'totalTTC' => $this->cartService->getTotalTTC(),
            'totalVAT' => $this->cartService->getTotalVAT(),
            'displayHT' => $this->siteContext->getCurrentSite()?->isCatalogDisplayHT() ?? false,
            'stripeConfigured' => $this->stripeService->isConfigured(),
        ]);
    }

    #[Route('/commande/confirmation/{reference}', name: 'app_checkout_confirmation')]
    public function confirmation(string $reference): Response
    {
        if (!$this->siteContext->hasModule('ecommerce')) {
            throw $this->createNotFoundException();
        }

        $order = $this->em->getRepository(Order::class)->findOneBy(['reference' => $reference]);
        if (!$order) {
            throw $this->createNotFoundException('Commande introuvable.');
        }

        return $this->render('checkout/confirmation.html.twig', [
            'order' => $order,
        ]);
    }

    #[Route('/commande/annulation/{reference}', name: 'app_checkout_cancel')]
    public function cancel(string $reference): Response
    {
        if (!$this->siteContext->hasModule('ecommerce')) {
            throw $this->createNotFoundException();
        }

        $order = $this->em->getRepository(Order::class)->findOneBy(['reference' => $reference]);
        if (!$order) {
            throw $this->createNotFoundException('Commande introuvable.');
        }

        return $this->render('checkout/cancel.html.twig', [
            'order' => $order,
        ]);
    }

    #[Route('/webhook/stripe', name: 'app_stripe_webhook', methods: ['POST'])]
    public function stripeWebhook(Request $request): Response
    {
        $payload = $request->getContent();
        $sigHeader = $request->headers->get('Stripe-Signature', '');

        try {
            $event = $this->stripeService->constructWebhookEvent($payload, $sigHeader);
        } catch (\Throwable) {
            return new Response('Invalid signature', 400);
        }

        if ($event->type === 'checkout.session.completed') {
            $session = $event->data->object;
            $reference = $session->client_reference_id ?? ($session->metadata->order_reference ?? null);

            if ($reference) {
                $order = $this->em->getRepository(Order::class)->findOneBy(['reference' => $reference]);
                if ($order && $order->isPending()) {
                    $order->markAsPaid();
                    $order->setStripeSessionId($session->id);
                    $this->em->flush();

                    $this->sendConfirmationEmails($order);
                }
            }
        }

        return new Response('OK', 200);
    }

    private function sendConfirmationEmails(Order $order): void
    {
        $siteName = $this->systemMailer->getSiteName();
        $siteEmail = $this->systemMailer->getSiteEmail();

        try {
            $clientEmail = $this->systemMailer->createEmail("Confirmation de commande {$order->getReference()} - {$siteName}")
                ->to($order->getCustomerEmail())
                ->html($this->renderView('emails/order_confirmation.html.twig', [
                    'order' => $order,
                    'siteName' => $siteName,
                ]));

            $this->systemMailer->send($clientEmail);
        } catch (\Throwable) {
        }

        if ($siteEmail) {
            try {
                $adminEmail = $this->systemMailer->createEmail("Nouvelle commande {$order->getReference()}")
                    ->to($siteEmail)
                    ->html($this->renderView('emails/order_admin_notification.html.twig', [
                        'order' => $order,
                        'siteName' => $siteName,
                    ]));

                $this->systemMailer->send($adminEmail);
            } catch (\Throwable) {
            }
        }
    }
}
