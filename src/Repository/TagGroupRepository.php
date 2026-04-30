<?php

namespace App\Repository;

use App\Entity\TagGroup;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<TagGroup>
 *
 * @method TagGroup|null find($id, $lockMode = null, $lockVersion = null)
 * @method TagGroup|null findOneBy(array $criteria, array $orderBy = null)
 * @method TagGroup[]    findAll()
 * @method TagGroup[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class TagGroupRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, TagGroup::class);
    }

    public function save(TagGroup $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(TagGroup $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * Toutes les familles, ordonnees par displayOrder puis nom.
     *
     * @return TagGroup[]
     */
    public function findAllOrdered(): array
    {
        return $this->createQueryBuilder('g')
            ->orderBy('g.displayOrder', 'ASC')
            ->addOrderBy('g.name', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Familles ayant au moins un tag attache a une entree d'annuaire active.
     * Sert a generer dynamiquement les filtres front sur /annuaire.
     *
     * @return TagGroup[]
     */
    public function findActiveForDirectory(): array
    {
        return $this->createQueryBuilder('g')
            ->innerJoin('g.tags', 't')
            ->innerJoin('t.directoryEntries', 'd', 'WITH', 'd.isActive = true')
            ->groupBy('g.id')
            ->orderBy('g.displayOrder', 'ASC')
            ->addOrderBy('g.name', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
