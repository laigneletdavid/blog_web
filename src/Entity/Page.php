<?php

namespace App\Entity;

use App\Entity\Trait\SeoTrait;
use App\Model\TimestampedInterface;
use App\Repository\PageRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: PageRepository::class)]
class Page implements TimestampedInterface, SanitizableContentInterface
{
    use SeoTrait;

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 20, options: ['default' => 'public'])]
    private string $visibility = 'public';

    #[ORM\Column(length: 255)]
    private ?string $title = null;

    #[ORM\Column(type: Types::TEXT)]
    private ?string $content = null;

    #[ORM\Column(length: 255, unique: true)]
    private ?string $slug = null;

    #[ORM\Column]
    private ?bool $published = null;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(onDelete: 'SET NULL')]
    private ?Media $featuredMedia = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE)]
    private ?\DateTimeInterface $createdAt = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE, nullable: true)]
    private ?\DateTimeInterface $updatedAt = null;

    #[ORM\Column(type: Types::JSON, nullable: true)]
    private ?array $blocks = null;

    #[ORM\Column(length: 30, options: ['default' => 'default'])]
    private string $template = 'default';

    #[ORM\Column(options: ['default' => false])]
    private bool $isSystem = false;

    #[ORM\Column(length: 50, nullable: true, unique: true)]
    private ?string $systemKey = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $ctaText = null;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $ctaUrl = null;

    #[ORM\Column(nullable: true, options: ['default' => true])]
    private ?bool $showForm = true;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $formTitle = null;

    #[ORM\ManyToMany(targetEntity: Tag::class, mappedBy: 'page')]
    private Collection $tags;

    public function __construct()
    {
        $this->tags = new ArrayCollection();
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

    public function getContent(): ?string
    {
        return $this->content;
    }

    public function setContent(string $content): self
    {
        $this->content = $content;

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

    public function isPublished(): ?bool
    {
        return $this->published;
    }

    public function setPublished(bool $published): self
    {
        $this->published = $published;

        return $this;
    }

    public function getFeaturedMedia(): ?Media
    {
        return $this->featuredMedia;
    }

    public function setFeaturedMedia(?Media $featuredMedia): self
    {
        $this->featuredMedia = $featuredMedia;

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

    public function getUpdatedAt(): ?\DateTimeInterface
    {
        return $this->updatedAt;
    }

    public function setUpdatedAt(\DateTimeInterface|null $updatedAt): self
    {
        $this->updatedAt = $updatedAt;

        return $this;
    }

    /**
     * @return Collection<int, Tag>
     */
    public function getTags(): Collection
    {
        return $this->tags;
    }

    public function addTag(Tag $tag): self
    {
        if (!$this->tags->contains($tag)) {
            $this->tags->add($tag);
            $tag->addPage($this);
        }

        return $this;
    }

    public function removeTag(Tag $tag): self
    {
        if ($this->tags->removeElement($tag)) {
            $tag->removePage($this);
        }

        return $this;
    }
    public function __toString(): string
    {
        return $this->title;
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


    /**
     * Propriete virtuelle pour le formulaire EasyAdmin.
     * Serialise/deserialise le JSON TipTap pour le champ textarea.
     */
    public function getBlocksJson(): ?string
    {
        if ($this->blocks !== null) {
            return json_encode($this->blocks, JSON_UNESCAPED_UNICODE);
        }

        // Fallback: return HTML content for pages without Tiptap blocks (e.g. legal pages)
        return $this->content;
    }

    public function setBlocksJson(?string $json): self
    {
        $this->blocks = ($json !== null && $json !== '') ? json_decode($json, true) : null;

        return $this;
    }

    public function getTemplate(): string
    {
        return $this->template;
    }

    public function setTemplate(string $template): self
    {
        $this->template = $template;

        return $this;
    }

    public function getVisibility(): string
    {
        return $this->visibility;
    }

    public function setVisibility(string $visibility): self
    {
        $this->visibility = $visibility;

        return $this;
    }

    public function isSystem(): bool
    {
        return $this->isSystem;
    }

    public function setIsSystem(bool $isSystem): self
    {
        $this->isSystem = $isSystem;

        return $this;
    }

    public function getSystemKey(): ?string
    {
        return $this->systemKey;
    }

    public function setSystemKey(?string $systemKey): self
    {
        $this->systemKey = $systemKey;

        return $this;
    }

    public function getCtaText(): ?string
    {
        return $this->ctaText;
    }

    public function setCtaText(?string $ctaText): self
    {
        $this->ctaText = $ctaText;

        return $this;
    }

    public function getCtaUrl(): ?string
    {
        return $this->ctaUrl;
    }

    public function setCtaUrl(?string $ctaUrl): self
    {
        $this->ctaUrl = $ctaUrl;

        return $this;
    }

    public function isShowForm(): ?bool
    {
        return $this->showForm;
    }

    public function setShowForm(?bool $showForm): self
    {
        $this->showForm = $showForm;

        return $this;
    }

    public function getFormTitle(): ?string
    {
        return $this->formTitle;
    }

    public function setFormTitle(?string $formTitle): self
    {
        $this->formTitle = $formTitle;

        return $this;
    }
}
