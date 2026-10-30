<?php

namespace App\EventSubscriber;

use App\Entity\PageView;
use App\Entity\StatSession;
use App\Repository\StatBotDailyRepository;
use App\Repository\StatSessionRepository;
use App\Service\BotDetector;
use App\Service\SourceClassifier;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\Cookie;
use Symfony\Component\HttpKernel\Event\ResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;

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

    private const COOKIE_NAME = '_bw_sid';
    private const SESSION_TIMEOUT = 1800; // 30 minutes
    private const BOT_PAGE_THRESHOLD = 30;  // pages max en SESSION_BOT_WINDOW
    private const BOT_TIME_WINDOW = 60;     // secondes

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Security $security,
        private readonly StatSessionRepository $sessionRepository,
        private readonly SourceClassifier $sourceClassifier,
        private readonly BotDetector $botDetector,
        private readonly StatBotDailyRepository $botDailyRepository,
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

        $userAgent = mb_substr($request->headers->get('User-Agent', ''), 0, 500) ?: null;

        $ip = $request->getClientIp() ?? '0.0.0.0';
        $ipHash = hash('sha256', $ip . date('Y-m-d'));

        // Un robot n'est pas une visite : il est seulement compte, sans
        // session ni ligne de visite (ses passages remplissaient la base)
        if ($this->botDetector->isBotUserAgent($userAgent) || $this->botDetector->isFlooding($ipHash)) {
            $this->botDailyRepository->increment();

            return;
        }

        $url = mb_substr($path, 0, 500);
        $referer = mb_substr($request->headers->get('Referer', ''), 0, 500) ?: null;

        // --- Session ---
        $session = null;
        $sessionToken = $request->cookies->get(self::COOKIE_NAME);
        $isNewSession = false;

        if ($sessionToken) {
            $session = $this->sessionRepository->findOneBy(['sessionToken' => $sessionToken]);

            if ($session) {
                $elapsed = time() - $session->getEndedAt()->getTimestamp();
                if ($elapsed > self::SESSION_TIMEOUT) {
                    $session = null;
                }
            }
        }

        if (!$session) {
            $isNewSession = true;
            $sessionToken = bin2hex(random_bytes(32));

            $utmSource = $request->query->get('utm_source');
            $utmMedium = $request->query->get('utm_medium');
            $utmCampaign = $request->query->get('utm_campaign');

            [$source, $sourceDetail] = $this->sourceClassifier->classify($referer, $utmSource, $utmMedium);

            $session = new StatSession();
            $session->setSessionToken($sessionToken);
            $session->setSource($source);
            $session->setSourceDetail($sourceDetail ? mb_substr($sourceDetail, 0, 500) : null);
            $session->setUtmCampaign($utmCampaign ? mb_substr($utmCampaign, 0, 255) : null);
            $session->setUtmMedium($utmMedium ? mb_substr($utmMedium, 0, 100) : null);
            $session->setLandingPage($url);
            $session->setExitPage($url);
            $session->setIpHash($ipHash);
            $session->setDeviceType($this->sourceClassifier->detectDeviceType($userAgent));

            $this->em->persist($session);
        } else {
            // Session deja reconnue comme robot : ses pages ne sont plus que comptees
            if ($session->isBot()) {
                $this->botDailyRepository->increment();

                return;
            }

            $session->setEndedAt(new \DateTimeImmutable());
            $session->setExitPage($url);
            $session->incrementPageCount();

            // Detection comportementale bot : > 30 pages en 60s. Les pages
            // deja enregistrees de la session restent, les suivantes sont comptees
            $elapsed = time() - $session->getStartedAt()->getTimestamp();
            if ($elapsed > 0 && $elapsed <= self::BOT_TIME_WINDOW && $session->getPageCount() >= self::BOT_PAGE_THRESHOLD) {
                $session->setIsBot(true);
                $this->em->flush();
                $this->botDailyRepository->increment();

                return;
            }
        }

        // --- PageView ---
        $previousUrl = null;
        $sequenceNumber = 1;

        if (!$isNewSession) {
            $sequenceNumber = $session->getPageCount();
            $lastPageView = $this->em->getRepository(PageView::class)->findOneBy(
                ['session' => $session],
                ['sequenceNumber' => 'DESC'],
            );
            if ($lastPageView) {
                $previousUrl = $lastPageView->getUrl();
            }
        }

        $pageView = new PageView();
        $pageView->setUrl($url);
        $pageView->setIpHash($ipHash);
        $pageView->setReferer($referer);
        $pageView->setSession($session);
        $pageView->setPreviousUrl($previousUrl);
        $pageView->setSequenceNumber($sequenceNumber);

        $this->em->persist($pageView);
        $this->em->flush();

        // --- Cookie ---
        $response->headers->setCookie(
            Cookie::create(self::COOKIE_NAME)
                ->withValue($sessionToken)
                ->withExpires(time() + self::SESSION_TIMEOUT)
                ->withPath('/')
                ->withHttpOnly(false)
                ->withSameSite('lax')
        );
    }
}
