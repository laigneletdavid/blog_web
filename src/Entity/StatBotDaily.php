<?php

namespace App\Entity;

use App\Repository\StatBotDailyRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

/**
 * Pages vues par les robots, comptees par jour. Les robots ne sont plus
 * enregistres visite par visite (voir PageViewSubscriber) : ce compteur
 * suffit a la courbe « Robots » de l'accueil de l'admin.
 */
#[ORM\Entity(repositoryClass: StatBotDailyRepository::class)]
class StatBotDaily
{
    #[ORM\Id]
    #[ORM\Column(type: Types::DATE_IMMUTABLE)]
    private ?\DateTimeImmutable $day = null;

    #[ORM\Column]
    private int $hits = 0;

    public function getDay(): ?\DateTimeImmutable
    {
        return $this->day;
    }

    public function getHits(): int
    {
        return $this->hits;
    }
}
