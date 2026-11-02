<?php

namespace App\Tests\Unit\Service;

use App\Entity\Site;
use App\Enum\SeoStatus;
use App\Model\SeoDocument;
use App\Model\SeoReport;
use App\Repository\ArticleRepository;
use App\Repository\PageRepository;
use App\Repository\ServiceRepository;
use App\Service\SeoIntentChecker;
use App\Service\SiteContext;
use PHPUnit\Framework\TestCase;

class SeoIntentCheckerTest extends TestCase
{
    private SeoIntentChecker $checker;

    protected function setUp(): void
    {
        // checkAgainst() ne touche pas aux depots : de simples doublures suffisent
        $this->checker = new SeoIntentChecker(
            $this->createStub(PageRepository::class),
            $this->createStub(ServiceRepository::class),
            $this->createStub(ArticleRepository::class),
            $this->createStub(SiteContext::class),
        );
    }

    // ========== Fiche ==========

    public function testFicheVideDonneOrange(): void
    {
        $report = $this->checker->checkAgainst(new Site(), []);

        $this->assertCheckStatus($report, 'profile', SeoStatus::ORANGE);
        $this->assertCheckAbsent($report, 'areas');
    }

    public function testFicheRemplieDonneVert(): void
    {
        $site = $this->createLocalSite();
        $report = $this->checker->checkAgainst($site, []);

        $this->assertCheckStatus($report, 'profile', SeoStatus::GREEN);
    }

    // ========== Coordonnees et type (local uniquement) ==========

    public function testLocalSansAdresseDonneOrange(): void
    {
        $site = $this->createLocalSite();
        $site->setAddress1(null);
        $report = $this->checker->checkAgainst($site, []);

        $this->assertCheckStatus($report, 'coordinates', SeoStatus::ORANGE);
    }

    public function testNationalSansControleLocal(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoReach('national');
        $report = $this->checker->checkAgainst($site, []);

        $this->assertCheckAbsent($report, 'coordinates');
        $this->assertCheckAbsent($report, 'areas');
        $this->assertCheckAbsent($report, 'business_type');
    }

    public function testTypeOrganisationEnLocalDonneOrange(): void
    {
        $site = $this->createLocalSite();
        $site->setBusinessType('Organization');
        $report = $this->checker->checkAgainst($site, []);

        $this->assertCheckStatus($report, 'business_type', SeoStatus::ORANGE);
    }

    // ========== Villes ==========

    public function testVilleAbsenteDesTitresDonneOrange(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoAreas("Pau\nLescar");
        $docs = [$this->doc(seoTitle: 'Paysagiste à Pau')];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'areas', SeoStatus::ORANGE);
        $this->assertStringContainsString('Lescar', $this->message($report, 'areas'));
        $this->assertStringNotContainsString('Pau', $this->message($report, 'areas'));
    }

    public function testVilleTrouveeSansAccentNiMajuscule(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoAreas("billere\r\n");
        $docs = [$this->doc(seoDescription: 'Entretien de jardins à Billère et alentours')];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'areas', SeoStatus::GREEN);
    }

    public function testVilleCourteNeMatchePasUnMotPlusLong(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoAreas('Pau');
        $docs = [$this->doc(title: 'Rencontre avec Paul')];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'areas', SeoStatus::ORANGE);
    }

    public function testVilleDansLeContenuSeulNeSuffitPas(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoAreas('Lescar');
        $docs = [$this->doc(content: '<p>Nous intervenons à Lescar.</p>')];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'areas', SeoStatus::ORANGE);
    }

    // ========== Priorites ==========

    public function testPrioriteSansPageDedieeDonneOrange(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoPriorities("Élagage\nCréation de jardins");
        $docs = [
            $this->doc(title: 'Création de jardins'),
            // Un article ne compte pas comme page dediee
            $this->doc(title: 'Nos conseils d\'élagage', dedicated: false),
        ];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'priorities', SeoStatus::ORANGE);
        $this->assertStringContainsString('Élagage', $this->message($report, 'priorities'));
    }

    public function testPrioritesToutesCouvertesDonneVert(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoPriorities('Elagage');
        $docs = [$this->doc(title: 'Élagage et abattage')];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'priorities', SeoStatus::GREEN);
    }

    public function testSansPrioriteAucunCheck(): void
    {
        $report = $this->checker->checkAgainst($this->createLocalSite(), []);

        $this->assertCheckAbsent($report, 'priorities');
        $this->assertCheckAbsent($report, 'customer_words');
    }

    // ========== Mots des clients ==========

    public function testMotClientDansLeContenuDonneVert(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoCustomerWords('paysagiste près de chez moi');
        $docs = [$this->doc(content: '<p>Votre <strong>paysagiste près de chez moi</strong></p>', dedicated: false)];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'customer_words', SeoStatus::GREEN);
    }

    public function testMotClientTrouveDansLeDesordreEtSansMotsVides(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoCustomerWords('notaire saint-martory');
        $site->setDefaultSeoTitle('Maître Mainguy, notaire à Saint-Martory');

        $report = $this->checker->checkAgainst($site, []);

        $this->assertCheckStatus($report, 'customer_words', SeoStatus::GREEN);
    }

    public function testMotsRepartisSurDeuxTextesNeComptentPas(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoCustomerWords('notaire lescar');
        $docs = [$this->doc(title: 'Votre notaire'), $this->doc(title: 'Venir de Lescar')];

        $report = $this->checker->checkAgainst($site, $docs);

        $this->assertCheckStatus($report, 'customer_words', SeoStatus::ORANGE);
    }

    public function testMotClientAbsentDonneOrange(): void
    {
        $site = $this->createLocalSite();
        $site->setSeoCustomerWords('élagueur pau');

        $report = $this->checker->checkAgainst($site, [$this->doc(title: 'Accueil')]);

        $this->assertCheckStatus($report, 'customer_words', SeoStatus::ORANGE);
    }

    public function testJamaisDeRouge(): void
    {
        $site = new Site();
        $site->setSeoReach('local');
        $site->setSeoAreas('Pau');
        $site->setSeoPriorities('Élagage');
        $site->setSeoCustomerWords('élagueur');

        $report = $this->checker->checkAgainst($site, []);

        $this->assertNotSame(SeoStatus::RED, $report->status);
    }

    // ========== Helpers ==========

    private function createLocalSite(): Site
    {
        $site = new Site();
        $site->setSeoActivity('Aménagement de jardins');
        $site->setSeoReach('local');
        $site->setAddress1('1 rue des Jardins');
        $site->setTown('Pau');
        $site->setOpeningHours('Mo 09:00-18:00');
        $site->setBusinessType('ProfessionalService');

        return $site;
    }

    private function doc(
        ?string $title = null,
        ?string $seoTitle = null,
        ?string $seoDescription = null,
        ?string $content = null,
        bool $dedicated = true,
    ): SeoDocument {
        return new SeoDocument($title, $seoTitle, $seoDescription, $content, $dedicated);
    }

    private function message(SeoReport $report, string $key): string
    {
        foreach ($report->checks as $check) {
            if ($check->key === $key) {
                return $check->message;
            }
        }
        $this->fail("Check '{$key}' introuvable dans le rapport");
    }

    private function assertCheckStatus(SeoReport $report, string $key, SeoStatus $expected): void
    {
        foreach ($report->checks as $check) {
            if ($check->key === $key) {
                $this->assertSame($expected, $check->status, "Check '{$key}' attendu {$expected->value}, obtenu {$check->status->value} : {$check->message}");
                return;
            }
        }
        $this->fail("Check '{$key}' introuvable dans le rapport");
    }

    private function assertCheckAbsent(SeoReport $report, string $key): void
    {
        foreach ($report->checks as $check) {
            if ($check->key === $key) {
                $this->fail("Check '{$key}' present alors qu'il ne devrait pas l'etre");
            }
        }
        $this->assertTrue(true);
    }
}
