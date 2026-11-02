<?php

namespace App\Service;

use App\Entity\Media;
use App\Entity\Site;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;
use Intervention\Image\Interfaces\ImageInterface;

class FaviconGeneratorService
{
    /**
     * Longueur retenue pour le nom court. Les recommandations parlent de douze
     * caracteres, mais couper si tot ampute le nom utile -- « Maitre Bruno
     * Mainguy » tombait a « Maitre ». Vingt tient sur les ecrans d'accueil et
     * laisse passer un prenom suivi d'un nom.
     */
    private const SHORT_NAME_MAX = 20;

    /** Onglet du navigateur : fond transparent, l'image occupe tout le carre. */
    private const TAB_SIZES = [
        'favicon-16x16.png' => 16,
        'favicon-32x32.png' => 32,
        'favicon-96x96.png' => 96,
    ];

    /**
     * Ecrans d'accueil : fond blanc, car iOS remplit le transparent en noir,
     * et une marge (part du cote occupee par l'image). Les icones Android sont
     * declarees « maskable » : le systeme les decoupe en cercle de 80 %.
     */
    private const HOME_SCREEN_SIZES = [
        'apple-touch-icon.png' => [180, 0.8],
        'mstile-150x150.png' => [150, 0.7],
        'android-chrome-192x192.png' => [192, 0.72],
        'android-chrome-512x512.png' => [512, 0.72],
    ];

    /** Images embarquees dans favicon.ico, que certains navigateurs demandent d'office. */
    private const ICO_SIZES = [16, 32, 48];

    public function __construct(
        private readonly string $mediaDirectory,
        private readonly string $publicDirectory,
    ) {
    }

    /**
     * Genere les favicons depuis l'icone du site ou, a defaut, depuis le logo.
     * L'image est toujours contenue, jamais rognee : un logo horizontal tient
     * entier dans le carre au lieu d'y perdre ses bords.
     */
    public function generate(Media $source): void
    {
        $sourcePath = $this->mediaDirectory . '/' . $source->getFileName();
        if (!file_exists($sourcePath)) {
            return;
        }

        $manager = new ImageManager(new Driver());

        try {
            foreach (self::TAB_SIZES as $filename => $size) {
                $this->square($manager, $sourcePath, $size, 1.0, false)
                    ->toPng()->save($this->publicDirectory . '/' . $filename);
            }

            foreach (self::HOME_SCREEN_SIZES as $filename => [$size, $scale]) {
                $this->square($manager, $sourcePath, $size, $scale, true)
                    ->toPng()->save($this->publicDirectory . '/' . $filename);
            }

            $pngs = [];
            foreach (self::ICO_SIZES as $size) {
                $pngs[$size] = (string) $this->square($manager, $sourcePath, $size, 1.0, false)->toPng();
            }
            file_put_contents($this->publicDirectory . '/favicon.ico', $this->ico($pngs));
        } catch (\Throwable) {
            // Silent failure — default favicons remain
        }
    }

    /** L'image contenue dans un carre de $size, sur $scale de son cote. */
    private function square(ImageManager $manager, string $sourcePath, int $size, float $scale, bool $whiteBackground): ImageInterface
    {
        $inner = max(1, (int) round($size * $scale));
        $image = $manager->read($sourcePath)->contain($inner, $inner, 'transparent');

        $canvas = $manager->create($size, $size);
        if ($whiteBackground) {
            $canvas->fill('ffffff');
        }

        return $canvas->place($image, 'center');
    }

    /**
     * Conteneur ICO dont chaque entree est une image PNG (format lu par tous
     * les navigateurs actuels).
     *
     * @param array<int, string> $pngs taille => contenu PNG
     */
    private function ico(array $pngs): string
    {
        $header = pack('vvv', 0, 1, \count($pngs));
        $offset = 6 + 16 * \count($pngs);
        $data = '';
        foreach ($pngs as $size => $png) {
            $header .= pack('CCCCvvVV', $size, $size, 0, 0, 1, 32, \strlen($png), $offset);
            $offset += \strlen($png);
            $data .= $png;
        }

        return $header . $data;
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
