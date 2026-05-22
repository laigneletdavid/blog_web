<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260521043802 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Stats Phase 1 : tables stat_session + contact_message, enrichissement page_view (+5 colonnes)';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE contact_message (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(100) NOT NULL, firstname VARCHAR(100) NOT NULL, email VARCHAR(255) NOT NULL, subject VARCHAR(255) NOT NULL, message LONGTEXT NOT NULL, ip_hash VARCHAR(64) NOT NULL, source_page VARCHAR(500) DEFAULT NULL, created_at DATETIME NOT NULL, is_read TINYINT DEFAULT 0 NOT NULL, session_id INT DEFAULT NULL, INDEX IDX_2C9211FE613FECDF (session_id), INDEX idx_contact_created (created_at), INDEX idx_contact_read (is_read), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE stat_session (id INT AUTO_INCREMENT NOT NULL, session_token VARCHAR(64) NOT NULL, started_at DATETIME NOT NULL, ended_at DATETIME NOT NULL, source VARCHAR(30) NOT NULL, source_detail VARCHAR(500) DEFAULT NULL, utm_campaign VARCHAR(255) DEFAULT NULL, utm_medium VARCHAR(100) DEFAULT NULL, landing_page VARCHAR(500) NOT NULL, exit_page VARCHAR(500) NOT NULL, page_count SMALLINT DEFAULT 1 NOT NULL, ip_hash VARCHAR(64) NOT NULL, user_agent VARCHAR(500) DEFAULT NULL, is_bot TINYINT DEFAULT 0 NOT NULL, device_type VARCHAR(10) DEFAULT NULL, UNIQUE INDEX UNIQ_34BEA24D844A19ED (session_token), INDEX idx_session_started (started_at), INDEX idx_session_source (source), INDEX idx_session_token (session_token), INDEX idx_session_bot (is_bot), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE contact_message ADD CONSTRAINT FK_2C9211FE613FECDF FOREIGN KEY (session_id) REFERENCES stat_session (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE page_view ADD previous_url VARCHAR(500) DEFAULT NULL, ADD sequence_number SMALLINT DEFAULT 1 NOT NULL, ADD duration_seconds SMALLINT DEFAULT NULL, ADD scroll_max_pct SMALLINT DEFAULT NULL, ADD session_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE page_view ADD CONSTRAINT FK_7939B754613FECDF FOREIGN KEY (session_id) REFERENCES stat_session (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX idx_pageview_session ON page_view (session_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE contact_message DROP FOREIGN KEY FK_2C9211FE613FECDF');
        $this->addSql('DROP TABLE contact_message');
        $this->addSql('DROP TABLE stat_session');
        $this->addSql('ALTER TABLE page_view DROP FOREIGN KEY FK_7939B754613FECDF');
        $this->addSql('DROP INDEX idx_pageview_session ON page_view');
        $this->addSql('ALTER TABLE page_view DROP previous_url, DROP sequence_number, DROP duration_seconds, DROP scroll_max_pct, DROP session_id');
    }
}
