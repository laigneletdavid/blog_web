<?php

namespace App\Enum;

enum SeoStatus: string
{
    case RED = 'red';
    case ORANGE = 'orange';
    case GREEN = 'green';

    public function label(): string
    {
        return match ($this) {
            self::RED => 'À corriger',
            self::ORANGE => 'À améliorer',
            self::GREEN => 'Bon',
        };
    }

    public function bootstrapColor(): string
    {
        return match ($this) {
            self::RED => 'danger',
            self::ORANGE => 'warning',
            self::GREEN => 'success',
        };
    }

    public function icon(): string
    {
        return match ($this) {
            self::RED => 'fa fa-times-circle',
            self::ORANGE => 'fa fa-exclamation-circle',
            self::GREEN => 'fa fa-check-circle',
        };
    }
}
