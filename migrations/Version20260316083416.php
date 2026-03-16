<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260316083416 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE site CHANGE primary_color primary_color VARCHAR(7) DEFAULT NULL, CHANGE secondary_color secondary_color VARCHAR(7) DEFAULT NULL, CHANGE accent_color accent_color VARCHAR(7) DEFAULT NULL, CHANGE font_family font_family VARCHAR(100) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE site CHANGE primary_color primary_color VARCHAR(7) DEFAULT \'#2563EB\', CHANGE secondary_color secondary_color VARCHAR(7) DEFAULT \'#F59E0B\', CHANGE accent_color accent_color VARCHAR(7) DEFAULT \'#8B5CF6\', CHANGE font_family font_family VARCHAR(100) DEFAULT \'\'\'Inter\'\', sans-serif\'');
    }
}
