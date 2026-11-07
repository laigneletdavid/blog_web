<?php

namespace App\Tests\Unit\Service;

use App\Entity\Option;
use App\Entity\Site;
use App\Repository\OptionRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use PHPUnit\Framework\TestCase;

class SeoServicePageSystemeTest extends TestCase
{
    private function service(array $options): SeoService
    {
        $site = $this->createMock(Site::class);
        $site->method('getName')->willReturn('Com Web Solutions');
        $site->method('getDefaultSeoDescription')->willReturn('Description de la home');
        $context = $this->createMock(SiteContext::class);
        $context->method('getCurrentSite')->willReturn($site);

        $repo = $this->createMock(OptionRepository::class);
        $repo->method('findOneBy')->willReturnCallback(function (array $critere) use ($options) {
            $nom = $critere['name'];
            return array_key_exists($nom, $options) ? (new Option())->setName($nom)->setValue($options[$nom]) : null;
        });

        return new SeoService($context, $repo);
    }

    public function testSansOptionRenduParDefaut(): void
    {
        $seo = $this->service([])->resolveForPage('Contact', 'Contactez %s.', 'contact');

        $this->assertSame('Contact — Com Web Solutions', $seo['title']);
        $this->assertSame('Contactez Com Web Solutions.', $seo['description']);
    }

    public function testOptionsDuSitePrisesTellesQuelles(): void
    {
        $seo = $this->service([
            'seo.contact.title' => 'Contact et rendez-vous — Com Web Solutions',
            'seo.contact.description' => 'Prenez rendez-vous en ligne.',
        ])->resolveForPage('Contact', 'Contactez %s.', 'contact');

        $this->assertSame('Contact et rendez-vous — Com Web Solutions', $seo['title']);
        $this->assertSame('Prenez rendez-vous en ligne.', $seo['description']);
    }

    public function testOptionVideIgnoreeEtSansCleRienNeChange(): void
    {
        $service = $this->service(['seo.blog.title' => '  ', 'seo.blog.description' => 'Conseils']);

        $this->assertSame('Blog — Com Web Solutions', $service->resolveForPage('Blog', null, 'blog')['title']);
        $this->assertSame('Conseils', $service->resolveForPage('Blog', null, 'blog')['description']);
        $this->assertSame('Description de la home', $service->resolveForPage('Blog')['description']);
    }
}
