<?php

namespace App\Enum;

enum VisibilityEnum: string
{
    case PUBLIC = 'public';
    case USER = 'user';
    case AUTHOR = 'author';
    case ADMIN = 'admin';

    public function label(): string
    {
        return match ($this) {
            self::PUBLIC => 'Public',
            self::USER => 'Membres (connectés)',
            self::AUTHOR => 'Auteurs et +',
            self::ADMIN => 'Administrateurs uniquement',
        };
    }

    public function requiredRole(): ?string
    {
        return match ($this) {
            self::PUBLIC => null,
            self::USER => 'ROLE_USER',
            self::AUTHOR => 'ROLE_AUTHOR',
            self::ADMIN => 'ROLE_ADMIN',
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
