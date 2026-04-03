<?php

namespace App\Repository;

use App\Entity\DirectoryCategory;
use App\Entity\DirectoryEntry;
use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<DirectoryEntry>
 */
class DirectoryEntryRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, DirectoryEntry::class);
    }

    /** @return DirectoryEntry[] */
    public function findAllActive(): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->setParameter('active', true)
            ->orderBy('e.lastName', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /** @return DirectoryEntry[] */
    public function findActiveByCategory(DirectoryCategory $category): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.category = :category')
            ->setParameter('active', true)
            ->setParameter('category', $category)
            ->orderBy('e.lastName', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /** @return DirectoryEntry[] */
    public function searchActive(string $query): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.lastName LIKE :q OR e.firstName LIKE :q OR e.company LIKE :q OR e.jobTitle LIKE :q OR e.city LIKE :q')
            ->setParameter('active', true)
            ->setParameter('q', '%' . $query . '%')
            ->orderBy('e.lastName', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /** @return DirectoryEntry[] */
    public function findFeatured(int $limit = 6): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.isFeatured = :featured')
            ->setParameter('active', true)
            ->setParameter('featured', true)
            ->orderBy('e.lastName', 'ASC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    public function findOneActiveBySlug(string $slug): ?DirectoryEntry
    {
        return $this->createQueryBuilder('e')
            ->where('e.slug = :slug')
            ->andWhere('e.isActive = :active')
            ->setParameter('slug', $slug)
            ->setParameter('active', true)
            ->getQuery()
            ->getOneOrNullResult();
    }

    public function findByUser(User $user): ?DirectoryEntry
    {
        return $this->findOneBy(['user' => $user]);
    }

    /** @return DirectoryEntry[] */
    public function findAllActiveForSitemap(): array
    {
        return $this->createQueryBuilder('e')
            ->where('e.isActive = :active')
            ->andWhere('e.noIndex = :noIndex')
            ->setParameter('active', true)
            ->setParameter('noIndex', false)
            ->orderBy('e.lastName', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
