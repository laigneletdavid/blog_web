<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20230608042543 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article ADD featured_media_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE article ADD CONSTRAINT FK_23A0E66E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_23A0E66E2532148 ON article (featured_media_id)');
        $this->addSql('ALTER TABLE media DROP FOREIGN KEY FK_6A2CA10C7294869C');
        $this->addSql('DROP INDEX IDX_6A2CA10C7294869C ON media');
        $this->addSql('ALTER TABLE media DROP article_id');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article DROP FOREIGN KEY FK_23A0E66E2532148');
        $this->addSql('DROP INDEX UNIQ_23A0E66E2532148 ON article');
        $this->addSql('ALTER TABLE article DROP featured_media_id');
        $this->addSql('ALTER TABLE media ADD article_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE media ADD CONSTRAINT FK_6A2CA10C7294869C FOREIGN KEY (article_id) REFERENCES article (id)');
        $this->addSql('CREATE INDEX IDX_6A2CA10C7294869C ON media (article_id)');
    }
}
