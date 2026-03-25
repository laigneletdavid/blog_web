<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260323183342 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE menu ADD location VARCHAR(20) DEFAULT \'header\' NOT NULL, ADD is_system TINYINT DEFAULT 0 NOT NULL, ADD system_key VARCHAR(50) DEFAULT NULL, ADD route VARCHAR(100) DEFAULT NULL, ADD route_params JSON DEFAULT NULL');
        $this->addSql('CREATE INDEX idx_menu_location ON menu (location)');
        $this->addSql('CREATE UNIQUE INDEX uniq_menu_location_system_key ON menu (location, system_key)');
        $this->addSql('ALTER TABLE page ADD is_system TINYINT DEFAULT 0 NOT NULL, ADD system_key VARCHAR(50) DEFAULT NULL');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_140AB62047280172 ON page (system_key)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP INDEX idx_menu_location ON menu');
        $this->addSql('DROP INDEX uniq_menu_location_system_key ON menu');
        $this->addSql('ALTER TABLE menu DROP location, DROP is_system, DROP system_key, DROP route, DROP route_params');
        $this->addSql('DROP INDEX UNIQ_140AB62047280172 ON page');
        $this->addSql('ALTER TABLE page DROP is_system, DROP system_key');
    }
}
