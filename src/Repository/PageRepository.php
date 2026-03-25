<?php

namespace App\Repository;

use App\Entity\Page;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Page>
 *
 * @method Page|null find($id, $lockMode = null, $lockVersion = null)
 * @method Page|null findOneBy(array $criteria, array $orderBy = null)
 * @method Page[]    findAll()
 * @method Page[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class PageRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Page::class);
    }

    public function save(Page $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Page $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * @return Page[]
     */
    public function findAllPublishedForSitemap(): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.published = true')
            ->andWhere('p.noIndex = false')
            ->andWhere('p.visibility = :public')
            ->setParameter('public', 'public')
            ->orderBy('p.updated_at', 'DESC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return Page[]
     */
    public function findAllPublished(): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.published = true')
            ->orderBy('p.title', 'ASC')
            ->getQuery()
            ->getResult();
    }

    public function findSystemPage(string $systemKey): ?Page
    {
        return $this->findOneBy(['system_key' => $systemKey]);
    }

    /**
     * @return Page[]
     */
    public function findAllSystemPages(): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.is_system = true')
            ->andWhere('p.published = true')
            ->orderBy('p.title', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Published non-system pages (for menu sources panel).
     *
     * @return Page[]
     */
    public function findCustomPages(): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.published = true')
            ->andWhere('p.is_system = false')
            ->orderBy('p.title', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @param string[] $allowedVisibilities
     * @return Page[]
     */
    public function findPublishedByVisibility(array $allowedVisibilities): array
    {
        return $this->createQueryBuilder('p')
            ->where('p.published = true')
            ->andWhere('p.visibility IN (:visibilities)')
            ->setParameter('visibilities', $allowedVisibilities)
            ->orderBy('p.title', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
