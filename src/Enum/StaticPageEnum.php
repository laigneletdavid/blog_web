<?php

namespace App\Enum;

/**
 * Pages "en dur" du site (routes d'index sans parametre dynamique).
 *
 * Permet d'iterer sur toutes les pages statiques disponibles en fonction
 * des modules actifs, pour : selecteur de liens Tiptap, menus, sitemap, etc.
 */
enum StaticPageEnum: string
{
    case HOME = 'home';
    case CONTACT = 'contact';
    case SEARCH = 'search';
    case BLOG_INDEX = 'blog_index';
    case SERVICE_INDEX = 'service_index';
    case EVENT_INDEX = 'event_index';
    case PORTFOLIO_INDEX = 'portfolio_index';
    case FAQ_INDEX = 'faq_index';
    case PRODUCT_INDEX = 'product_index';
    case DIRECTORY_INDEX = 'directory_index';
    case CART = 'cart';

    public function label(): string
    {
        return match ($this) {
            self::HOME => 'Accueil',
            self::CONTACT => 'Contact',
            self::SEARCH => 'Recherche',
            self::BLOG_INDEX => 'Blog',
            self::SERVICE_INDEX => 'Services',
            self::EVENT_INDEX => 'Evenements',
            self::PORTFOLIO_INDEX => 'Realisations',
            self::FAQ_INDEX => 'FAQ',
            self::PRODUCT_INDEX => 'Catalogue',
            self::DIRECTORY_INDEX => 'Annuaire',
            self::CART => 'Panier',
        };
    }

    public function routeName(): string
    {
        return match ($this) {
            self::HOME => 'app_home',
            self::CONTACT => 'app_contact',
            self::SEARCH => 'app_search_results',
            self::BLOG_INDEX => 'app_article_show_all',
            self::SERVICE_INDEX => 'app_service_index',
            self::EVENT_INDEX => 'app_event_index',
            self::PORTFOLIO_INDEX => 'app_portfolio_index',
            self::FAQ_INDEX => 'app_faq_index',
            self::PRODUCT_INDEX => 'app_product_index',
            self::DIRECTORY_INDEX => 'app_directory',
            self::CART => 'app_cart',
        };
    }

    /**
     * Module requis pour afficher la page, null = toujours disponible.
     */
    public function requiredModule(): ?ModuleEnum
    {
        return match ($this) {
            self::HOME, self::CONTACT, self::SEARCH => null,
            self::BLOG_INDEX => ModuleEnum::BLOG,
            self::SERVICE_INDEX => ModuleEnum::SERVICES,
            self::EVENT_INDEX => ModuleEnum::EVENTS,
            self::PORTFOLIO_INDEX => ModuleEnum::PORTFOLIO,
            self::FAQ_INDEX => ModuleEnum::FAQ,
            self::PRODUCT_INDEX => ModuleEnum::CATALOGUE,
            self::DIRECTORY_INDEX => ModuleEnum::DIRECTORY,
            self::CART => ModuleEnum::ECOMMERCE,
        };
    }
}
