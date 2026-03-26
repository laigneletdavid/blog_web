<?php

namespace App\Repository;

use App\Entity\Faq;
use App\Entity\FaqCategory;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Faq>
 */
class FaqRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Faq::class);
    }

    /**
     * @return Faq[]
     */
    public function findAllActive(): array
    {
        return $this->createQueryBuilder('f')
            ->where('f.isActive = :active')
            ->setParameter('active', true)
            ->orderBy('f.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return Faq[]
     */
    public function findActiveByCategory(FaqCategory $category): array
    {
        return $this->createQueryBuilder('f')
            ->where('f.isActive = :active')
            ->andWhere('f.category = :category')
            ->setParameter('active', true)
            ->setParameter('category', $category)
            ->orderBy('f.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return array<array{category: FaqCategory|null, faqs: Faq[]}>
     */
    public function findAllActiveGroupedByCategory(): array
    {
        $faqs = $this->createQueryBuilder('f')
            ->leftJoin('f.category', 'c')
            ->addSelect('c')
            ->where('f.isActive = :active')
            ->setParameter('active', true)
            ->addOrderBy('c.position', 'ASC')
            ->addOrderBy('f.position', 'ASC')
            ->getQuery()
            ->getResult();

        $grouped = [];
        foreach ($faqs as $faq) {
            $catId = $faq->getCategory()?->getId() ?? 0;
            if (!isset($grouped[$catId])) {
                $grouped[$catId] = [
                    'category' => $faq->getCategory(),
                    'faqs' => [],
                ];
            }
            $grouped[$catId]['faqs'][] = $faq;
        }

        return array_values($grouped);
    }

    public function findOneActiveBySlug(string $slug): ?Faq
    {
        return $this->createQueryBuilder('f')
            ->where('f.slug = :slug')
            ->andWhere('f.isActive = :active')
            ->setParameter('slug', $slug)
            ->setParameter('active', true)
            ->getQuery()
            ->getOneOrNullResult();
    }
}
