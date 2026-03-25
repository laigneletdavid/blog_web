<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260323124847 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add customer_last_name and change customer_name to customer_first_name in order table';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE `order` ADD customer_last_name VARCHAR(255) NOT NULL, CHANGE customer_name customer_first_name VARCHAR(255) NOT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE `order` ADD customer_name VARCHAR(255) NOT NULL, DROP customer_first_name, DROP customer_last_name');
    }
}
