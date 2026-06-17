<?php

namespace App\Tests\Unit\Service;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Media;
use App\Entity\Service;
use App\Entity\Tag;
use App\Enum\SeoStatus;
use App\Model\SeoReport;
use App\Service\SeoAnalyzer;
use PHPUnit\Framework\TestCase;

class SeoAnalyzerTest extends TestCase
{
    private SeoAnalyzer $analyzer;

    protected function setUp(): void
    {
        $this->analyzer = new SeoAnalyzer();
    }

    // ========== Titre SEO ==========

    public function testTitreAbsentDonneRouge(): void
    {
        $article = $this->createArticle(seoTitle: null);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'seo_title', SeoStatus::RED);
    }

    public function testTitreTropCourtDonneOrange(): void
    {
        $article = $this->createArticle(seoTitle: 'Court');
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'seo_title', SeoStatus::ORANGE);
    }

    public function testTitreTropLongDonneOrange(): void
    {
        $article = $this->createArticle(seoTitle: str_repeat('A', 65));
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'seo_title', SeoStatus::ORANGE);
    }

    public function testTitreBonDonneVert(): void
    {
        $article = $this->createArticle(seoTitle: 'Un bon titre SEO qui fait quarante car.');
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'seo_title', SeoStatus::GREEN);
    }

    // ========== Meta description ==========

    public function testMetaAbsenteDonneRouge(): void
    {
        $article = $this->createArticle(seoDescription: null);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'seo_description', SeoStatus::RED);
    }

    public function testMetaTropCourteDonneOrange(): void
    {
        $article = $this->createArticle(seoDescription: 'Trop court');
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'seo_description', SeoStatus::ORANGE);
    }

    public function testMetaBonneDonneVert(): void
    {
        $article = $this->createArticle(seoDescription: str_repeat('Mot de passe ', 11));
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'seo_description', SeoStatus::GREEN);
    }

    // ========== Contenu ==========

    public function testContenuTresMinceDonneRouge(): void
    {
        $article = $this->createArticle(content: '<p>Bonjour le monde.</p>');
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'content', SeoStatus::RED);
    }

    public function testContenuLegerDonneOrange(): void
    {
        $content = '<p>' . implode(' ', array_fill(0, 200, 'mot')) . '</p>';
        $article = $this->createArticle(content: $content);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'content', SeoStatus::ORANGE);
    }

    public function testContenuSuffisantDonneVert(): void
    {
        $content = '<p>' . implode(' ', array_fill(0, 400, 'mot')) . '</p>';
        $article = $this->createArticle(content: $content);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'content', SeoStatus::GREEN);
    }

    // ========== Sous-titres H2 ==========

    public function testPasDeH2SurContenuLongDonneOrange(): void
    {
        $content = '<p>' . implode(' ', array_fill(0, 400, 'mot')) . '</p>';
        $article = $this->createArticle(content: $content);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'headings', SeoStatus::ORANGE);
    }

    public function testH2PresentSurContenuLongDonneVert(): void
    {
        $content = '<h2>Section</h2><p>' . implode(' ', array_fill(0, 400, 'mot')) . '</p>';
        $article = $this->createArticle(content: $content);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'headings', SeoStatus::GREEN);
    }

    public function testPasDeCheckH2SurContenuCourt(): void
    {
        $content = '<p>' . implode(' ', array_fill(0, 100, 'mot')) . '</p>';
        $article = $this->createArticle(content: $content);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckAbsent($report, 'headings');
    }

    // ========== Image ==========

    public function testPasImageDonneRouge(): void
    {
        $article = $this->createArticle(hasImage: false);
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'image', SeoStatus::RED);
    }

    public function testAvecImageDonneVert(): void
    {
        $article = $this->createArticle();
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'image', SeoStatus::GREEN);
    }

    // ========== Slug ==========

    public function testSlugTropLongDonneOrange(): void
    {
        $article = $this->createArticle(slug: str_repeat('mot-', 25));
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'slug', SeoStatus::ORANGE);
    }

    public function testSlugNormalDonneVert(): void
    {
        $article = $this->createArticle(slug: 'mon-bel-article');
        $report = $this->analyzer->analyze($article);

        $this->assertCheckStatus($report, 'slug', SeoStatus::GREEN);
    }

    // ========== Score agrege ==========

    public function testScoreRougeAvecUnCheckCritique(): void
    {
        $content = '<h2>S</h2><p>' . implode(' ', array_fill(0, 400, 'mot')) . '</p>';
        $article = $this->createArticle(
            seoTitle: null,
            content: $content,
        );
        $report = $this->analyzer->analyze($article);

        $this->assertSame(SeoStatus::RED, $report->status);
    }

    public function testScoreVertToutOk(): void
    {
        $content = '<h2>Titre</h2><p>' . implode(' ', array_fill(0, 400, 'mot')) . '</p>';
        $article = $this->createArticle(
            seoTitle: 'Un titre SEO optimise pour Google',
            seoDescription: str_repeat('Mot de passe ', 11),
            content: $content,
        );
        $report = $this->analyzer->analyze($article);

        $this->assertSame(SeoStatus::GREEN, $report->status);
    }

    // ========== Entites sans contenu (Tag, Categorie) ==========

    public function testTagSansContenuPasDeCheckContenu(): void
    {
        $tag = new Tag();
        $tag->setName('PHP');
        $tag->setSlug('php');

        $report = $this->analyzer->analyze($tag);

        $this->assertCheckAbsent($report, 'content');
        $this->assertCheckAbsent($report, 'headings');
    }

    public function testCategorieSansContenuPasDeCheckContenu(): void
    {
        $categorie = new Categorie();
        $categorie->setName('Dev');
        $categorie->setSlug('dev');
        $categorie->setColor('#333');

        $report = $this->analyzer->analyze($categorie);

        $this->assertCheckAbsent($report, 'content');
    }

    // ========== Service avec getImage() ==========

    public function testServiceAvecImageDonneVert(): void
    {
        $media = $this->createMedia();

        $service = new Service();
        $service->setTitle('Mon service');
        $service->setSlug('mon-service');
        $service->setContent('dummy');
        $service->setImage($media);

        $report = $this->analyzer->analyze($service);

        $this->assertCheckStatus($report, 'image', SeoStatus::GREEN);
    }

    // ========== Helpers ==========

    private function createArticle(
        ?string $seoTitle = 'DEFAULTS',
        ?string $seoDescription = 'DEFAULTS',
        ?string $content = null,
        bool $hasImage = true,
        string $slug = 'mon-article-test',
    ): Article {
        if ($seoTitle === 'DEFAULTS') {
            $seoTitle = 'Un titre SEO optimise pour Google';
        }
        if ($seoDescription === 'DEFAULTS') {
            $seoDescription = str_repeat('Mot de passe ', 11);
        }
        if ($content === null) {
            $content = '<h2>Section</h2><p>' . implode(' ', array_fill(0, 400, 'mot')) . '</p>';
        }

        $article = new Article();
        $article->setTitle('Mon article de test');
        $article->setSlug($slug);
        $article->setContent($content);
        $article->setPublished(true);
        $article->setSeoTitle($seoTitle);
        $article->setSeoDescription($seoDescription);

        if ($hasImage) {
            $article->setFeaturedMedia($this->createMedia());
        }

        return $article;
    }

    private function createMedia(): Media
    {
        $media = new Media();
        $media->setName('test');
        $media->setFileName('test.jpg');

        return $media;
    }

    private function assertCheckStatus(SeoReport $report, string $key, SeoStatus $expected): void
    {
        foreach ($report->checks as $check) {
            if ($check->key === $key) {
                $this->assertSame($expected, $check->status, "Check '{$key}' attendu {$expected->value}, obtenu {$check->status->value}");
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
