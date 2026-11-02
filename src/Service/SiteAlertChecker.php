<?php

namespace App\Service;

use App\Enum\ModuleEnum;
use Doctrine\DBAL\ArrayParameterType;
use Doctrine\DBAL\Connection;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Contracts\HttpClient\HttpClientInterface;

/**
 * Controles hebdo du site pour le super admin (RAPPORT.md, section 2).
 *
 * Ne renvoie que les anomalies : une liste vide veut dire que tout va bien
 * et qu'aucun e-mail ne part. Les controles Search Console (impressions,
 * couverture) arriveront en phase R2.
 */
class SiteAlertChecker
{
    private const SSL_MIN_DAYS = 21;
    private const ARTICLE_MAX_DAYS = 30;
    private const STATS_MAX_BYTES = 1024 ** 3; // 1 Go
    private const STAT_TABLES = ['page_view', 'stat_session', 'stat_conversion', 'stat_bot_daily'];
    // Vague de robots : semaine plus de 3 fois au-dessus de la moyenne des 4 precedentes
    private const BOT_SURGE_FACTOR = 3;
    private const BOT_SURGE_MIN_HITS = 1000;

    public function __construct(
        private readonly Connection $db,
        private readonly SiteContext $siteContext,
        private readonly HttpClientInterface $httpClient,
        private readonly CertificateChecker $certificateChecker,
        private readonly CriticalLogScanner $logScanner,
        #[Autowire('%env(APP_PRIMARY_HOST)%')]
        private readonly string $primaryHost,
        #[Autowire('%kernel.logs_dir%/%kernel.environment%.log')]
        private readonly string $logFile,
    ) {
    }

    /**
     * @return list<array{title: string, detail: string, action: string}>
     */
    public function check(?\DateTimeImmutable $now = null): array
    {
        $now ??= new \DateTimeImmutable();
        $host = trim($this->primaryHost);

        return array_values(array_filter([
            $host !== '' ? $this->checkHomepage($host) : null,
            $host !== '' ? $this->checkCertificate($host) : null,
            $this->checkCriticalErrors($now),
            $this->checkBotSurge($now),
            $this->checkStatsSize(),
            $this->checkLastArticle($now),
        ]));
    }

    /**
     * Vague de robots : la semaine depasse BOT_SURGE_FACTOR fois la moyenne
     * des 4 semaines precedentes, et un minimum pour ignorer les petits sites.
     */
    public static function isBotSurge(int $weekHits, int $previousFourWeeksHits): bool
    {
        $average = $previousFourWeeksHits / 4;

        return $weekHits >= self::BOT_SURGE_MIN_HITS && $average > 0 && $weekHits > self::BOT_SURGE_FACTOR * $average;
    }

    private function checkHomepage(string $host): ?array
    {
        $url = 'https://' . $host . '/';
        try {
            $status = $this->httpClient->request('GET', $url, ['timeout' => 20, 'max_redirects' => 0])->getStatusCode();
        } catch (\Throwable $e) {
            return $this->alert('Site injoignable', "{$url} ne répond pas : " . mb_substr($e->getMessage(), 0, 150), 'Ouvrir le site, puis regarder var/log/prod.log et l\'état de l\'hébergement OVH.');
        }

        if ($status !== 200) {
            return $this->alert('Accueil en erreur', "{$url} répond {$status}.", 'Ouvrir le site, puis regarder var/log/prod.log.');
        }

        return null;
    }

    private function checkCertificate(string $host): ?array
    {
        $days = $this->certificateChecker->daysLeft($host);
        if ($days === null || $days >= self::SSL_MIN_DAYS) {
            return null;
        }

        return $this->alert(
            $days < 0 ? 'Certificat SSL expiré' : 'Certificat SSL bientôt expiré',
            $days < 0 ? "Le certificat de {$host} a expiré il y a " . -$days . ' jours.' : "Le certificat de {$host} expire dans {$days} jours.",
            'Multisite OVH : régénérer le certificat SSL du domaine.',
        );
    }

    private function checkCriticalErrors(\DateTimeImmutable $now): ?array
    {
        $errors = $this->logScanner->scan($this->logFile, $now->modify('-7 days'));
        if ($errors['count'] === 0) {
            return null;
        }

        return $this->alert(
            sprintf('%d erreur%s grave%s cette semaine', $errors['count'], $errors['count'] > 1 ? 's' : '', $errors['count'] > 1 ? 's' : ''),
            'Dernière : ' . $errors['last'],
            'Lire les lignes CRITICAL de var/log/prod.log sur le serveur.',
        );
    }

    private function checkBotSurge(\DateTimeImmutable $now): ?array
    {
        $today = $now->format('Y-m-d');
        $week = (int) $this->db->fetchOne(
            'SELECT COALESCE(SUM(hits), 0) FROM stat_bot_daily WHERE day >= :from AND day < :to',
            ['from' => $now->modify('-7 days')->format('Y-m-d'), 'to' => $today],
        );
        $previous = (int) $this->db->fetchOne(
            'SELECT COALESCE(SUM(hits), 0) FROM stat_bot_daily WHERE day >= :from AND day < :to',
            ['from' => $now->modify('-35 days')->format('Y-m-d'), 'to' => $now->modify('-7 days')->format('Y-m-d')],
        );

        if (!self::isBotSurge($week, $previous)) {
            return null;
        }

        return $this->alert(
            'Vague de robots',
            sprintf('%s pages servies à des robots cette semaine, contre %s en moyenne les 4 semaines précédentes.', number_format($week, 0, ',', ' '), number_format((int) round($previous / 4), 0, ',', ' ')),
            'Rien n\'est stocké, mais le serveur travaille pour rien : bloquer les robots en cause dans robots.txt ou .htaccess.',
        );
    }

    private function checkStatsSize(): ?array
    {
        $bytes = (int) $this->db->fetchOne(
            'SELECT COALESCE(SUM(data_length + index_length), 0) FROM information_schema.tables
             WHERE table_schema = DATABASE() AND table_name IN (?)',
            [self::STAT_TABLES],
            [ArrayParameterType::STRING],
        );
        if ($bytes < self::STATS_MAX_BYTES) {
            return null;
        }

        return $this->alert(
            'Tables de statistiques trop lourdes',
            sprintf('%s Go pour les tables de statistiques.', number_format($bytes / 1024 ** 3, 2, ',', ' ')),
            'Vérifier que le cron tourne (app:stat:purge), puis chercher la source des lignes en trop.',
        );
    }

    private function checkLastArticle(\DateTimeImmutable $now): ?array
    {
        if (!$this->siteContext->hasModule(ModuleEnum::BLOG)) {
            return null;
        }

        $last = $this->db->fetchOne('SELECT MAX(published_at) FROM article WHERE published = 1');
        $days = $last ? (int) (new \DateTimeImmutable($last))->diff($now)->days : null;
        if ($days !== null && $days <= self::ARTICLE_MAX_DAYS) {
            return null;
        }

        return $this->alert(
            'Pas d\'article récent',
            $days === null ? 'Aucun article publié.' : "Dernier article publié il y a {$days} jours.",
            'Proposer un sujet au client, ou en rédiger un.',
        );
    }

    /**
     * @return array{title: string, detail: string, action: string}
     */
    private function alert(string $title, string $detail, string $action): array
    {
        return ['title' => $title, 'detail' => $detail, 'action' => $action];
    }
}
