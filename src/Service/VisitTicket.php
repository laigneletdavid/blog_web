<?php

namespace App\Service;

use Symfony\Component\DependencyInjection\Attribute\Autowire;

/**
 * Ticket de visite : signe par le serveur sur chaque page servie (balise
 * meta, voir PageViewSubscriber), renvoye par stat-tracker.js pour que la
 * visite soit enregistree.
 *
 * Seule une page reellement servie (200, HTML) recoit un ticket : une page
 * d'erreur ou une requete fabriquee a la main ne compte pas. Le chemin vient
 * du ticket, pas du navigateur.
 */
class VisitTicket
{
    private const MAX_AGE = 600; // 10 minutes entre la page et sa confirmation

    public function __construct(
        #[Autowire('%kernel.secret%')]
        private readonly string $secret,
    ) {
    }

    public function issue(string $path, ?int $now = null): string
    {
        $payload = ($now ?? time()) . '|' . $path;

        return base64_encode($payload) . '.' . $this->sign($payload);
    }

    /**
     * @return string|null le chemin de la page, ou null si le ticket est faux ou perime
     */
    public function verify(string $ticket, ?int $now = null): ?string
    {
        [$encoded, $signature] = array_pad(explode('.', $ticket, 2), 2, '');
        $payload = base64_decode($encoded, true);

        if ($payload === false || !hash_equals($this->sign($payload), $signature)) {
            return null;
        }

        [$issuedAt, $path] = array_pad(explode('|', $payload, 2), 2, '');
        $age = ($now ?? time()) - (int) $issuedAt;

        if ($path === '' || $age < 0 || $age > self::MAX_AGE) {
            return null;
        }

        return $path;
    }

    private function sign(string $payload): string
    {
        return hash_hmac('sha256', $payload, $this->secret);
    }
}
