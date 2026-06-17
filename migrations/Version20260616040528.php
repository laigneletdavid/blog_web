<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260616040528 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajout fiche entreprise, reseaux sociaux et horaires sur site';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site ADD business_type VARCHAR(50) DEFAULT NULL, ADD price_range VARCHAR(10) DEFAULT NULL, ADD opening_hours LONGTEXT DEFAULT NULL, ADD facebook_url VARCHAR(255) DEFAULT NULL, ADD instagram_url VARCHAR(255) DEFAULT NULL, ADD linkedin_url VARCHAR(255) DEFAULT NULL, ADD twitter_handle VARCHAR(100) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site DROP business_type, DROP price_range, DROP opening_hours, DROP facebook_url, DROP instagram_url, DROP linkedin_url, DROP twitter_handle');
    }
}
