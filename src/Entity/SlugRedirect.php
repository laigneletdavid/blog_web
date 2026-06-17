<?php

namespace App\Entity;

use App\Repository\SlugRedirectRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: SlugRedirectRepository::class)]
#[ORM\Index(columns: ['entity_type', 'old_slug'], name: 'idx_slug_redirect_lookup')]
class SlugRedirect
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 50)]
    private ?string $entityType = null;

    #[ORM\Column(length: 255)]
    private ?string $oldSlug = null;

    #[ORM\Column(length: 255)]
    private ?string $newSlug = null;

    #[ORM\Column(type: 'datetime')]
    private ?\DateTimeInterface $createdAt = null;

    public function __construct()
    {
        $this->createdAt = new \DateTime();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getEntityType(): ?string
    {
        return $this->entityType;
    }

    public function setEntityType(string $entityType): self
    {
        $this->entityType = $entityType;

        return $this;
    }

    public function getOldSlug(): ?string
    {
        return $this->oldSlug;
    }

    public function setOldSlug(string $oldSlug): self
    {
        $this->oldSlug = $oldSlug;

        return $this;
    }

    public function getNewSlug(): ?string
    {
        return $this->newSlug;
    }

    public function setNewSlug(string $newSlug): self
    {
        $this->newSlug = $newSlug;

        return $this;
    }

    public function getCreatedAt(): ?\DateTimeInterface
    {
        return $this->createdAt;
    }

    public function setCreatedAt(\DateTimeInterface $createdAt): self
    {
        $this->createdAt = $createdAt;

        return $this;
    }
}
