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
        ];
    }

    /**
     * Retourne un tag <img> complet avec srcset, sizes et loading="lazy".
     */
    public function responsiveImg(
        ?Media $media,
        string $sizes = '100vw',
        string $cssClass = '',
        ?string $alt = null,
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

        return '<img src="' . htmlspecialchars($src, ENT_QUOTES, 'UTF-8') . '"'
            . $srcsetAttr . $sizesAttr
            . ' alt="' . $altText . '"'
            . $classAttr
            . ' loading="lazy">';
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
