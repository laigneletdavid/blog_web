<?php

namespace App\Repository;

use App\Entity\Tag;
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
}
