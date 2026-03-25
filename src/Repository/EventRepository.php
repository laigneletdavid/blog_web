<?php

namespace App\Repository;

use App\Entity\Event;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Event>
 */
class EventRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Event::class);
    }

    /**
     * Événements à venir (dateStart >= aujourd'hui), triés par date croissante.
     *
     * @return Event[]
     */
    public function findUpcoming(int $limit = 10): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.dateStart >= :now')
            ->setParameter('active', true)
            ->setParameter('now', new \DateTime('today'))
            ->orderBy('e.dateStart', 'ASC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * Événements passés, triés par date décroissante.
     *
     * @return Event[]
     */
    public function findPast(int $limit = 10, int $offset = 0): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.dateStart < :now')
            ->setParameter('active', true)
            ->setParameter('now', new \DateTime('today'))
            ->orderBy('e.dateStart', 'DESC')
            ->setFirstResult($offset)
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * Nombre total d'événements passés (pour pagination).
     */
    public function countPast(): int
    {
        return (int) $this->createQueryBuilder('e')
            ->select('COUNT(e.id)')
            ->where('e.isActive = :active')
            ->andWhere('e.dateStart < :now')
            ->setParameter('active', true)
            ->setParameter('now', new \DateTime('today'))
            ->getQuery()
            ->getSingleScalarResult();
    }

    /**
     * Événements d'un mois donné (pour widget calendrier simple).
     *
     * @return Event[]
     */
    public function findByMonth(int $year, int $month): array
    {
        $start = new \DateTime("$year-$month-01");
        $end = (clone $start)->modify('last day of this month')->setTime(23, 59, 59);

        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.dateStart >= :start')
            ->andWhere('e.dateStart <= :end')
            ->setParameter('active', true)
            ->setParameter('start', $start)
            ->setParameter('end', $end)
            ->orderBy('e.dateStart', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Détail d'un événement actif par slug.
     */
    public function findOneActiveBySlug(string $slug): ?Event
    {
        return $this->createQueryBuilder('e')
            ->where('e.slug = :slug')
            ->andWhere('e.isActive = :active')
            ->setParameter('slug', $slug)
            ->setParameter('active', true)
            ->getQuery()
            ->getOneOrNullResult();
    }

    /**
     * Tous les événements actifs pour le sitemap.
     *
     * @return Event[]
     */
    public function findAllActiveForSitemap(): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.noIndex = :noIndex')
            ->setParameter('active', true)
            ->setParameter('noIndex', false)
            ->orderBy('e.dateStart', 'DESC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Événements mis en avant (à venir + actifs + featured).
     *
     * @return Event[]
     */
    public function findFeatured(): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.isFeatured = :featured')
            ->andWhere('e.dateStart >= :now')
            ->setParameter('active', true)
            ->setParameter('featured', true)
            ->setParameter('now', new \DateTime('today'))
            ->orderBy('e.dateStart', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
