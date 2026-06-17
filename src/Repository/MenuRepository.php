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
     * Visible root menu items for a specific location, with children eager-loaded.
     *
     * @return Menu[]
     */
    public function findByLocation(string $location): array
    {
        return $this->createQueryBuilder('m')
            ->leftJoin('m.children', 'c', 'WITH', 'c.isVisible = true')
            ->addSelect('c')
            ->leftJoin('c.children', 'gc', 'WITH', 'gc.isVisible = true')
            ->addSelect('gc')
            ->leftJoin('m.article', 'ma')->addSelect('ma')
            ->leftJoin('m.categorie', 'mc')->addSelect('mc')
            ->leftJoin('m.page', 'mp')->addSelect('mp')
            ->leftJoin('m.service', 'ms')->addSelect('ms')
            ->leftJoin('c.article', 'ca')->addSelect('ca')
            ->leftJoin('c.categorie', 'cc')->addSelect('cc')
            ->leftJoin('c.page', 'cp')->addSelect('cp')
            ->leftJoin('c.service', 'cs')->addSelect('cs')
            ->leftJoin('gc.article', 'ga')->addSelect('ga')
            ->leftJoin('gc.categorie', 'gca')->addSelect('gca')
            ->leftJoin('gc.page', 'gp')->addSelect('gp')
            ->leftJoin('gc.service', 'gs')->addSelect('gs')
            ->where('m.isVisible = true')
            ->andWhere('m.parent IS NULL')
            ->andWhere('m.location = :location')
            ->setParameter('location', $location)
            ->orderBy('m.menuOrder', 'ASC')
            ->addOrderBy('c.menuOrder', 'ASC')
            ->addOrderBy('gc.menuOrder', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Load ALL visible root menu items across all locations in a single query.
     *
     * @return array<string, Menu[]> Indexed by location
     */
    public function findAllLocationsCached(): array
    {
        $menus = $this->createQueryBuilder('m')
            ->leftJoin('m.children', 'c', 'WITH', 'c.isVisible = true')
            ->addSelect('c')
            ->leftJoin('c.children', 'gc', 'WITH', 'gc.isVisible = true')
            ->addSelect('gc')
            ->leftJoin('m.article', 'ma')->addSelect('ma')
            ->leftJoin('m.categorie', 'mc')->addSelect('mc')
            ->leftJoin('m.page', 'mp')->addSelect('mp')
            ->leftJoin('m.service', 'ms')->addSelect('ms')
            ->leftJoin('c.article', 'ca')->addSelect('ca')
            ->leftJoin('c.categorie', 'cc')->addSelect('cc')
            ->leftJoin('c.page', 'cp')->addSelect('cp')
            ->leftJoin('c.service', 'cs')->addSelect('cs')
            ->leftJoin('gc.article', 'ga')->addSelect('ga')
            ->leftJoin('gc.categorie', 'gca')->addSelect('gca')
            ->leftJoin('gc.page', 'gp')->addSelect('gp')
            ->leftJoin('gc.service', 'gs')->addSelect('gs')
            ->where('m.isVisible = true')
            ->andWhere('m.parent IS NULL')
            ->orderBy('m.menuOrder', 'ASC')
            ->addOrderBy('c.menuOrder', 'ASC')
            ->addOrderBy('gc.menuOrder', 'ASC')
            ->getQuery()
            ->getResult();

        $grouped = [];
        foreach ($menus as $menu) {
            $grouped[$menu->getLocation()][] = $menu;
        }

        return $grouped;
    }

    public function findSystemByLocationAndKey(string $location, string $systemKey): ?Menu
    {
        return $this->findOneBy([
            'location' => $location,
            'systemKey' => $systemKey,
        ]);
    }

    /**
     * Root visible menu items with visible children eager-loaded.
     *
     * @return Menu[]
     */
    public function findRootMenuVisible(): array
    {
        return $this->createQueryBuilder('m')
            ->leftJoin('m.children', 'c', 'WITH', 'c.isVisible = true')
            ->addSelect('c')
            ->leftJoin('m.article', 'ma')->addSelect('ma')
            ->leftJoin('m.categorie', 'mc')->addSelect('mc')
            ->leftJoin('m.page', 'mp')->addSelect('mp')
            ->leftJoin('c.article', 'ca')->addSelect('ca')
            ->leftJoin('c.categorie', 'cc')->addSelect('cc')
            ->leftJoin('c.page', 'cp')->addSelect('cp')
            ->where('m.isVisible = true')
            ->andWhere('m.parent IS NULL')
            ->orderBy('m.menuOrder', 'ASC')
            ->addOrderBy('c.menuOrder', 'ASC')
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
            ->orderBy('m.menuOrder', 'ASC')
            ->addOrderBy('c.menuOrder', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * All root menu items (visible AND hidden) for a specific location, for admin menu manager.
     *
     * @return Menu[]
     */
    public function findByLocationAllItems(string $location): array
    {
        return $this->createQueryBuilder('m')
            ->leftJoin('m.children', 'c')
            ->addSelect('c')
            ->leftJoin('c.children', 'gc')
            ->addSelect('gc')
            ->leftJoin('m.article', 'ma')->addSelect('ma')
            ->leftJoin('m.categorie', 'mc')->addSelect('mc')
            ->leftJoin('m.page', 'mp')->addSelect('mp')
            ->leftJoin('m.service', 'ms')->addSelect('ms')
            ->leftJoin('c.article', 'ca')->addSelect('ca')
            ->leftJoin('c.categorie', 'cc')->addSelect('cc')
            ->leftJoin('c.page', 'cp')->addSelect('cp')
            ->leftJoin('c.service', 'cs')->addSelect('cs')
            ->leftJoin('gc.service', 'gs')->addSelect('gs')
            ->where('m.parent IS NULL')
            ->andWhere('m.location = :location')
            ->setParameter('location', $location)
            ->orderBy('m.menuOrder', 'ASC')
            ->addOrderBy('c.menuOrder', 'ASC')
            ->addOrderBy('gc.menuOrder', 'ASC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Get the next menu_order value for a location.
     */
    public function getNextOrder(string $location): int
    {
        $result = $this->createQueryBuilder('m')
            ->select('MAX(m.menuOrder)')
            ->where('m.location = :location')
            ->setParameter('location', $location)
            ->getQuery()
            ->getSingleScalarResult();

        return ($result ?? 0) + 1;
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
            ->andWhere('m.isVisible = :val')
            ->setParameter('val', $visible)
            ->orderBy('m.menuOrder', 'ASC')
            ->getQuery()
            ->getResult();
    }
}
