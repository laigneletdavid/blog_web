<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260416073057 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute la colonne blocks (JSON) sur directory_entry pour le contenu Tiptap de la biographie.';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE directory_entry ADD blocks JSON DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE directory_entry DROP blocks');
    }
}
