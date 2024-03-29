<?php

namespace App\Repository;

use App\Entity\Article;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Article>
 *
 * @method Article|null find($id, $lockMode = null, $lockVersion = null, $published = TRUE)
 * @method Article|null findOneBy(array $criteria, array $orderBy = null)
 * @method Article[]    findAll()
 * @method Article[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class ArticleRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Article::class);
    }

    public function save(Article $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Article $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * @return Article[] Returns an array of All Published Articles
     */
    public function findAllPublished(): array
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.published = TRUE')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->orderBy('a.id', 'ASC')
            ->getQuery()
            ->getResult()
        ;
    }

    /**
     * @return Article[] Returns an array of All Published Articles
     */
    public function lastArticle(): array
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.published = TRUE')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->orderBy('a.id', 'DESC')
            ->setMaxResults(1)
            ->getQuery()
            ->getResult()
            ;
    }

    /**
     * @return Article[] Returns an array of All Published Articles
     */
    public function homeArticles(): array
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.published = TRUE')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->orderBy('a.id', 'ASC')
            ->setMaxResults(2)
            ->getQuery()
            ->getResult()
            ;
    }


//    public function findOneBySomeField($value): ?Article
//    {
//        return $this->createQueryBuilder('a')
//            ->andWhere('a.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
