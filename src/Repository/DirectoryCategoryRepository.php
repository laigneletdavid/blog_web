<?php

namespace App\Repository;

use App\Entity\DirectoryCategory;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<DirectoryCategory>
 */
class DirectoryCategoryRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, DirectoryCategory::class);
    }

    /** @return DirectoryCategory[] */
    public function findAllActive(): array
    {
        return $this->createQueryBuilder('c')
            ->where('c.isActive = :active')
            ->setParameter('active', true)
            ->orderBy('c.position', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
