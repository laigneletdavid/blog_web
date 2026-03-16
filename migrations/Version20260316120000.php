<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260316120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'DT.3: Fix adress typos, rename subscription fields, add isVerified on User';
    }

    public function up(Schema $schema): void
    {
        // DT.3a — Fix typos adress → address
        $this->addSql('ALTER TABLE site CHANGE adress_1 address_1 VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE site CHANGE adress_2 address_2 VARCHAR(255) DEFAULT NULL');

        // DT.3b — Rename subscription fields
        $this->addSql('ALTER TABLE user CHANGE news subscribe_news TINYINT(1) DEFAULT NULL');
        $this->addSql('ALTER TABLE user CHANGE articles subscribe_articles TINYINT(1) DEFAULT NULL');

        // DT.3c — Add isVerified
        $this->addSql('ALTER TABLE user ADD is_verified TINYINT(1) NOT NULL DEFAULT 0');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site CHANGE address_1 adress_1 VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE site CHANGE address_2 adress_2 VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE user CHANGE subscribe_news news TINYINT(1) DEFAULT NULL');
        $this->addSql('ALTER TABLE user CHANGE subscribe_articles articles TINYINT(1) DEFAULT NULL');
        $this->addSql('ALTER TABLE user DROP is_verified');
    }
}
