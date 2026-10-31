<?php

namespace App\Tests\Unit\EventSubscriber;

use App\EventSubscriber\PrimaryHostSubscriber;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\HttpKernelInterface;

class PrimaryHostSubscriberTest extends TestCase
{
    private function requete(string $primaryHost, string $url, int $type = HttpKernelInterface::MAIN_REQUEST): RequestEvent
    {
        $event = new RequestEvent($this->createStub(HttpKernelInterface::class), Request::create($url), $type);
        (new PrimaryHostSubscriber($primaryHost))->onRequest($event);

        return $event;
    }

    public function testLeDomaineNuRedirigeVersLeWww(): void
    {
        $response = $this->requete('www.bm-notaire.fr', 'https://bm-notaire.fr/expertises?page=2')->getResponse();

        $this->assertInstanceOf(RedirectResponse::class, $response);
        $this->assertSame(301, $response->getStatusCode());
        $this->assertSame('https://www.bm-notaire.fr/expertises?page=2', $response->getTargetUrl());
    }

    public function testUneAnciennePreprodRedirige(): void
    {
        $response = $this->requete('lesprodici.fr', 'https://prodici.comwebsolutions.fr/annuaire')->getResponse();

        $this->assertSame('https://lesprodici.fr/annuaire', $response?->getTargetUrl());
    }

    public function testLeDomainePrincipalPasse(): void
    {
        $this->assertNull($this->requete('www.bm-notaire.fr', 'https://WWW.bm-notaire.fr/')->getResponse());
    }

    public function testSansReglageRienNeChange(): void
    {
        $this->assertNull($this->requete('', 'http://localhost:8090/contact')->getResponse());
    }

    public function testLesSousRequetesNeSontPasRedirigees(): void
    {
        $this->assertNull($this->requete('www.bm-notaire.fr', 'https://bm-notaire.fr/', HttpKernelInterface::SUB_REQUEST)->getResponse());
    }
}
