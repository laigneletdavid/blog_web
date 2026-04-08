<?php

namespace App\Repository;

use App\Entity\PageView;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<PageView>
 */
class PageViewRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, PageView::class);
    }

    public function countToday(): int
    {
        $today = new \DateTimeImmutable('today');

        return (int) $this->createQueryBuilder('pv')
            ->select('COUNT(pv.id)')
            ->where('pv.createdAt >= :today')
            ->andWhere('pv.isBot = false')
            ->setParameter('today', $today)
            ->getQuery()
            ->getSingleScalarResult();
    }

    public function countThisWeek(): int
    {
        $monday = new \DateTimeImmutable('monday this week');

        return (int) $this->createQueryBuilder('pv')
            ->select('COUNT(pv.id)')
            ->where('pv.createdAt >= :monday')
            ->andWhere('pv.isBot = false')
            ->setParameter('monday', $monday)
            ->getQuery()
            ->getSingleScalarResult();
    }

    public function countThisMonth(): int
    {
        $firstDay = new \DateTimeImmutable('first day of this month midnight');

        return (int) $this->createQueryBuilder('pv')
            ->select('COUNT(pv.id)')
            ->where('pv.createdAt >= :firstDay')
            ->andWhere('pv.isBot = false')
            ->setParameter('firstDay', $firstDay)
            ->getQuery()
            ->getSingleScalarResult();
    }

    public function uniqueVisitorsToday(): int
    {
        $today = new \DateTimeImmutable('today');

        return (int) $this->createQueryBuilder('pv')
            ->select('COUNT(DISTINCT pv.ipHash)')
            ->where('pv.createdAt >= :today')
            ->andWhere('pv.isBot = false')
            ->setParameter('today', $today)
            ->getQuery()
            ->getSingleScalarResult();
    }

    /**
     * Top pages les plus vues (humains uniquement), filtrable par periode et annee.
     *
     * @return array<int, array{url: string, views: int}>
     */
    public function topPages(int $limit = 10, string $period = 'month', int $year = 0): array
    {
        $qb = $this->createQueryBuilder('pv')
            ->select('pv.url, COUNT(pv.id) AS views')
            ->where('pv.isBot = false');

        $since = $this->resolvePeriodDate($period, $year);
        if ($since !== null) {
            $qb->andWhere('pv.createdAt >= :since')
               ->setParameter('since', $since);
        }

        return $qb->groupBy('pv.url')
            ->orderBy('views', 'DESC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    private function resolvePeriodDate(string $period, int $year): ?\DateTimeImmutable
    {
        return match ($period) {
            'today' => new \DateTimeImmutable('today'),
            'week' => new \DateTimeImmutable('monday this week'),
            'month' => new \DateTimeImmutable('first day of this month midnight'),
            'year' => new \DateTimeImmutable($year . '-01-01'),
            default => null,
        };
    }

    /**
     * Nombre de vues humaines pour une URL donnee.
     */
    public function countViewsByUrl(string $url): int
    {
        return (int) $this->createQueryBuilder('pv')
            ->select('COUNT(pv.id)')
            ->where('pv.url = :url')
            ->andWhere('pv.isBot = false')
            ->setParameter('url', $url)
            ->getQuery()
            ->getSingleScalarResult();
    }

    /**
     * Stats journalières sur les N derniers jours.
     * Retourne vues humaines, visiteurs uniques humains, et vues bots séparément.
     *
     * @return array<int, array{date: string, views: int, visitors: int, bot_views: int}>
     */
    public function dailyStats(int $days = 30): array
    {
        $since = new \DateTimeImmutable("-{$days} days midnight");

        $conn = $this->getEntityManager()->getConnection();

        $sql = '
            SELECT
                DATE(created_at) AS date,
                SUM(CASE WHEN is_bot = 0 THEN 1 ELSE 0 END) AS views,
                COUNT(DISTINCT CASE WHEN is_bot = 0 THEN ip_hash END) AS visitors,
                SUM(CASE WHEN is_bot = 1 THEN 1 ELSE 0 END) AS bot_views
            FROM page_view
            WHERE created_at >= :since
            GROUP BY DATE(created_at)
            ORDER BY date ASC
        ';

        $result = $conn->executeQuery($sql, ['since' => $since->format('Y-m-d H:i:s')]);

        return $result->fetchAllAssociative();
    }
}
