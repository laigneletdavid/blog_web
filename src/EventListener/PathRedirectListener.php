<?php

namespace App\EventListener;

use App\Repository\SlugRedirectRepository;
use Symfony\Component\EventDispatcher\Attribute\AsEventListener;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Event\RequestEvent;

/**
 * Redirection 301 d'un chemin fixe vers un autre (ex. /services -> /).
 *
 * Complete SlugRedirectListener, qui ne couvre que les slugs d'entites et
 * n'agit que sur un 404 : ici le chemin peut etre une route qui existe encore.
 * Stocke dans slug_redirect avec entity_type = 'chemin', old_slug = chemin
 * d'origine, new_slug = chemin cible. Cible interne uniquement (commence par
 * un seul /) : pas de redirection ouverte vers un autre site.
 *
 * Priorite 40 : avant le routeur (32), pour qu'un chemin sans route soit
 * redirige lui aussi au lieu de finir en 404.
 */
#[AsEventListener(event: 'kernel.request', priority: 40)]
class PathRedirectListener
{
    public const TYPE = 'chemin';

    public function __construct(
        private readonly SlugRedirectRepository $redirectRepository,
    ) {
    }

    public function __invoke(RequestEvent $event): void
    {
        if (!$event->isMainRequest()) {
            return;
        }

        $request = $event->getRequest();
        if (!$request->isMethod('GET') && !$request->isMethod('HEAD')) {
            return;
        }

        $path = $request->getPathInfo();
        // Admin, profiler et fichiers (assets, medias) : jamais concernes.
        if (str_starts_with($path, '/admin') || str_starts_with($path, '/_') || str_contains(basename($path), '.')) {
            return;
        }

        $chemin = $path === '/' ? '/' : rtrim($path, '/');
        $redirect = $this->redirectRepository->findRedirect(self::TYPE, $chemin);
        if ($redirect === null) {
            return;
        }

        $cible = (string) $redirect->getNewSlug();
        if (!str_starts_with($cible, '/') || str_starts_with($cible, '//') || $cible === $chemin) {
            return;
        }

        $query = $request->getQueryString();
        $event->setResponse(new RedirectResponse($query ? $cible . '?' . $query : $cible, 301));
    }
}
