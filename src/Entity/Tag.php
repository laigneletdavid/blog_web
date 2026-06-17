<?php

namespace App\Entity;

use App\Entity\Trait\SeoTrait;
use App\Repository\TagRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: TagRepository::class)]
class Tag
{
    use SeoTrait;

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $name = null;

    #[ORM\Column(length: 255, unique: true)]
    private ?string $slug = null;

    #[ORM\ManyToMany(targetEntity: Article::class, inversedBy: 'tags')]
    private Collection $article;

    #[ORM\ManyToMany(targetEntity: Page::class, inversedBy: 'tags')]
    private Collection $page;

    #[ORM\ManyToMany(targetEntity: Categorie::class, inversedBy: 'tags')]
    private Collection $categorie;

    #[ORM\ManyToMany(targetEntity: Media::class, inversedBy: 'tags')]
    private Collection $media;

    #[ORM\ManyToMany(targetEntity: Product::class, mappedBy: 'tags')]
    private Collection $product;

    #[ORM\ManyToMany(targetEntity: PortfolioItem::class, mappedBy: 'tags')]
    private Collection $portfolioItem;

    #[ORM\ManyToMany(targetEntity: DirectoryEntry::class, mappedBy: 'tags')]
    private Collection $directoryEntries;

    /**
     * Famille de tags (optionnelle). Permet de regrouper les tags
     * pour generer des filtres front dedies (ex: Villes, Metiers).
     * Sans famille, le tag reste "general" (compatible usage blog actuel).
     */
    #[ORM\ManyToOne(targetEntity: TagGroup::class, inversedBy: 'tags')]
    #[ORM\JoinColumn(name: 'tag_group_id', referencedColumnName: 'id', nullable: true, onDelete: 'SET NULL')]
    private ?TagGroup $tagGroup = null;

    public function __construct()
    {
        $this->article = new ArrayCollection();
        $this->page = new ArrayCollection();
        $this->categorie = new ArrayCollection();
        $this->media = new ArrayCollection();
        $this->product = new ArrayCollection();
        $this->portfolioItem = new ArrayCollection();
        $this->directoryEntries = new ArrayCollection();

        // Les tags sont noIndex par defaut (contrairement aux autres entites).
        // Le client choisit lesquels promouvoir en passant noIndex a false.
        $this->noIndex = true;
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

    /**
     * @return Collection<int, Article>
     */
    public function getArticle(): Collection
    {
        return $this->article;
    }

    public function addArticle(Article $article): self
    {
        if (!$this->article->contains($article)) {
            $this->article->add($article);
        }

        return $this;
    }

    public function removeArticle(Article $article): self
    {
        $this->article->removeElement($article);

        return $this;
    }

    /**
     * @return Collection<int, Page>
     */
    public function getPage(): Collection
    {
        return $this->page;
    }

    public function addPage(Page $page): self
    {
        if (!$this->page->contains($page)) {
            $this->page->add($page);
        }

        return $this;
    }

    public function removePage(Page $page): self
    {
        $this->page->removeElement($page);

        return $this;
    }

    /**
     * @return Collection<int, Categorie>
     */
    public function getCategorie(): Collection
    {
        return $this->categorie;
    }

    public function addCategorie(Categorie $categorie): self
    {
        if (!$this->categorie->contains($categorie)) {
            $this->categorie->add($categorie);
        }

        return $this;
    }

    public function removeCategorie(Categorie $categorie): self
    {
        $this->categorie->removeElement($categorie);

        return $this;
    }

    /**
     * @return Collection<int, Media>
     */
    public function getMedia(): Collection
    {
        return $this->media;
    }

    public function addMedium(Media $medium): self
    {
        if (!$this->media->contains($medium)) {
            $this->media->add($medium);
        }

        return $this;
    }

    public function removeMedium(Media $medium): self
    {
        $this->media->removeElement($medium);

        return $this;
    }

    /** @return Collection<int, Product> */
    public function getProduct(): Collection
    {
        return $this->product;
    }

    public function addProduct(Product $product): self
    {
        if (!$this->product->contains($product)) {
            $this->product->add($product);
            $product->addTag($this);
        }

        return $this;
    }

    public function removeProduct(Product $product): self
    {
        if ($this->product->removeElement($product)) {
            $product->removeTag($this);
        }

        return $this;
    }

    /** @return Collection<int, PortfolioItem> */
    public function getPortfolioItem(): Collection
    {
        return $this->portfolioItem;
    }

    public function addPortfolioItem(PortfolioItem $portfolioItem): self
    {
        if (!$this->portfolioItem->contains($portfolioItem)) {
            $this->portfolioItem->add($portfolioItem);
            $portfolioItem->addTag($this);
        }

        return $this;
    }

    public function removePortfolioItem(PortfolioItem $portfolioItem): self
    {
        if ($this->portfolioItem->removeElement($portfolioItem)) {
            $portfolioItem->removeTag($this);
        }

        return $this;
    }

    /** @return Collection<int, DirectoryEntry> */
    public function getDirectoryEntries(): Collection
    {
        return $this->directoryEntries;
    }

    public function addDirectoryEntry(DirectoryEntry $directoryEntry): self
    {
        if (!$this->directoryEntries->contains($directoryEntry)) {
            $this->directoryEntries->add($directoryEntry);
            $directoryEntry->addTag($this);
        }

        return $this;
    }

    public function removeDirectoryEntry(DirectoryEntry $directoryEntry): self
    {
        if ($this->directoryEntries->removeElement($directoryEntry)) {
            $directoryEntry->removeTag($this);
        }

        return $this;
    }

    public function getTagGroup(): ?TagGroup
    {
        return $this->tagGroup;
    }

    public function setTagGroup(?TagGroup $tagGroup): self
    {
        $this->tagGroup = $tagGroup;

        return $this;
    }

    public function __toString(): string
    {
        return $this->name ?? '';
    }
}
