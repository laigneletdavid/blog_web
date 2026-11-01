<?php

namespace App\Tests\Unit\Service;

use App\Service\SourceClassifier;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

class SourceClassifierTest extends TestCase
{
    public static function referers(): iterable
    {
        yield 'aucun referent' => [null, 'direct'];
        yield 'google' => ['https://www.google.com/', 'seo_google'];
        yield 'google etranger' => ['https://www.google.com.hk/', 'seo_google'];
        yield 'bing' => ['https://www.bing.com/search?q=x', 'seo_bing'];
        yield 'qwant, pas un reseau social' => ['https://www.qwant.com/', 'seo_other'];
        yield 'ecosia' => ['https://www.ecosia.org/', 'seo_other'];
        yield 'blogspot, pas twitter' => ['https://spam.blogspot.com/', 'referral'];
        yield 't.co' => ['https://t.co/abc', 'social_other'];
        yield 'x.com' => ['https://x.com/compte', 'social_other'];
        yield 'facebook mobile' => ['https://m.facebook.com/', 'social_facebook'];
        yield 'autre site' => ['https://www.toutvendre.fr/', 'referral'];
        yield 'le site lui-meme' => ['https://lesprodici.fr/annuaire', 'direct'];
        yield 'le site lui-meme avec www' => ['https://www.lesprodici.fr/', 'direct'];
    }

    #[DataProvider('referers')]
    public function testClassify(?string $referer, string $expected): void
    {
        [$source] = (new SourceClassifier())->classify($referer, null, null, 'lesprodici.fr');

        $this->assertSame($expected, $source);
    }

    public function testWithoutSiteHostOwnSiteIsReferral(): void
    {
        [$source] = (new SourceClassifier())->classify('https://lesprodici.fr/', null, null);

        $this->assertSame('referral', $source);
    }
}
