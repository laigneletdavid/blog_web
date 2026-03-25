<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260320173148 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add event table';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE event (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, short_description LONGTEXT DEFAULT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, date_start DATETIME NOT NULL, date_end DATETIME DEFAULT NULL, location VARCHAR(255) DEFAULT NULL, is_active TINYINT DEFAULT 1 NOT NULL, is_featured TINYINT DEFAULT 0 NOT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, image_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_3BAE0AA7989D9B62 (slug), INDEX IDX_3BAE0AA73DA5256D (image_id), INDEX idx_event_active (is_active), INDEX idx_event_date_start (date_start), INDEX idx_event_featured (is_featured), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE event ADD CONSTRAINT FK_3BAE0AA73DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE event DROP FOREIGN KEY FK_3BAE0AA73DA5256D');
        $this->addSql('DROP TABLE event');
    }
}
