<?php

namespace App\Entity;

use App\Repository\SiteRepository;
use Doctrine\ORM\Mapping as ORM;

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

    #[ORM\Column(nullable: true)]
    private ?int $phone = null;

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

    public function getPhone(): ?int
    {
        return $this->phone;
    }

    public function setPhone(?int $phone): self
    {
        $this->phone = $phone;

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
}
