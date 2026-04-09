<?php

namespace App\EventSubscriber;

use App\Repository\ArticleRepository;
use App\Service\ArticleNotificationService;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\KernelEvents;

/**
 * Publication programmee "lazy" : a chaque visite front,
 * verifie si des articles programmes sont prets a etre publies.
 *
 * Pas de cron necessaire — fonctionne nativement en multi-site.
 */
class ScheduledPublicationSubscriber implements EventSubscriberInterface
{
    private const EXCLUDED_PREFIXES = [
        '/_wdt',
        '/_profiler',
        '/_error',
        '/build/',
        '/bundles/',
        '/images/',
        '/documents/',
        '/favicon',
    ];

    public function __construct(
        private readonly ArticleRepository $articleRepository,
        private readonly EntityManagerInterface $em,
        private readonly ArticleNotificationService $notificationService,
        private readonly LoggerInterface $logger,
    ) {
    }

    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::REQUEST => ['onKernelRequest', 20],
        ];
    }

    public function onKernelRequest(RequestEvent $event): void
    {
        if (!$event->isMainRequest()) {
            return;
        }

        $path = $event->getRequest()->getPathInfo();

        // Ne pas executer sur les assets et outils dev
        foreach (self::EXCLUDED_PREFIXES as $prefix) {
            if (str_starts_with($path, $prefix)) {
                return;
            }
        }

        $articles = $this->articleRepository->findScheduledReady();

        if (empty($articles)) {
            return;
        }

        foreach ($articles as $article) {
            $article->setPublished(true);
            $article->setPublishedAt($article->getScheduledAt());

            $this->logger->info('Publication programmee : "{title}" (programme pour {date})', [
                'title' => $article->getTitle(),
                'date' => $article->getScheduledAt()->format('Y-m-d H:i'),
            ]);
        }

        $this->em->flush();

        // Notifications apres le flush pour garantir la persistance
        foreach ($articles as $article) {
            try {
                $this->notificationService->notifySubscribers($article);
            } catch (\Throwable $e) {
                $this->logger->error('Erreur notification article programme "{title}" : {error}', [
                    'title' => $article->getTitle(),
                    'error' => $e->getMessage(),
                ]);
            }
        }
    }
}
