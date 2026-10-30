<?php

namespace App\Tests\Unit\Service;

use App\Service\BotDetector;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Cache\Adapter\ArrayAdapter;

class BotDetectorTest extends TestCase
{
    private BotDetector $detector;

    protected function setUp(): void
    {
        $this->detector = new BotDetector(new ArrayAdapter());
    }

    // ========== User-agent ==========

    #[DataProvider('robots')]
    public function testRobotsReconnus(?string $userAgent): void
    {
        $this->assertTrue($this->detector->isBotUserAgent($userAgent));
    }

    public static function robots(): iterable
    {
        yield 'absent' => [null];
        yield 'vide' => [''];
        yield 'trop court' => ['Mozilla/5.0'];
        yield 'Majestic' => ['Mozilla/5.0 (compatible; MJ12bot/v1.4.8; http://mj12bot.com/)'];
        yield 'Baidu' => ['Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)'];
        yield 'Semrush' => ['Mozilla/5.0 (compatible; SemrushBot/7~bl; +http://www.semrush.com/bot.html)'];
        yield 'Facebook' => ['facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)'];
        yield 'faux Android' => ['Mozilla/5.0 (Linux; Android 7.0;) AppleWebKit/537.36 (HTML, like Gecko) Mobile Safari/537.36'];
        yield 'curl' => ['curl/8.5.0 (x86_64-pc-linux-gnu) libcurl/8.5.0'];
        yield 'python' => ['python-requests/2.31.0 (scraper de test)'];
        yield 'Chrome sans tete' => ['Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/120.0 Safari/537.36'];
    }

    #[DataProvider('navigateurs')]
    public function testNavigateursAcceptes(string $userAgent): void
    {
        $this->assertFalse($this->detector->isBotUserAgent($userAgent));
    }

    public static function navigateurs(): iterable
    {
        yield 'Chrome Windows' => ['Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36'];
        yield 'Safari iPhone' => ['Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1'];
        yield 'Firefox' => ['Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0'];
        yield 'Chrome Android' => ['Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36'];
    }

    // ========== Cadence par IP ==========

    public function testUnHumainPasseSousLaCadence(): void
    {
        for ($i = 0; $i < 20; ++$i) {
            $this->assertFalse($this->detector->isFlooding('ip-humaine'));
        }
    }

    public function testAuDelaDeVingtPagesLaMinuteLIpEstUnRobot(): void
    {
        for ($i = 0; $i < 20; ++$i) {
            $this->detector->isFlooding('ip-robot');
        }

        $this->assertTrue($this->detector->isFlooding('ip-robot'));
        // Marquee pour la journee, meme si la cadence retombe
        $this->assertTrue($this->detector->isFlooding('ip-robot'));
    }

    public function testIsFlaggedNeCompteRien(): void
    {
        for ($i = 0; $i < 50; ++$i) {
            $this->assertFalse($this->detector->isFlagged('ip-humaine'));
        }
        $this->assertFalse($this->detector->isFlooding('ip-humaine'));

        for ($i = 0; $i < 20; ++$i) {
            $this->detector->isFlooding('ip-robot');
        }
        $this->assertFalse($this->detector->isFlagged('ip-robot'));
        $this->detector->isFlooding('ip-robot');
        $this->assertTrue($this->detector->isFlagged('ip-robot'));
    }

    public function testLesIpSontCompteesSeparement(): void
    {
        for ($i = 0; $i < 25; ++$i) {
            $this->detector->isFlooding('ip-robot');
        }

        $this->assertFalse($this->detector->isFlooding('ip-voisine'));
    }
}
