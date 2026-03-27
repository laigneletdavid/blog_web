<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260316104123 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE site_gallery_item (id INT AUTO_INCREMENT NOT NULL, slot VARCHAR(30) NOT NULL, position SMALLINT DEFAULT 0 NOT NULL, title VARCHAR(255) DEFAULT NULL, content LONGTEXT DEFAULT NULL, site_id INT NOT NULL, media_id INT NOT NULL, INDEX IDX_478E9021F6BD1646 (site_id), INDEX IDX_478E9021EA9FDD75 (media_id), INDEX idx_gallery_slot (slot), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE site_gallery_item ADD CONSTRAINT FK_478E9021F6BD1646 FOREIGN KEY (site_id) REFERENCES site (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE site_gallery_item ADD CONSTRAINT FK_478E9021EA9FDD75 FOREIGN KEY (media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD hero_image_id INT DEFAULT NULL, ADD about_image_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E498BB94C5 FOREIGN KEY (hero_image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E471BB2404 FOREIGN KEY (about_image_id) REFERENCES media (id)');
        $this->addSql('CREATE INDEX IDX_694309E498BB94C5 ON site (hero_image_id)');
        $this->addSql('CREATE INDEX IDX_694309E471BB2404 ON site (about_image_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE site_gallery_item DROP FOREIGN KEY FK_478E9021F6BD1646');
        $this->addSql('ALTER TABLE site_gallery_item DROP FOREIGN KEY FK_478E9021EA9FDD75');
        $this->addSql('DROP TABLE site_gallery_item');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E498BB94C5');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E471BB2404');
        $this->addSql('DROP INDEX IDX_694309E498BB94C5 ON site');
        $this->addSql('DROP INDEX IDX_694309E471BB2404 ON site');
        $this->addSql('ALTER TABLE site DROP hero_image_id, DROP about_image_id');
    }
}
