<?php

namespace App\Enum;

enum PaymentMethodEnum: string
{
    case STRIPE = 'stripe';
    case MANUAL = 'manual';

    public function label(): string
    {
        return match ($this) {
            self::STRIPE => 'Carte bancaire',
            self::MANUAL => 'Virement / cheque / especes',
        };
    }

    public function icon(): string
    {
        return match ($this) {
            self::STRIPE => 'fa-credit-card',
            self::MANUAL => 'fa-money-bill',
        };
    }

    /**
     * @return array<string, string>
     */
    public static function choices(): array
    {
        $choices = [];
        foreach (self::cases() as $case) {
            $choices[$case->label()] = $case->value;
        }

        return $choices;
    }
}
