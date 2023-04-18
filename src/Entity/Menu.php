<?php

namespace App\Entity;

use App\Repository\MenuRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: MenuRepository::class)]
class Menu
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $name = null;

    #[ORM\Column(nullable: true)]
    private ?int $menu_order = null;

    #[ORM\ManyToMany(targetEntity: self::class, inversedBy: 'sub_menu')]
    private Collection $sub_menu;

    #[ORM\Column]
    private ?bool $is_visible = null;

    #[ORM\ManyToOne]
    private ?Article $article = null;

    #[ORM\ManyToOne]
    private ?Categorie $categorie = null;

    #[ORM\ManyToOne]
    private ?Page $page = null;

    public function __construct()
    {
        $this->sub_menu = new ArrayCollection();
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

    public function getMenuOrder(): ?int
    {
        return $this->menu_order;
    }

    public function setMenuOrder(?int $menu_order): self
    {
        $this->menu_order = $menu_order;

        return $this;
    }

    /**
     * @return Collection<int, self>
     */
    public function getSubMenu(): Collection
    {
        return $this->sub_menu;
    }

    public function addSubMenu(self $subMenu): self
    {
        if (!$this->sub_menu->contains($subMenu)) {
            $this->sub_menu->add($subMenu);
        }

        return $this;
    }

    public function removeSubMenu(self $subMenu): self
    {
        $this->sub_menu->removeElement($subMenu);

        return $this;
    }

    public function isIsVisible(): ?bool
    {
        return $this->is_visible;
    }

    public function setIsVisible(bool $is_visible): self
    {
        $this->is_visible = $is_visible;

        return $this;
    }

    public function getArticle(): ?Article
    {
        return $this->article;
    }

    public function setArticle(?Article $article): self
    {
        $this->article = $article;

        return $this;
    }

    public function getCategorie(): ?Categorie
    {
        return $this->categorie;
    }

    public function setCategorie(?Categorie $categorie): self
    {
        $this->categorie = $categorie;

        return $this;
    }

    public function getPage(): ?Page
    {
        return $this->page;
    }

    public function setPage(?Page $page): self
    {
        $this->page = $page;

        return $this;
    }
}
