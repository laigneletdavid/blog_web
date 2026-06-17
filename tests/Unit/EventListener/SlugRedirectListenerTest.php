<?php

namespace App\Tests\Unit\EventListener;

use App\Entity\SlugRedirect;
use App\EventListener\SlugRedirectListener;
use App\Repository\SlugRedirectRepository;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\HttpKernel\HttpKernelInterface;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class SlugRedirectListenerTest extends TestCase
{
    private SlugRedirectRepository $repo;
    private UrlGeneratorInterface $urlGenerator;
    private SlugRedirectListener $listener;

    protected function setUp(): void
    {
        $this->repo = $this->createMock(SlugRedirectRepository::class);
        $this->urlGenerator = $this->createMock(UrlGeneratorInterface::class);
        $this->listener = new SlugRedirectListener($this->repo, $this->urlGenerator);
    }

    public function testRedirect301SurAncienSlugArticle(): void
    {
        $redirect = $this->makeRedirect('article', 'ancien-article', 'nouveau-article');

        $this->repo->method('findRedirect')
            ->willReturnCallback(fn(string $type, string $slug) => $slug === 'ancien-article' ? $redirect : null);

        $this->urlGenerator->method('generate')
            ->with('app_article_show', ['slug' => 'nouveau-article'])
            ->willReturn('/article/nouveau-article');

        $event = $this->createExceptionEvent('/article/ancien-article');
        ($this->listener)($event);

        $response = $event->getResponse();
        $this->assertInstanceOf(RedirectResponse::class, $response);
        $this->assertSame(301, $response->getStatusCode());
        $this->assertSame('/article/nouveau-article', $response->getTargetUrl());
    }

    public function testPasDeRedirectSiSlugInconnu(): void
    {
        $this->repo->method('findRedirect')->willReturn(null);

        $event = $this->createExceptionEvent('/article/slug-inconnu');
        ($this->listener)($event);

        $this->assertNull($event->getResponse());
    }

    public function testIgnoreExceptionsNon404(): void
    {
        $event = $this->createExceptionEvent('/article/test', new \RuntimeException('erreur'));
        ($this->listener)($event);

        $this->assertNull($event->getResponse());
    }

    public function testResolutionChaine(): void
    {
        $redirect1 = $this->makeRedirect('article', 'slug-v1', 'slug-v2');
        $redirect2 = $this->makeRedirect('article', 'slug-v2', 'slug-v3');

        $this->repo->method('findRedirect')
            ->willReturnCallback(function (string $type, string $slug) use ($redirect1, $redirect2) {
                return match ($slug) {
                    'slug-v1' => $redirect1,
                    'slug-v2' => $redirect2,
                    default => null,
                };
            });

        $this->urlGenerator->method('generate')
            ->with('app_article_show', ['slug' => 'slug-v3'])
            ->willReturn('/article/slug-v3');

        $event = $this->createExceptionEvent('/article/slug-v1');
        ($this->listener)($event);

        $response = $event->getResponse();
        $this->assertInstanceOf(RedirectResponse::class, $response);
        $this->assertSame('/article/slug-v3', $response->getTargetUrl());
    }

    public function testPrefixeCatalogue(): void
    {
        $redirect = $this->makeRedirect('product', 'ancien-produit', 'nouveau-produit');

        $this->repo->method('findRedirect')
            ->willReturnCallback(fn(string $type, string $slug) => $slug === 'ancien-produit' ? $redirect : null);

        $this->urlGenerator->method('generate')
            ->with('app_product_show', ['slug' => 'nouveau-produit'])
            ->willReturn('/catalogue/nouveau-produit');

        $event = $this->createExceptionEvent('/catalogue/ancien-produit');
        ($this->listener)($event);

        $response = $event->getResponse();
        $this->assertInstanceOf(RedirectResponse::class, $response);
        $this->assertSame(301, $response->getStatusCode());
    }

    public function testPrefixeEvenement(): void
    {
        $redirect = $this->makeRedirect('event', 'ancien-event', 'nouveau-event');

        $this->repo->method('findRedirect')
            ->willReturnCallback(fn(string $type, string $slug) => $slug === 'ancien-event' ? $redirect : null);

        $this->urlGenerator->method('generate')
            ->with('app_event_show', ['slug' => 'nouveau-event'])
            ->willReturn('/evenement/nouveau-event');

        $event = $this->createExceptionEvent('/evenement/ancien-event');
        ($this->listener)($event);

        $this->assertInstanceOf(RedirectResponse::class, $event->getResponse());
    }

    public function testUrlSansSlugIgnoree(): void
    {
        $event = $this->createExceptionEvent('/article/');
        ($this->listener)($event);

        $this->assertNull($event->getResponse());
    }

    public function testPrefixeInconnuIgnore(): void
    {
        $event = $this->createExceptionEvent('/contact/test');
        ($this->listener)($event);

        $this->assertNull($event->getResponse());
    }

    // ========== Helpers ==========

    private function createExceptionEvent(string $path, ?\Throwable $exception = null): ExceptionEvent
    {
        $request = Request::create($path);
        $kernel = $this->createMock(HttpKernelInterface::class);
        $exception ??= new NotFoundHttpException();

        return new ExceptionEvent($kernel, $request, HttpKernelInterface::MAIN_REQUEST, $exception);
    }

    private function makeRedirect(string $entityType, string $oldSlug, string $newSlug): SlugRedirect
    {
        $redirect = new SlugRedirect();
        $redirect->setEntityType($entityType);
        $redirect->setOldSlug($oldSlug);
        $redirect->setNewSlug($newSlug);

        return $redirect;
    }
}
