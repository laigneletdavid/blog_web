<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260317060354 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE service (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, short_description LONGTEXT DEFAULT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, icon VARCHAR(100) DEFAULT NULL, link VARCHAR(255) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, image_id INT DEFAULT NULL, linked_page_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_E19D9AD2989D9B62 (slug), INDEX IDX_E19D9AD23DA5256D (image_id), INDEX IDX_E19D9AD2670E5B73 (linked_page_id), INDEX idx_service_active (is_active), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE service ADD CONSTRAINT FK_E19D9AD23DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE service ADD CONSTRAINT FK_E19D9AD2670E5B73 FOREIGN KEY (linked_page_id) REFERENCES page (id)');
        $this->addSql('ALTER TABLE site ADD enabled_modules JSON DEFAULT \'["vitrine"]\' NOT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE service DROP FOREIGN KEY FK_E19D9AD23DA5256D');
        $this->addSql('ALTER TABLE service DROP FOREIGN KEY FK_E19D9AD2670E5B73');
        $this->addSql('DROP TABLE service');
        $this->addSql('ALTER TABLE site DROP enabled_modules');
    }
}
