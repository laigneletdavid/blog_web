<?php

namespace App\Service;

use App\Entity\PageView;
use App\Entity\StatSession;
use App\Repository\StatBotDailyRepository;
use App\Repository\StatSessionRepository;
use Doctrine\ORM\EntityManagerInterface;

/**
 * Enregistre une visite confirmee par le navigateur (stat-tracker.js).
 *
 * Les robots qui ne font que telecharger le HTML n'arrivent jamais ici :
 * ils n'executent pas le JavaScript. Ceux qui l'executent sont ecartes par
 * l'user-agent, la cadence par IP, navigator.webdriver ou le rythme de la
 * session.
 */
class VisitRecorder
{
    public const COOKIE_NAME = '_bw_sid';
    public const SESSION_TIMEOUT = 1800; // 30 minutes
    private const BOT_PAGE_THRESHOLD = 30;  // pages max en BOT_TIME_WINDOW
    private const BOT_TIME_WINDOW = 60;     // secondes

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly StatSessionRepository $sessionRepository,
        private readonly SourceClassifier $sourceClassifier,
        private readonly BotDetector $botDetector,
        private readonly StatBotDailyRepository $botDailyRepository,
    ) {
    }

    /**
     * @param array<string, string> $utm utm_source, utm_medium, utm_campaign de la page
     *
     * @return string|null le jeton de session a poser en cookie, null pour un robot
     */
    public function record(
        string $path,
        ?string $sessionToken,
        ?string $userAgent,
        string $ip,
        ?string $referer,
        array $utm,
        bool $webdriver,
    ): ?string {
        $ipHash = hash('sha256', $ip . date('Y-m-d'));

        if ($webdriver || $this->botDetector->isBotUserAgent($userAgent) || $this->botDetector->isFlagged($ipHash)) {
            $this->botDailyRepository->increment();

            return null;
        }

        $url = mb_substr($path, 0, 500);
        $referer = $referer ? mb_substr($referer, 0, 500) : null;

        // --- Session ---
        $session = null;
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

            $utmSource = $utm['utm_source'] ?? null;
            $utmMedium = $utm['utm_medium'] ?? null;
            $utmCampaign = $utm['utm_campaign'] ?? null;

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

                return null;
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

                return null;
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

        return $sessionToken;
    }
}
