<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Aligne le defaut SQL de tag.no_index sur le mapping Doctrine.
 *
 * La migration Version20260520120000 avait pose DEFAULT 1 pour que les tags
 * soient noIndex par defaut, mais SeoTrait declare DEFAULT 0 et PHP interdit
 * de surcharger la propriete d'un trait avec une autre valeur initiale.
 * L'ecart faisait echouer doctrine:schema:validate en permanence et polluait
 * toutes les migrations generees ensuite.
 *
 * La regle metier ne bouge pas : Tag::__construct() met noIndex a true, donc
 * un tag cree par l'application reste noIndex. Les lignes existantes ne sont
 * pas touchees (changer un DEFAULT ne reecrit pas les lignes).
 */
final class Version20261017061500 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Aligne le defaut de tag.no_index sur le mapping (0), la regle restant portee par Tag::__construct()';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE tag CHANGE no_index no_index TINYINT(1) DEFAULT 0 NOT NULL');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE tag CHANGE no_index no_index TINYINT(1) DEFAULT 1 NOT NULL');
    }
}
