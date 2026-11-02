<?php

namespace App\Service;

/**
 * Compte les erreurs CRITICAL d'un journal Monolog depuis une date.
 *
 * Lignes au format « [2026-11-02T05:51:12.123456+01:00] request.CRITICAL: ... » :
 * l'horodatage ISO se compare en texte. Lecture ligne a ligne, le journal
 * de prod peut peser plusieurs centaines de Mo.
 */
class CriticalLogScanner
{
    /**
     * @return array{count: int, last: ?string} nombre d'erreurs et debut de la derniere
     */
    public function scan(string $logFile, \DateTimeImmutable $since): array
    {
        $result = ['count' => 0, 'last' => null];
        if (!is_readable($logFile)) {
            return $result;
        }

        $handle = fopen($logFile, 'r');
        if ($handle === false) {
            return $result;
        }

        $sinceText = $since->format('Y-m-d\TH:i:s');
        while (($line = fgets($handle)) !== false) {
            if (!str_contains($line, '.CRITICAL:') || substr($line, 1, 19) < $sinceText) {
                continue;
            }
            ++$result['count'];
            $result['last'] = mb_substr(trim($line), 0, 300);
        }
        fclose($handle);

        return $result;
    }
}
