<?php

namespace App\Tests\Unit\Service;

use App\Twig\AppExtension;
use PHPUnit\Framework\TestCase;

class FichierPublicTest extends TestCase
{
    private function ext(string $dir): AppExtension
    {
        $r = new \ReflectionClass(AppExtension::class);
        $ext = $r->newInstanceWithoutConstructor();
        $r->getProperty('projectDir')->setValue($ext, $dir);

        return $ext;
    }

    public function testFichierPresentAbsentEtRemonteeRefusee(): void
    {
        $dir = sys_get_temp_dir() . '/fp_' . uniqid();
        mkdir($dir . '/public/images', 0777, true);
        touch($dir . '/public/images/a.webp');
        $ext = $this->ext($dir);

        $this->assertTrue($ext->fichierPublic('images/a.webp'));
        $this->assertTrue($ext->fichierPublic('/images/a.webp'));
        $this->assertFalse($ext->fichierPublic('images/b.webp'));
        $this->assertFalse($ext->fichierPublic('images'));
        $this->assertFalse($ext->fichierPublic('../public/images/a.webp'));
        $this->assertFalse($ext->fichierPublic(''));
    }
}
