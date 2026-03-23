<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260321064455 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article ADD visibility VARCHAR(20) DEFAULT \'public\' NOT NULL');
        $this->addSql('ALTER TABLE page ADD visibility VARCHAR(20) DEFAULT \'public\' NOT NULL');
        $this->addSql('ALTER TABLE user ADD company VARCHAR(255) DEFAULT NULL, ADD job_title VARCHAR(255) DEFAULT NULL, ADD phone VARCHAR(20) DEFAULT NULL, ADD is_directory_visible TINYINT DEFAULT 0 NOT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article DROP visibility');
        $this->addSql('ALTER TABLE page DROP visibility');
        $this->addSql('ALTER TABLE user DROP company, DROP job_title, DROP phone, DROP is_directory_visible');
    }
}
