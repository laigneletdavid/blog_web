<?php

namespace App\Twig;

use Twig\Extension\AbstractExtension;
use Twig\TwigFunction;

class IconExtension extends AbstractExtension
{
    private array $cache = [];

    public function __construct(
        private readonly string $projectDir,
    ) {
    }

    public function getFunctions(): array
    {
        return [
            new TwigFunction('bi', [$this, 'icon'], ['is_safe' => ['html']]),
        ];
    }

    public function icon(string $name, string $class = '', string $size = '1em'): string
    {
        if (isset($this->cache[$name])) {
            $svg = $this->cache[$name];
        } else {
            $path = $this->projectDir . '/templates/icons/' . $name . '.svg';

            if (!file_exists($path)) {
                return '';
            }

            $svg = file_get_contents($path);
            $this->cache[$name] = $svg;
        }

        $cssClass = 'bi-svg' . ($class ? ' ' . $class : '');

        // Inject class and size into SVG tag
        $svg = preg_replace(
            '/<svg\b/',
            '<svg class="' . htmlspecialchars($cssClass) . '" width="' . htmlspecialchars($size) . '" height="' . htmlspecialchars($size) . '"',
            $svg,
            1
        );

        return $svg;
    }
}
