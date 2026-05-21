<?php

namespace App\Repository;

use App\Entity\Tag;
use App\Entity\TagGroup;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Tag>
 *
 * @method Tag|null find($id, $lockMode = null, $lockVersion = null)
 * @method Tag|null findOneBy(array $criteria, array $orderBy = null)
 * @method Tag[]    findAll()
 * @method Tag[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class TagRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Tag::class);
    }

    public function save(Tag $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Tag $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * @return array<array{0: Tag, articleCount: int}>
     */
    public function findAllWithArticleCount(): array
    {
        // Retourne TOUS les tags avec leur count d'articles publies (0 inclus).
        // Le HAVING > 0 a ete retire pour que la sidebar / le nuage affiche
        // l'ensemble des sujets prevus, meme avant qu'un article soit ecrit.
        // Cote template: cacher le compteur quand articleCount == 0.
        return $this->createQueryBuilder('t')
            ->select('t', 'COUNT(a.id) AS articleCount')
            ->leftJoin('t.article', 'a', 'WITH', 'a.published = true')
            ->groupBy('t.id')
            ->orderBy('t.name', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Tags utilises par au moins une DirectoryEntry active, avec count.
     * Optionnellement filtre par famille de tags.
     *
     * @return array<array{0: Tag, directoryCount: int}>
     */
    public function findCloudForDirectory(?TagGroup $group = null): array
    {
        $qb = $this->createQueryBuilder('t')
            ->select('t', 'COUNT(d.id) AS directoryCount')
            ->innerJoin('t.directoryEntries', 'd', 'WITH', 'd.isActive = true')
            ->groupBy('t.id')
            ->orderBy('t.name', 'ASC');

        if ($group !== null) {
            $qb->andWhere('t.tagGroup = :group')
                ->setParameter('group', $group);
        }

        return $qb->getQuery()->getResult();
    }

    /**
     * Tags d'une famille avec count d'articles publies (pour widget filtre par famille).
     *
     * @return array<array{0: Tag, articleCount: int}>
     */
    public function findCloudByGroupForArticles(TagGroup $group): array
    {
        return $this->createQueryBuilder('t')
            ->select('t', 'COUNT(a.id) AS articleCount')
            ->leftJoin('t.article', 'a', 'WITH', 'a.published = true')
            ->where('t.tagGroup = :group')
            ->setParameter('group', $group)
            ->groupBy('t.id')
            ->orderBy('t.name', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Tags indexables pour le sitemap : exclut noIndex et les tags sans contenu publie.
     *
     * @return Tag[]
     */
    public function findAllForSitemap(): array
    {
        return $this->createQueryBuilder('t')
            ->innerJoin('t.article', 'a', 'WITH', 'a.published = true')
            ->andWhere('t.noIndex = false')
            ->groupBy('t.id')
            ->orderBy('t.name', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Compteurs cross-modules pour un tag donne. Sert a la page /tag/{slug}
     * pour afficher des sections "Articles", "Annuaire", "Produits", etc.
     *
     * @return array{articles: int, directory: int, products: int, portfolio: int}
     */
    public function getMultiSourceCounts(Tag $tag): array
    {
        $em = $this->getEntityManager();

        $articles = (int) $em->createQuery(
            'SELECT COUNT(a.id) FROM App\\Entity\\Article a JOIN a.tag t WHERE t = :tag AND a.published = true'
        )->setParameter('tag', $tag)->getSingleScalarResult();

        $directory = (int) $em->createQuery(
            'SELECT COUNT(d.id) FROM App\\Entity\\DirectoryEntry d JOIN d.tags t WHERE t = :tag AND d.isActive = true'
        )->setParameter('tag', $tag)->getSingleScalarResult();

        $products = (int) $em->createQuery(
            'SELECT COUNT(p.id) FROM App\\Entity\\Product p JOIN p.tags t WHERE t = :tag'
        )->setParameter('tag', $tag)->getSingleScalarResult();

        $portfolio = (int) $em->createQuery(
            'SELECT COUNT(pi.id) FROM App\\Entity\\PortfolioItem pi JOIN pi.tags t WHERE t = :tag'
        )->setParameter('tag', $tag)->getSingleScalarResult();

        return [
            'articles' => $articles,
            'directory' => $directory,
            'products' => $products,
            'portfolio' => $portfolio,
        ];
    }
}
