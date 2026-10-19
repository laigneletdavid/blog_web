<?php

namespace App\Repository;

use App\Entity\Service;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Service>
 */
class ServiceRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Service::class);
    }

    /**
     * @return Service[]
     */
    public function findAllActive(): array
    {
        return $this->createQueryBuilder('s')
            ->where('s.isActive = :active')
            ->setParameter('active', true)
            ->orderBy('s.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Services actifs ouvrant une branche, c'est-a-dire sans parent.
     *
     * C'est ce qu'attendent l'accueil et la page d'index : les poles, pas le
     * detail de chaque prestation. Sur un site dont l'offre est a plat, aucun
     * service n'a de parent et le resultat est celui de findAllActive().
     *
     * @return Service[]
     */
    public function findRootsActive(): array
    {
        return $this->createQueryBuilder('s')
            ->where('s.isActive = :active')
            ->andWhere('s.parent IS NULL')
            ->setParameter('active', true)
            ->orderBy('s.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Services actifs et indexables pour le sitemap.
     *
     * @return Service[]
     */
    public function findAllActiveForSitemap(): array
    {
        return $this->createQueryBuilder('s')
            ->where('s.isActive = true')
            ->andWhere('s.noIndex = false')
            ->orderBy('s.position', 'ASC')
            ->getQuery()
            ->getResult();
    }

    public function findOneActiveBySlug(string $slug): ?Service
    {
        return $this->createQueryBuilder('s')
            ->where('s.slug = :slug')
            ->andWhere('s.isActive = :active')
            ->setParameter('slug', $slug)
            ->setParameter('active', true)
            ->getQuery()
            ->getOneOrNullResult();
    }
}
