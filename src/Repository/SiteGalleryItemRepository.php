<?php

namespace App\Repository;

use App\Entity\Site;
use App\Entity\SiteGalleryItem;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<SiteGalleryItem>
 */
class SiteGalleryItemRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, SiteGalleryItem::class);
    }

    /**
     * @return SiteGalleryItem[]
     */
    public function findBySlot(Site $site, string $slot): array
    {
        return $this->createQueryBuilder('g')
            ->andWhere('g.site = :site')
            ->andWhere('g.slot = :slot')
            ->setParameter('site', $site)
            ->setParameter('slot', $slot)
            ->orderBy('g.position', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
