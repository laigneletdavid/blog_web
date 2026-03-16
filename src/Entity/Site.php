<?php

namespace App\Entity;

use App\Repository\SiteRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: SiteRepository::class)]
class Site
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $name = null;

    #[ORM\Column(length: 255)]
    private ?string $title = null;

    #[ORM\OneToOne(cascade: ['persist', 'remove'])]
    private ?Media $logo = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $email = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $town = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $post_code = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $adress_1 = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $adress_2 = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $google_maps = null;

    #[ORM\Column(length: 10, nullable: true)]
    private ?string $phone = null;

    // --- SEO ---

    #[ORM\Column(length: 70, nullable: true)]
    #[Assert\Length(max: 70)]
    private ?string $defaultSeoTitle = null;

    #[ORM\Column(length: 160, nullable: true)]
    #[Assert\Length(max: 160)]
    private ?string $defaultSeoDescription = null;

    #[ORM\Column(length: 20, nullable: true)]
    private ?string $googleAnalyticsId = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $googleSearchConsole = null;

    #[ORM\ManyToOne(targetEntity: Media::class)]
    private ?Media $favicon = null;

    // --- Apparence ---

    #[ORM\Column(length: 7, nullable: true)]
    private ?string $primaryColor = null;

    #[ORM\Column(length: 7, nullable: true)]
    private ?string $secondaryColor = null;

    #[ORM\Column(length: 7, nullable: true)]
    private ?string $accentColor = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $fontFamily = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $fontFamilySecondary = null;

    #[ORM\Column(length: 20, options: ['default' => 'default'])]
    private string $template = 'default';

    // --- Images du theme ---

    #[ORM\ManyToOne(targetEntity: Media::class)]
    private ?Media $heroImage = null;

    #[ORM\ManyToOne(targetEntity: Media::class)]
    private ?Media $aboutImage = null;

    /** @var Collection<int, SiteGalleryItem> */
    #[ORM\OneToMany(targetEntity: SiteGalleryItem::class, mappedBy: 'site', cascade: ['persist', 'remove'], orphanRemoval: true)]
    #[ORM\OrderBy(['position' => 'ASC'])]
    private Collection $galleryItems;

    // --- Proprietaire (Freelance) ---

    #[ORM\ManyToOne(targetEntity: User::class)]
    private ?User $owner = null;

    public function __construct()
    {
        $this->galleryItems = new ArrayCollection();
    }

    // --- Getters / Setters ---

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

    public function getTitle(): ?string
    {
        return $this->title;
    }

    public function setTitle(string $title): self
    {
        $this->title = $title;

        return $this;
    }

    public function getLogo(): ?Media
    {
        return $this->logo;
    }

    public function setLogo(?Media $logo): self
    {
        $this->logo = $logo;

        return $this;
    }

    public function getEmail(): ?string
    {
        return $this->email;
    }

    public function setEmail(?string $email): self
    {
        $this->email = $email;

        return $this;
    }

    public function getTown(): ?string
    {
        return $this->town;
    }

    public function setTown(?string $town): self
    {
        $this->town = $town;

        return $this;
    }

    public function getPostCode(): ?string
    {
        return $this->post_code;
    }

    public function setPostCode(?string $post_code): self
    {
        $this->post_code = $post_code;

        return $this;
    }

    public function getAdress1(): ?string
    {
        return $this->adress_1;
    }

    public function setAdress1(?string $adress_1): self
    {
        $this->adress_1 = $adress_1;

        return $this;
    }

    public function getAdress2(): ?string
    {
        return $this->adress_2;
    }

    public function setAdress2(?string $adress_2): self
    {
        $this->adress_2 = $adress_2;

        return $this;
    }

    public function getGoogleMaps(): ?string
    {
        return $this->google_maps;
    }

    public function setGoogleMaps(?string $google_maps): self
    {
        $this->google_maps = $google_maps;

        return $this;
    }

    public function getPhone(): ?string
    {
        return $this->phone;
    }

    public function setPhone(?string $phone): self
    {
        $this->phone = $phone;

        return $this;
    }

    // --- SEO Getters/Setters ---

    public function getDefaultSeoTitle(): ?string
    {
        return $this->defaultSeoTitle;
    }

    public function setDefaultSeoTitle(?string $defaultSeoTitle): self
    {
        $this->defaultSeoTitle = $defaultSeoTitle;

        return $this;
    }

    public function getDefaultSeoDescription(): ?string
    {
        return $this->defaultSeoDescription;
    }

    public function setDefaultSeoDescription(?string $defaultSeoDescription): self
    {
        $this->defaultSeoDescription = $defaultSeoDescription;

        return $this;
    }

    public function getGoogleAnalyticsId(): ?string
    {
        return $this->googleAnalyticsId;
    }

    public function setGoogleAnalyticsId(?string $googleAnalyticsId): self
    {
        $this->googleAnalyticsId = $googleAnalyticsId;

        return $this;
    }

    public function getGoogleSearchConsole(): ?string
    {
        return $this->googleSearchConsole;
    }

    public function setGoogleSearchConsole(?string $googleSearchConsole): self
    {
        $this->googleSearchConsole = $googleSearchConsole;

        return $this;
    }

    public function getFavicon(): ?Media
    {
        return $this->favicon;
    }

    public function setFavicon(?Media $favicon): self
    {
        $this->favicon = $favicon;

        return $this;
    }

    // --- Apparence Getters/Setters ---

    public function getPrimaryColor(): ?string
    {
        return $this->primaryColor;
    }

    public function setPrimaryColor(?string $primaryColor): self
    {
        $this->primaryColor = $primaryColor;

        return $this;
    }

    public function getSecondaryColor(): ?string
    {
        return $this->secondaryColor;
    }

    public function setSecondaryColor(?string $secondaryColor): self
    {
        $this->secondaryColor = $secondaryColor;

        return $this;
    }

    public function getAccentColor(): ?string
    {
        return $this->accentColor;
    }

    public function setAccentColor(?string $accentColor): self
    {
        $this->accentColor = $accentColor;

        return $this;
    }

    public function getFontFamily(): ?string
    {
        return $this->fontFamily;
    }

    public function setFontFamily(?string $fontFamily): self
    {
        $this->fontFamily = $fontFamily;

        return $this;
    }

    public function getFontFamilySecondary(): ?string
    {
        return $this->fontFamilySecondary;
    }

    public function setFontFamilySecondary(?string $fontFamilySecondary): self
    {
        $this->fontFamilySecondary = $fontFamilySecondary;

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

    // --- Theme Images Getters/Setters ---

    public function getHeroImage(): ?Media
    {
        return $this->heroImage;
    }

    public function setHeroImage(?Media $heroImage): self
    {
        $this->heroImage = $heroImage;

        return $this;
    }

    public function getAboutImage(): ?Media
    {
        return $this->aboutImage;
    }

    public function setAboutImage(?Media $aboutImage): self
    {
        $this->aboutImage = $aboutImage;

        return $this;
    }

    /** @return Collection<int, SiteGalleryItem> */
    public function getGalleryItems(): Collection
    {
        return $this->galleryItems;
    }

    public function addGalleryItem(SiteGalleryItem $item): self
    {
        if (!$this->galleryItems->contains($item)) {
            $this->galleryItems->add($item);
            $item->setSite($this);
        }

        return $this;
    }

    public function removeGalleryItem(SiteGalleryItem $item): self
    {
        if ($this->galleryItems->removeElement($item)) {
            if ($item->getSite() === $this) {
                $item->setSite(null);
            }
        }

        return $this;
    }

    /**
     * Helper: get gallery items filtered by slot.
     *
     * @return Collection<int, SiteGalleryItem>
     */
    public function getGalleryBySlot(string $slot): Collection
    {
        return $this->galleryItems->filter(
            fn (SiteGalleryItem $item) => $item->getSlot() === $slot
        );
    }

    // --- Owner Getters/Setters ---

    public function getOwner(): ?User
    {
        return $this->owner;
    }

    public function setOwner(?User $owner): self
    {
        $this->owner = $owner;

        return $this;
    }
}
