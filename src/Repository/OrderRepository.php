<?php

namespace App\Repository;

use App\Entity\Order;
use App\Enum\OrderStatusEnum;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Order>
 */
class OrderRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Order::class);
    }

    /**
     * @return Order[]
     */
    public function findRecent(int $limit = 5): array
    {
        return $this->createQueryBuilder('o')
            ->orderBy('o.createdAt', 'DESC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * @return array<string, int>
     */
    public function countByStatus(): array
    {
        $results = $this->createQueryBuilder('o')
            ->select('o.status, COUNT(o.id) as total')
            ->groupBy('o.status')
            ->getQuery()
            ->getResult();

        $counts = [];
        foreach ($results as $row) {
            $counts[$row['status']->value] = (int) $row['total'];
        }

        return $counts;
    }

    public function revenueThisMonth(): float
    {
        $start = new \DateTimeImmutable('first day of this month midnight');
        $end = new \DateTimeImmutable('first day of next month midnight');

        $result = $this->createQueryBuilder('o')
            ->select('SUM(o.totalTTC) as revenue')
            ->where('o.status = :paid')
            ->andWhere('o.paidAt >= :start')
            ->andWhere('o.paidAt < :end')
            ->setParameter('paid', OrderStatusEnum::PAID)
            ->setParameter('start', $start)
            ->setParameter('end', $end)
            ->getQuery()
            ->getSingleScalarResult();

        return (float) ($result ?? 0);
    }

    public function countPaidThisMonth(): int
    {
        $start = new \DateTimeImmutable('first day of this month midnight');
        $end = new \DateTimeImmutable('first day of next month midnight');

        $result = $this->createQueryBuilder('o')
            ->select('COUNT(o.id)')
            ->where('o.status = :paid')
            ->andWhere('o.paidAt >= :start')
            ->andWhere('o.paidAt < :end')
            ->setParameter('paid', OrderStatusEnum::PAID)
            ->setParameter('start', $start)
            ->setParameter('end', $end)
            ->getQuery()
            ->getSingleScalarResult();

        return (int) $result;
    }

    /**
     * CA par mois sur les N derniers mois.
     *
     * @return array<array{month: string, revenue: float}>
     */
    public function revenueByMonth(int $months = 6): array
    {
        $start = new \DateTimeImmutable("-{$months} months first day of midnight");

        $conn = $this->getEntityManager()->getConnection();
        $sql = "
            SELECT DATE_FORMAT(paid_at, '%Y-%m') as month, SUM(total_ttc) as revenue
            FROM `order`
            WHERE status = :paid AND paid_at >= :start
            GROUP BY month
            ORDER BY month ASC
        ";

        $results = $conn->executeQuery($sql, [
            'paid' => OrderStatusEnum::PAID->value,
            'start' => $start->format('Y-m-d'),
        ])->fetchAllAssociative();

        return array_map(fn (array $row) => [
            'month' => $row['month'],
            'revenue' => (float) $row['revenue'],
        ], $results);
    }
}
