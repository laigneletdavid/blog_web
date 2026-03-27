<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260326084200 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE portfolio_item_tag (portfolio_item_id INT NOT NULL, tag_id INT NOT NULL, INDEX IDX_9816962944DA7D90 (portfolio_item_id), INDEX IDX_98169629BAD26311 (tag_id), PRIMARY KEY (portfolio_item_id, tag_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE portfolio_item_tag ADD CONSTRAINT FK_9816962944DA7D90 FOREIGN KEY (portfolio_item_id) REFERENCES portfolio_item (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE portfolio_item_tag ADD CONSTRAINT FK_98169629BAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE portfolio_item DROP tags');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE portfolio_item_tag DROP FOREIGN KEY FK_9816962944DA7D90');
        $this->addSql('ALTER TABLE portfolio_item_tag DROP FOREIGN KEY FK_98169629BAD26311');
        $this->addSql('DROP TABLE portfolio_item_tag');
        $this->addSql('ALTER TABLE portfolio_item ADD tags VARCHAR(255) DEFAULT NULL');
    }
}
