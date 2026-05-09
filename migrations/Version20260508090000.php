<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260508090000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Creation table document (PDF, DOCX, XLSX, ZIP... insertable depuis TipTap).';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('CREATE TABLE document (
            id INT AUTO_INCREMENT NOT NULL,
            name VARCHAR(255) NOT NULL,
            file_name VARCHAR(255) NOT NULL,
            extension VARCHAR(10) DEFAULT NULL,
            mime_type VARCHAR(100) DEFAULT NULL,
            size BIGINT DEFAULT NULL,
            created_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\',
            PRIMARY KEY(id)
        ) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('DROP TABLE document');
    }
}
