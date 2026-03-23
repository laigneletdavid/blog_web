<?php

namespace App\Entity;

use App\Repository\ProductVariantRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: ProductVariantRepository::class)]
class ProductVariant
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne(targetEntity: Product::class, inversedBy: 'variants')]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?Product $product = null;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    private ?string $label = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2, nullable: true)]
    private ?string $priceHT = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2, nullable: true)]
    private ?string $oldPriceHT = null;

    #[ORM\Column(type: Types::INTEGER, options: ['default' => 0])]
    private ?int $position = 0;

    #[ORM\Column(type: Types::BOOLEAN, options: ['default' => true])]
    private bool $isActive = true;

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

    public function getLabel(): ?string
    {
        return $this->label;
    }

    public function setLabel(string $label): self
    {
        $this->label = $label;

        return $this;
    }

    public function getPriceHT(): ?float
    {
        return $this->priceHT !== null ? (float) $this->priceHT : null;
    }

    public function setPriceHT(?string $priceHT): self
    {
        $this->priceHT = $priceHT;

        return $this;
    }

    public function getOldPriceHT(): ?float
    {
        return $this->oldPriceHT !== null ? (float) $this->oldPriceHT : null;
    }

    public function setOldPriceHT(?string $oldPriceHT): self
    {
        $this->oldPriceHT = $oldPriceHT;

        return $this;
    }

    public function getEffectivePriceHT(): ?float
    {
        return $this->getPriceHT() ?? $this->product?->getPriceHT();
    }

    public function getPriceTTC(): ?float
    {
        $ht = $this->getEffectivePriceHT();
        if ($ht === null || $this->product === null) {
            return null;
        }

        return round($ht * (1 + $this->product->getVatRate() / 100), 2);
    }

    public function getOldPriceTTC(): ?float
    {
        if ($this->oldPriceHT === null || $this->product === null) {
            return null;
        }

        return round((float) $this->oldPriceHT * (1 + $this->product->getVatRate() / 100), 2);
    }

    public function isOnSale(): bool
    {
        return $this->oldPriceHT !== null && (float) $this->oldPriceHT > $this->getEffectivePriceHT();
    }

    public function getPosition(): int
    {
        return $this->position ?? 0;
    }

    public function setPosition(?int $position): self
    {
        $this->position = $position ?? 0;

        return $this;
    }

    public function isActive(): bool
    {
        return $this->isActive;
    }

    public function setIsActive(bool $isActive): self
    {
        $this->isActive = $isActive;

        return $this;
    }

    public function __toString(): string
    {
        return $this->label ?? '';
    }
}
