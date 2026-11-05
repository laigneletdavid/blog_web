<?php

namespace App\Tests\Unit\Service;

use App\Twig\AppExtension;
use PHPUnit\Framework\TestCase;

class InsecablesTest extends TestCase
{
    private function f(string $t): string
    {
        $ext = (new \ReflectionClass(AppExtension::class))->newInstanceWithoutConstructor();

        return $ext->insecables($t);
    }

    public function testEspacesAvantPonctuationHaute(): void
    {
        $nb = "\u{00A0}";
        $this->assertSame("Un échange pour faire le point{$nb}?", $this->f('Un échange pour faire le point ?'));
        $this->assertSame("Prospection{$nb}: un objectif{$nb}!", $this->f('Prospection : un objectif !'));
        $this->assertSame("«{$nb}On n'a personne{$nb}»", $this->f('« On n\'a personne »'));
    }

    public function testRienNEstAjouteSansEspace(): void
    {
        $this->assertSame('https://exemple.fr à 10:30', $this->f('https://exemple.fr à 10:30'));
        $this->assertSame('', $this->f(''));
    }
}
