<?php

namespace App\Service;

class SourceClassifier
{
    /**
     * @return array{0: string, 1: ?string} [source, sourceDetail]
     */
    public function classify(?string $referer, ?string $utmSource, ?string $utmMedium, ?string $siteHost = null): array
    {
        if ($utmSource) {
            return match (true) {
                str_contains($utmSource, 'newsletter'),
                str_contains($utmSource, 'email') => ['email', $utmSource],
                str_contains($utmSource, 'linkedin') => ['social_linkedin', $utmSource],
                str_contains($utmSource, 'facebook') => ['social_facebook', $utmSource],
                str_contains($utmSource, 'instagram'),
                str_contains($utmSource, 'twitter'),
                str_contains($utmSource, 'tiktok') => ['social_other', $utmSource],
                str_contains($utmSource, 'google') => $utmMedium === 'cpc' ? ['paid_google', $utmSource] : ['seo_google', $utmSource],
                default => ['other', $utmSource],
            };
        }

        if (!$referer) {
            return ['direct', null];
        }

        $host = parse_url($referer, PHP_URL_HOST);
        if (!$host) {
            return ['direct', null];
        }

        $host = strtolower($host);

        // Le site lui-meme (session expiree en pleine navigation) : pas un
        // « autre site ». En octobre 2026, 35 % des visites de bw_pro_dici
        // etaient classees ainsi.
        if ($siteHost !== null && $this->withoutWww($host) === $this->withoutWww(strtolower($siteHost))) {
            return ['direct', null];
        }

        return match (true) {
            str_contains($host, 'google') => ['seo_google', $referer],
            str_contains($host, 'bing') => ['seo_bing', $referer],
            str_contains($host, 'yahoo'),
            str_contains($host, 'duckduckgo'),
            str_contains($host, 'qwant'),
            str_contains($host, 'ecosia') => ['seo_other', $referer],
            str_contains($host, 'linkedin') => ['social_linkedin', $referer],
            str_contains($host, 'facebook'),
            $this->isDomain($host, 'fb.com') => ['social_facebook', $referer],
            str_contains($host, 'instagram') => ['social_other', $referer],
            // Domaines exacts : « t.co » se trouve aussi dans qwant.com ou blogspot.com
            $this->isDomain($host, 'twitter.com'),
            $this->isDomain($host, 'x.com'),
            $this->isDomain($host, 't.co') => ['social_other', $referer],
            str_contains($host, 'tiktok') => ['social_other', $referer],
            default => ['referral', $referer],
        };
    }

    private function withoutWww(string $host): string
    {
        return str_starts_with($host, 'www.') ? substr($host, 4) : $host;
    }

    /** Le domaine lui-meme ou l'un de ses sous-domaines (m.facebook.com) */
    private function isDomain(string $host, string $domain): bool
    {
        return $host === $domain || str_ends_with($host, '.' . $domain);
    }

    public function detectDeviceType(?string $userAgent): ?string
    {
        if (!$userAgent) {
            return null;
        }

        $ua = strtolower($userAgent);

        if (str_contains($ua, 'tablet') || str_contains($ua, 'ipad')) {
            return 'tablet';
        }

        if (str_contains($ua, 'mobile') || str_contains($ua, 'android') || str_contains($ua, 'iphone')) {
            return 'mobile';
        }

        return 'desktop';
    }
}
