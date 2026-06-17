<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260615180000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajout des champs landing page sur la table page (cta_text, cta_url, show_form, form_title)';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE page ADD cta_text VARCHAR(100) DEFAULT NULL, ADD cta_url VARCHAR(500) DEFAULT NULL, ADD show_form TINYINT(1) DEFAULT 1, ADD form_title VARCHAR(255) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE page DROP cta_text, DROP cta_url, DROP show_form, DROP form_title');
    }
}
