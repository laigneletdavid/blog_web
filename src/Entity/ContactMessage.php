<?php

namespace App\Entity;

use App\Repository\ContactMessageRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: ContactMessageRepository::class)]
#[ORM\Index(columns: ['created_at'], name: 'idx_contact_created')]
#[ORM\Index(columns: ['is_read'], name: 'idx_contact_read')]
class ContactMessage
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?StatSession $session = null;

    #[ORM\Column(length: 100)]
    private ?string $name = null;

    #[ORM\Column(length: 100)]
    private ?string $firstname = null;

    #[ORM\Column(length: 255)]
    private ?string $email = null;

    #[ORM\Column(length: 255)]
    private ?string $subject = null;

    #[ORM\Column(type: Types::TEXT)]
    private ?string $message = null;

    #[ORM\Column(length: 64)]
    private ?string $ipHash = null;

    #[ORM\Column(length: 500, nullable: true)]
    private ?string $sourcePage = null;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private ?\DateTimeImmutable $createdAt = null;

    #[ORM\Column(options: ['default' => false])]
    private bool $isRead = false;

    public function __construct()
    {
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): ?int
    {
        return $this->id;
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

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;
        return $this;
    }

    public function getFirstname(): ?string
    {
        return $this->firstname;
    }

    public function setFirstname(string $firstname): self
    {
        $this->firstname = $firstname;
        return $this;
    }

    public function getEmail(): ?string
    {
        return $this->email;
    }

    public function setEmail(string $email): self
    {
        $this->email = $email;
        return $this;
    }

    public function getSubject(): ?string
    {
        return $this->subject;
    }

    public function setSubject(string $subject): self
    {
        $this->subject = $subject;
        return $this;
    }

    public function getMessage(): ?string
    {
        return $this->message;
    }

    public function setMessage(string $message): self
    {
        $this->message = $message;
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

    public function getSourcePage(): ?string
    {
        return $this->sourcePage;
    }

    public function setSourcePage(?string $sourcePage): self
    {
        $this->sourcePage = $sourcePage;
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

    public function isRead(): bool
    {
        return $this->isRead;
    }

    public function setIsRead(bool $isRead): self
    {
        $this->isRead = $isRead;
        return $this;
    }

    public function getFullName(): string
    {
        return trim($this->firstname . ' ' . $this->name);
    }

    public function __toString(): string
    {
        return $this->getFullName() . ' — ' . $this->subject;
    }
}
