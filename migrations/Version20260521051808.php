<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260521051808 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Stats Phase 2 : table stat_conversion (phone_click, email_click, form_submit)';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE stat_conversion (id INT AUTO_INCREMENT NOT NULL, type VARCHAR(20) NOT NULL, page_url VARCHAR(500) NOT NULL, detail LONGTEXT DEFAULT NULL, created_at DATETIME NOT NULL, session_id INT DEFAULT NULL, INDEX idx_conversion_session (session_id), INDEX idx_conversion_type (type), INDEX idx_conversion_created (created_at), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE stat_conversion ADD CONSTRAINT FK_724550EC613FECDF FOREIGN KEY (session_id) REFERENCES stat_session (id) ON DELETE SET NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE stat_conversion DROP FOREIGN KEY FK_724550EC613FECDF');
        $this->addSql('DROP TABLE stat_conversion');
    }
}
