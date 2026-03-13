<?php

namespace App\Repository;

use App\Entity\Menu;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Menu>
 *
 * @method Menu|null find($id, $lockMode = null, $lockVersion = null)
 * @method Menu|null findOneBy(array $criteria, array $orderBy = null)
 * @method Menu[]    findAll()
 * @method Menu[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class MenuRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Menu::class);
    }

    public function save(Menu $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Menu $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * Root visible menu items with visible children eager-loaded.
     *
     * @return Menu[]
     */
    public function findRootMenuVisible(): array
    {
        return $this->createQueryBuilder('m')
            ->leftJoin('m.children', 'c', 'WITH', 'c.is_visible = true')
            ->addSelect('c')
            ->where('m.is_visible = true')
            ->andWhere('m.parent IS NULL')
            ->orderBy('m.menu_order', 'ASC')
            ->addOrderBy('c.menu_order', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * All root menu items with children, for admin DnD page.
     *
     * @return Menu[]
     */
    public function findAllOrdered(): array
    {
        return $this->createQueryBuilder('m')
            ->leftJoin('m.children', 'c')
            ->addSelect('c')
            ->where('m.parent IS NULL')
            ->orderBy('m.menu_order', 'ASC')
            ->addOrderBy('c.menu_order', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * @return Menu[]
     */
    public function findMenuVisible(): array
    {
        return $this->findRootMenuVisible();
    }

    /**
     * @return Menu[]
     */
    public function findByVisible($visible): array
    {
        return $this->createQueryBuilder('m')
            ->andWhere('m.is_visible = :val')
            ->setParameter('val', $visible)
            ->orderBy('m.menu_order', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
