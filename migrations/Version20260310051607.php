<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260310051607 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add indexes and foreign keys for article, categorie, menu, page and tag tables';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE UNIQUE INDEX UNIQ_23A0E66989D9B62 ON article (slug)');
        $this->addSql('CREATE INDEX idx_article_published ON article (published)');
        $this->addSql('ALTER TABLE categorie ADD featured_media_id INT DEFAULT NULL, DROP featured_media');
        $this->addSql('ALTER TABLE categorie ADD CONSTRAINT FK_497DD634E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_497DD634989D9B62 ON categorie (slug)');
        $this->addSql('CREATE INDEX IDX_497DD634E2532148 ON categorie (featured_media_id)');
        $this->addSql('CREATE INDEX idx_menu_is_visible ON menu (is_visible)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_140AB620989D9B62 ON page (slug)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_389B783989D9B62 ON tag (slug)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP INDEX UNIQ_23A0E66989D9B62 ON article');
        $this->addSql('DROP INDEX idx_article_published ON article');
        $this->addSql('ALTER TABLE categorie DROP FOREIGN KEY FK_497DD634E2532148');
        $this->addSql('DROP INDEX UNIQ_497DD634989D9B62 ON categorie');
        $this->addSql('DROP INDEX IDX_497DD634E2532148 ON categorie');
        $this->addSql('ALTER TABLE categorie ADD featured_media SMALLINT DEFAULT NULL, DROP featured_media_id');
        $this->addSql('DROP INDEX idx_menu_is_visible ON menu');
        $this->addSql('DROP INDEX UNIQ_140AB620989D9B62 ON page');
        $this->addSql('DROP INDEX UNIQ_389B783989D9B62 ON tag');
    }
}
