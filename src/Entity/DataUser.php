<?php

namespace App\Entity;

use App\Repository\DataUserRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: DataUserRepository::class)]
class DataUser
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $name = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $first_name = null;

    #[ORM\Column]
    private ?bool $news = null;

    #[ORM\Column]
    private ?bool $articles = null;

    #[ORM\OneToOne(cascade: ['persist', 'remove'])]
    #[ORM\JoinColumn(nullable: false)]
    private ?user $user = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(?string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getFirstName(): ?string
    {
        return $this->first_name;
    }

    public function setFirstName(?string $first_name): self
    {
        $this->first_name = $first_name;

        return $this;
    }

    public function isNews(): ?bool
    {
        return $this->news;
    }

    public function setNews(bool $news): self
    {
        $this->news = $news;

        return $this;
    }

    public function isArticles(): ?bool
    {
        return $this->articles;
    }

    public function setArticles(bool $articles): self
    {
        $this->articles = $articles;

        return $this;
    }

    public function getUser(): ?user
    {
        return $this->user;
    }

    public function setUser(user $user): self
    {
        $this->user = $user;

        return $this;
    }
}
