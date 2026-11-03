<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auteur sur Article (relation vers user).
 *
 * Nullable, ON DELETE SET NULL : les articles existants restent sans auteur
 * (affiches au nom du site) et supprimer un compte ne supprime pas ses articles.
 */
final class Version20261020044200 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajoute article.author_id (nullable, SET NULL a la suppression du user)';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE article ADD author_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE article ADD CONSTRAINT FK_23A0E66F675F31B FOREIGN KEY (author_id) REFERENCES user (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX IDX_23A0E66F675F31B ON article (author_id)');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE article DROP FOREIGN KEY FK_23A0E66F675F31B');
        $this->addSql('DROP INDEX IDX_23A0E66F675F31B ON article');
        $this->addSql('ALTER TABLE article DROP author_id');
    }
}
