<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20261019081701 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE service ADD parent_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE service ADD CONSTRAINT FK_E19D9AD2727ACA70 FOREIGN KEY (parent_id) REFERENCES service (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX IDX_E19D9AD2727ACA70 ON service (parent_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE service DROP FOREIGN KEY FK_E19D9AD2727ACA70');
        $this->addSql('DROP INDEX IDX_E19D9AD2727ACA70 ON service');
        $this->addSql('ALTER TABLE service DROP parent_id');
    }
}
