<?php

namespace App\Service;

use Doctrine\DBAL\Connection;
use Symfony\Component\DependencyInjection\Attribute\Autowire;

/**
 * Donnees du rapport mensuel client (voir RAPPORT.md), sans mise en forme :
 * un tableau que l'e-mail affiche et que LintellO pourra recevoir tel quel.
 *
 * Phase R1 : module de stats seulement (visites confirmees par le navigateur,
 * robots exclus). Search Console arrive en R2, avec l'API LintellO.
 */
class MonthlyReportBuilder
{
    private const TOP_PAGES = 5;

    /** Sources de StatSession regroupees comme dans le rapport */
    private const SOURCE_GROUPS = [
        'seo_google' => 'Google',
        'paid_google' => 'Google',
        'direct' => 'Accès direct',
        'social_facebook' => 'Réseaux sociaux',
        'social_linkedin' => 'Réseaux sociaux',
        'social_other' => 'Réseaux sociaux',
    ];
    private const SOURCE_OTHER = 'Autres sites';

    public function __construct(
        private readonly Connection $db,
        private readonly SiteContext $siteContext,
        #[Autowire('%env(APP_PRIMARY_HOST)%')]
        private readonly string $primaryHost,
    ) {
    }

    /**
     * @param \DateTimeImmutable $month n'importe quel jour du mois rapporte
     */
    public function build(\DateTimeImmutable $month): array
    {
        $start = $month->modify('first day of this month midnight');
        $end = $start->modify('+1 month');
        $previousStart = $start->modify('-1 month');

        $visitors = $this->visitors($start, $end);
        $previousVisitors = $this->visitors($previousStart, $start);
        $contacts = $this->contacts($start, $end);
        $previousContacts = $this->contacts($previousStart, $start);
        $sources = $this->sources($start, $end);
        $lastArticle = $this->lastArticleDate();

        // Mois en toutes lettres sans intl : l'ICU de l'image Docker n'a pas le francais
        $mois = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];

        $report = [
            'month' => $start,
            'month_label' => $mois[(int) $start->format('n') - 1] . ' ' . $start->format('Y'),
            'site_name' => $this->siteContext->getCurrentSite()?->getName() ?? '',
            'site_url' => trim($this->primaryHost) !== '' ? 'https://' . trim($this->primaryHost) : null,
            'visitors' => [
                'current' => $visitors,
                'previous' => $previousVisitors,
                'trend' => $this->trend($visitors, $previousVisitors),
            ],
            'google_share' => $this->share($sources['Google'] ?? 0, $visitors),
            'mobile_share' => $this->share($this->mobileVisitors($start, $end), $visitors),
            // Groupes sous 1 % retires : « Autres sites 0 % » n'apprend rien au client
            'sources' => array_filter(array_map(fn (int $n) => $this->share($n, $visitors), $sources)),
            'top_pages' => $this->topPages($start, $end),
            'article' => $this->articleOfTheMonth($start, $end),
            'contacts' => [
                'current' => $contacts,
                'total' => array_sum($contacts),
                'previous_total' => array_sum($previousContacts),
                'trend' => $this->trend(array_sum($contacts), array_sum($previousContacts)),
            ],
            'health' => [
                'ssl_days_left' => $this->sslDaysLeft(),
                'days_since_last_article' => $lastArticle ? (int) $lastArticle->diff(new \DateTimeImmutable())->days : null,
            ],
        ];

        $report['health']['status'] = $this->healthStatus($report['health']);
        $report['summary'] = $this->summary($report);
        $report['next_actions'] = $this->nextActions($report);

        return $report;
    }

    private function visitors(\DateTimeImmutable $from, \DateTimeImmutable $to): int
    {
        return (int) $this->db->fetchOne(
            'SELECT COUNT(*) FROM stat_session WHERE is_bot = 0 AND started_at >= :from AND started_at < :to',
            $this->period($from, $to),
        );
    }

    private function mobileVisitors(\DateTimeImmutable $from, \DateTimeImmutable $to): int
    {
        return (int) $this->db->fetchOne(
            "SELECT COUNT(*) FROM stat_session WHERE is_bot = 0 AND started_at >= :from AND started_at < :to
             AND device_type IN ('mobile', 'tablet')",
            $this->period($from, $to),
        );
    }

    /**
     * @return array<string, int> visites par groupe de sources, du plus gros au plus petit
     */
    private function sources(\DateTimeImmutable $from, \DateTimeImmutable $to): array
    {
        $rows = $this->db->fetchAllKeyValue(
            'SELECT source, COUNT(*) FROM stat_session WHERE is_bot = 0 AND started_at >= :from AND started_at < :to GROUP BY source',
            $this->period($from, $to),
        );

        $groups = [];
        foreach ($rows as $source => $count) {
            $group = self::SOURCE_GROUPS[$source] ?? self::SOURCE_OTHER;
            $groups[$group] = ($groups[$group] ?? 0) + (int) $count;
        }
        arsort($groups);

        return $groups;
    }

    /**
     * @return list<array{url: string, views: int}>
     */
    private function topPages(\DateTimeImmutable $from, \DateTimeImmutable $to): array
    {
        $rows = $this->db->fetchAllAssociative(
            'SELECT url, COUNT(*) AS views FROM page_view WHERE is_bot = 0 AND created_at >= :from AND created_at < :to
             GROUP BY url ORDER BY views DESC LIMIT ' . self::TOP_PAGES,
            $this->period($from, $to),
        );

        return array_map(fn (array $row) => ['url' => $row['url'], 'views' => (int) $row['views']], $rows);
    }

    /**
     * Dernier article publie dans le mois, et ses vues depuis sa publication.
     *
     * @return array{title: string, url: string, views: int}|null
     */
    private function articleOfTheMonth(\DateTimeImmutable $from, \DateTimeImmutable $to): ?array
    {
        $article = $this->db->fetchAssociative(
            'SELECT title, slug FROM article WHERE published = 1 AND published_at >= :from AND published_at < :to
             ORDER BY published_at DESC LIMIT 1',
            $this->period($from, $to),
        );
        if (!$article) {
            return null;
        }

        $url = '/article/' . $article['slug'];
        $views = (int) $this->db->fetchOne(
            'SELECT COUNT(*) FROM page_view WHERE is_bot = 0 AND url = :url',
            ['url' => $url],
        );

        return ['title' => $article['title'], 'url' => $url, 'views' => $views];
    }

    /**
     * @return array{phone: int, form: int, email: int, directions: int}
     */
    private function contacts(\DateTimeImmutable $from, \DateTimeImmutable $to): array
    {
        $rows = $this->db->fetchAllKeyValue(
            'SELECT type, COUNT(*) FROM stat_conversion WHERE created_at >= :from AND created_at < :to GROUP BY type',
            $this->period($from, $to),
        );

        return [
            'phone' => (int) ($rows['phone_click'] ?? 0),
            'form' => (int) ($rows['form_submit'] ?? 0) + (int) ($rows['landing_form_submit'] ?? 0),
            'email' => (int) ($rows['email_click'] ?? 0),
            'directions' => (int) ($rows['directions_click'] ?? 0),
        ];
    }

    private function lastArticleDate(): ?\DateTimeImmutable
    {
        $date = $this->db->fetchOne('SELECT MAX(published_at) FROM article WHERE published = 1');

        return $date ? new \DateTimeImmutable($date) : null;
    }

    /**
     * Jours avant l'expiration du certificat du domaine principal, null si inconnu.
     */
    private function sslDaysLeft(): ?int
    {
        $host = trim($this->primaryHost);
        if ($host === '') {
            return null;
        }

        $context = stream_context_create(['ssl' => ['capture_peer_cert' => true, 'verify_peer' => false, 'verify_peer_name' => false]]);
        $socket = @stream_socket_client("ssl://{$host}:443", $errno, $errstr, 10, STREAM_CLIENT_CONNECT, $context);
        if (!$socket) {
            return null;
        }

        $certificate = openssl_x509_parse(stream_context_get_params($socket)['options']['ssl']['peer_certificate'] ?? '');
        fclose($socket);

        if (!$certificate || !isset($certificate['validTo_time_t'])) {
            return null;
        }

        return (int) floor(($certificate['validTo_time_t'] - time()) / 86400);
    }

    /**
     * @param array{ssl_days_left: ?int, days_since_last_article: ?int} $health
     */
    private function healthStatus(array $health): string
    {
        $ssl = $health['ssl_days_left'];
        if ($ssl !== null && $ssl < 7) {
            return 'red';
        }
        if (($ssl !== null && $ssl < 21) || ($health['days_since_last_article'] ?? 0) > 60) {
            return 'orange';
        }

        return 'green';
    }

    /**
     * Phrase d'en-tete. Phrases a modeles en R1 ; LintellO la redigera en R2.
     */
    private function summary(array $report): string
    {
        $visitors = $report['visitors']['current'];
        $trend = $report['visitors']['trend'];
        $contacts = $report['contacts']['total'];

        $opening = match (true) {
            $trend === null => 'En ' . $report['month_label'],
            $trend >= 5 => 'Bon mois',
            $trend <= -5 => 'Mois plus calme',
            default => 'Mois stable',
        };

        $sentence = sprintf('%s : %s visiteur%s sur votre site', $opening, number_format($visitors, 0, ',', ' '), $visitors > 1 ? 's' : '');
        if ($trend !== null) {
            $sentence .= sprintf(' (%s%d %%)', $trend > 0 ? '+' : '', $trend);
        }
        if ($contacts > 0) {
            $sentence .= sprintf(', et %d prise%s de contact', $contacts, $contacts > 1 ? 's' : '');
        }

        return $sentence . '.';
    }

    /**
     * Une ou deux actions concretes pour le mois suivant.
     *
     * @return list<string>
     */
    private function nextActions(array $report): array
    {
        $actions = [];
        $days = $report['health']['days_since_last_article'];

        if ($days === null || $days > 30) {
            $actions[] = 'Publier un nouvel article : Google met en avant les sites qui vivent.';
        }
        if (($report['health']['ssl_days_left'] ?? 99) < 21) {
            $actions[] = 'Renouveler le certificat de sécurité du site avant son expiration.';
        }
        if ($actions === [] && $report['top_pages'] !== []) {
            $actions[] = sprintf('Enrichir la page la plus vue (%s) : c\'est elle qui attire vos visiteurs.', $report['top_pages'][0]['url']);
        }

        return array_slice($actions, 0, 2);
    }

    /**
     * Evolution en %, arrondie ; null s'il n'y a rien a comparer.
     */
    private function trend(int $current, int $previous): ?int
    {
        if ($previous === 0) {
            return null;
        }

        return (int) round(($current - $previous) / $previous * 100);
    }

    private function share(int $part, int $total): int
    {
        return $total > 0 ? (int) round($part / $total * 100) : 0;
    }

    /**
     * @return array{from: string, to: string}
     */
    private function period(\DateTimeImmutable $from, \DateTimeImmutable $to): array
    {
        return ['from' => $from->format('Y-m-d H:i:s'), 'to' => $to->format('Y-m-d H:i:s')];
    }
}
