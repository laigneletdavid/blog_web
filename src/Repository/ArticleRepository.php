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


    /**
     * Articles connexes : meme categorie, sauf l'article courant.
     *
     * @return Article[]
     */
    public function findRelated(Article $article, int $limit = 3): array
    {
        $categories = $article->getCategories();
        if ($categories->isEmpty()) {
            return [];
        }

        return $this->createQueryBuilder('a')
            ->innerJoin('a.categories', 'c')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->andWhere('a.published = TRUE')
            ->andWhere('a.id != :id')
            ->andWhere('c IN (:cats)')
            ->setParameter('id', $article->getId())
            ->setParameter('cats', $categories->toArray())
            ->orderBy('a.created_at', 'DESC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    /**
     * Archives : articles groupes par mois/annee.
     *
     * @return array<array{year: int, month: int, count: int}>
     */
    public function findArchiveMonths(int $limit = 12): array
    {
        $conn = $this->getEntityManager()->getConnection();

        $sql = '
            SELECT YEAR(created_at) AS year, MONTH(created_at) AS month, COUNT(*) AS count
            FROM article
            WHERE published = 1
            GROUP BY year, month
            ORDER BY year DESC, month DESC
            LIMIT ' . (int) $limit . '
        ';

        return $conn->executeQuery($sql)->fetchAllAssociative();
    }

    /**
     * Dernier article featured publie, ou le plus recent si aucun featured.
     */
    public function findFeatured(): ?Article
    {
        $article = $this->createQueryBuilder('a')
            ->andWhere('a.published = TRUE')
            ->andWhere('a.isFeatured = TRUE')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->leftJoin('a.categories', 'c')
            ->addSelect('c')
            ->orderBy('a.created_at', 'DESC')
            ->setMaxResults(1)
            ->getQuery()
            ->getOneOrNullResult();

        if ($article !== null) {
            return $article;
        }

        return $this->createQueryBuilder('a')
            ->andWhere('a.published = TRUE')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->leftJoin('a.categories', 'c')
            ->addSelect('c')
            ->orderBy('a.created_at', 'DESC')
            ->setMaxResults(1)
            ->getQuery()
            ->getOneOrNullResult();
    }

    /**
     * Articles publies avec pagination (Doctrine Paginator).
     * Filtrable par mois/annee et par categorie.
     *
     * @return \Doctrine\ORM\Tools\Pagination\Paginator<Article>
     */
    public function findPublishedPaginated(int $page = 1, int $perPage = 9, ?int $month = null, ?int $year = null, ?string $categorieSlug = null, ?int $excludeId = null): \Doctrine\ORM\Tools\Pagination\Paginator
    {
        $qb = $this->createQueryBuilder('a')
            ->andWhere('a.published = TRUE')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->orderBy('a.created_at', 'DESC')
            ->setFirstResult(($page - 1) * $perPage)
            ->setMaxResults($perPage);

        if ($month !== null && $year !== null) {
            $startDate = new \DateTime(sprintf('%d-%02d-01', $year, $month));
            $endDate = (clone $startDate)->modify('first day of next month');
            $qb->andWhere('a.created_at >= :startDate')
                ->andWhere('a.created_at < :endDate')
                ->setParameter('startDate', $startDate)
                ->setParameter('endDate', $endDate);
        }

        if ($categorieSlug !== null) {
            $qb->innerJoin('a.categories', 'cat')
                ->andWhere('cat.slug = :catSlug')
                ->setParameter('catSlug', $categorieSlug);
        }

        if ($excludeId !== null) {
            $qb->andWhere('a.id != :excludeId')
                ->setParameter('excludeId', $excludeId);
        }

        return new \Doctrine\ORM\Tools\Pagination\Paginator($qb->getQuery());
    }

    /**
     * Articles publies par tag avec pagination.
     *
     * @return \Doctrine\ORM\Tools\Pagination\Paginator<Article>
     */
    public function findPublishedByTag(\App\Entity\Tag $tag, int $page = 1, int $perPage = 9): \Doctrine\ORM\Tools\Pagination\Paginator
    {
        $qb = $this->createQueryBuilder('a')
            ->innerJoin('a.tag', 't')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->andWhere('a.published = TRUE')
            ->andWhere('t = :tag')
            ->setParameter('tag', $tag)
            ->orderBy('a.created_at', 'DESC')
            ->setFirstResult(($page - 1) * $perPage)
            ->setMaxResults($perPage);

        return new \Doctrine\ORM\Tools\Pagination\Paginator($qb->getQuery());
    }

    public function countPublished(): int
    {
        return (int) $this->createQueryBuilder('a')
            ->select('COUNT(a.id)')
            ->where('a.published = TRUE')
            ->getQuery()
            ->getSingleScalarResult();
    }

    /**
     * @return Article[]
     */
    public function findRecentPublished(int $limit = 5): array
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.published = TRUE')
            ->leftJoin('a.featured_media', 'm')
            ->addSelect('m')
            ->orderBy('a.created_at', 'DESC')
            ->setMaxResults($limit)
            ->getQuery()
            ->getResult();
    }

    public function countDrafts(): int
    {
        return (int) $this->createQueryBuilder('a')
            ->select('COUNT(a.id)')
            ->where('a.published = FALSE')
            ->getQuery()
            ->getSingleScalarResult();
    }

    /**
     * @return Article[]
     */
    public function findAllPublishedForSitemap(): array
    {
        return $this->createQueryBuilder('a')
            ->where('a.published = true')
            ->andWhere('a.noIndex = false')
            ->orderBy('a.updated_at', 'DESC')
            ->getQuery()
            ->getResult();
    }
}
