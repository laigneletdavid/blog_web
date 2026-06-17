<?php

namespace App\EventListener;

use App\Repository\SlugRedirectRepository;
use Symfony\Component\EventDispatcher\Attribute\AsEventListener;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

#[AsEventListener(event: 'kernel.exception', priority: 10)]
class SlugRedirectListener
{
    private const ROUTE_MAP = [
        'article' => 'app_article_show',
        'page' => 'app_page_show',
        'categorie' => 'app_categorie_show',
        'tag' => 'app_tag_show',
        'service' => 'app_service_show',
        'product' => 'app_product_show',
        'event' => 'app_event_show',
        'portfolio' => 'app_portfolio_show',
        'directory' => 'app_directory_show',
    ];

    private const PATH_PREFIX_MAP = [
        '/article/' => 'article',
        '/page/' => 'page',
        '/categorie/' => 'categorie',
        '/tag/' => 'tag',
        '/service/' => 'service',
        '/catalogue/' => 'product',
        '/evenement/' => 'event',
        '/realisation/' => 'portfolio',
        '/annuaire/' => 'directory',
    ];

    public function __construct(
        private readonly SlugRedirectRepository $redirectRepository,
        private readonly UrlGeneratorInterface $urlGenerator,
    ) {
    }

    public function __invoke(ExceptionEvent $event): void
    {
        $exception = $event->getThrowable();

        if (!$exception instanceof NotFoundHttpException) {
            return;
        }

        $path = $event->getRequest()->getPathInfo();

        foreach (self::PATH_PREFIX_MAP as $prefix => $entityType) {
            if (!str_starts_with($path, $prefix)) {
                continue;
            }

            $slug = substr($path, strlen($prefix));
            $slug = rtrim($slug, '/');

            if ($slug === '') {
                continue;
            }

            $redirect = $this->resolveChain($entityType, $slug);

            if ($redirect === null) {
                continue;
            }

            $route = self::ROUTE_MAP[$entityType];
            $url = $this->urlGenerator->generate($route, ['slug' => $redirect]);

            $event->setResponse(new RedirectResponse($url, 301));

            return;
        }
    }

    private function resolveChain(string $entityType, string $slug, int $maxDepth = 5): ?string
    {
        $current = $slug;

        for ($i = 0; $i < $maxDepth; $i++) {
            $redirect = $this->redirectRepository->findRedirect($entityType, $current);

            if ($redirect === null) {
                return $current === $slug ? null : $current;
            }

            $current = $redirect->getNewSlug();
        }

        return $current === $slug ? null : $current;
    }
}
