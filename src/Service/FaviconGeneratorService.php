<?php

namespace App\Service;

use App\Entity\Media;
use App\Entity\Site;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;

class FaviconGeneratorService
{
    /**
     * Longueur retenue pour le nom court. Les recommandations parlent de douze
     * caracteres, mais couper si tot ampute le nom utile -- « Maitre Bruno
     * Mainguy » tombait a « Maitre ». Vingt tient sur les ecrans d'accueil et
     * laisse passer un prenom suivi d'un nom.
     */
    private const SHORT_NAME_MAX = 20;

    private const FAVICON_SIZES = [
        'favicon-16x16.png' => 16,
        'favicon-32x32.png' => 32,
        'favicon-96x96.png' => 96,
        'apple-touch-icon.png' => 180,
        'mstile-150x150.png' => 150,
        'android-chrome-192x192.png' => 192,
        'android-chrome-512x512.png' => 512,
    ];

    public function __construct(
        private readonly string $mediaDirectory,
        private readonly string $publicDirectory,
    ) {
    }

    public function generateFromLogo(Media $logo): void
    {
        $sourcePath = $this->mediaDirectory . '/' . $logo->getFileName();
        if (!file_exists($sourcePath)) {
            return;
        }

        $manager = new ImageManager(new Driver());

        foreach (self::FAVICON_SIZES as $filename => $size) {
            try {
                $image = $manager->read($sourcePath);
                $image->cover($size, $size);
                $image->toPng()->save($this->publicDirectory . '/' . $filename);
            } catch (\Throwable) {
                // Silent failure — default favicons remain
            }
        }
    }

    /**
     * Nom court du manifeste : c'est ce qui s'affiche sous l'icone une fois le
     * site ajoute a un ecran d'accueil, ou une douzaine de caracteres passent.
     * Recopier le nom complet le fait tronquer par le systeme, n'importe ou.
     * On coupe donc a la premiere ponctuation, puis sur un mot entier.
     */
    private function shortName(?string $name): string
    {
        $name = trim((string) $name);
        if ($name === '') {
            return 'Site';
        }

        // « Maitre Bruno Mainguy, notaire a Saint-Martory » -> « Maitre Bruno Mainguy »
        $court = trim((string) preg_split('/\s*[,|:\x{2013}\x{2014}\x{00B7}]|\s+-\s+/u', $name, 2)[0]);
        if ($court === '') {
            $court = $name;
        }

        if (mb_strlen($court) <= self::SHORT_NAME_MAX) {
            return $court;
        }

        // Troncature sur un mot entier. On prend un caractere de plus que la
        // limite : s'il s'agit d'un espace, la coupe tombe deja juste et il
        // serait dommage de reculer jusqu'au mot precedent.
        $coupe = mb_substr($court, 0, self::SHORT_NAME_MAX + 1);
        $espace = mb_strrpos($coupe, ' ');
        if ($espace === false || $espace === 0) {
            return mb_substr($court, 0, self::SHORT_NAME_MAX);
        }

        return rtrim(mb_substr($coupe, 0, $espace));
    }

    public function generateWebManifest(Site $site): void
    {
        $manifest = [
            'name' => $site->getName() ?? 'Mon site',
            'short_name' => $this->shortName($site->getName()),
            'icons' => [
                [
                    'src' => '/android-chrome-192x192.png',
                    'sizes' => '192x192',
                    'type' => 'image/png',
                    'purpose' => 'maskable',
                ],
                [
                    'src' => '/android-chrome-512x512.png',
                    'sizes' => '512x512',
                    'type' => 'image/png',
                    'purpose' => 'maskable',
                ],
            ],
            'theme_color' => $site->getPrimaryColor() ?? '#ffffff',
            'background_color' => '#ffffff',
            'display' => 'standalone',
        ];

        file_put_contents(
            $this->publicDirectory . '/site.webmanifest',
            json_encode($manifest, \JSON_PRETTY_PRINT | \JSON_UNESCAPED_SLASHES),
        );
    }

    public function generateBrowserConfig(Site $site): void
    {
        $tileColor = $site->getPrimaryColor() ?? '#ffffff';

        $xml = <<<XML
        <?xml version="1.0" encoding="utf-8"?>
        <browserconfig>
            <msapplication>
                <tile>
                    <square150x150logo src="/mstile-150x150.png"/>
                    <TileColor>{$tileColor}</TileColor>
                </tile>
            </msapplication>
        </browserconfig>
        XML;

        file_put_contents($this->publicDirectory . '/browserconfig.xml', $xml);
    }
}
