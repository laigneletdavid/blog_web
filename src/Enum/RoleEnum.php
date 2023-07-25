<?php

namespace App\Enum;

enum RoleEnum:string
{
    case ROLE_USER = 'ROLE_USER';
    case ROLE_CORRECTOR = 'ROLE_CORRECTOR';
    case ROLE_AUTHOR = 'ROLE_AUTHOR';
    case ROLE_ADMIN = 'ROLE_ADMIN';

    public function label()
    {
        return match($this) {
            self::ROLE_USER => 'User',
            self::ROLE_CORRECTOR => 'Correcteur',
            self::ROLE_AUTHOR => 'Auteur',
            self::ROLE_ADMIN => 'Admin',
            default => $this->name,
        };
    }

    public static function choices()
    {
        $choices = [];
        foreach (self::cases() as $choice)
        {
            $choices[$choice->label()] = $choice->value;
        }

        return $choices;
    }

    public static function getValues()
    {
        return array_values(self::choices());
    }
}