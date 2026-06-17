<?php

namespace App\Repository;

use App\Entity\SlugRedirect;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<SlugRedirect>
 */
class SlugRedirectRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, SlugRedirect::class);
    }

    public function findRedirect(string $entityType, string $oldSlug): ?SlugRedirect
    {
        return $this->findOneBy([
            'entityType' => $entityType,
            'oldSlug' => $oldSlug,
        ]);
    }

    public function purgeOlderThan(\DateTimeInterface $date): int
    {
        return $this->createQueryBuilder('r')
            ->delete()
            ->where('r.createdAt < :date')
            ->setParameter('date', $date)
            ->getQuery()
            ->execute();
    }
}
