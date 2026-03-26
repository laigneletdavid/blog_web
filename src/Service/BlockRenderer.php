<?php

namespace App\Service;

use App\Repository\MediaRepository;

/**
 * Convertit le JSON natif TipTap en HTML pour le cache `content`.
 *
 * Le JSON TipTap est un arbre de nodes :
 * { "type": "doc", "content": [ { "type": "paragraph", ... }, ... ] }
 */
class BlockRenderer
{
    private const RESPONSIVE_SIZES = [480, 800, 1200];

    public function __construct(
        private readonly MediaRepository $mediaRepository,
        private readonly string $mediaDirectory,
    ) {
    }

    /**
     * Convertit un document TipTap JSON en HTML.
     */
    public function toHtml(?array $doc): string
    {
        if ($doc === null || empty($doc)) {
            return '';
        }

        // Le JSON TipTap a une racine "type": "doc" avec un "content"
        $nodes = $doc['content'] ?? $doc;

        if (!is_array($nodes)) {
            return '';
        }

        return $this->renderNodes($nodes);
    }

    private function renderNodes(array $nodes): string
    {
        $html = '';

        foreach ($nodes as $node) {
            $html .= $this->renderNode($node);
        }

        return $html;
    }

    private function renderNode(array $node): string
    {
        $type = $node['type'] ?? '';
        $attrs = $node['attrs'] ?? [];
        $content = isset($node['content']) ? $this->renderNodes($node['content']) : '';

        return match ($type) {
            'paragraph' => "<p>{$content}</p>",
            'heading' => $this->renderHeading($attrs, $content),
            'text' => $this->renderText($node),
            'bulletList' => "<ul>{$content}</ul>",
            'orderedList' => "<ol>{$content}</ol>",
            'listItem' => "<li>{$content}</li>",
            'blockquote' => "<blockquote class=\"block-quote\">{$content}</blockquote>",
            'codeBlock' => $this->renderCodeBlock($attrs, $content),
            'horizontalRule' => '<hr class="block-separator">',
            'image' => $this->renderImage($attrs),
            'youtube' => $this->renderYoutube($attrs),
            'hardBreak' => '<br>',
            default => $content,
        };
    }

    private function renderHeading(array $attrs, string $content): string
    {
        $level = $attrs['level'] ?? 2;
        $level = max(2, min(6, $level)); // H2-H6 (H1 réservé au titre de page)

        return "<h{$level}>{$content}</h{$level}>";
    }

    private function renderText(array $node): string
    {
        $text = htmlspecialchars($node['text'] ?? '', ENT_QUOTES, 'UTF-8');
        $marks = $node['marks'] ?? [];

        foreach ($marks as $mark) {
            $text = match ($mark['type'] ?? '') {
                'bold' => "<strong>{$text}</strong>",
                'italic' => "<em>{$text}</em>",
                'underline' => "<u>{$text}</u>",
                'strike' => "<s>{$text}</s>",
                'code' => "<code>{$text}</code>",
                'link' => $this->renderLink($mark['attrs'] ?? [], $text),
                default => $text,
            };
        }

        return $text;
    }

    private function renderLink(array $attrs, string $text): string
    {
        $href = htmlspecialchars($attrs['href'] ?? '#', ENT_QUOTES, 'UTF-8');
        $target = ($attrs['target'] ?? null) === '_blank' ? ' target="_blank" rel="noopener noreferrer"' : '';

        return "<a href=\"{$href}\"{$target}>{$text}</a>";
    }

    private function renderImage(array $attrs): string
    {
        $rawSrc = $attrs['src'] ?? '';
        // Encoder les espaces et caracteres speciaux dans le chemin (le sanitizer rejette les URLs invalides)
        $dir = dirname($rawSrc);
        $file = basename($rawSrc);
        $encodedSrc = $dir . '/' . rawurlencode($file);
        $src = htmlspecialchars($encodedSrc, ENT_QUOTES, 'UTF-8');
        $alt = htmlspecialchars($attrs['alt'] ?? '', ENT_QUOTES, 'UTF-8');
        $title = htmlspecialchars($attrs['title'] ?? '', ENT_QUOTES, 'UTF-8');

        if (empty($src)) {
            return '';
        }

        $srcsetAttr = '';
        $sizesAttr = '';

        if (str_contains($src, '/documents/medias/')) {
            $fileName = basename($src);
            $baseName = pathinfo($fileName, PATHINFO_FILENAME);
            // Si c'est deja un WebP, utiliser le nom de base sans -XXXw
            $baseName = preg_replace('/-\d+w$/', '', $baseName);

            $parts = [];
            foreach (self::RESPONSIVE_SIZES as $width) {
                $sizedFile = $baseName . '-' . $width . 'w.webp';
                if (file_exists($this->mediaDirectory . '/' . $sizedFile)) {
                    $parts[] = '/documents/medias/' . $sizedFile . ' ' . $width . 'w';
                }
            }

            if (!empty($parts)) {
                $parts[] = $src . ' 1600w';
                $srcsetAttr = ' srcset="' . implode(', ', $parts) . '"';
                $sizesAttr = ' sizes="(max-width: 768px) 100vw, 800px"';
            }
        }

        $figcaption = $title ? "<figcaption>{$title}</figcaption>" : '';

        return "<figure class=\"block-image\"><img src=\"{$src}\"{$srcsetAttr}{$sizesAttr} alt=\"{$alt}\" loading=\"lazy\">{$figcaption}</figure>";
    }

    private function renderYoutube(array $attrs): string
    {
        $src = htmlspecialchars($attrs['src'] ?? '', ENT_QUOTES, 'UTF-8');

        if (empty($src)) {
            return '';
        }

        // Convertir les URLs YouTube en embed
        $embedUrl = $this->toYoutubeEmbed($src);

        return '<div class="block-video"><iframe src="' . $embedUrl . '" frameborder="0" allowfullscreen allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" loading="lazy"></iframe></div>';
    }

    private function renderCodeBlock(array $attrs, string $content): string
    {
        $language = htmlspecialchars($attrs['language'] ?? '', ENT_QUOTES, 'UTF-8');
        $langClass = $language ? " class=\"language-{$language}\"" : '';

        return "<pre class=\"block-code\"><code{$langClass}>{$content}</code></pre>";
    }

    private function toYoutubeEmbed(string $url): string
    {
        // youtube.com/watch?v=ID → youtube.com/embed/ID
        if (preg_match('/(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]+)/', $url, $matches)) {
            return 'https://www.youtube.com/embed/' . $matches[1];
        }

        // Vimeo
        if (preg_match('/vimeo\.com\/(\d+)/', $url, $matches)) {
            return 'https://player.vimeo.com/video/' . $matches[1];
        }

        // Déjà un embed URL ou autre
        return $url;
    }
}
