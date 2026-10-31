<?php

namespace App\EventSubscriber;

use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\KernelEvents;

/**
 * Une seule adresse publique par site : toute requete arrivee sur un autre
 * domaine (www ou non, ancienne preprod *.comwebsolutions.fr...) repart en
 * 301 vers https://APP_PRIMARY_HOST, meme chemin. Evite le contenu en double
 * dans Google.
 *
 * APP_PRIMARY_HOST se regle dans le .env.local du serveur (ex. www.bm-notaire.fr) :
 * rien n'est versionne par client, donc aucun conflit au merge tactique.
 * Vide (en local, par defaut), rien ne change. Le passage en https est fait
 * avant, par public/.htaccess.
 */
class PrimaryHostSubscriber implements EventSubscriberInterface
{
    public function __construct(
        #[Autowire('%env(APP_PRIMARY_HOST)%')]
        private readonly string $primaryHost,
    ) {
    }

    public static function getSubscribedEvents(): array
    {
        // Avant le routeur et la securite : inutile de traiter la requete
        return [
            KernelEvents::REQUEST => ['onRequest', 512],
        ];
    }

    public function onRequest(RequestEvent $event): void
    {
        $primaryHost = strtolower(trim($this->primaryHost));
        if ($primaryHost === '' || !$event->isMainRequest()) {
            return;
        }

        $request = $event->getRequest();
        if (strtolower($request->getHost()) === $primaryHost) {
            return;
        }

        $event->setResponse(new RedirectResponse('https://' . $primaryHost . $request->getRequestUri(), 301));
    }
}
