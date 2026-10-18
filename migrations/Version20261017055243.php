<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Fiches annuaire : lien TikTok et lien de prise de rendez-vous.
 */
final class Version20261017055243 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute tiktok et booking_url sur directory_entry';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE directory_entry ADD tiktok VARCHAR(255) DEFAULT NULL, ADD booking_url VARCHAR(255) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE directory_entry DROP tiktok, DROP booking_url');
    }
}
