<?php

namespace App\EventSubscriber;

use App\Entity\PageView;
use App\Entity\StatSession;
use App\Repository\StatSessionRepository;
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

    private const BOT_PATTERNS = [
        'bot', 'crawl', 'spider', 'slurp', 'googlebot', 'bingbot', 'yandex',
        'baidu', 'duckduckbot', 'facebookexternalhit', 'twitterbot', 'linkedinbot',
        'semrush', 'ahrefs', 'mj12bot', 'dotbot', 'petalbot', 'bytespider',
        'gptbot', 'claudebot', 'lighthouse', 'pagespeed', 'gtmetrix',
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
        $isBot = $this->isBot($userAgent);

        $ip = $request->getClientIp() ?? '0.0.0.0';
        $ipHash = hash('sha256', $ip . date('Y-m-d'));

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
            $session->setUserAgent($userAgent);
            $session->setIsBot($isBot);
            $session->setDeviceType($this->sourceClassifier->detectDeviceType($userAgent));

            $this->em->persist($session);
        } else {
            $session->setEndedAt(new \DateTimeImmutable());
            $session->setExitPage($url);
            $session->incrementPageCount();

            // Detection comportementale bot : > 30 pages en 60s
            if (!$session->isBot()) {
                $elapsed = time() - $session->getStartedAt()->getTimestamp();
                if ($elapsed > 0 && $elapsed <= self::BOT_TIME_WINDOW && $session->getPageCount() >= self::BOT_PAGE_THRESHOLD) {
                    $session->setIsBot(true);
                    $isBot = true;
                }
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
        $pageView->setUserAgent($userAgent);
        $pageView->setReferer($referer);
        $pageView->setIsBot($isBot);
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

    private function isBot(?string $userAgent): bool
    {
        if ($userAgent === null || $userAgent === '') {
            return true;
        }

        $ua = strtolower($userAgent);
        foreach (self::BOT_PATTERNS as $pattern) {
            if (str_contains($ua, $pattern)) {
                return true;
            }
        }

        return false;
    }
}
