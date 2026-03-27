<?php

namespace App\Repository;

use App\Entity\Product;
use App\Entity\ProductCategory;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\Tools\Pagination\Paginator;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Product>
 */
class ProductRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Product::class);
    }

    /**
     * @return Product[]
     */
    public function findAllActive(?string $sort = null): array
    {
        $qb = $this->createQueryBuilder('p')
            ->leftJoin('p.category', 'c')
            ->addSelect('c')
            ->where('p.isActive = :active')
            ->setParameter('active', true);

        match ($sort) {
            'price_asc' => $qb->orderBy('p.priceHT', 'ASC'),
            'price_desc' => $qb->orderBy('p.priceHT', 'DESC'),
            default => $qb->orderBy('p.position', 'ASC'),
        };

        return $qb->getQuery()->getResult();
    }

    /**
     * @return Product[]
     */
    public function findByCategory(ProductCategory $category, ?string $sort = null): array
    {
        $qb = $this->createQueryBuilder('p')
            ->where('p.category = :category')
            ->andWhere('p.isActive = :active')
            ->setParameter('category', $category)
            ->setParameter('active', true);

        match ($sort) {
            'price_asc' => $qb->orderBy('p.priceHT', 'ASC'),
            'price_desc' => $qb->orderBy('p.priceHT', 'DESC'),
            default => $qb->orderBy('p.position', 'ASC'),
        };

        return $qb->getQuery()->getResult();
    }

    /**
     * @return Product[]
     */
    public function findFeatured(int $limit = 6): array
    {
        return $this->createQueryBuilder('p')
            ->leftJoin('p.category', 'c')
            ->addSelect('c')
            ->where('p.isActive = :active')
            ->andWhere('p.isFeatured = :featured')
            ->setParameter('active', true)
            ->setParameter('featured', true)
            ->orderBy('p.position', 'ASC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * @return Product[]
     */
    public function findRelated(Product $product, int $limit = 4): array
    {
        $related = $product->getRelatedProducts();

        if ($related->count() > 0) {
            return $related->slice(0, $limit);
        }

        if ($product->getCategory() === null) {
            return [];
        }

        return $this->createQueryBuilder('p')
            ->where('p.category = :category')
            ->andWhere('p.isActive = :active')
            ->andWhere('p.id != :currentId')
            ->setParameter('category', $product->getCategory())
            ->setParameter('active', true)
            ->setParameter('currentId', $product->getId())
            ->orderBy('p.position', 'ASC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    public function findOneActiveBySlug(string $slug): ?Product
    {
        return $this->createQueryBuilder('p')
            ->leftJoin('p.category', 'c')
            ->addSelect('c')
            ->leftJoin('p.galleryImages', 'gi')
            ->addSelect('gi')
            ->leftJoin('p.variants', 'v')
            ->addSelect('v')
            ->where('p.slug = :slug')
            ->andWhere('p.isActive = :active')
            ->setParameter('slug', $slug)
            ->setParameter('active', true)
            ->getQuery()
            ->getOneOrNullResult();
    }

    /**
     * @return Product[]
     */
    public function findForSitemap(): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.isActive = :active')
            ->andWhere('p.noIndex = :noIndex')
            ->setParameter('active', true)
            ->setParameter('noIndex', false)
            ->orderBy('p.id', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return Product[]
     */
    public function searchByKeyword(string $keyword, int $limit = 20): array
    {
        return $this->createQueryBuilder('p')
            ->leftJoin('p.category', 'c')
            ->addSelect('c')
            ->where('p.isActive = :active')
            ->andWhere('p.title LIKE :keyword OR p.shortDescription LIKE :keyword')
            ->setParameter('active', true)
            ->setParameter('keyword', '%' . $keyword . '%')
            ->orderBy('p.position', 'ASC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }
}
