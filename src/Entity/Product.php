<?php

namespace App\Entity;

use App\Entity\Trait\SeoTrait;
use App\Enum\AvailabilityEnum;
use App\Repository\ProductRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: ProductRepository::class)]
#[ORM\Index(columns: ['is_active'], name: 'idx_product_active')]
#[ORM\Index(columns: ['is_featured'], name: 'idx_product_featured')]
#[ORM\Index(columns: ['availability'], name: 'idx_product_availability')]
class Product
{
    use SeoTrait;

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    private ?string $title = null;

    #[ORM\Column(length: 255, unique: true)]
    private ?string $slug = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $shortDescription = null;

    #[ORM\Column(type: Types::JSON, nullable: true)]
    private ?array $blocks = null;

    #[ORM\Column(type: Types::TEXT)]
    private string $content = '';

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2, nullable: true)]
    private ?string $priceHT = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2, nullable: true)]
    private ?string $oldPriceHT = null;

    #[ORM\Column(type: Types::DECIMAL, precision: 4, scale: 2, options: ['default' => '20.00'])]
    private string $vatRate = '20.00';

    #[ORM\Column(length: 20, enumType: AvailabilityEnum::class, options: ['default' => 'available'])]
    private AvailabilityEnum $availability = AvailabilityEnum::AVAILABLE;

    #[ORM\ManyToOne(targetEntity: ProductCategory::class, inversedBy: 'products')]
    private ?ProductCategory $category = null;

    #[ORM\ManyToMany(targetEntity: Tag::class, inversedBy: 'product')]
    #[ORM\JoinTable(name: 'product_tag')]
    private Collection $tags;

    #[ORM\ManyToOne(targetEntity: Media::class)]
    private ?Media $image = null;

    /** @var Collection<int, ProductImage> */
    #[ORM\OneToMany(targetEntity: ProductImage::class, mappedBy: 'product', cascade: ['persist', 'remove'], orphanRemoval: true)]
    #[ORM\OrderBy(['position' => 'ASC'])]
    private Collection $galleryImages;

    /** @var Collection<int, ProductVariant> */
    #[ORM\OneToMany(targetEntity: ProductVariant::class, mappedBy: 'product', cascade: ['persist', 'remove'], orphanRemoval: true)]
    #[ORM\OrderBy(['position' => 'ASC'])]
    private Collection $variants;

    #[ORM\ManyToMany(targetEntity: Product::class)]
    #[ORM\JoinTable(name: 'product_related')]
    private Collection $relatedProducts;

    #[ORM\Column(length: 255, nullable: true)]
    #[Assert\Url]
    private ?string $bookingUrl = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $bookingLabel = null;

    #[ORM\Column(type: Types::BOOLEAN, options: ['default' => true])]
    private bool $isActive = true;

    #[ORM\Column(type: Types::BOOLEAN, options: ['default' => false])]
    private bool $isFeatured = false;

    #[ORM\Column(type: Types::INTEGER, options: ['default' => 0])]
    private ?int $position = 0;

    public function __construct()
    {
        $this->tags = new ArrayCollection();
        $this->galleryImages = new ArrayCollection();
        $this->variants = new ArrayCollection();
        $this->relatedProducts = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getTitle(): ?string
    {
        return $this->title;
    }

    public function setTitle(string $title): self
    {
        $this->title = $title;

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

    public function getShortDescription(): ?string
    {
        return $this->shortDescription;
    }

    public function setShortDescription(?string $shortDescription): self
    {
        $this->shortDescription = $shortDescription;

        return $this;
    }

    public function getBlocks(): ?array
    {
        return $this->blocks;
    }

    public function setBlocks(?array $blocks): self
    {
        $this->blocks = $blocks;

        return $this;
    }

    public function getContent(): string
    {
        return $this->content;
    }

    public function setContent(string $content): self
    {
        $this->content = $content;

        return $this;
    }

    // --- Prix ---

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

    public function getVatRate(): float
    {
        return (float) $this->vatRate;
    }

    public function setVatRate(string $vatRate): self
    {
        $this->vatRate = $vatRate;

        return $this;
    }

    public function getPriceTTC(): ?float
    {
        if ($this->priceHT === null) {
            return null;
        }

        return round((float) $this->priceHT * (1 + (float) $this->vatRate / 100), 2);
    }

    public function getOldPriceTTC(): ?float
    {
        if ($this->oldPriceHT === null) {
            return null;
        }

        return round((float) $this->oldPriceHT * (1 + (float) $this->vatRate / 100), 2);
    }

    public function getVatAmount(): ?float
    {
        if ($this->priceHT === null) {
            return null;
        }

        return round($this->getPriceTTC() - (float) $this->priceHT, 2);
    }

    public function isOnSale(): bool
    {
        return $this->oldPriceHT !== null && (float) $this->oldPriceHT > (float) $this->priceHT;
    }

    public function isOnRequest(): bool
    {
        return $this->availability === AvailabilityEnum::ON_REQUEST;
    }

    // --- Disponibilité ---

    public function getAvailability(): AvailabilityEnum
    {
        return $this->availability;
    }

    public function setAvailability(AvailabilityEnum $availability): self
    {
        $this->availability = $availability;

        return $this;
    }

    // --- Relations ---

    public function getCategory(): ?ProductCategory
    {
        return $this->category;
    }

    public function setCategory(?ProductCategory $category): self
    {
        $this->category = $category;

        return $this;
    }

    /** @return Collection<int, Tag> */
    public function getTags(): Collection
    {
        return $this->tags;
    }

    public function addTag(Tag $tag): self
    {
        if (!$this->tags->contains($tag)) {
            $this->tags->add($tag);
        }

        return $this;
    }

    public function removeTag(Tag $tag): self
    {
        $this->tags->removeElement($tag);

        return $this;
    }

    public function getImage(): ?Media
    {
        return $this->image;
    }

    public function setImage(?Media $image): self
    {
        $this->image = $image;

        return $this;
    }

    /** @return Collection<int, ProductImage> */
    public function getGalleryImages(): Collection
    {
        return $this->galleryImages;
    }

    public function addGalleryImage(ProductImage $galleryImage): self
    {
        if (!$this->galleryImages->contains($galleryImage)) {
            $this->galleryImages->add($galleryImage);
            $galleryImage->setProduct($this);
        }

        return $this;
    }

    public function removeGalleryImage(ProductImage $galleryImage): self
    {
        if ($this->galleryImages->removeElement($galleryImage)) {
            if ($galleryImage->getProduct() === $this) {
                $galleryImage->setProduct(null);
            }
        }

        return $this;
    }

    /** @return Collection<int, ProductVariant> */
    public function getVariants(): Collection
    {
        return $this->variants;
    }

    public function addVariant(ProductVariant $variant): self
    {
        if (!$this->variants->contains($variant)) {
            $this->variants->add($variant);
            $variant->setProduct($this);
        }

        return $this;
    }

    public function removeVariant(ProductVariant $variant): self
    {
        if ($this->variants->removeElement($variant)) {
            if ($variant->getProduct() === $this) {
                $variant->setProduct(null);
            }
        }

        return $this;
    }

    /** @return Collection<int, Product> */
    public function getRelatedProducts(): Collection
    {
        return $this->relatedProducts;
    }

    public function addRelatedProduct(Product $product): self
    {
        if (!$this->relatedProducts->contains($product)) {
            $this->relatedProducts->add($product);
        }

        return $this;
    }

    public function removeRelatedProduct(Product $product): self
    {
        $this->relatedProducts->removeElement($product);

        return $this;
    }

    // --- Booking ---

    public function getBookingUrl(): ?string
    {
        return $this->bookingUrl;
    }

    public function setBookingUrl(?string $bookingUrl): self
    {
        $this->bookingUrl = $bookingUrl;

        return $this;
    }

    public function getBookingLabel(): ?string
    {
        return $this->bookingLabel;
    }

    public function setBookingLabel(?string $bookingLabel): self
    {
        $this->bookingLabel = $bookingLabel;

        return $this;
    }

    // --- Flags ---

    public function isActive(): bool
    {
        return $this->isActive;
    }

    public function setIsActive(bool $isActive): self
    {
        $this->isActive = $isActive;

        return $this;
    }

    public function isFeatured(): bool
    {
        return $this->isFeatured;
    }

    public function setIsFeatured(bool $isFeatured): self
    {
        $this->isFeatured = $isFeatured;

        return $this;
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

    // --- Virtual properties pour TipTap ---

    public function getBlocksJson(): ?string
    {
        return $this->blocks !== null ? json_encode($this->blocks, JSON_UNESCAPED_UNICODE) : null;
    }

    public function setBlocksJson(?string $json): self
    {
        $this->blocks = ($json !== null && $json !== '') ? json_decode($json, true) : null;

        return $this;
    }

    public function __toString(): string
    {
        return $this->title ?? '';
    }
}
