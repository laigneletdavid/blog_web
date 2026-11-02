<?php

namespace App\Tests\Unit\Service;

use App\Service\CriticalLogScanner;
use App\Service\SiteAlertChecker;
use PHPUnit\Framework\TestCase;

class SiteAlertsTest extends TestCase
{
    public function testCriticalErrorsOnlySinceDate(): void
    {
        $log = tempnam(sys_get_temp_dir(), 'log');
        file_put_contents($log, implode("\n", [
            '[2026-10-20T10:00:00.000000+02:00] request.CRITICAL: ancienne erreur',
            '[2026-10-30T09:00:00.000000+01:00] request.ERROR: simple erreur',
            '[2026-10-31T08:00:00.000000+01:00] request.CRITICAL: premiere',
            '[2026-11-01T07:00:00.000000+01:00] console.CRITICAL: derniere',
        ]) . "\n");

        $result = (new CriticalLogScanner())->scan($log, new \DateTimeImmutable('2026-10-26 00:00:00'));
        unlink($log);

        $this->assertSame(2, $result['count']);
        $this->assertStringContainsString('derniere', $result['last']);
    }

    public function testMissingLogFileIsNoError(): void
    {
        $result = (new CriticalLogScanner())->scan('/nexiste/pas.log', new \DateTimeImmutable());

        $this->assertSame(['count' => 0, 'last' => null], $result);
    }

    public function testBotSurge(): void
    {
        // 4 semaines a 1 000 en moyenne
        $this->assertTrue(SiteAlertChecker::isBotSurge(3500, 4000));
        $this->assertFalse(SiteAlertChecker::isBotSurge(2500, 4000));
        // Petit site : sous le minimum, pas d'alerte meme si x10
        $this->assertFalse(SiteAlertChecker::isBotSurge(500, 200));
        // Pas d'historique : rien a comparer
        $this->assertFalse(SiteAlertChecker::isBotSurge(50000, 0));
    }
}
