<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260311041529 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add page view tracking and content blocks to articles and pages';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE page_view (id INT AUTO_INCREMENT NOT NULL, url VARCHAR(500) NOT NULL, ip_hash VARCHAR(64) NOT NULL, user_agent VARCHAR(500) DEFAULT NULL, referer VARCHAR(500) DEFAULT NULL, created_at DATETIME NOT NULL, INDEX idx_pageview_created_at (created_at), INDEX idx_pageview_url (url), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE article ADD blocks JSON DEFAULT NULL, ADD draft_blocks JSON DEFAULT NULL');
        $this->addSql('ALTER TABLE page ADD blocks JSON DEFAULT NULL, ADD draft_blocks JSON DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP TABLE page_view');
        $this->addSql('ALTER TABLE article DROP blocks, DROP draft_blocks');
        $this->addSql('ALTER TABLE page DROP blocks, DROP draft_blocks');
    }
}
