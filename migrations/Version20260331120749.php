<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260331120749 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE subscriber (id INT AUTO_INCREMENT NOT NULL, email VARCHAR(180) NOT NULL, subscribe_articles TINYINT DEFAULT 0 NOT NULL, subscribe_events TINYINT DEFAULT 0 NOT NULL, token VARCHAR(64) NOT NULL, is_active TINYINT DEFAULT 0 NOT NULL, created_at DATETIME NOT NULL, confirmed_at DATETIME DEFAULT NULL, UNIQUE INDEX UNIQ_AD005B69E7927C74 (email), UNIQUE INDEX UNIQ_AD005B695F37A13B (token), INDEX idx_subscriber_articles (is_active, subscribe_articles), INDEX idx_subscriber_events (is_active, subscribe_events), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP TABLE subscriber');
    }
}
