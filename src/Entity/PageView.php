<?php

namespace App\Entity;

use App\Repository\PageViewRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: PageViewRepository::class)]
#[ORM\Index(columns: ['created_at'], name: 'idx_pageview_created_at')]
#[ORM\Index(columns: ['url'], name: 'idx_pageview_url')]
class PageView
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 500)]
    private ?string $url = null;

    #[ORM\Column(length: 64)]
    private ?string $ipHash = null;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $userAgent = null;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $referer = null;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private ?\DateTimeImmutable $createdAt = null;

    public function __construct()
    {
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getUrl(): ?string
    {
        return $this->url;
    }

    public function setUrl(string $url): self
    {
        $this->url = $url;

        return $this;
    }

    public function getIpHash(): ?string
    {
        return $this->ipHash;
    }

    public function setIpHash(string $ipHash): self
    {
        $this->ipHash = $ipHash;

        return $this;
    }

    public function getUserAgent(): ?string
    {
        return $this->userAgent;
    }

    public function setUserAgent(?string $userAgent): self
    {
        $this->userAgent = $userAgent;

        return $this;
    }

    public function getReferer(): ?string
    {
        return $this->referer;
    }

    public function setReferer(?string $referer): self
    {
        $this->referer = $referer;

        return $this;
    }

    public function getCreatedAt(): ?\DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function setCreatedAt(\DateTimeImmutable $createdAt): self
    {
        $this->createdAt = $createdAt;

        return $this;
    }
}
