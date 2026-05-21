<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260520120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'SEO Phase 1 : add SeoTrait columns to tag and service tables';
    }

    public function up(Schema $schema): void
    {
        // --- Tag : SeoTrait columns (noIndex defaults to true for tags) ---
        $this->addSql('ALTER TABLE tag ADD seo_title VARCHAR(70) DEFAULT NULL');
        $this->addSql('ALTER TABLE tag ADD seo_description VARCHAR(160) DEFAULT NULL');
        $this->addSql('ALTER TABLE tag ADD seo_keywords VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE tag ADD no_index TINYINT(1) DEFAULT 1 NOT NULL');
        $this->addSql('ALTER TABLE tag ADD canonical_url VARCHAR(255) DEFAULT NULL');

        // --- Service : SeoTrait columns (noIndex defaults to false) ---
        $this->addSql('ALTER TABLE service ADD seo_title VARCHAR(70) DEFAULT NULL');
        $this->addSql('ALTER TABLE service ADD seo_description VARCHAR(160) DEFAULT NULL');
        $this->addSql('ALTER TABLE service ADD seo_keywords VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE service ADD no_index TINYINT(1) DEFAULT 0 NOT NULL');
        $this->addSql('ALTER TABLE service ADD canonical_url VARCHAR(255) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE tag DROP seo_title, DROP seo_description, DROP seo_keywords, DROP no_index, DROP canonical_url');
        $this->addSql('ALTER TABLE service DROP seo_title, DROP seo_description, DROP seo_keywords, DROP no_index, DROP canonical_url');
    }
}
