<?php

namespace App\Service;

/**
 * Fabrique une carte statique en assemblant des tuiles raster.
 *
 * Le resultat est une image servie par le site : aucun appel a un service tiers
 * au moment de l'affichage, donc aucun cookie tiers, aucune cle d'API et aucun
 * risque de cadre vide si un fournisseur ferme son point d'entree — ce qui est
 * arrive successivement a l'integration Google sans cle et a celle d'OSM.
 */
class StaticMapService
{
    public const TILE_SIZE = 256;

    /**
     * Fonds disponibles : gabarit d'URL et mention d'attribution obligatoire.
     *
     * @var array<string, array{url: string, attribution: string, label: string}>
     */
    public const STYLES = [
        'positron' => [
            'url' => 'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
            'attribution' => '© OpenStreetMap contributors © CARTO',
            'label' => 'Gris clair, quasi monochrome',
        ],
        'positron-nolabels' => [
            'url' => 'https://basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
            'attribution' => '© OpenStreetMap contributors © CARTO',
            'label' => 'Gris clair sans noms de rues',
        ],
        'dark' => [
            'url' => 'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
            'attribution' => '© OpenStreetMap contributors © CARTO',
            'label' => 'Sombre',
        ],
        'voyager' => [
            'url' => 'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
            'attribution' => '© OpenStreetMap contributors © CARTO',
            'label' => 'Couleurs douces',
        ],
        'osm' => [
            'url' => 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            'attribution' => '© OpenStreetMap contributors',
            'label' => 'OpenStreetMap standard, colore',
        ],
    ];

    private const USER_AGENT = 'BlogWebCMS/1.0 (+https://blogweb.comwebsolutions.fr)';

    public function __construct(
        private readonly string $projectDir,
    ) {
    }

    /**
     * Convertit une adresse en coordonnees via Nominatim.
     *
     * @return array{lat: float, lon: float, display: string}|null
     */
    public function geocode(string $address): ?array
    {
        $url = 'https://nominatim.openstreetmap.org/search?format=json&limit=1&q=' . rawurlencode($address);
        $json = @file_get_contents($url, false, $this->httpContext());

        if ($json === false) {
            return null;
        }

        $data = json_decode($json, true);
        if (!is_array($data) || $data === []) {
            return null;
        }

        return [
            'lat' => (float) $data[0]['lat'],
            'lon' => (float) $data[0]['lon'],
            'display' => (string) ($data[0]['display_name'] ?? $address),
        ];
    }

    /**
     * Genere l'image et renvoie le chemin relatif a public/.
     *
     * @return array{path: string, tiles: int, failed: int, bytes: int}
     */
    public function generate(
        float $lat,
        float $lon,
        string $fileName,
        string $style = 'positron',
        int $zoom = 16,
        int $width = 900,
        int $height = 560,
    ): array {
        if (!isset(self::STYLES[$style])) {
            throw new \InvalidArgumentException(sprintf('Fond inconnu "%s". Disponibles : %s.', $style, implode(', ', array_keys(self::STYLES))));
        }

        $config = self::STYLES[$style];

        // Projection slippy map : position du centre en pixels dans la grille mondiale.
        $n = 2 ** $zoom;
        $latRad = deg2rad($lat);
        $centerX = ($lon + 180) / 360 * $n * self::TILE_SIZE;
        $centerY = (1 - log(tan($latRad) + 1 / cos($latRad)) / M_PI) / 2 * $n * self::TILE_SIZE;

        $left = $centerX - $width / 2;
        $top = $centerY - $height / 2;

        $canvas = imagecreatetruecolor($width, $height);
        imagefilledrectangle($canvas, 0, 0, $width, $height, imagecolorallocate($canvas, 238, 243, 243));

        $tiles = 0;
        $failed = 0;

        for ($tx = (int) floor($left / self::TILE_SIZE); $tx <= (int) floor(($left + $width) / self::TILE_SIZE); $tx++) {
            for ($ty = (int) floor($top / self::TILE_SIZE); $ty <= (int) floor(($top + $height) / self::TILE_SIZE); $ty++) {
                $url = str_replace(['{z}', '{x}', '{y}'], [$zoom, $tx, $ty], $config['url']);
                $data = @file_get_contents($url, false, $this->httpContext());

                if ($data === false || ($tile = @imagecreatefromstring($data)) === false) {
                    $failed++;
                    continue;
                }

                imagecopy(
                    $canvas,
                    $tile,
                    (int) round($tx * self::TILE_SIZE - $left),
                    (int) round($ty * self::TILE_SIZE - $top),
                    0,
                    0,
                    self::TILE_SIZE,
                    self::TILE_SIZE,
                );
                imagedestroy($tile);
                $tiles++;
            }
        }

        if ($tiles === 0) {
            imagedestroy($canvas);
            throw new \RuntimeException('Aucune tuile recuperee : verifier la connexion sortante.');
        }

        $this->drawMarker($canvas, (int) round($width / 2), (int) round($height / 2), $style === 'dark');
        $this->drawAttribution($canvas, $width, $height, $config['attribution']);

        $dir = $this->projectDir . '/public/documents/medias';
        if (!is_dir($dir)) {
            mkdir($dir, 0775, true);
        }

        $relative = 'documents/medias/' . $fileName . '.webp';
        imagewebp($canvas, $this->projectDir . '/public/' . $relative, 82);
        imagedestroy($canvas);

        return [
            'path' => $relative,
            'tiles' => $tiles,
            'failed' => $failed,
            'bytes' => filesize($this->projectDir . '/public/' . $relative),
        ];
    }

    /**
     * Goutte pleine, cerclee de la couleur opposee pour rester lisible sur
     * un fond clair comme sur un fond sombre.
     */
    private function drawMarker(\GdImage $canvas, int $cx, int $cy, bool $onDark): void
    {
        $body = $onDark
            ? imagecolorallocate($canvas, 255, 255, 255)
            : imagecolorallocate($canvas, 39, 49, 51);
        $ring = $onDark
            ? imagecolorallocate($canvas, 39, 49, 51)
            : imagecolorallocate($canvas, 255, 255, 255);

        imagefilledpolygon($canvas, [$cx - 10, $cy + 6, $cx + 10, $cy + 6, $cx, $cy + 30], $body);
        imagefilledellipse($canvas, $cx, $cy, 26, 26, $body);
        imageellipse($canvas, $cx, $cy, 30, 30, $ring);
        imagefilledellipse($canvas, $cx, $cy, 9, 9, $ring);
    }

    /**
     * L'attribution est incrustee dans l'image : la licence ODbL d'OpenStreetMap
     * l'impose, et l'incruster garantit qu'elle suit l'image partout ou elle est
     * reprise.
     */
    private function drawAttribution(\GdImage $canvas, int $width, int $height, string $text): void
    {
        // Les polices bitmap de GD ne couvrent pas les caracteres non ASCII :
        // le symbole du copyright y ressort en lettre accentuee. On l'ecrit donc
        // en toutes lettres, ce que la licence admet.
        $ascii = str_replace('©', '(c)', $text);
        $ascii = preg_replace('/[^ -~]/', '', $ascii) ?? $ascii;
        $font = 2;
        $textWidth = imagefontwidth($font) * strlen($ascii);
        $textHeight = imagefontheight($font);

        $padX = 6;
        $padY = 3;
        $boxWidth = $textWidth + $padX * 2;
        $boxHeight = $textHeight + $padY * 2;
        $x = $width - $boxWidth;
        $y = $height - $boxHeight;

        $veil = imagecolorallocatealpha($canvas, 255, 255, 255, 40);
        imagefilledrectangle($canvas, $x, $y, $width, $height, $veil);
        imagestring($canvas, $font, $x + $padX, $y + $padY, $ascii, imagecolorallocate($canvas, 70, 78, 80));
    }

    /**
     * @return resource
     */
    private function httpContext()
    {
        return stream_context_create([
            'http' => [
                'header' => 'User-Agent: ' . self::USER_AGENT . "\r\n",
                'timeout' => 20,
            ],
        ]);
    }
}
