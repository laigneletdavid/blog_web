<?php

namespace App\Enum;

/**
 * Portee de referencement visee par le site (fiche Referencement).
 */
enum SeoReachEnum: string
{
    case LOCAL = 'local';
    case REGIONAL = 'regional';
    case NATIONAL = 'national';

    public function label(): string
    {
        return match ($this) {
            self::LOCAL => 'Local — ma ville et ses alentours',
            self::REGIONAL => 'Régional — mon département ou ma région',
            self::NATIONAL => 'National — toute la France',
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
