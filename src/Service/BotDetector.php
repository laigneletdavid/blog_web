<?php

namespace App\Service;

use Psr\Cache\CacheItemPoolInterface;

/**
 * Reconnait les robots, pour ne pas les enregistrer comme des visites.
 *
 * Deux signaux :
 * - l'user-agent : robots declares (« bot », « spider »...) et outils de
 *   scraping (curl, python, navigateurs sans tete, faux navigateurs) ;
 * - la cadence par IP : la plupart des robots ne gardent pas le cookie de
 *   session, chaque page ouvrirait une nouvelle session et la detection par
 *   session ne verrait rien. Au-dela de FLOOD_PAGES pages dans la minute,
 *   l'IP est traitee comme un robot jusqu'a la fin de la journee.
 */
class BotDetector
{
    private const USER_AGENT_PATTERNS = [
        // Robots declares
        'bot', 'crawl', 'spider', 'slurp', 'yandex', 'baidu', 'facebookexternalhit',
        'semrush', 'ahrefs', 'petalbot', 'bytespider', 'lighthouse', 'pagespeed', 'gtmetrix',
        // Outils de scraping et clients HTTP
        'python', 'curl', 'wget', 'scrapy', 'headless', 'phantomjs', 'go-http', 'java/',
        'httpclient', 'okhttp', 'axios', 'node-fetch', 'libwww',
        // Faux navigateurs : « (HTML, like Gecko) » au lieu de « (KHTML, like Gecko) »
        '(html, like gecko)',
    ];

    // Un vrai navigateur annonce bien plus que 20 caracteres
    private const MIN_USER_AGENT_LENGTH = 20;

    private const FLOOD_PAGES = 20;

    public function __construct(
        private readonly CacheItemPoolInterface $cache,
    ) {
    }

    public function isBotUserAgent(?string $userAgent): bool
    {
        if ($userAgent === null || mb_strlen(trim($userAgent)) < self::MIN_USER_AGENT_LENGTH) {
            return true;
        }

        $ua = strtolower($userAgent);
        foreach (self::USER_AGENT_PATTERNS as $pattern) {
            if (str_contains($ua, $pattern)) {
                return true;
            }
        }

        return false;
    }

    /**
     * L'IP a-t-elle deja depasse la cadence aujourd'hui ? Lecture seule : la
     * confirmation d'une visite ne doit pas compter une seconde fois la page.
     */
    public function isFlagged(string $ipHash): bool
    {
        return $this->cache->getItem('stat_bot_ip_' . $ipHash)->isHit();
    }

    /**
     * Compte la page pour cette IP et dit si elle depasse la cadence d'un humain.
     * $ipHash change chaque jour (voir PageViewSubscriber) : le marquage robot
     * s'eteint donc de lui-meme le lendemain.
     */
    public function isFlooding(string $ipHash): bool
    {
        $flagged = $this->cache->getItem('stat_bot_ip_' . $ipHash);
        if ($flagged->isHit()) {
            return true;
        }

        $counter = $this->cache->getItem('stat_rate_' . $ipHash . '_' . date('YmdHi'));
        $pages = ($counter->isHit() ? (int) $counter->get() : 0) + 1;
        $counter->set($pages)->expiresAfter(120);
        $this->cache->save($counter);

        if ($pages <= self::FLOOD_PAGES) {
            return false;
        }

        $flagged->set(true)->expiresAt(new \DateTimeImmutable('tomorrow'));
        $this->cache->save($flagged);

        return true;
    }
}
