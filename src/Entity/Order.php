<?php

namespace App\Entity;

use App\Enum\OrderStatusEnum;
use App\Enum\PaymentMethodEnum;
use App\Repository\OrderRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

#[ORM\Entity(repositoryClass: OrderRepository::class)]
#[ORM\Table(name: '`order`')]
#[ORM\Index(columns: ['status'], name: 'idx_order_status')]
#[ORM\Index(columns: ['created_at'], name: 'idx_order_created')]
class Order
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 20, unique: true)]
    private ?string $reference = null;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    private ?string $customerFirstName = null;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    private ?string $customerLastName = null;

    #[ORM\Column(length: 255)]
    #[Assert\NotBlank]
    #[Assert\Email]
    private ?string $customerEmail = null;

    #[ORM\Column(length: 50, nullable: true)]
    private ?string $customerPhone = null;

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $customerMessage = null;

    #[ORM\Column(type: Types::JSON)]
    private array $items = [];

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2)]
    private string $totalHT = '0.00';

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2)]
    private string $totalVAT = '0.00';

    #[ORM\Column(type: Types::DECIMAL, precision: 10, scale: 2)]
    private string $totalTTC = '0.00';

    #[ORM\Column(length: 20, enumType: PaymentMethodEnum::class)]
    private PaymentMethodEnum $paymentMethod = PaymentMethodEnum::STRIPE;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $stripeSessionId = null;

    #[ORM\Column(length: 20, enumType: OrderStatusEnum::class)]
    private OrderStatusEnum $status = OrderStatusEnum::PENDING;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE, nullable: true)]
    private ?\DateTimeImmutable $paidAt = null;

    public function __construct()
    {
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getReference(): ?string
    {
        return $this->reference;
    }

    public function setReference(string $reference): self
    {
        $this->reference = $reference;

        return $this;
    }

    /**
     * Genere une reference unique au format BW-YYYYMMDD-XXX.
     */
    public static function generateReference(): string
    {
        return 'BW-' . date('Ymd') . '-' . strtoupper(substr(bin2hex(random_bytes(3)), 0, 5));
    }

    public function getCustomerFirstName(): ?string
    {
        return $this->customerFirstName;
    }

    public function setCustomerFirstName(string $customerFirstName): self
    {
        $this->customerFirstName = $customerFirstName;

        return $this;
    }

    public function getCustomerLastName(): ?string
    {
        return $this->customerLastName;
    }

    public function setCustomerLastName(string $customerLastName): self
    {
        $this->customerLastName = $customerLastName;

        return $this;
    }

    public function getCustomerFullName(): string
    {
        return trim($this->customerFirstName . ' ' . $this->customerLastName);
    }

    public function getCustomerEmail(): ?string
    {
        return $this->customerEmail;
    }

    public function setCustomerEmail(string $customerEmail): self
    {
        $this->customerEmail = $customerEmail;

        return $this;
    }

    public function getCustomerPhone(): ?string
    {
        return $this->customerPhone;
    }

    public function setCustomerPhone(?string $customerPhone): self
    {
        $this->customerPhone = $customerPhone;

        return $this;
    }

    public function getCustomerMessage(): ?string
    {
        return $this->customerMessage;
    }

    public function setCustomerMessage(?string $customerMessage): self
    {
        $this->customerMessage = $customerMessage;

        return $this;
    }

    public function getItems(): array
    {
        return $this->items;
    }

    public function setItems(array $items): self
    {
        $this->items = $items;

        return $this;
    }

    public function getTotalHT(): float
    {
        return (float) $this->totalHT;
    }

    public function setTotalHT(float $totalHT): self
    {
        $this->totalHT = number_format($totalHT, 2, '.', '');

        return $this;
    }

    public function getTotalVAT(): float
    {
        return (float) $this->totalVAT;
    }

    public function setTotalVAT(float $totalVAT): self
    {
        $this->totalVAT = number_format($totalVAT, 2, '.', '');

        return $this;
    }

    public function getTotalTTC(): float
    {
        return (float) $this->totalTTC;
    }

    public function setTotalTTC(float $totalTTC): self
    {
        $this->totalTTC = number_format($totalTTC, 2, '.', '');

        return $this;
    }

    public function getPaymentMethod(): PaymentMethodEnum
    {
        return $this->paymentMethod;
    }

    public function setPaymentMethod(PaymentMethodEnum $paymentMethod): self
    {
        $this->paymentMethod = $paymentMethod;

        return $this;
    }

    public function getStripeSessionId(): ?string
    {
        return $this->stripeSessionId;
    }

    public function setStripeSessionId(?string $stripeSessionId): self
    {
        $this->stripeSessionId = $stripeSessionId;

        return $this;
    }

    public function getStatus(): OrderStatusEnum
    {
        return $this->status;
    }

    public function setStatus(OrderStatusEnum $status): self
    {
        $this->status = $status;

        return $this;
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function setCreatedAt(\DateTimeImmutable $createdAt): self
    {
        $this->createdAt = $createdAt;

        return $this;
    }

    public function getPaidAt(): ?\DateTimeImmutable
    {
        return $this->paidAt;
    }

    public function setPaidAt(?\DateTimeImmutable $paidAt): self
    {
        $this->paidAt = $paidAt;

        return $this;
    }

    public function isPaid(): bool
    {
        return $this->status === OrderStatusEnum::PAID;
    }

    public function isPending(): bool
    {
        return $this->status === OrderStatusEnum::PENDING;
    }

    public function markAsPaid(): self
    {
        $this->status = OrderStatusEnum::PAID;
        $this->paidAt = new \DateTimeImmutable();

        return $this;
    }

    public function __toString(): string
    {
        return $this->reference ?? 'Commande #' . $this->id;
    }
}
