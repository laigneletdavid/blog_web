<?php

namespace App\Twig;

use App\Entity\Media;
use App\Service\MediaProcessorService;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;
use Twig\TwigFunction;

class ResponsiveImageExtension extends AbstractExtension
{
    public function __construct(
        private readonly string $mediaDirectory,
    ) {
    }

    public function getFilters(): array
    {
        return [
            new TwigFilter('media_srcset', [$this, 'mediaSrcset']),
        ];
    }

    public function getFunctions(): array
    {
        return [
            new TwigFunction('responsive_img', [$this, 'responsiveImg'], ['is_safe' => ['html']]),
            new TwigFunction('logo_img', [$this, 'logoImg'], ['is_safe' => ['html']]),
        ];
    }

    /**
     * Generates an <img> tag for a logo with correct width/height based on actual image dimensions.
     * Calculates width dynamically from the target display height to preserve aspect ratio.
     */
    public function logoImg(?Media $media, int $displayHeight = 0, string $alt = '', string $cssClass = ''): string
    {
        if (!$media || !$media->getFileName()) {
            return '';
        }

        $src = '/documents/medias/' . $media->getFileName();
        $altText = htmlspecialchars($alt, ENT_QUOTES, 'UTF-8');
        $classAttr = $cssClass ? ' class="' . htmlspecialchars($cssClass, ENT_QUOTES, 'UTF-8') . '"' : '';

        // If displayHeight is 0, let CSS handle sizing (no inline width/height)
        if ($displayHeight === 0) {
            return '<img src="' . htmlspecialchars($src, ENT_QUOTES, 'UTF-8') . '"'
                . ' alt="' . $altText . '"'
                . $classAttr . '>';
        }

        // Calculate width from actual image dimensions
        $widthAttr = '';
        $filePath = $this->mediaDirectory . '/' . $media->getFileName();
        if (file_exists($filePath)) {
            $imageSize = @getimagesize($filePath);
            if ($imageSize && $imageSize[1] > 0) {
                $ratio = $imageSize[0] / $imageSize[1];
                $displayWidth = (int) round($ratio * $displayHeight);
                $widthAttr = ' width="' . $displayWidth . '"';
            }
        }

        return '<img src="' . htmlspecialchars($src, ENT_QUOTES, 'UTF-8') . '"'
            . ' alt="' . $altText . '"'
            . $widthAttr
            . ' height="' . $displayHeight . '"'
            . $classAttr . '>';
    }

    /**
     * Retourne un tag <img> complet avec srcset, sizes et loading="lazy".
     */
    /**
     * Retourne un tag <img> complet avec srcset, sizes et loading.
     * $eager = true pour les images LCP (hero) : loading="eager" + fetchpriority="high"
     */
    public function responsiveImg(
        ?Media $media,
        string $sizes = '100vw',
        string $cssClass = '',
        ?string $alt = null,
        bool $eager = false,
    ): string {
        if (!$media || !$media->getFileName()) {
            return '';
        }

        $src = '/documents/medias/' . ($media->getWebpFileName() ?? $media->getFileName());
        $altText = htmlspecialchars($alt ?? $media->getName() ?? '', ENT_QUOTES, 'UTF-8');
        $srcsetValue = $this->buildSrcset($media);

        $classAttr = $cssClass ? ' class="' . htmlspecialchars($cssClass, ENT_QUOTES, 'UTF-8') . '"' : '';
        $srcsetAttr = $srcsetValue ? ' srcset="' . $srcsetValue . '"' : '';
        $sizesAttr = $srcsetValue ? ' sizes="' . htmlspecialchars($sizes, ENT_QUOTES, 'UTF-8') . '"' : '';
        $loadingAttr = $eager ? ' loading="eager" fetchpriority="high"' : ' loading="lazy"';

        return '<img src="' . htmlspecialchars($src, ENT_QUOTES, 'UTF-8') . '"'
            . $srcsetAttr . $sizesAttr
            . ' alt="' . $altText . '"'
            . $classAttr
            . $loadingAttr . '>';
    }

    /**
     * Retourne uniquement la valeur srcset pour un Media.
     */
    public function mediaSrcset(?Media $media): string
    {
        if (!$media || !$media->getFileName()) {
            return '';
        }

        return $this->buildSrcset($media);
    }

    private function buildSrcset(Media $media): string
    {
        $baseName = pathinfo($media->getFileName(), PATHINFO_FILENAME);
        $parts = [];

        foreach (MediaProcessorService::RESPONSIVE_SIZES as $width) {
            $sizedFile = $baseName . '-' . $width . 'w.webp';
            if (file_exists($this->mediaDirectory . '/' . $sizedFile)) {
                $parts[] = '/documents/medias/' . $sizedFile . ' ' . $width . 'w';
            }
        }

        // Ajouter le full-size WebP comme plus grande option
        if ($media->getWebpFileName()) {
            $parts[] = '/documents/medias/' . $media->getWebpFileName() . ' 1600w';
        }

        return implode(', ', $parts);
    }
}
