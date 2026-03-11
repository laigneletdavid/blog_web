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
            ->setParameter('today', $today)
            ->getQuery()
            ->getSingleScalarResult();
    }

    /**
     * Top articles les plus vus (par URL contenant /article/).
     *
     * @return array<int, array{url: string, views: int}>
     */
    public function topArticles(int $limit = 10): array
    {
        return $this->createQueryBuilder('pv')
            ->select('pv.url, COUNT(pv.id) AS views')
            ->where('pv.url LIKE :pattern')
            ->setParameter('pattern', '%/article/%')
            ->groupBy('pv.url')
            ->orderBy('views', 'DESC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * Stats journalières sur les N derniers jours.
     *
     * @return array<int, array{date: string, views: int, visitors: int}>
     */
    public function dailyStats(int $days = 30): array
    {
        $since = new \DateTimeImmutable("-{$days} days midnight");

        $conn = $this->getEntityManager()->getConnection();

        $sql = '
            SELECT
                DATE(created_at) AS date,
                COUNT(*) AS views,
                COUNT(DISTINCT ip_hash) AS visitors
            FROM page_view
            WHERE created_at >= :since
            GROUP BY DATE(created_at)
            ORDER BY date ASC
        ';

        $result = $conn->executeQuery($sql, ['since' => $since->format('Y-m-d H:i:s')]);

        return $result->fetchAllAssociative();
    }
}
