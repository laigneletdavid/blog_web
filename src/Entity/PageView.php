<?php

namespace App\Entity;

use App\Repository\PageViewRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use App\Entity\StatSession;

#[ORM\Entity(repositoryClass: PageViewRepository::class)]
#[ORM\Index(columns: ['created_at'], name: 'idx_pageview_created_at')]
#[ORM\Index(columns: ['url'], name: 'idx_pageview_url')]
#[ORM\Index(columns: ['is_bot'], name: 'idx_pageview_is_bot')]
#[ORM\Index(columns: ['session_id'], name: 'idx_pageview_session')]
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

    #[ORM\Column(options: ['default' => false])]
    private bool $isBot = false;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private ?\DateTimeImmutable $createdAt = null;

    #[ORM\ManyToOne(targetEntity: StatSession::class, inversedBy: 'pageViews')]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?StatSession $session = null;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $previousUrl = null;

    #[ORM\Column(type: Types::SMALLINT, options: ['default' => 1])]
    private int $sequenceNumber = 1;

    #[ORM\Column(type: Types::SMALLINT, nullable: true)]
    private ?int $durationSeconds = null;

    #[ORM\Column(type: Types::SMALLINT, nullable: true)]
    private ?int $scrollMaxPct = null;

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

    public function isBot(): bool
    {
        return $this->isBot;
    }

    public function setIsBot(bool $isBot): self
    {
        $this->isBot = $isBot;

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

    public function getSession(): ?StatSession
    {
        return $this->session;
    }

    public function setSession(?StatSession $session): self
    {
        $this->session = $session;

        return $this;
    }

    public function getPreviousUrl(): ?string
    {
        return $this->previousUrl;
    }

    public function setPreviousUrl(?string $previousUrl): self
    {
        $this->previousUrl = $previousUrl;

        return $this;
    }

    public function getSequenceNumber(): int
    {
        return $this->sequenceNumber;
    }

    public function setSequenceNumber(int $sequenceNumber): self
    {
        $this->sequenceNumber = $sequenceNumber;

        return $this;
    }

    public function getDurationSeconds(): ?int
    {
        return $this->durationSeconds;
    }

    public function setDurationSeconds(?int $durationSeconds): self
    {
        $this->durationSeconds = $durationSeconds;

        return $this;
    }

    public function getScrollMaxPct(): ?int
    {
        return $this->scrollMaxPct;
    }

    public function setScrollMaxPct(?int $scrollMaxPct): self
    {
        $this->scrollMaxPct = $scrollMaxPct;

        return $this;
    }
}
