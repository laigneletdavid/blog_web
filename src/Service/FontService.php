<?php

namespace App\Service;

/**
 * Curated list of 20 Google Fonts for site customization.
 * Base: fonts used in the 6 themes + top Google Fonts 2025.
 *
 * Key = CSS value stored in DB. Value = [label, Google Fonts URL name, weights, category].
 */
class FontService
{
    /**
     * @var array<string, array{label: string, google: string, weights: string, category: string}>
     */
    public const FONTS = [
        // ===== Polices des themes (7) =====
        "'Inter', sans-serif" => [
            'label' => 'Inter',
            'google' => 'Inter',
            'weights' => '400;500;600;700;800',
            'category' => 'Sans-serif',
        ],
        "'Poppins', sans-serif" => [
            'label' => 'Poppins',
            'google' => 'Poppins',
            'weights' => '400;500;600;700',
            'category' => 'Sans-serif',
        ],
        "'Source Sans 3', sans-serif" => [
            'label' => 'Source Sans 3',
            'google' => 'Source+Sans+3',
            'weights' => '400;500;600;700',
            'category' => 'Sans-serif',
        ],
        "'DM Sans', sans-serif" => [
            'label' => 'DM Sans',
            'google' => 'DM+Sans',
            'weights' => '400;500;600;700',
            'category' => 'Sans-serif',
        ],
        "'Lato', sans-serif" => [
            'label' => 'Lato',
            'google' => 'Lato',
            'weights' => '400;700;900',
            'category' => 'Sans-serif',
        ],
        "'Playfair Display', serif" => [
            'label' => 'Playfair Display',
            'google' => 'Playfair+Display',
            'weights' => '400;500;600;700;800',
            'category' => 'Serif',
        ],
        "'Space Grotesk', sans-serif" => [
            'label' => 'Space Grotesk',
            'google' => 'Space+Grotesk',
            'weights' => '400;500;600;700',
            'category' => 'Sans-serif',
        ],

        // ===== Top Google Fonts 2025 (13) =====
        "'Roboto', sans-serif" => [
            'label' => 'Roboto',
            'google' => 'Roboto',
            'weights' => '400;500;700',
            'category' => 'Sans-serif',
        ],
        "'Open Sans', sans-serif" => [
            'label' => 'Open Sans',
            'google' => 'Open+Sans',
            'weights' => '400;500;600;700',
            'category' => 'Sans-serif',
        ],
        "'Montserrat', sans-serif" => [
            'label' => 'Montserrat',
            'google' => 'Montserrat',
            'weights' => '400;500;600;700;800',
            'category' => 'Sans-serif',
        ],
        "'Nunito', sans-serif" => [
            'label' => 'Nunito',
            'google' => 'Nunito',
            'weights' => '400;500;600;700;800',
            'category' => 'Sans-serif',
        ],
        "'Raleway', sans-serif" => [
            'label' => 'Raleway',
            'google' => 'Raleway',
            'weights' => '400;500;600;700;800',
            'category' => 'Sans-serif',
        ],
        "'Work Sans', sans-serif" => [
            'label' => 'Work Sans',
            'google' => 'Work+Sans',
            'weights' => '400;500;600;700',
            'category' => 'Sans-serif',
        ],
        "'Oswald', sans-serif" => [
            'label' => 'Oswald',
            'google' => 'Oswald',
            'weights' => '400;500;600;700',
            'category' => 'Display',
        ],
        "'Merriweather', serif" => [
            'label' => 'Merriweather',
            'google' => 'Merriweather',
            'weights' => '400;700;900',
            'category' => 'Serif',
        ],
        "'Lora', serif" => [
            'label' => 'Lora',
            'google' => 'Lora',
            'weights' => '400;500;600;700',
            'category' => 'Serif',
        ],
        "'Libre Baskerville', serif" => [
            'label' => 'Libre Baskerville',
            'google' => 'Libre+Baskerville',
            'weights' => '400;700',
            'category' => 'Serif',
        ],
        "'Manrope', sans-serif" => [
            'label' => 'Manrope',
            'google' => 'Manrope',
            'weights' => '400;500;600;700;800',
            'category' => 'Sans-serif',
        ],
        "'Plus Jakarta Sans', sans-serif" => [
            'label' => 'Plus Jakarta Sans',
            'google' => 'Plus+Jakarta+Sans',
            'weights' => '400;500;600;700;800',
            'category' => 'Sans-serif',
        ],
        "'Outfit', sans-serif" => [
            'label' => 'Outfit',
            'google' => 'Outfit',
            'weights' => '400;500;600;700',
            'category' => 'Sans-serif',
        ],
    ];

    /**
     * Choices for EasyAdmin ChoiceField, grouped by category.
     * "Label (category)" => CSS value
     *
     * @return array<string, string>
     */
    public function getChoices(): array
    {
        $choices = [];
        foreach (self::FONTS as $cssValue => $font) {
            $choices[$font['label'] . '  —  ' . $font['category']] = $cssValue;
        }

        return $choices;
    }

    /**
     * Choices with an empty "use main font" option for secondary font.
     *
     * @return array<string, string>
     */
    public function getSecondaryChoices(): array
    {
        return array_merge(
            ['Identique a la police principale' => ''],
            $this->getChoices(),
        );
    }

    /**
     * Build a Google Fonts CSS2 URL from CSS values.
     * Always includes JetBrains Mono for code blocks.
     *
     * @param string[] $cssValues CSS font values (e.g. "'Inter', sans-serif")
     */
    public function buildGoogleFontsUrl(array $cssValues): string
    {
        $families = [];
        $seen = [];

        foreach ($cssValues as $cssValue) {
            if ($cssValue === '' || $cssValue === null) {
                continue;
            }
            $font = self::FONTS[$cssValue] ?? null;
            if ($font && !isset($seen[$font['google']])) {
                $families[] = 'family=' . $font['google'] . ':wght@' . $font['weights'];
                $seen[$font['google']] = true;
            }
        }

        // Always include JetBrains Mono for code blocks
        $families[] = 'family=JetBrains+Mono:wght@400;500';

        return 'https://fonts.googleapis.com/css2?' . implode('&', $families) . '&display=swap';
    }

    /**
     * Get font label from CSS value.
     */
    public function getLabel(string $cssValue): string
    {
        return self::FONTS[$cssValue]['label'] ?? $cssValue;
    }
}
