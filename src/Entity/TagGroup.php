<?php

namespace App\Entity;

use App\Repository\TagGroupRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * Famille de tags. Permet de regrouper des tags par theme (Villes, Metiers, Niveaux...)
 * pour generer automatiquement des filtres front dedies sur l'annuaire, le catalogue, etc.
 *
 * Le rattachement d'un tag a une famille reste optionnel : un tag sans famille
 * (tagGroup = null) garde le comportement historique (usage blog/sujets).
 */
#[ORM\Entity(repositoryClass: TagGroupRepository::class)]
class TagGroup
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    private ?string $name = null;

    #[ORM\Column(length: 255, unique: true)]
    private ?string $slug = null;

    /**
     * Couleur du badge (hex). Sert a differencier visuellement les familles
     * dans les nuages de tags et les filtres front.
     */
    #[ORM\Column(length: 7, options: ['default' => '#6c757d'])]
    private string $color = '#6c757d';

    /**
     * Ordre d'affichage des familles dans les filtres front. Plus petit = plus haut.
     */
    #[ORM\Column(type: Types::INTEGER, options: ['default' => 0])]
    private int $displayOrder = 0;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $description = null;

    /** @var Collection<int, Tag> */
    #[ORM\OneToMany(targetEntity: Tag::class, mappedBy: 'tagGroup')]
    #[ORM\OrderBy(['name' => 'ASC'])]
    private Collection $tags;

    public function __construct()
    {
        $this->tags = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getSlug(): ?string
    {
        return $this->slug;
    }

    public function setSlug(string $slug): self
    {
        $this->slug = $slug;

        return $this;
    }

    public function getColor(): string
    {
        return $this->color;
    }

    public function setColor(?string $color): self
    {
        $this->color = $color ?: '#6c757d';

        return $this;
    }

    public function getDisplayOrder(): int
    {
        return $this->displayOrder;
    }

    public function setDisplayOrder(?int $displayOrder): self
    {
        $this->displayOrder = $displayOrder ?? 0;

        return $this;
    }

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): self
    {
        $this->description = $description;

        return $this;
    }

    /** @return Collection<int, Tag> */
    public function getTags(): Collection
    {
        return $this->tags;
    }

    public function __toString(): string
    {
        return $this->name ?? '';
    }
}
