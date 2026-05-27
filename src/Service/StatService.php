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

        // Duration : requete directe sur page_view (evite sous-requete correlee incompatible ONLY_FULL_GROUP_BY)
        if ($metric === 'duration') {
            return $this->conn->fetchAllAssociative(
                'SELECT DATE(pv.created_at) AS date, ROUND(AVG(pv.duration_seconds)) AS value
                 FROM page_view pv
                 WHERE pv.is_bot = 0 AND pv.created_at >= :since AND pv.duration_seconds IS NOT NULL
                 GROUP BY DATE(pv.created_at)
                 ORDER BY date ASC',
                ['since' => $since],
            );
        }

        $select = match ($metric) {
            'bounce' => 'ROUND(SUM(CASE WHEN s.page_count = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) * 100, 1)',
            'depth' => 'ROUND(AVG(s.page_count), 1)',
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
            'behavior' => $this->behaviorKpiWithTrend($period),
            'visitors' => $this->visitorsWithTrend($period),
            'sources' => $this->sourceBreakdown($period),
            'devices' => $this->deviceBreakdown($period),
            'landingPages' => $this->topLandingPages($period, 15),
            'funnel' => $this->conversionFunnel($period),
            'counts' => $this->conversionCountsWithTrend($period),
            'topPages' => $this->topPagesEnriched($period, 20),
            'exitPages' => $this->topExitPages($period, 10),
            'conversionPages' => $this->conversionPages($period, 10),
            'conversionPaths' => $this->topConversionPaths($period),
            'criticalPages' => $this->criticalPages($period),
            'heatmap' => $this->heatmapData($period),
            'conversions' => $this->exportConversions($period),
        ];
    }

    // =============================================
    // PARCOURS DE CONVERSION (Phase 5b)
    // =============================================

    /**
     * Top parcours des sessions qui ont converti.
     * Reconstruit le chemin page par page puis agrege les patterns.
     * @return array<int, array{path: string, count: int, pct: float}>
     */
    public function topConversionPaths(string $period = '30d', int $limit = 5): array
    {
        [$since] = $this->resolvePeriod($period);

        // Récupérer les parcours de chaque session convertie
        $rows = $this->conn->fetchAllAssociative(
            'SELECT pv.session_id,
                    GROUP_CONCAT(pv.url ORDER BY pv.sequence_number SEPARATOR \' → \') AS journey
             FROM page_view pv
             WHERE pv.session_id IN (
               SELECT DISTINCT session_id FROM stat_conversion WHERE created_at >= :since AND session_id IS NOT NULL
             )
             GROUP BY pv.session_id',
            ['since' => $since],
        );

        if (empty($rows)) {
            return [];
        }

        // Agréger les parcours identiques
        $paths = [];
        foreach ($rows as $row) {
            $journey = $row['journey'];
            $paths[$journey] = ($paths[$journey] ?? 0) + 1;
        }
        arsort($paths);

        $total = count($rows);
        $result = [];
        $i = 0;
        foreach ($paths as $path => $count) {
            if (++$i > $limit) {
                break;
            }
            $result[] = [
                'path' => $path,
                'count' => $count,
                'pct' => round($count / $total * 100, 1),
            ];
        }

        return $result;
    }

    /**
     * Pages les plus présentes dans les parcours qui convertissent.
     * @return array<int, array{url: string, sessions: int, pct: float}>
     */
    public function criticalPages(string $period = '30d', int $limit = 10): array
    {
        [$since] = $this->resolvePeriod($period);

        $totalConverted = (int) $this->conn->fetchOne(
            'SELECT COUNT(DISTINCT session_id) FROM stat_conversion WHERE created_at >= :since AND session_id IS NOT NULL',
            ['since' => $since],
        );

        if ($totalConverted === 0) {
            return [];
        }

        $rows = $this->conn->fetchAllAssociative(
            'SELECT pv.url, COUNT(DISTINCT pv.session_id) AS sessions_converties
             FROM page_view pv
             WHERE pv.session_id IN (
               SELECT DISTINCT session_id FROM stat_conversion WHERE created_at >= :since AND session_id IS NOT NULL
             )
             GROUP BY pv.url
             ORDER BY sessions_converties DESC
             LIMIT :lim',
            ['since' => $since, 'lim' => $limit],
            ['lim' => \Doctrine\DBAL\ParameterType::INTEGER],
        );

        return array_map(fn(array $row) => [
            'url' => $row['url'],
            'sessions' => (int) $row['sessions_converties'],
            'pct' => round((int) $row['sessions_converties'] / $totalConverted * 100, 1),
        ], $rows);
    }

    // =============================================
    // HEATMAP TEMPOREL (Phase 5c)
    // =============================================

    /**
     * Matrice jour×heure des sessions (heatmap 7×24).
     * DAYOFWEEK MariaDB : 1=Dim, 2=Lun...7=Sam → on remap en 0=Lun..6=Dim.
     * @return array{grid: array<int, array<int, int>>, max: int, days: string[], hours: int[]}
     */
    public function heatmapData(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);

        $rows = $this->conn->fetchAllAssociative(
            'SELECT DAYOFWEEK(started_at) AS dow, HOUR(started_at) AS hour, COUNT(*) AS sessions
             FROM stat_session
             WHERE is_bot = 0 AND started_at >= :since
             GROUP BY dow, hour
             ORDER BY dow, hour',
            ['since' => $since],
        );

        // Initialiser grille 7 jours × 24 heures à 0
        $grid = array_fill(0, 7, array_fill(0, 24, 0));
        $max = 0;

        // Remap DAYOFWEEK (1=Dim) → 0=Lun..6=Dim
        $dowMap = [2 => 0, 3 => 1, 4 => 2, 5 => 3, 6 => 4, 7 => 5, 1 => 6];

        foreach ($rows as $row) {
            $dayIdx = $dowMap[(int) $row['dow']] ?? 0;
            $hour = (int) $row['hour'];
            $count = (int) $row['sessions'];
            $grid[$dayIdx][$hour] = $count;
            if ($count > $max) {
                $max = $count;
            }
        }

        return [
            'grid' => $grid,
            'max' => $max,
            'days' => ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
            'hours' => range(0, 23),
        ];
    }

    // =============================================
    // TENDANCES (vs période précédente)
    // =============================================

    /**
     * KPI comportementaux avec delta vs période précédente.
     * Chaque KPI contient la valeur actuelle + trend (delta en %).
     */
    public function behaviorKpiWithTrend(string $period = '30d'): array
    {
        $current = $this->behaviorKpi($period);
        [$prevSince, $prevUntil] = $this->resolvePreviousPeriod($period);

        // Période précédente
        $prevPv = $this->conn->fetchAssociative(
            'SELECT AVG(pv.duration_seconds) AS avg_duration, AVG(pv.scroll_max_pct) AS avg_scroll
             FROM page_view pv
             WHERE pv.is_bot = 0 AND pv.created_at >= :since AND pv.created_at < :until AND pv.duration_seconds IS NOT NULL',
            ['since' => $prevSince, 'until' => $prevUntil],
        );

        $prevSession = $this->conn->fetchAssociative(
            'SELECT COUNT(*) AS total, SUM(CASE WHEN page_count = 1 THEN 1 ELSE 0 END) AS bounces, AVG(page_count) AS avg_depth
             FROM stat_session WHERE is_bot = 0 AND started_at >= :since AND started_at < :until',
            ['since' => $prevSince, 'until' => $prevUntil],
        );

        $prevTotal = (int) ($prevSession['total'] ?? 0);
        $prev = [
            'avg_duration' => $prevPv['avg_duration'] ? round((float) $prevPv['avg_duration']) : null,
            'bounce_rate' => $prevTotal > 0 ? round((int) $prevSession['bounces'] / $prevTotal * 100, 1) : null,
            'avg_depth' => $prevSession['avg_depth'] ? round((float) $prevSession['avg_depth'], 1) : null,
            'avg_scroll' => $prevPv['avg_scroll'] ? round((float) $prevPv['avg_scroll']) : null,
        ];

        return [
            'avg_duration' => $current['avg_duration'],
            'avg_duration_trend' => $this->calcTrend($current['avg_duration'], $prev['avg_duration']),
            'bounce_rate' => $current['bounce_rate'],
            'bounce_rate_trend' => $this->calcTrend($current['bounce_rate'], $prev['bounce_rate']),
            'avg_depth' => $current['avg_depth'],
            'avg_depth_trend' => $this->calcTrend($current['avg_depth'], $prev['avg_depth']),
            'avg_scroll' => $current['avg_scroll'],
            'avg_scroll_trend' => $this->calcTrend($current['avg_scroll'], $prev['avg_scroll']),
        ];
    }

    /**
     * Compteurs de conversions avec tendance.
     */
    public function conversionCountsWithTrend(string $period = '30d'): array
    {
        $current = $this->conversionCounts($period);
        [$prevSince, $prevUntil] = $this->resolvePreviousPeriod($period);

        $prevRows = $this->conn->fetchAllAssociative(
            'SELECT type, COUNT(*) AS cnt FROM stat_conversion WHERE created_at >= :since AND created_at < :until GROUP BY type',
            ['since' => $prevSince, 'until' => $prevUntil],
        );

        $prev = ['phone_click' => 0, 'email_click' => 0, 'form_submit' => 0];
        foreach ($prevRows as $row) {
            $prev[$row['type']] = (int) $row['cnt'];
        }
        $prev['total'] = array_sum($prev);

        return [
            'phone_click' => $current['phone_click'],
            'phone_click_trend' => $this->calcTrend($current['phone_click'], $prev['phone_click']),
            'email_click' => $current['email_click'],
            'email_click_trend' => $this->calcTrend($current['email_click'], $prev['email_click']),
            'form_submit' => $current['form_submit'],
            'form_submit_trend' => $this->calcTrend($current['form_submit'], $prev['form_submit']),
            'total' => $current['total'],
            'total_trend' => $this->calcTrend($current['total'], $prev['total']),
        ];
    }

    /**
     * Nombre de visiteurs avec tendance (pour la vue d'ensemble).
     */
    public function visitorsWithTrend(string $period = '30d'): array
    {
        [$since] = $this->resolvePeriod($period);
        [$prevSince, $prevUntil] = $this->resolvePreviousPeriod($period);

        $current = (int) $this->conn->fetchOne(
            'SELECT COUNT(*) FROM stat_session WHERE is_bot = 0 AND started_at >= :since',
            ['since' => $since],
        );

        $prev = (int) $this->conn->fetchOne(
            'SELECT COUNT(*) FROM stat_session WHERE is_bot = 0 AND started_at >= :since AND started_at < :until',
            ['since' => $prevSince, 'until' => $prevUntil],
        );

        return [
            'value' => $current,
            'trend' => $this->calcTrend($current, $prev),
        ];
    }

    /**
     * Calcule le delta en pourcentage entre la valeur actuelle et precedente.
     * @return array{delta: float|null, direction: string} direction = 'up'|'down'|'stable'
     */
    private function calcTrend(?float $current, ?float $previous): array
    {
        if ($current === null || $previous === null || $previous == 0) {
            if ($current !== null && $current > 0 && ($previous === null || $previous == 0)) {
                return ['delta' => null, 'direction' => 'up'];
            }
            return ['delta' => null, 'direction' => 'stable'];
        }

        $delta = round(($current - $previous) / abs($previous) * 100, 1);

        if (abs($delta) < 2.0) {
            return ['delta' => $delta, 'direction' => 'stable'];
        }

        return ['delta' => $delta, 'direction' => $delta > 0 ? 'up' : 'down'];
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

    /**
     * Calcule la période précédente de même durée.
     * Ex: 30d actuel = [now-30d, now] → précédent = [now-60d, now-30d]
     * @return array{0: string, 1: string} [prevSince, prevUntil]
     */
    private function resolvePreviousPeriod(string $period): array
    {
        $now = new \DateTimeImmutable('now');

        [$currentSince] = $this->resolvePeriod($period);
        $currentSinceDate = new \DateTimeImmutable($currentSince);

        // Durée en secondes de la période actuelle
        $durationSeconds = $now->getTimestamp() - $currentSinceDate->getTimestamp();

        $prevUntil = $currentSinceDate;
        $prevSince = $prevUntil->modify("-{$durationSeconds} seconds");

        return [$prevSince->format('Y-m-d H:i:s'), $prevUntil->format('Y-m-d H:i:s')];
    }
}
