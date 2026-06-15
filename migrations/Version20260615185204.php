<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260615185204 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Table slug_redirect pour les redirections 301 au changement de slug';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('CREATE TABLE slug_redirect (id INT AUTO_INCREMENT NOT NULL, entity_type VARCHAR(50) NOT NULL, old_slug VARCHAR(255) NOT NULL, new_slug VARCHAR(255) NOT NULL, created_at DATETIME NOT NULL, INDEX idx_slug_redirect_lookup (entity_type, old_slug), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('DROP TABLE slug_redirect');
    }
}
