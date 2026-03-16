<?php

namespace App\Entity;

use App\Repository\SiteGalleryItemRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * Images et contenus visuels associes au theme du site.
 *
 * Slots disponibles :
 *  - gallery    : galerie photos / portfolio / realisations
 *  - logo       : logos clients / partenaires
 *  - testimonial: temoignages (avec title = nom, content = texte)
 */
#[ORM\Entity(repositoryClass: SiteGalleryItemRepository::class)]
#[ORM\Table(name: 'site_gallery_item')]
#[ORM\Index(columns: ['slot'], name: 'idx_gallery_slot')]
class SiteGalleryItem
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Site::class, inversedBy: 'galleryItems')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Site $site = null;

    #[ORM\ManyToOne(targetEntity: Media::class)]
    #[ORM\JoinColumn(nullable: false)]
    private ?Media $media = null;

    #[ORM\Column(length: 30)]
    #[Assert\Choice(choices: ['gallery', 'logo', 'testimonial'])]
    private string $slot = 'gallery';

    #[ORM\Column(type: Types::SMALLINT, options: ['default' => 0])]
    private int $position = 0;

    /** Label : alt text pour gallery/logo, nom pour testimonial */
    #[ORM\Column(length: 255, nullable: true)]
    private ?string $title = null;

    /** Texte complementaire : description ou citation testimonial */
    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $content = null;

    // --- Getters / Setters ---

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getSite(): ?Site
    {
        return $this->site;
    }

    public function setSite(?Site $site): self
    {
        $this->site = $site;

        return $this;
    }

    public function getMedia(): ?Media
    {
        return $this->media;
    }

    public function setMedia(?Media $media): self
    {
        $this->media = $media;

        return $this;
    }

    public function getSlot(): string
    {
        return $this->slot;
    }

    public function setSlot(string $slot): self
    {
        $this->slot = $slot;

        return $this;
    }

    public function getPosition(): int
    {
        return $this->position;
    }

    public function setPosition(int $position): self
    {
        $this->position = $position;

        return $this;
    }

    public function getTitle(): ?string
    {
        return $this->title;
    }

    public function setTitle(?string $title): self
    {
        $this->title = $title;

        return $this;
    }

    public function getContent(): ?string
    {
        return $this->content;
    }

    public function setContent(?string $content): self
    {
        $this->content = $content;

        return $this;
    }

    public function __toString(): string
    {
        return $this->title ?? $this->media?->getName() ?? 'Image #' . $this->id;
    }
}
