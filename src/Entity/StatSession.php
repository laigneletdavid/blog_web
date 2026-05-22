<?php

namespace App\Entity;

use App\Repository\StatSessionRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: StatSessionRepository::class)]
#[ORM\Index(columns: ['started_at'], name: 'idx_session_started')]
#[ORM\Index(columns: ['source'], name: 'idx_session_source')]
#[ORM\Index(columns: ['session_token'], name: 'idx_session_token')]
#[ORM\Index(columns: ['is_bot'], name: 'idx_session_bot')]
class StatSession
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 64, unique: true)]
    private ?string $sessionToken = null;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private ?\DateTimeImmutable $startedAt = null;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private ?\DateTimeImmutable $endedAt = null;

    #[ORM\Column(length: 30)]
    private ?string $source = null;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $sourceDetail = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $utmCampaign = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $utmMedium = null;

    #[ORM\Column(length: 500)]
    private ?string $landingPage = null;

    #[ORM\Column(length: 500)]
    private ?string $exitPage = null;

    #[ORM\Column(type: Types::SMALLINT, options: ['default' => 1])]
    private int $pageCount = 1;

    #[ORM\Column(length: 64)]
    private ?string $ipHash = null;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $userAgent = null;

    #[ORM\Column(options: ['default' => false])]
    private bool $isBot = false;

    #[ORM\Column(length: 10, nullable: true)]
    private ?string $deviceType = null;

    /** @var Collection<int, PageView> */
    #[ORM\OneToMany(targetEntity: PageView::class, mappedBy: 'session')]
    private Collection $pageViews;

    public function __construct()
    {
        $now = new \DateTimeImmutable();
        $this->startedAt = $now;
        $this->endedAt = $now;
        $this->pageViews = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getSessionToken(): ?string
    {
        return $this->sessionToken;
    }

    public function setSessionToken(string $sessionToken): self
    {
        $this->sessionToken = $sessionToken;
        return $this;
    }

    public function getStartedAt(): ?\DateTimeImmutable
    {
        return $this->startedAt;
    }

    public function setStartedAt(\DateTimeImmutable $startedAt): self
    {
        $this->startedAt = $startedAt;
        return $this;
    }

    public function getEndedAt(): ?\DateTimeImmutable
    {
        return $this->endedAt;
    }

    public function setEndedAt(\DateTimeImmutable $endedAt): self
    {
        $this->endedAt = $endedAt;
        return $this;
    }

    public function getSource(): ?string
    {
        return $this->source;
    }

    public function setSource(string $source): self
    {
        $this->source = $source;
        return $this;
    }

    public function getSourceDetail(): ?string
    {
        return $this->sourceDetail;
    }

    public function setSourceDetail(?string $sourceDetail): self
    {
        $this->sourceDetail = $sourceDetail;
        return $this;
    }

    public function getUtmCampaign(): ?string
    {
        return $this->utmCampaign;
    }

    public function setUtmCampaign(?string $utmCampaign): self
    {
        $this->utmCampaign = $utmCampaign;
        return $this;
    }

    public function getUtmMedium(): ?string
    {
        return $this->utmMedium;
    }

    public function setUtmMedium(?string $utmMedium): self
    {
        $this->utmMedium = $utmMedium;
        return $this;
    }

    public function getLandingPage(): ?string
    {
        return $this->landingPage;
    }

    public function setLandingPage(string $landingPage): self
    {
        $this->landingPage = $landingPage;
        return $this;
    }

    public function getExitPage(): ?string
    {
        return $this->exitPage;
    }

    public function setExitPage(string $exitPage): self
    {
        $this->exitPage = $exitPage;
        return $this;
    }

    public function getPageCount(): int
    {
        return $this->pageCount;
    }

    public function setPageCount(int $pageCount): self
    {
        $this->pageCount = $pageCount;
        return $this;
    }

    public function incrementPageCount(): self
    {
        $this->pageCount++;
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

    public function isBot(): bool
    {
        return $this->isBot;
    }

    public function setIsBot(bool $isBot): self
    {
        $this->isBot = $isBot;
        return $this;
    }

    public function getDeviceType(): ?string
    {
        return $this->deviceType;
    }

    public function setDeviceType(?string $deviceType): self
    {
        $this->deviceType = $deviceType;
        return $this;
    }

    /** @return Collection<int, PageView> */
    public function getPageViews(): Collection
    {
        return $this->pageViews;
    }
}
