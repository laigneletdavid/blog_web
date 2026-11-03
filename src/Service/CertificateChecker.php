<?php

namespace App\Service;

/**
 * Lit le certificat SSL d'un domaine depuis le serveur, sans le valider :
 * le but est de connaitre sa date d'expiration, meme s'il est deja perime.
 */
class CertificateChecker
{
    /**
     * Jours avant l'expiration du certificat, null si le domaine ne repond pas.
     */
    public function daysLeft(string $host): ?int
    {
        $host = trim($host);
        if ($host === '') {
            return null;
        }

        $context = stream_context_create(['ssl' => ['capture_peer_cert' => true, 'verify_peer' => false, 'verify_peer_name' => false]]);
        $socket = @stream_socket_client("ssl://{$host}:443", $errno, $errstr, 10, STREAM_CLIENT_CONNECT, $context);
        if (!$socket) {
            return null;
        }

        $certificate = openssl_x509_parse(stream_context_get_params($socket)['options']['ssl']['peer_certificate'] ?? '');
        fclose($socket);

        if (!$certificate || !isset($certificate['validTo_time_t'])) {
            return null;
        }

        return (int) floor(($certificate['validTo_time_t'] - time()) / 86400);
    }
}
