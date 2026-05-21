<?php

namespace App\Service;

use Doctrine\DBAL\Connection;

/**
 * Requetes d'agregation pour le module Stats admin.
 * Utilise du SQL natif pour la performance (agrégations lourdes).
 */
class StatService
{
    public function __construct(
        private readonly Connection $conn,
    ) {
    }

    // =============================================
    // ACQUISITION
    // =============================================

    /**
     * Repartition des sources de trafic.
     * @return array<array{source: string, cnt: int}>
     */
    public function sourceBreakdown(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        return $this->conn->fetchAllAssociative(
            'SELECT source, COUNT(*) AS cnt
             FROM stat_session
             WHERE is_bot = 0 AND started_at >= :since
             GROUP BY source
             ORDER BY cnt DESC',
            ['since' => $since],
        );
    }

    /**
     * Repartition par type d'appareil (desktop, mobile, tablet).
     * @return array<array{device_type: string, cnt: int}>
     */
    public function deviceBreakdown(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        return $this->conn->fetchAllAssociative(
            'SELECT COALESCE(device_type, \'unknown\') AS device_type, COUNT(*) AS cnt
             FROM stat_session
             WHERE is_bot = 0 AND started_at >= :since
             GROUP BY device_type
             ORDER BY cnt DESC',
            ['since' => $since],
        );
    }

    /**
     * Top pages d'entree (landing pages).
     * @return array<array{landing_page: string, cnt: int}>
     */
    public function topLandingPages(string $period = '30d', int $limit = 10): array
    {
        [$since] = $this->resolvePeriod($period);

        return $this->conn->fetchAllAssociative(
            'SELECT landing_page, COUNT(*) AS cnt
             FROM stat_session
             WHERE is_bot = 0 AND started_at >= :since
             GROUP BY landing_page
             ORDER BY cnt DESC
             LIMIT :lim',
            ['since' => $since, 'lim' => $limit],
            ['lim' => \Doctrine\DBAL\ParameterType::INTEGER],
        );
    }

    // =============================================
    // COMPORTEMENT
    // =============================================

    /**
     * KPI comportementaux globaux.
     * @return array{avg_duration: ?float, bounce_rate: ?float, avg_depth: ?float, avg_scroll: ?float}
     */
    public function behaviorKpi(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        $row = $this->conn->fetchAssociative(
            'SELECT
                AVG(pv.duration_seconds) AS avg_duration,
                AVG(pv.scroll_max_pct) AS avg_scroll
             FROM page_view pv
             WHERE pv.is_bot = 0
               AND pv.created_at >= :since
               AND pv.duration_seconds IS NOT NULL',
            ['since' => $since],
        );

        $sessionRow = $this->conn->fetchAssociative(
            'SELECT
                COUNT(*) AS total,
                SUM(CASE WHEN page_count = 1 THEN 1 ELSE 0 END) AS bounces,
                AVG(page_count) AS avg_depth
             FROM stat_session
             WHERE is_bot = 0 AND started_at >= :since',
            ['since' => $since],
        );

        $total = (int) ($sessionRow['total'] ?? 0);

        return [
            'avg_duration' => $row['avg_duration'] ? round((float) $row['avg_duration']) : null,
            'bounce_rate' => $total > 0 ? round((int) $sessionRow['bounces'] / $total * 100, 1) : null,
            'avg_depth' => $sessionRow['avg_depth'] ? round((float) $sessionRow['avg_depth'], 1) : null,
            'avg_scroll' => $row['avg_scroll'] ? round((float) $row['avg_scroll']) : null,
        ];
    }

    /**
     * Graphe temporel d'une metrique comportementale sur 30 jours.
     * @return array<array{date: string, value: float}>
     */
    public function behaviorTimeline(string $metric = 'duration', int $days = 30): array
    {
        $since = (new \DateTimeImmutable("-{$days} days midnight"))->format('Y-m-d H:i:s');

        $select = match ($metric) {
            'bounce' => 'ROUND(SUM(CASE WHEN s.page_count = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) * 100, 1)',
            'depth' => 'ROUND(AVG(s.page_count), 1)',
            default => '(SELECT ROUND(AVG(pv2.duration_seconds)) FROM page_view pv2 WHERE pv2.is_bot = 0 AND DATE(pv2.created_at) = DATE(s.started_at) AND pv2.duration_seconds IS NOT NULL)',
        };

        return $this->conn->fetchAllAssociative(
            "SELECT DATE(s.started_at) AS date, {$select} AS value
             FROM stat_session s
             WHERE s.is_bot = 0 AND s.started_at >= :since
             GROUP BY DATE(s.started_at)
             ORDER BY date ASC",
            ['since' => $since],
        );
    }

    /**
     * Top pages avec metriques comportementales enrichies.
     * @return array<array{url: string, views: int, avg_duration: ?float, avg_scroll: ?float, bounce_rate: ?float}>
     */
    public function topPagesEnriched(string $period = '30d', int $limit = 15): array
    {
        [$since] = $this->resolvePeriod($period);

        return $this->conn->fetchAllAssociative(
            'SELECT
                pv.url,
                COUNT(*) AS views,
                ROUND(AVG(pv.duration_seconds)) AS avg_duration,
                ROUND(AVG(pv.scroll_max_pct)) AS avg_scroll,
                ROUND(
                    SUM(CASE WHEN pv.sequence_number = 1 AND s.page_count = 1 THEN 1 ELSE 0 END)
                    / NULLIF(SUM(CASE WHEN pv.sequence_number = 1 THEN 1 ELSE 0 END), 0) * 100
                , 1) AS bounce_rate
             FROM page_view pv
             LEFT JOIN stat_session s ON s.id = pv.session_id
             WHERE pv.is_bot = 0 AND pv.created_at >= :since
             GROUP BY pv.url
             ORDER BY views DESC
             LIMIT :lim',
            ['since' => $since, 'lim' => $limit],
            ['lim' => \Doctrine\DBAL\ParameterType::INTEGER],
        );
    }

    // =============================================
    // PARCOURS
    // =============================================

    /**
     * Pages precedentes et suivantes pour une URL donnee.
     * @return array{prev: array, next: array, exit_rate: ?float}
     */
    public function pageFlow(string $url, string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        $next = $this->conn->fetchAllAssociative(
            'SELECT pv.url AS page, COUNT(*) AS cnt
             FROM page_view pv
             WHERE pv.previous_url = :url AND pv.is_bot = 0 AND pv.created_at >= :since
             GROUP BY pv.url ORDER BY cnt DESC LIMIT 5',
            ['url' => $url, 'since' => $since],
        );

        $prev = $this->conn->fetchAllAssociative(
            'SELECT pv.previous_url AS page, COUNT(*) AS cnt
             FROM page_view pv
             WHERE pv.url = :url AND pv.previous_url IS NOT NULL AND pv.is_bot = 0 AND pv.created_at >= :since
             GROUP BY pv.previous_url ORDER BY cnt DESC LIMIT 5',
            ['url' => $url, 'since' => $since],
        );

        // Taux de sortie
        $exitRow = $this->conn->fetchAssociative(
            'SELECT
                COUNT(DISTINCT s.id) AS sessions_with_page,
                COUNT(DISTINCT CASE WHEN s.exit_page = :url THEN s.id END) AS exit_sessions
             FROM stat_session s
             JOIN page_view pv ON pv.session_id = s.id
             WHERE pv.url = :url AND s.is_bot = 0 AND s.started_at >= :since',
            ['url' => $url, 'since' => $since],
        );

        $total = (int) ($exitRow['sessions_with_page'] ?? 0);
        $exitRate = $total > 0 ? round((int) $exitRow['exit_sessions'] / $total * 100, 1) : null;

        return [
            'prev' => $prev,
            'next' => $next,
            'exit_rate' => $exitRate,
        ];
    }

    /**
     * Pages de sortie problematiques (taux de sortie eleve).
     * @return array<array{exit_page: string, exit_rate: float, sessions: int}>
     */
    public function topExitPages(string $period = '30d', int $limit = 10): array
    {
        [$since] = $this->resolvePeriod($period);

        return $this->conn->fetchAllAssociative(
            'SELECT
                s.exit_page,
                COUNT(*) AS exit_sessions,
                ROUND(COUNT(*) / (SELECT COUNT(*) FROM stat_session s2 WHERE s2.is_bot = 0 AND s2.started_at >= :since) * 100, 1) AS exit_rate
             FROM stat_session s
             WHERE s.is_bot = 0 AND s.started_at >= :since
             GROUP BY s.exit_page
             ORDER BY exit_sessions DESC
             LIMIT :lim',
            ['since' => $since, 'lim' => $limit],
            ['lim' => \Doctrine\DBAL\ParameterType::INTEGER],
        );
    }

    // =============================================
    // CONVERSIONS
    // =============================================

    /**
     * Compteurs de conversions par type.
     * @return array{phone_click: int, email_click: int, form_submit: int, total: int}
     */
    public function conversionCounts(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        $rows = $this->conn->fetchAllAssociative(
            'SELECT type, COUNT(*) AS cnt
             FROM stat_conversion
             WHERE created_at >= :since
             GROUP BY type',
            ['since' => $since],
        );

        $counts = ['phone_click' => 0, 'email_click' => 0, 'form_submit' => 0];
        foreach ($rows as $row) {
            $counts[$row['type']] = (int) $row['cnt'];
        }
        $counts['total'] = array_sum($counts);

        return $counts;
    }

    /**
     * Entonnoir de conversion.
     * @return array{visitors: int, engaged: int, saw_contact: int, converted: int, rate: ?float}
     */
    public function conversionFunnel(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        $visitors = (int) $this->conn->fetchOne(
            'SELECT COUNT(*) FROM stat_session WHERE is_bot = 0 AND started_at >= :since',
            ['since' => $since],
        );

        $engaged = (int) $this->conn->fetchOne(
            'SELECT COUNT(*) FROM stat_session WHERE is_bot = 0 AND page_count > 1 AND started_at >= :since',
            ['since' => $since],
        );

        $sawContact = (int) $this->conn->fetchOne(
            'SELECT COUNT(DISTINCT pv.session_id)
             FROM page_view pv
             JOIN stat_session s ON s.id = pv.session_id
             WHERE pv.url = :url AND s.is_bot = 0 AND pv.created_at >= :since',
            ['url' => '/contact', 'since' => $since],
        );

        $converted = (int) $this->conn->fetchOne(
            'SELECT COUNT(DISTINCT sc.session_id)
             FROM stat_conversion sc
             WHERE sc.created_at >= :since',
            ['since' => $since],
        );

        return [
            'visitors' => $visitors,
            'engaged' => $engaged,
            'saw_contact' => $sawContact,
            'converted' => $converted,
            'rate' => $visitors > 0 ? round($converted / $visitors * 100, 1) : null,
        ];
    }

    /**
     * Conversions recentes avec parcours resumé.
     * @return array<array{date: string, source: string, type: string, detail: ?string, page_url: string, journey: string}>
     */
    public function recentConversions(int $limit = 10): array
    {
        $rows = $this->conn->fetchAllAssociative(
            'SELECT
                sc.created_at AS date,
                sc.type,
                sc.detail,
                sc.page_url,
                s.source,
                s.id AS session_id
             FROM stat_conversion sc
             LEFT JOIN stat_session s ON s.id = sc.session_id
             ORDER BY sc.created_at DESC
             LIMIT :lim',
            ['lim' => $limit],
            ['lim' => \Doctrine\DBAL\ParameterType::INTEGER],
        );

        foreach ($rows as &$row) {
            $row['journey'] = '';
            if ($row['session_id']) {
                $pages = $this->conn->fetchAllAssociative(
                    'SELECT url FROM page_view
                     WHERE session_id = :sid
                     ORDER BY sequence_number ASC LIMIT 5',
                    ['sid' => $row['session_id']],
                );
                $urls = array_column($pages, 'url');
                $row['journey'] = implode(' → ', $urls);
            }
        }

        return $rows;
    }

    /**
     * Pages qui generent le plus de conversions (derniere page avant conversion).
     * @return array<array{page_url: string, cnt: int}>
     */
    public function conversionPages(string $period = '30d', int $limit = 10): array
    {
        [$since] = $this->resolvePeriod($period);

        return $this->conn->fetchAllAssociative(
            'SELECT page_url, COUNT(*) AS cnt
             FROM stat_conversion
             WHERE created_at >= :since
             GROUP BY page_url
             ORDER BY cnt DESC
             LIMIT :lim',
            ['since' => $since, 'lim' => $limit],
            ['lim' => \Doctrine\DBAL\ParameterType::INTEGER],
        );
    }

    // =============================================
    // DASHBOARD RESUME
    // =============================================

    /**
     * Resume mensuel pour le bloc dashboard principal.
     * @return array{top_source: ?string, top_source_pct: ?float, bounce_rate: ?float, avg_duration: ?int, conversions: int}
     */
    public function dashboardSummary(): array
    {
        $since = (new \DateTimeImmutable('first day of this month midnight'))->format('Y-m-d H:i:s');

        // Source principale
        $sourceRow = $this->conn->fetchAssociative(
            'SELECT source, COUNT(*) AS cnt,
                    ROUND(COUNT(*) / (SELECT COUNT(*) FROM stat_session WHERE is_bot = 0 AND started_at >= :since) * 100, 1) AS pct
             FROM stat_session
             WHERE is_bot = 0 AND started_at >= :since
             GROUP BY source
             ORDER BY cnt DESC
             LIMIT 1',
            ['since' => $since],
        );

        // Taux de rebond
        $bounceRow = $this->conn->fetchAssociative(
            'SELECT
                COUNT(*) AS total,
                SUM(CASE WHEN page_count = 1 THEN 1 ELSE 0 END) AS bounces
             FROM stat_session
             WHERE is_bot = 0 AND started_at >= :since',
            ['since' => $since],
        );

        // Duree moyenne
        $durationRow = $this->conn->fetchOne(
            'SELECT ROUND(AVG(duration_seconds))
             FROM page_view
             WHERE is_bot = 0 AND created_at >= :since AND duration_seconds IS NOT NULL',
            ['since' => $since],
        );

        // Conversions
        $conversions = (int) $this->conn->fetchOne(
            'SELECT COUNT(*) FROM stat_conversion WHERE created_at >= :since',
            ['since' => $since],
        );

        $total = (int) ($bounceRow['total'] ?? 0);

        return [
            'top_source' => $sourceRow['source'] ?? null,
            'top_source_pct' => $sourceRow['pct'] ?? null,
            'bounce_rate' => $total > 0 ? round((int) ($bounceRow['bounces'] ?? 0) / $total * 100, 1) : null,
            'avg_duration' => $durationRow ? (int) $durationRow : null,
            'conversions' => $conversions,
        ];
    }

    // =============================================
    // EXPORT
    // =============================================

    /**
     * Export des conversions pour CSV.
     * @return array<array{date: string, type: string, page_url: string, source: ?string, detail: ?string}>
     */
    public function exportConversions(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        return $this->conn->fetchAllAssociative(
            'SELECT
                DATE_FORMAT(c.created_at, "%d/%m/%Y %H:%i") AS date,
                c.type,
                c.page_url,
                s.source,
                c.detail
             FROM stat_conversion c
             LEFT JOIN stat_session s ON c.session_id = s.id
             WHERE c.created_at >= :since
             ORDER BY c.created_at DESC',
            ['since' => $since],
        );
    }

    /**
     * Rassemble toutes les donnees pour le rapport complet (CSV/PDF).
     * @return array{behavior: array, sources: array, landingPages: array, funnel: array, counts: array, topPages: array, exitPages: array, conversionPages: array, conversions: array}
     */
    public function fullReportData(string $period = '30d'): array
    {
        return [
            'behavior' => $this->behaviorKpi($period),
            'sources' => $this->sourceBreakdown($period),
            'devices' => $this->deviceBreakdown($period),
            'landingPages' => $this->topLandingPages($period, 15),
            'funnel' => $this->conversionFunnel($period),
            'counts' => $this->conversionCounts($period),
            'topPages' => $this->topPagesEnriched($period, 20),
            'exitPages' => $this->topExitPages($period, 10),
            'conversionPages' => $this->conversionPages($period, 10),
            'conversions' => $this->exportConversions($period),
        ];
    }

    // =============================================
    // UTILS
    // =============================================

    /**
     * @return array{0: string} [sinceDate]
     */
    private function resolvePeriod(string $period): array
    {
        $since = match ($period) {
            'today' => new \DateTimeImmutable('today'),
            '7d' => new \DateTimeImmutable('-7 days midnight'),
            '30d' => new \DateTimeImmutable('-30 days midnight'),
            'month' => new \DateTimeImmutable('first day of this month midnight'),
            'quarter' => new \DateTimeImmutable('first day of ' . match ((int) date('n') % 3) {
                1 => 'this month', 2 => '-1 month', 0 => '-2 months',
            } . ' midnight'),
            'year' => new \DateTimeImmutable('first day of January this year'),
            default => new \DateTimeImmutable('-30 days midnight'),
        };

        return [$since->format('Y-m-d H:i:s')];
    }
}
