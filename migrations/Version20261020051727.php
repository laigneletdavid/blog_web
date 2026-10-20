<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Mode expert de l'admin, preference par compte.
 *
 * Les clients demarrent en mode simple. Les comptes webmaster (FREELANCE,
 * SUPER_ADMIN) demarrent en mode expert pour garder leurs reglages techniques.
 */
final class Version20261020051727 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute user.admin_expert (mode expert de l\'admin), active pour FREELANCE et SUPER_ADMIN';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE user ADD admin_expert TINYINT DEFAULT 0 NOT NULL');
        $this->addSql("UPDATE user SET admin_expert = 1 WHERE roles LIKE '%ROLE_FREELANCE%' OR roles LIKE '%ROLE_SUPER_ADMIN%'");
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE user DROP admin_expert');
    }
}
