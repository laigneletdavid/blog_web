<?php

namespace App\EventSubscriber;

use App\Entity\PageView;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\ResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;

/**
 * Log chaque visite front dans la table page_view.
 * Exclut les routes admin, le profiler, les assets et les bots courants.
 */
class PageViewSubscriber implements EventSubscriberInterface
{
    private const EXCLUDED_PREFIXES = [
        '/admin',
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
        private readonly EntityManagerInterface $em,
    ) {
    }

    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::RESPONSE => ['onResponse', -100], // Basse priorité
        ];
    }

    public function onResponse(ResponseEvent $event): void
    {
        if (!$event->isMainRequest()) {
            return;
        }

        $request = $event->getRequest();
        $response = $event->getResponse();

        // Ne loguer que les réponses HTML 200
        if ($response->getStatusCode() !== 200) {
            return;
        }

        $contentType = $response->headers->get('Content-Type', '');
        if (!str_contains($contentType, 'text/html')) {
            return;
        }

        $path = $request->getPathInfo();

        // Exclure les routes non-front
        foreach (self::EXCLUDED_PREFIXES as $prefix) {
            if (str_starts_with($path, $prefix)) {
                return;
            }
        }

        // Hasher l'IP (RGPD — on ne stocke jamais l'IP en clair)
        $ip = $request->getClientIp() ?? '0.0.0.0';
        $ipHash = hash('sha256', $ip . date('Y-m-d')); // Salté par jour pour limiter le tracking

        $pageView = new PageView();
        $pageView->setUrl(mb_substr($path, 0, 500));
        $pageView->setIpHash($ipHash);
        $pageView->setUserAgent(mb_substr($request->headers->get('User-Agent', ''), 0, 500) ?: null);
        $pageView->setReferer(mb_substr($request->headers->get('Referer', ''), 0, 500) ?: null);

        $this->em->persist($pageView);
        $this->em->flush();
    }
}
