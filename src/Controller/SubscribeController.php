<?php

namespace App\Controller;

use App\Entity\Subscriber;
use App\Form\Type\SubscribeType;
use App\Repository\SubscriberRepository;
use App\Service\SiteContext;
use App\Service\SystemMailerService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\RateLimiter\RateLimiterFactory;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class SubscribeController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly EntityManagerInterface $em,
        private readonly SubscriberRepository $subscriberRepository,
        private readonly SystemMailerService $systemMailer,
        private readonly UrlGeneratorInterface $urlGenerator,
    ) {
    }

    #[Route('/subscribe', name: 'app_subscribe', methods: ['POST'])]
    public function subscribe(
        Request $request,
        #[Autowire(service: 'limiter.subscribe_limiter')] RateLimiterFactory $subscribeLimiter,
    ): Response {
        $form = $this->createForm(SubscribeType::class, new Subscriber(), [
            'active_modules' => $this->getActiveModules(),
        ]);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // Honeypot check
            $honeypot = $form->get('website')->getData();
            if ($honeypot) {
                $this->addFlash('success', 'Un email de confirmation vous a ete envoye.');

                return $this->redirect($this->getReferer($request));
            }

            // Rate limiting
            $limiter = $subscribeLimiter->create($request->getClientIp());
            if (!$limiter->consume()->isAccepted()) {
                $this->addFlash('error', 'Trop de demandes. Veuillez reessayer dans quelques minutes.');

                return $this->redirect($this->getReferer($request));
            }

            /** @var Subscriber $submitted */
            $submitted = $form->getData();
            $email = $submitted->getEmail();

            $existing = $this->subscriberRepository->findByEmail($email);

            if ($existing) {
                $this->updatePreferences($existing, $submitted);

                if ($existing->isActive()) {
                    $this->addFlash('success', 'Vos preferences ont ete mises a jour.');
                } else {
                    $this->sendConfirmationEmail($existing);
                    $this->addFlash('info', 'Un email de confirmation vous a ete renvoye. Verifiez votre boite mail.');
                }

                $this->em->flush();
            } else {
                $this->em->persist($submitted);
                $this->em->flush();

                $this->sendConfirmationEmail($submitted);
                $this->addFlash('success', 'Un email de confirmation vous a ete envoye. Verifiez votre boite mail.');
            }

            return $this->redirect($this->getReferer($request));
        }

        $this->addFlash('error', 'Veuillez verifier votre adresse email.');

        return $this->redirect($this->getReferer($request));
    }

    #[Route('/subscribe/confirm/{token}', name: 'app_subscribe_confirm', methods: ['GET'])]
    public function confirm(string $token): Response
    {
        $subscriber = $this->subscriberRepository->findByToken($token);

        if (!$subscriber) {
            throw $this->createNotFoundException();
        }

        if ($subscriber->isActive()) {
            $this->addFlash('info', 'Votre abonnement est deja confirme.');

            return $this->redirectToRoute('app_home');
        }

        $subscriber->confirm();
        $this->em->flush();

        return $this->render('subscribe/confirm.html.twig', [
            'subscriber' => $subscriber,
        ]);
    }

    #[Route('/unsubscribe/{token}', name: 'app_unsubscribe', methods: ['GET'])]
    public function unsubscribe(string $token): Response
    {
        $subscriber = $this->subscriberRepository->findByToken($token);

        if (!$subscriber) {
            throw $this->createNotFoundException();
        }

        $subscriber->unsubscribeAll();
        $this->em->flush();

        return $this->render('subscribe/unsubscribe.html.twig', [
            'subscriber' => $subscriber,
            'resubscribe_url' => $this->urlGenerator->generate('app_subscribe_manage', [
                'token' => $subscriber->getToken(),
            ]),
        ]);
    }

    #[Route('/subscribe/manage/{token}', name: 'app_subscribe_manage', methods: ['GET', 'POST'])]
    public function manage(Request $request, string $token): Response
    {
        $subscriber = $this->subscriberRepository->findByToken($token);

        if (!$subscriber) {
            throw $this->createNotFoundException();
        }

        $form = $this->createForm(SubscribeType::class, $subscriber, [
            'active_modules' => $this->getActiveModules(),
        ]);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            if (!$subscriber->isActive()) {
                $subscriber->confirm();
            }

            $this->em->flush();
            $this->addFlash('success', 'Vos preferences ont ete mises a jour.');

            return $this->redirectToRoute('app_subscribe_manage', ['token' => $token]);
        }

        return $this->render('subscribe/manage.html.twig', [
            'subscriber' => $subscriber,
            'form' => $form,
            'unsubscribe_url' => $this->urlGenerator->generate('app_unsubscribe', [
                'token' => $subscriber->getToken(),
            ]),
        ]);
    }

    public function widget(): Response
    {
        $form = $this->createForm(SubscribeType::class, new Subscriber(), [
            'active_modules' => $this->getActiveModules(),
            'action' => $this->urlGenerator->generate('app_subscribe'),
        ]);

        return $this->render('widgets/_subscribe_form.html.twig', [
            'form' => $form,
        ]);
    }

    private function getActiveModules(): array
    {
        $modules = [];

        if ($this->siteContext->hasModule('blog')) {
            $modules[] = 'blog';
        }
        if ($this->siteContext->hasModule('events')) {
            $modules[] = 'events';
        }

        return $modules;
    }

    private function updatePreferences(Subscriber $existing, Subscriber $submitted): void
    {
        if ($this->siteContext->hasModule('blog')) {
            $existing->setSubscribeArticles($submitted->isSubscribeArticles());
        }
        if ($this->siteContext->hasModule('events')) {
            $existing->setSubscribeEvents($submitted->isSubscribeEvents());
        }
    }

    private function sendConfirmationEmail(Subscriber $subscriber): void
    {
        $siteName = $this->systemMailer->getSiteName();

        $confirmUrl = $this->urlGenerator->generate('app_subscribe_confirm', [
            'token' => $subscriber->getToken(),
        ], UrlGeneratorInterface::ABSOLUTE_URL);

        $email = $this->systemMailer->createEmail("{$siteName} — Confirmez votre abonnement")
            ->to($subscriber->getEmail())
            ->html($this->buildConfirmationEmailBody($siteName, $confirmUrl));

        $this->systemMailer->send($email);
    }

    private function buildConfirmationEmailBody(string $siteName, string $confirmUrl): string
    {
        return <<<HTML
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
            <h2 style="color: #0455C0;">{$siteName}</h2>
            <p>Bonjour,</p>
            <p>Vous avez demande a recevoir nos actualites par email.</p>
            <p>Pour confirmer votre abonnement, cliquez sur le bouton ci-dessous :</p>
            <p style="text-align: center; margin: 30px 0;">
                <a href="{$confirmUrl}"
                   style="display: inline-block; padding: 12px 30px; background: #0455C0; color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: bold;">
                    Confirmer mon abonnement
                </a>
            </p>
            <p style="font-size: 0.9em; color: #666;">
                Si vous n'avez pas demande cet abonnement, ignorez simplement cet email.
            </p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="font-size: 0.8em; color: #999; text-align: center;">
                {$siteName}
            </p>
        </div>
        HTML;
    }

    private function getReferer(Request $request): string
    {
        $referer = $request->headers->get('referer');

        return $referer ?: $this->urlGenerator->generate('app_home');
    }
}
