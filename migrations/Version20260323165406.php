<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260323165406 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add linked_product_id to event';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE event ADD linked_product_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE event ADD CONSTRAINT FK_3BAE0AA7D240BD1D FOREIGN KEY (linked_product_id) REFERENCES product (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX IDX_3BAE0AA7D240BD1D ON event (linked_product_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE event DROP FOREIGN KEY FK_3BAE0AA7D240BD1D');
        $this->addSql('DROP INDEX IDX_3BAE0AA7D240BD1D ON event');
        $this->addSql('ALTER TABLE event DROP linked_product_id');
    }
}
