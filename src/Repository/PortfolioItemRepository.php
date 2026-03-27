<?php

namespace App\Repository;

use App\Entity\PortfolioCategory;
use App\Entity\PortfolioItem;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<PortfolioItem>
 */
class PortfolioItemRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, PortfolioItem::class);
    }

    /**
     * @return PortfolioItem[]
     */
    public function findAllActive(): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.isActive = :active')
            ->setParameter('active', true)
            ->orderBy('p.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return PortfolioItem[]
     */
    public function findActiveByCategory(PortfolioCategory $category): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.isActive = :active')
            ->andWhere('p.category = :category')
            ->setParameter('active', true)
            ->setParameter('category', $category)
            ->orderBy('p.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return PortfolioItem[]
     */
    public function findFeatured(int $limit = 6): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.isActive = :active')
            ->andWhere('p.isFeatured = :featured')
            ->setParameter('active', true)
            ->setParameter('featured', true)
            ->orderBy('p.position', 'ASC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    public function findOneActiveBySlug(string $slug): ?PortfolioItem
    {
        return $this->createQueryBuilder('p')
            ->where('p.slug = :slug')
            ->andWhere('p.isActive = :active')
            ->setParameter('slug', $slug)
            ->setParameter('active', true)
            ->getQuery()
            ->getOneOrNullResult();
    }

    /**
     * @return PortfolioItem[]
     */
    public function findAllActiveForSitemap(): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.isActive = :active')
            ->andWhere('p.noIndex = :noIndex')
            ->setParameter('active', true)
            ->setParameter('noIndex', false)
            ->orderBy('p.position', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
