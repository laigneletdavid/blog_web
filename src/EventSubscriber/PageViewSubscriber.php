<?php

namespace App\EventSubscriber;

use App\Repository\StatBotDailyRepository;
use App\Service\BotDetector;
use App\Service\VisitTicket;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\ResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;

/**
 * Prepare la mesure d'audience sur chaque page servie, sans rien ecrire.
 *
 * La visite n'est plus enregistree ici : le serveur glisse un ticket signe
 * dans la page (<meta name="bw-visit">) et c'est stat-tracker.js qui la
 * confirme (VisitApiController). Un robot qui ne fait que telecharger le
 * HTML n'execute pas le script et ne cree donc aucune ligne : en octobre
 * 2026, 517 000 fausses visites de /annuaire venaient de tels robots, sur
 * des milliers d'IP, avec un user-agent de navigateur.
 *
 * Les robots reconnus ici (user-agent, cadence par IP) ne recoivent pas de
 * ticket et sont seulement comptes, pour la courbe Robots.
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
        '/api/',
    ];

    public function __construct(
        private readonly Security $security,
        private readonly BotDetector $botDetector,
        private readonly StatBotDailyRepository $botDailyRepository,
        private readonly VisitTicket $visitTicket,
    ) {
    }

    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::RESPONSE => ['onResponse', -100],
        ];
    }

    public function onResponse(ResponseEvent $event): void
    {
        if (!$event->isMainRequest()) {
            return;
        }

        $request = $event->getRequest();
        $response = $event->getResponse();

        if ($response->getStatusCode() !== 200) {
            return;
        }

        $contentType = $response->headers->get('Content-Type', '');
        if (!str_contains($contentType, 'text/html')) {
            return;
        }

        $path = $request->getPathInfo();

        foreach (self::EXCLUDED_PREFIXES as $prefix) {
            if (str_starts_with($path, $prefix)) {
                return;
            }
        }

        if ($this->security->isGranted('ROLE_AUTHOR')) {
            return;
        }

        $userAgent = $request->headers->get('User-Agent');
        $ipHash = hash('sha256', ($request->getClientIp() ?? '0.0.0.0') . date('Y-m-d'));

        if ($this->botDetector->isBotUserAgent($userAgent) || $this->botDetector->isFlooding($ipHash)) {
            $this->botDailyRepository->increment();

            return;
        }

        $content = $response->getContent();
        if ($content === false || !str_contains($content, '</head>')) {
            return;
        }

        $meta = '<meta name="bw-visit" content="' . htmlspecialchars($this->visitTicket->issue($path), ENT_QUOTES) . '">';
        $response->setContent(preg_replace('#</head>#', $meta . "\n</head>", $content, 1));
    }
}
