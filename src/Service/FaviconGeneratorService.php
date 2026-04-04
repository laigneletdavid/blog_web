<?php

namespace App\Service;

use App\Entity\Media;
use App\Entity\Site;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;

class FaviconGeneratorService
{
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

    public function generateWebManifest(Site $site): void
    {
        $manifest = [
            'name' => $site->getName() ?? 'Mon site',
            'short_name' => $site->getName() ?? 'Site',
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
