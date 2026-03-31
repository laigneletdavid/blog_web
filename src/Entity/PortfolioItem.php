<?php

namespace App\Entity;

use App\Entity\Trait\SeoTrait;
use App\Repository\PortfolioItemRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: PortfolioItemRepository::class)]
#[ORM\Index(columns: ['is_active'], name: 'idx_portfolio_active')]
#[ORM\Index(columns: ['is_featured'], name: 'idx_portfolio_featured')]
class PortfolioItem
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

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $client = null;

    #[ORM\Column(type: Types::DATE_MUTABLE, nullable: true)]
    private ?\DateTimeInterface $projectDate = null;

    #[ORM\Column(length: 255, nullable: true)]
    #[Assert\Url]
    private ?string $projectUrl = null;

    #[ORM\ManyToOne(targetEntity: PortfolioCategory::class, inversedBy: 'items')]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?PortfolioCategory $category = null;

    #[ORM\ManyToOne(targetEntity: Media::class)]
    #[ORM\JoinColumn(onDelete: 'SET NULL')]
    private ?Media $image = null;

    #[ORM\Column(type: Types::JSON, nullable: true)]
    private ?array $gallery = null;

    /** @var Collection<int, Tag> */
    #[ORM\ManyToMany(targetEntity: Tag::class, inversedBy: 'portfolioItem')]
    #[ORM\JoinTable(name: 'portfolio_item_tag')]
    #[ORM\OrderBy(['name' => 'ASC'])]
    private Collection $tags;

    #[ORM\Column(type: Types::INTEGER, options: ['default' => 0])]
    private int $position = 0;

    #[ORM\Column(type: Types::BOOLEAN, options: ['default' => true])]
    private bool $isActive = true;

    #[ORM\Column(type: Types::BOOLEAN, options: ['default' => false])]
    private bool $isFeatured = false;

    public function __construct()
    {
        $this->tags = new ArrayCollection();
    }

    // --- Getters / Setters ---

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

    public function getClient(): ?string
    {
        return $this->client;
    }

    public function setClient(?string $client): self
    {
        $this->client = $client;

        return $this;
    }

    public function getProjectDate(): ?\DateTimeInterface
    {
        return $this->projectDate;
    }

    public function setProjectDate(?\DateTimeInterface $projectDate): self
    {
        $this->projectDate = $projectDate;

        return $this;
    }

    public function getProjectUrl(): ?string
    {
        return $this->projectUrl;
    }

    public function setProjectUrl(?string $projectUrl): self
    {
        $this->projectUrl = $projectUrl;

        return $this;
    }

    public function getCategory(): ?PortfolioCategory
    {
        return $this->category;
    }

    public function setCategory(?PortfolioCategory $category): self
    {
        $this->category = $category;

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

    public function getGallery(): ?array
    {
        return $this->gallery;
    }

    public function setGallery(?array $gallery): self
    {
        $this->gallery = $gallery;

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

    public function getPosition(): int
    {
        return $this->position;
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

    public function isFeatured(): bool
    {
        return $this->isFeatured;
    }

    public function setIsFeatured(bool $isFeatured): self
    {
        $this->isFeatured = $isFeatured;

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
