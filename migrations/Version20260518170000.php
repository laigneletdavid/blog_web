<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260518170000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add tour_completed field to user entity for walkthrough feature';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE user ADD tour_completed TINYINT(1) DEFAULT 0 NOT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE user DROP tour_completed');
    }
}
