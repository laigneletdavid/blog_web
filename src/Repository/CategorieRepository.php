<?php

namespace App\Repository;

use App\Entity\Categorie;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Categorie>
 */
class CategorieRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Categorie::class);
    }

    public function save(Categorie $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Categorie $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * Categories ayant au moins un article publie, avec compteur.
     *
     * @return array<array{categorie: Categorie, articleCount: int}>
     */
    public function findAllWithPublishedArticleCount(): array
    {
        return $this->createQueryBuilder('c')
            ->innerJoin('c.articles', 'a')
            ->addSelect('COUNT(a.id) AS articleCount')
            ->andWhere('a.published = TRUE')
            ->groupBy('c.id')
            ->having('COUNT(a.id) > 0')
            ->orderBy('c.name', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return Categorie[]
     */
    public function findByArticle(int $articleId): array
    {
        return $this->createQueryBuilder('c')
            ->innerJoin('c.articles', 'a')
            ->andWhere('a.id = :articleId')
            ->setParameter('articleId', $articleId)
            ->orderBy('c.id', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
