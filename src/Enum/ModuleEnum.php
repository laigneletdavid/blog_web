<?php

namespace App\Enum;

enum ModuleEnum: string
{
    case VITRINE = 'vitrine';
    case SERVICES = 'services';
    case BLOG = 'blog';
    case CATALOGUE = 'catalogue';
    case ECOMMERCE = 'ecommerce';
    case EVENTS = 'events';
    case PRIVATE_PAGES = 'private_pages';
    case DIRECTORY = 'directory';
    case FAQ = 'faq';
    case PORTFOLIO = 'portfolio';

    public function label(): string
    {
        return match ($this) {
            self::VITRINE => 'Vitrine (base)',
            self::SERVICES => 'Services',
            self::BLOG => 'Blog',
            self::CATALOGUE => 'Catalogue produits',
            self::ECOMMERCE => 'E-commerce',
            self::EVENTS => 'Événements',
            self::PRIVATE_PAGES => 'Pages privées',
            self::DIRECTORY => 'Annuaire',
            self::FAQ => 'FAQ',
            self::PORTFOLIO => 'Portfolio / Réalisations',
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

    /**
     * @return string[]
     */
    public static function defaults(): array
    {
        return [self::VITRINE->value];
    }
}
