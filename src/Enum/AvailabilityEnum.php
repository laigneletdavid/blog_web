<?php

namespace App\Enum;

enum AvailabilityEnum: string
{
    case AVAILABLE = 'available';
    case UNAVAILABLE = 'unavailable';
    case ON_REQUEST = 'on_request';

    public function label(): string
    {
        return match ($this) {
            self::AVAILABLE => 'Disponible',
            self::UNAVAILABLE => 'Indisponible',
            self::ON_REQUEST => 'Sur devis',
        };
    }

    public function cssClass(): string
    {
        return match ($this) {
            self::AVAILABLE => 'success',
            self::UNAVAILABLE => 'danger',
            self::ON_REQUEST => 'warning',
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
