<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Menu: replace ManyToMany sub_menu with parent/children + add url field.
 * Page: add template field.
 */
final class Version20260311120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Menu: parent_id + url, drop menu_menu join table. Page: template field.';
    }

    public function up(Schema $schema): void
    {
        // Menu: add parent_id and url
        $this->addSql('ALTER TABLE menu ADD parent_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE menu ADD url VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE menu ADD CONSTRAINT FK_7D053A93727ACA70 FOREIGN KEY (parent_id) REFERENCES menu (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX IDX_7D053A93727ACA70 ON menu (parent_id)');

        // Data migration: convert menu_menu join table to parent_id
        $this->addSql('UPDATE menu m INNER JOIN menu_menu mm ON m.id = mm.menu_target SET m.parent_id = mm.menu_source');

        // Drop the old join table
        $this->addSql('ALTER TABLE menu_menu DROP FOREIGN KEY FK_B54ACADD8CCD27AB');
        $this->addSql('ALTER TABLE menu_menu DROP FOREIGN KEY FK_B54ACADD95287724');
        $this->addSql('DROP TABLE menu_menu');

        // Page: add template field
        $this->addSql("ALTER TABLE page ADD template VARCHAR(30) NOT NULL DEFAULT 'default'");
    }

    public function down(Schema $schema): void
    {
        // Reverse page template
        $this->addSql('ALTER TABLE page DROP template');

        // Recreate menu_menu join table
        $this->addSql('CREATE TABLE menu_menu (menu_source INT NOT NULL, menu_target INT NOT NULL, INDEX IDX_B54ACADD8CCD27AB (menu_source), INDEX IDX_B54ACADD95287724 (menu_target), PRIMARY KEY(menu_source, menu_target)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE menu_menu ADD CONSTRAINT FK_B54ACADD8CCD27AB FOREIGN KEY (menu_source) REFERENCES menu (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE menu_menu ADD CONSTRAINT FK_B54ACADD95287724 FOREIGN KEY (menu_target) REFERENCES menu (id) ON DELETE CASCADE');

        // Reverse menu changes
        $this->addSql('ALTER TABLE menu DROP FOREIGN KEY FK_7D053A93727ACA70');
        $this->addSql('DROP INDEX IDX_7D053A93727ACA70 ON menu');
        $this->addSql('ALTER TABLE menu DROP parent_id');
        $this->addSql('ALTER TABLE menu DROP url');
    }
}
