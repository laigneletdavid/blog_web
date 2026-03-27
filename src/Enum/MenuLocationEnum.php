<?php

namespace App\Enum;

enum MenuLocationEnum: string
{
    case HEADER = 'header';
    case FOOTER_NAV = 'footer_nav';
    case FOOTER_LEGAL = 'footer_legal';

    public function label(): string
    {
        return match ($this) {
            self::HEADER => 'Navigation principale',
            self::FOOTER_NAV => 'Footer navigation',
            self::FOOTER_LEGAL => 'Footer légal',
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
