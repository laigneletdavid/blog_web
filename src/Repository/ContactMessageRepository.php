<?php

namespace App\Repository;

use App\Entity\ContactMessage;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<ContactMessage>
 */
class ContactMessageRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, ContactMessage::class);
    }

    public function countUnread(): int
    {
        return (int) $this->createQueryBuilder('cm')
            ->select('COUNT(cm.id)')
            ->where('cm.isRead = false')
            ->getQuery()
            ->getSingleScalarResult();
    }
}
