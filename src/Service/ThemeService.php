<?php

namespace App\Service;

use Symfony\Contracts\Cache\CacheInterface;
use Symfony\Contracts\Cache\ItemInterface;
use Symfony\Component\Yaml\Yaml;

class ThemeService
{
    private const CACHE_KEY = 'themes_registry';
    private const CACHE_TTL = 3600;

    public function __construct(
        private readonly string $projectDir,
        private readonly CacheInterface $cache,
        private readonly SiteContext $siteContext,
    ) {
    }

    /**
     * All available themes indexed by slug.
     *
     * @return array<string, array>
     */
    public function getAvailableThemes(): array
    {
        return $this->cache->get(self::CACHE_KEY, function (ItemInterface $item): array {
            $item->expiresAfter(self::CACHE_TTL);

            $themesDir = $this->projectDir . '/templates/themes';
            $themes = [];

            if (!is_dir($themesDir)) {
                return [];
            }

            foreach (scandir($themesDir) as $dir) {
                if ($dir === '.' || $dir === '..') {
                    continue;
                }

                $yamlPath = $themesDir . '/' . $dir . '/theme.yaml';
                if (!file_exists($yamlPath)) {
                    continue;
                }

                $config = Yaml::parseFile($yamlPath);
                $config['slug'] = $dir;
                $config['hasThemeCss'] = file_exists($themesDir . '/' . $dir . '/theme.css');
                $config['hasPreview'] = file_exists($themesDir . '/' . $dir . '/preview.png');
                $themes[$dir] = $config;
            }

            return $themes;
        });
    }

    /**
     * Get a single theme config by slug.
     */
    public function getTheme(string $slug): ?array
    {
        return $this->getAvailableThemes()[$slug] ?? null;
    }

    /**
     * CSS custom properties for a theme (--bg, --surface, --text, etc.).
     *
     * @return array<string, string>
     */
    public function getThemeVars(?string $slug = null): array
    {
        $slug ??= $this->getCurrentThemeSlug();
        $theme = $this->getTheme($slug);

        if (!$theme) {
            $theme = $this->getTheme('default');
        }

        return $theme['variables'] ?? [];
    }

    /**
     * Meta-config (buttonStyle, headerStyle, google_fonts, etc.).
     */
    public function getConfig(?string $slug = null): array
    {
        $slug ??= $this->getCurrentThemeSlug();
        $theme = $this->getTheme($slug);

        if (!$theme) {
            $theme = $this->getTheme('default');
        }

        return [
            'buttonStyle' => $theme['buttonStyle'] ?? 'filled',
            'headerStyle' => $theme['headerStyle'] ?? 'sticky-white',
            'google_fonts' => $theme['google_fonts'] ?? null,
        ];
    }

    /**
     * Default colors/fonts a theme suggests when activated.
     *
     * @return array<string, string|null>
     */
    public function getDefaults(?string $slug = null): array
    {
        $slug ??= $this->getCurrentThemeSlug();
        $theme = $this->getTheme($slug);

        if (!$theme) {
            return [];
        }

        return $theme['defaults'] ?? [];
    }

    /**
     * Check if a theme provides a specific template partial.
     */
    public function hasTemplate(string $slug, string $template): bool
    {
        $path = $this->projectDir . '/templates/themes/' . $slug . '/' . $template;

        return file_exists($path);
    }

    /**
     * Resolve appearance values: site overrides ?? theme defaults.
     * Returns all 5 client-customizable properties with their effective value.
     *
     * @return array{primaryColor: string, secondaryColor: string, accentColor: string, fontFamily: string, fontFamilySecondary: string|null}
     */
    public function resolveAppearance(): array
    {
        $site = $this->siteContext->getCurrentSite();
        $defaults = $this->getDefaults($site?->getTemplate() ?? 'default');

        // Fallback chain: site value → theme default → hardcoded fallback
        return [
            'primaryColor' => $site?->getPrimaryColor() ?? $defaults['primaryColor'] ?? '#2563EB',
            'secondaryColor' => $site?->getSecondaryColor() ?? $defaults['secondaryColor'] ?? '#F59E0B',
            'accentColor' => $site?->getAccentColor() ?? $defaults['accentColor'] ?? '#8B5CF6',
            'fontFamily' => $site?->getFontFamily() ?? $defaults['fontFamily'] ?? "'Inter', sans-serif",
            'fontFamilySecondary' => $site?->getFontFamilySecondary() ?? $defaults['fontFamilySecondary'] ?? null,
        ];
    }

    /**
     * Current theme slug from Site entity.
     */
    public function getCurrentThemeSlug(): string
    {
        $site = $this->siteContext->getCurrentSite();

        return $site?->getTemplate() ?? 'default';
    }

    public function clearCache(): void
    {
        $this->cache->delete(self::CACHE_KEY);
    }
}
