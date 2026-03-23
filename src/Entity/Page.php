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
class Page implements TimestampedInterface
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
    private ?Media $featured_media = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE)]
    private ?\DateTimeInterface $created_at = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE, nullable: true)]
    private ?\DateTimeInterface $updated_at = null;

    #[ORM\Column(type: Types::JSON, nullable: true)]
    private ?array $blocks = null;

    #[ORM\Column(type: Types::JSON, nullable: true)]
    private ?array $draftBlocks = null;

    #[ORM\Column(length: 30, options: ['default' => 'default'])]
    private string $template = 'default';

    #[ORM\ManyToMany(targetEntity: Tag::class, mappedBy: 'page')]
    private Collection $tag;

    public function __construct()
    {
        $this->tag = new ArrayCollection();
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
        return $this->featured_media;
    }

    public function setFeaturedMedia(?Media $featured_media): self
    {
        $this->featured_media = $featured_media;

        return $this;
    }

    public function getCreatedAt(): ?\DateTimeInterface
    {
        return $this->created_at;
    }

    public function setCreatedAt(\DateTimeInterface $created_at): self
    {
        $this->created_at = $created_at;

        return $this;
    }

    public function getUpdatedAt(): ?\DateTimeInterface
    {
        return $this->updated_at;
    }

    public function setUpdatedAt(\DateTimeInterface|null $updated_at): self
    {
        $this->updated_at = $updated_at;

        return $this;
    }

    /**
     * @return Collection<int, Tag>
     */
    public function getTag(): Collection
    {
        return $this->tag;
    }

    public function addTag(Tag $tag): self
    {
        if (!$this->tag->contains($tag)) {
            $this->tag->add($tag);
            $tag->addPage($this);
        }

        return $this;
    }

    public function removeTag(Tag $tag): self
    {
        if ($this->tag->removeElement($tag)) {
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

    public function getDraftBlocks(): ?array
    {
        return $this->draftBlocks;
    }

    public function setDraftBlocks(?array $draftBlocks): self
    {
        $this->draftBlocks = $draftBlocks;

        return $this;
    }

    /**
     * Propriete virtuelle pour le formulaire EasyAdmin.
     * Serialise/deserialise le JSON TipTap pour le champ textarea.
     */
    public function getBlocksJson(): ?string
    {
        return $this->blocks !== null ? json_encode($this->blocks, JSON_UNESCAPED_UNICODE) : null;
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
}
