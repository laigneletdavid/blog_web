<?php

namespace App\Enum;

enum SystemPageEnum: string
{
    case MENTIONS_LEGALES = 'mentions-legales';
    case POLITIQUE_CONFIDENTIALITE = 'politique-confidentialite';
    case CGV = 'cgv';
    case CGU = 'cgu';

    public function title(): string
    {
        return match ($this) {
            self::MENTIONS_LEGALES => 'Mentions légales',
            self::POLITIQUE_CONFIDENTIALITE => 'Politique de confidentialité',
            self::CGV => 'Conditions générales de vente',
            self::CGU => "Conditions générales d'utilisation",
        };
    }

    public function slug(): string
    {
        return $this->value;
    }

    /**
     * Route type parameter used in LegalController URL.
     */
    public function routeType(): string
    {
        return match ($this) {
            self::MENTIONS_LEGALES => 'mentions-legales',
            self::POLITIQUE_CONFIDENTIALITE => 'politique-de-confidentialite',
            self::CGV => 'conditions-generales-de-vente',
            self::CGU => 'conditions-generales-utilisation',
        };
    }

    /**
     * Module required for this page, null = always required.
     */
    public function requiredModule(): ?ModuleEnum
    {
        return match ($this) {
            self::MENTIONS_LEGALES, self::POLITIQUE_CONFIDENTIALITE => null,
            self::CGV => ModuleEnum::ECOMMERCE,
            self::CGU => ModuleEnum::SERVICES,
        };
    }

    /**
     * Pages always created regardless of modules.
     *
     * @return self[]
     */
    public static function alwaysRequired(): array
    {
        return [self::MENTIONS_LEGALES, self::POLITIQUE_CONFIDENTIALITE];
    }

    /**
     * Additional pages needed when a module is enabled.
     *
     * @return self[]
     */
    public static function forModule(ModuleEnum $module): array
    {
        $pages = [];
        foreach (self::cases() as $case) {
            if ($case->requiredModule() === $module) {
                $pages[] = $case;
            }
        }

        return $pages;
    }
}
