<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Texte alternatif editable par media.
 *
 * Nullable : les medias existants gardent l'alt construit (nom + contexte)
 * tant que personne ne renseigne le champ.
 */
final class Version20261018054056 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute media.alt (texte alternatif editable, nullable)';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE media ADD alt VARCHAR(255) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE media DROP alt');
    }
}
