<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260323123955 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add order table to store customer orders';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE `order` (id INT AUTO_INCREMENT NOT NULL, reference VARCHAR(20) NOT NULL, customer_name VARCHAR(255) NOT NULL, customer_email VARCHAR(255) NOT NULL, customer_phone VARCHAR(50) DEFAULT NULL, customer_message LONGTEXT DEFAULT NULL, items JSON NOT NULL, total_ht NUMERIC(10, 2) NOT NULL, total_vat NUMERIC(10, 2) NOT NULL, total_ttc NUMERIC(10, 2) NOT NULL, payment_method VARCHAR(20) NOT NULL, stripe_session_id VARCHAR(255) DEFAULT NULL, status VARCHAR(20) NOT NULL, created_at DATETIME NOT NULL, paid_at DATETIME DEFAULT NULL, UNIQUE INDEX UNIQ_F5299398AEA34913 (reference), INDEX idx_order_status (status), INDEX idx_order_created (created_at), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP TABLE `order`');
    }
}
