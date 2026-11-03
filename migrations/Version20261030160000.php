<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Statistiques allegees.
 *
 * Les robots ne sont plus enregistres visite par visite : stat_bot_daily les
 * compte par jour. L'user-agent complet (500 caracteres) etait stocke dans
 * chaque visite et chaque session sans jamais etre relu : le type d'appareil
 * est calcule a l'enregistrement. Les deux colonnes sont retirees.
 *
 * Le down() recree les colonnes vides : les user-agents supprimes ne
 * reviennent pas.
 */
final class Version20261030160000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute stat_bot_daily (robots comptes par jour), retire user_agent de page_view et stat_session';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('CREATE TABLE stat_bot_daily (day DATE NOT NULL, hits INT NOT NULL, PRIMARY KEY (day)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE page_view DROP user_agent');
        $this->addSql('ALTER TABLE stat_session DROP user_agent');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE stat_session ADD user_agent VARCHAR(500) DEFAULT NULL');
        $this->addSql('ALTER TABLE page_view ADD user_agent VARCHAR(500) DEFAULT NULL');
        $this->addSql('DROP TABLE stat_bot_daily');
    }
}
