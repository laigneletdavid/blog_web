<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260615192357 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajout colonnes width et height sur media pour les dimensions d image';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE media ADD width INT DEFAULT NULL, ADD height INT DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE media DROP width, DROP height');
    }
}
