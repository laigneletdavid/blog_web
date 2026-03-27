<?php

namespace App\Twig;

use App\Entity\Menu;
use App\Enum\VisibilityEnum;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\Routing\RouterInterface;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;
use Twig\TwigFunction;

class AppExtension extends AbstractExtension
{

        public function __construct(
            private RouterInterface $router,
            private Security $security,
        ) {
        }

    public function getFilters(): array
    {
        return [
            new TwigFilter('menuLink', [$this, 'menuLink']),
            new TwigFilter('readingTime', [$this, 'readingTime']),
            new TwigFilter('highlight', [$this, 'highlight'], ['is_safe' => ['html']]),
            new TwigFilter('toc_anchors', [$this, 'addTocAnchors'], ['is_safe' => ['html']]),
            new TwigFilter('menuVisible', [$this, 'menuVisible']),
        ];
    }

    public function getFunctions(): array
    {
        return [
            new TwigFunction('toc_extract', [$this, 'extractToc']),
        ];
    }

    /**
     * Checks if a menu item should be visible based on the linked content's visibility.
     */
    public function menuVisible(Menu $menu): bool
    {
        $page = $menu->getPage();
        if ($page !== null) {
            $visibility = VisibilityEnum::tryFrom($page->getVisibility()) ?? VisibilityEnum::PUBLIC;
            if ($visibility !== VisibilityEnum::PUBLIC) {
                $requiredRole = $visibility->requiredRole();
                if ($requiredRole && !$this->security->isGranted($requiredRole)) {
                    return false;
                }
            }
        }

        $article = $menu->getArticle();
        if ($article !== null) {
            $visibility = VisibilityEnum::tryFrom($article->getVisibility()) ?? VisibilityEnum::PUBLIC;
            if ($visibility !== VisibilityEnum::PUBLIC) {
                $requiredRole = $visibility->requiredRole();
                if ($requiredRole && !$this->security->isGranted($requiredRole)) {
                    return false;
                }
            }
        }

        return true;
    }

    /**
     * Parse HTML content, extract H2/H3, add id anchors.
     * Returns modified HTML with id attributes on headings.
     */
    public function addTocAnchors(?string $html): string
    {
        if (!$html) {
            return '';
        }

        return preg_replace_callback(
            '/<(h[23])([^>]*)>(.*?)<\/\1>/is',
            function (array $m): string {
                $tag = $m[1];
                $attrs = $m[2];
                $text = $m[3];
                $id = $this->slugify(strip_tags($text));

                // Don't double-add id if already present
                if (preg_match('/\bid\s*=/i', $attrs)) {
                    return $m[0];
                }

                return sprintf('<%s%s id="%s">%s</%s>', $tag, $attrs, $id, $text, $tag);
            },
            $html
        );
    }

    /**
     * Extract TOC items from HTML content.
     * Returns array of ['id' => string, 'text' => string, 'level' => 2|3].
     * Returns empty array if fewer than 3 headings.
     */
    public function extractToc(?string $html, int $minHeadings = 3): array
    {
        if (!$html) {
            return [];
        }

        $items = [];
        preg_match_all('/<(h[23])[^>]*>(.*?)<\/\1>/is', $html, $matches, PREG_SET_ORDER);

        if (count($matches) < $minHeadings) {
            return [];
        }

        foreach ($matches as $match) {
            $text = strip_tags($match[2]);
            $items[] = [
                'id' => $this->slugify($text),
                'text' => $text,
                'level' => (int) $match[1][1], // '2' or '3'
            ];
        }

        return $items;
    }

    private function slugify(string $text): string
    {
        $text = transliterator_transliterate('Any-Latin; Latin-ASCII; Lower()', $text);
        $text = preg_replace('/[^a-z0-9]+/', '-', $text);

        return trim($text, '-');
    }

    /**
     * Estime le temps de lecture en minutes.
     */
    public function readingTime(?string $content): int
    {
        if (!$content) {
            return 1;
        }

        $wordCount = str_word_count(strip_tags($content));

        return max(1, (int) ceil($wordCount / 200));
    }

    /**
     * Entoure les occurrences du mot-cle avec <mark> dans le texte.
     * XSS-safe : le texte est echappe avant insertion des balises.
     */
    public function highlight(?string $text, ?string $keyword): string
    {
        if (!$text || !$keyword || mb_strlen($keyword) < 2) {
            return htmlspecialchars($text ?? '', ENT_QUOTES, 'UTF-8');
        }

        $escaped = htmlspecialchars($text, ENT_QUOTES, 'UTF-8');
        $escapedKeyword = preg_quote(htmlspecialchars($keyword, ENT_QUOTES, 'UTF-8'), '/');

        return preg_replace(
            '/(' . $escapedKeyword . ')/iu',
            '<mark>$1</mark>',
            $escaped
        );
    }

    public function menuLink(Menu $menu): string
    {
        // System menu items use named routes
        if ($menu->getRoute() !== null) {
            return $this->router->generate($menu->getRoute(), $menu->getRouteParams() ?? []);
        }

        if ($menu->getTarget() === 'url' && $menu->getUrl() !== null) {
            return $menu->getUrl();
        }

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