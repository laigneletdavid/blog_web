<?php

namespace App\Tests\Unit\Entity;

use App\Entity\Service;
use PHPUnit\Framework\TestCase;

class ServiceDetailTest extends TestCase
{
    public function testSansContenuPasDePageDetail(): void
    {
        $this->assertFalse((new Service())->hasDetail());
        $this->assertFalse((new Service())->setContent('<p> </p>')->hasDetail());
    }

    public function testBlocsTipTapDonnentUnePageDetail(): void
    {
        $service = (new Service())->setBlocksJson('{"type":"doc","content":[{"type":"paragraph"}]}');
        $this->assertTrue($service->hasDetail());
    }

    public function testHtmlSeulEcritEnSqlDonneUnePageDetail(): void
    {
        $this->assertTrue((new Service())->setContent('<p>Texte de la fiche</p>')->hasDetail());
    }
}
