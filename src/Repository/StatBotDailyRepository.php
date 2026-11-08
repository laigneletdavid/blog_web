<?php

namespace App\Repository;

use App\Entity\StatBotDaily;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<StatBotDaily>
 */
class StatBotDailyRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, StatBotDaily::class);
    }

    /**
     * Ajoute une page vue au compteur du jour, en une seule requete.
     */
    public function increment(): void
    {
        $this->getEntityManager()->getConnection()->executeStatement(
            'INSERT INTO stat_bot_daily (day, hits) VALUES (:day, 1)
             ON DUPLICATE KEY UPDATE hits = hits + 1',
            // Date cote PHP, comme created_at des visites : meme fuseau que l'appli
            ['day' => date('Y-m-d')],
        );
    }

    /**
     * @return array<string, int> pages vues par les robots, indexees par date (Y-m-d)
     */
    public function hitsSince(\DateTimeImmutable $since): array
    {
        $rows = $this->getEntityManager()->getConnection()->fetchAllKeyValue(
            'SELECT day, hits FROM stat_bot_daily WHERE day >= :since',
            ['since' => $since->format('Y-m-d')],
        );

        return array_map('intval', $rows);
    }
}
