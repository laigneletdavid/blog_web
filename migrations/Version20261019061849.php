<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Fiche Referencement : intention de l'admin (activite, cible, atouts,
 * portee, zones, priorites, mots des clients).
 *
 * Toutes les colonnes sont nullables : les sites existants n'ont rien a
 * remplir pour continuer a fonctionner.
 */
final class Version20261019061849 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute les champs de la fiche Referencement sur site (seo_activity, seo_reach...)';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site ADD seo_activity LONGTEXT DEFAULT NULL, ADD seo_audience VARCHAR(255) DEFAULT NULL, ADD seo_strengths LONGTEXT DEFAULT NULL, ADD seo_reach VARCHAR(20) DEFAULT NULL, ADD seo_areas LONGTEXT DEFAULT NULL, ADD seo_priorities LONGTEXT DEFAULT NULL, ADD seo_customer_words LONGTEXT DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site DROP seo_activity, DROP seo_audience, DROP seo_strengths, DROP seo_reach, DROP seo_areas, DROP seo_priorities, DROP seo_customer_words');
    }
}
