<?php

namespace App\Repository;

use App\Entity\Subscriber;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Subscriber>
 */
class SubscriberRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Subscriber::class);
    }

    public function save(Subscriber $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Subscriber $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * Abonnes actifs aux articles.
     *
     * @return Subscriber[]
     */
    public function findActiveArticleSubscribers(): array
    {
        return $this->createQueryBuilder('s')
            ->where('s.isActive = true')
            ->andWhere('s.subscribeArticles = true')
            ->getQuery()
            ->getResult();
    }

    /**
     * Abonnes actifs aux evenements.
     *
     * @return Subscriber[]
     */
    public function findActiveEventSubscribers(): array
    {
        return $this->createQueryBuilder('s')
            ->where('s.isActive = true')
            ->andWhere('s.subscribeEvents = true')
            ->getQuery()
            ->getResult();
    }

    public function findByToken(string $token): ?Subscriber
    {
        return $this->findOneBy(['token' => $token]);
    }

    public function findByEmail(string $email): ?Subscriber
    {
        return $this->findOneBy(['email' => $email]);
    }
}
