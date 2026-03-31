<?php

namespace App\Entity;

use App\Repository\ProductImageRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\HttpFoundation\File\UploadedFile;

#[ORM\Entity(repositoryClass: ProductImageRepository::class)]
class ProductImage
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Product::class, inversedBy: 'galleryImages')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Product $product = null;

    #[ORM\ManyToOne(targetEntity: Media::class)]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?Media $media = null;

    /**
     * Champ non persisté pour l'upload direct d'image.
     * Le fichier uploadé est converti en Media dans ProductCrudController.
     */
    private ?UploadedFile $uploadFile = null;

    #[ORM\Column(type: Types::INTEGER, options: ['default' => 0])]
    private int $position = 0;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getProduct(): ?Product
    {
        return $this->product;
    }

    public function setProduct(?Product $product): self
    {
        $this->product = $product;

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

    public function getPosition(): int
    {
        return $this->position;
    }

    public function setPosition(?int $position): self
    {
        $this->position = $position ?? 0;

        return $this;
    }

    public function getUploadFile(): ?UploadedFile
    {
        return $this->uploadFile;
    }

    public function setUploadFile(?UploadedFile $uploadFile): self
    {
        $this->uploadFile = $uploadFile;

        return $this;
    }

    /**
     * Retourne l'URL de l'image (depuis le media lié).
     */
    public function getImageUrl(): ?string
    {
        if ($this->media) {
            return '/documents/medias/' . $this->media->getFileName();
        }

        return null;
    }

    public function __toString(): string
    {
        return $this->media?->getName() ?? 'Image #' . $this->id;
    }
}
