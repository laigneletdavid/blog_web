<?php

namespace App\Twig;

use App\Entity\Menu;
use Symfony\Component\Routing\RouterInterface;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;

class AppExtension extends AbstractExtension
{

        public function __construct(
            private RouterInterface $router,
        ) {
        }

    public function getFilters(): array
    {
        return [
            new TwigFilter('menuLink', [$this, 'menuLink']),
        ];
    }

    public function menuLink(Menu $menu): string
    {
        $article = $menu->getArticle();
        if ($article !== null && $article->getSlug() !== null) {
            return $this->router->generate('app_article_show', ['slug' => $article->getSlug()]);
        }

        $categorie = $menu->getCategorie();
        if ($categorie !== null && $categorie->getSlug() !== null) {
            return $this->router->generate('app_categorie_show', ['slug' => $categorie->getSlug()]);
        }

        $page = $menu->getPage();
        if ($page !== null && $page->getSlug() !== null) {
            return $this->router->generate('app_page_show', ['slug' => $page->getSlug()]);
        }

        return '#';
    }
}