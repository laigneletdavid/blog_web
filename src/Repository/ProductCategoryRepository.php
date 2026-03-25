<?php

namespace App\Repository;

use App\Entity\ProductCategory;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<ProductCategory>
 */
class ProductCategoryRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, ProductCategory::class);
    }

    /**
     * @return ProductCategory[]
     */
    public function findAllActive(): array
    {
        return $this->createQueryBuilder('pc')
            ->where('pc.isActive = :active')
            ->setParameter('active', true)
            ->orderBy('pc.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return ProductCategory[]
     */
    public function findAllActiveWithProductCount(): array
    {
        return $this->createQueryBuilder('pc')
            ->select('pc', 'COUNT(p.id) AS productCount')
            ->leftJoin('pc.products', 'p', 'WITH', 'p.isActive = true')
            ->where('pc.isActive = :active')
            ->setParameter('active', true)
            ->groupBy('pc.id')
            ->orderBy('pc.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    public function findOneActiveBySlug(string $slug): ?ProductCategory
    {
        return $this->createQueryBuilder('pc')
            ->where('pc.slug = :slug')
            ->andWhere('pc.isActive = :active')
            ->setParameter('slug', $slug)
            ->setParameter('active', true)
            ->getQuery()
            ->getOneOrNullResult();
    }
}
