<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260314025407 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add SEO fields to tables and site settings';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article ADD seo_title VARCHAR(70) DEFAULT NULL, ADD seo_description VARCHAR(160) DEFAULT NULL, ADD seo_keywords VARCHAR(255) DEFAULT NULL, ADD no_index TINYINT DEFAULT 0 NOT NULL, ADD canonical_url VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE categorie ADD seo_title VARCHAR(70) DEFAULT NULL, ADD seo_description VARCHAR(160) DEFAULT NULL, ADD seo_keywords VARCHAR(255) DEFAULT NULL, ADD no_index TINYINT DEFAULT 0 NOT NULL, ADD canonical_url VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE media ADD webp_file_name VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE page ADD seo_title VARCHAR(70) DEFAULT NULL, ADD seo_description VARCHAR(160) DEFAULT NULL, ADD seo_keywords VARCHAR(255) DEFAULT NULL, ADD no_index TINYINT DEFAULT 0 NOT NULL, ADD canonical_url VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE site ADD default_seo_title VARCHAR(70) DEFAULT NULL, ADD default_seo_description VARCHAR(160) DEFAULT NULL, ADD google_analytics_id VARCHAR(20) DEFAULT NULL, ADD google_search_console VARCHAR(100) DEFAULT NULL, ADD primary_color VARCHAR(7) DEFAULT \'#2563EB\', ADD secondary_color VARCHAR(7) DEFAULT \'#F59E0B\', ADD accent_color VARCHAR(7) DEFAULT \'#8B5CF6\', ADD font_family VARCHAR(100) DEFAULT \'\'\'Inter\'\', sans-serif\', ADD font_family_secondary VARCHAR(100) DEFAULT NULL, ADD template VARCHAR(20) DEFAULT \'default\' NOT NULL, ADD favicon_id INT DEFAULT NULL, ADD owner_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E4D78119FD FOREIGN KEY (favicon_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E47E3C61F9 FOREIGN KEY (owner_id) REFERENCES user (id)');
        $this->addSql('CREATE INDEX IDX_694309E4D78119FD ON site (favicon_id)');
        $this->addSql('CREATE INDEX IDX_694309E47E3C61F9 ON site (owner_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article DROP seo_title, DROP seo_description, DROP seo_keywords, DROP no_index, DROP canonical_url');
        $this->addSql('ALTER TABLE categorie DROP seo_title, DROP seo_description, DROP seo_keywords, DROP no_index, DROP canonical_url');
        $this->addSql('ALTER TABLE media DROP webp_file_name');
        $this->addSql('ALTER TABLE page DROP seo_title, DROP seo_description, DROP seo_keywords, DROP no_index, DROP canonical_url');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E4D78119FD');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E47E3C61F9');
        $this->addSql('DROP INDEX IDX_694309E4D78119FD ON site');
        $this->addSql('DROP INDEX IDX_694309E47E3C61F9 ON site');
        $this->addSql('ALTER TABLE site DROP default_seo_title, DROP default_seo_description, DROP google_analytics_id, DROP google_search_console, DROP primary_color, DROP secondary_color, DROP accent_color, DROP font_family, DROP font_family_secondary, DROP template, DROP favicon_id, DROP owner_id');
    }
}
