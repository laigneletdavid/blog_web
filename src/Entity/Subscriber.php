<?php

namespace App\Entity;

use App\Repository\SubscriberRepository;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: SubscriberRepository::class)]
#[ORM\Table(name: 'subscriber')]
#[ORM\Index(columns: ['is_active', 'subscribe_articles'], name: 'idx_subscriber_articles')]
#[ORM\Index(columns: ['is_active', 'subscribe_events'], name: 'idx_subscriber_events')]
#[UniqueEntity(fields: ['email'], message: 'Cette adresse email est deja abonnee.')]
class Subscriber
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 180, unique: true)]
    #[Assert\NotBlank(message: 'Veuillez entrer votre adresse email.')]
    #[Assert\Email(message: 'Adresse email invalide.')]
    private ?string $email = null;

    #[ORM\Column(options: ['default' => false])]
    private bool $subscribeArticles = false;

    #[ORM\Column(options: ['default' => false])]
    private bool $subscribeEvents = false;

    #[ORM\Column(length: 64, unique: true)]
    private string $token;

    #[ORM\Column(options: ['default' => false])]
    private bool $isActive = false;

    #[ORM\Column]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column(nullable: true)]
    private ?\DateTimeImmutable $confirmedAt = null;

    public function __construct()
    {
        $this->token = bin2hex(random_bytes(32));
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): ?int
    {
        return $this->id;
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

    public function isSubscribeArticles(): bool
    {
        return $this->subscribeArticles;
    }

    public function setSubscribeArticles(bool $subscribeArticles): self
    {
        $this->subscribeArticles = $subscribeArticles;

        return $this;
    }

    public function isSubscribeEvents(): bool
    {
        return $this->subscribeEvents;
    }

    public function setSubscribeEvents(bool $subscribeEvents): self
    {
        $this->subscribeEvents = $subscribeEvents;

        return $this;
    }

    public function getToken(): string
    {
        return $this->token;
    }

    public function regenerateToken(): self
    {
        $this->token = bin2hex(random_bytes(32));

        return $this;
    }

    public function isActive(): bool
    {
        return $this->isActive;
    }

    public function setIsActive(bool $isActive): self
    {
        $this->isActive = $isActive;

        return $this;
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function getConfirmedAt(): ?\DateTimeImmutable
    {
        return $this->confirmedAt;
    }

    public function setConfirmedAt(?\DateTimeImmutable $confirmedAt): self
    {
        $this->confirmedAt = $confirmedAt;

        return $this;
    }

    /**
     * Confirme l'abonnement (double opt-in).
     */
    public function confirm(): self
    {
        $this->isActive = true;
        $this->confirmedAt = new \DateTimeImmutable();

        return $this;
    }

    /**
     * Desactive l'abonnement et reset toutes les preferences.
     */
    public function unsubscribeAll(): self
    {
        $this->isActive = false;
        $this->subscribeArticles = false;
        $this->subscribeEvents = false;

        return $this;
    }

    public function __toString(): string
    {
        return $this->email ?? '';
    }
}
