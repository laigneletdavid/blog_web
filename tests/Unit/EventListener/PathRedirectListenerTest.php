<?php

namespace App\Tests\Unit\EventListener;

use App\Entity\SlugRedirect;
use App\EventListener\PathRedirectListener;
use App\Repository\SlugRedirectRepository;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\HttpKernelInterface;

class PathRedirectListenerTest extends TestCase
{
    private function listener(?string $cible, ?string &$cherche = null): PathRedirectListener
    {
        $repo = $this->createMock(SlugRedirectRepository::class);
        $repo->method('findRedirect')->willReturnCallback(function (string $type, string $chemin) use ($cible, &$cherche) {
            $cherche = $chemin;
            if ($type !== PathRedirectListener::TYPE || $cible === null) {
                return null;
            }
            return (new SlugRedirect())->setEntityType($type)->setOldSlug($chemin)->setNewSlug($cible);
        });

        return new PathRedirectListener($repo);
    }

    private function event(string $uri, string $method = 'GET', int $type = HttpKernelInterface::MAIN_REQUEST): RequestEvent
    {
        return new RequestEvent($this->createMock(HttpKernelInterface::class), Request::create($uri, $method), $type);
    }

    public function testRedirect301VersLaCible(): void
    {
        $event = $this->event('/services');
        ($this->listener('/'))($event);

        $response = $event->getResponse();
        $this->assertInstanceOf(RedirectResponse::class, $response);
        $this->assertSame(301, $response->getStatusCode());
        $this->assertSame('/', $response->getTargetUrl());
    }

    public function testSlashFinalIgnoreEtQueryConservee(): void
    {
        $event = $this->event('/services/?utm_source=x');
        ($this->listener('/', $cherche))($event);

        $this->assertSame('/services', $cherche);
        $this->assertSame('/?utm_source=x', $event->getResponse()->getTargetUrl());
    }

    public function testRienSiAucuneRedirection(): void
    {
        $event = $this->event('/services');
        ($this->listener(null))($event);

        $this->assertNull($event->getResponse());
    }

    public function testCibleExterneRefusee(): void
    {
        foreach (['https://exemple.com', '//exemple.com', 'exemple.com'] as $cible) {
            $event = $this->event('/services');
            ($this->listener($cible))($event);
            $this->assertNull($event->getResponse(), $cible);
        }
    }

    public function testIgnorePostAdminFichiersEtSousRequetes(): void
    {
        $cas = [
            $this->event('/services', 'POST'),
            $this->event('/admin/services'),
            $this->event('/build/app.css'),
            $this->event('/services', 'GET', HttpKernelInterface::SUB_REQUEST),
        ];
        foreach ($cas as $event) {
            ($this->listener('/'))($event);
            $this->assertNull($event->getResponse());
        }
    }
}
