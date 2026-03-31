<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260331051133 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article DROP FOREIGN KEY `FK_23A0E66E2532148`');
        $this->addSql('ALTER TABLE article ADD CONSTRAINT FK_23A0E66E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE categorie DROP FOREIGN KEY `FK_497DD634E2532148`');
        $this->addSql('ALTER TABLE categorie ADD CONSTRAINT FK_497DD634E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE event DROP FOREIGN KEY `FK_3BAE0AA73DA5256D`');
        $this->addSql('ALTER TABLE event ADD CONSTRAINT FK_3BAE0AA73DA5256D FOREIGN KEY (image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE page DROP FOREIGN KEY `FK_140AB620E2532148`');
        $this->addSql('ALTER TABLE page ADD CONSTRAINT FK_140AB620E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE portfolio_item DROP FOREIGN KEY `FK_2F2A62E43DA5256D`');
        $this->addSql('ALTER TABLE portfolio_item ADD CONSTRAINT FK_2F2A62E43DA5256D FOREIGN KEY (image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE product DROP FOREIGN KEY `FK_D34A04AD3DA5256D`');
        $this->addSql('ALTER TABLE product ADD CONSTRAINT FK_D34A04AD3DA5256D FOREIGN KEY (image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE product_category DROP FOREIGN KEY `FK_CDFC73563DA5256D`');
        $this->addSql('ALTER TABLE product_category ADD CONSTRAINT FK_CDFC73563DA5256D FOREIGN KEY (image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE product_image DROP FOREIGN KEY `FK_64617F03EA9FDD75`');
        $this->addSql('ALTER TABLE product_image ADD CONSTRAINT FK_64617F03EA9FDD75 FOREIGN KEY (media_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE service DROP FOREIGN KEY `FK_E19D9AD23DA5256D`');
        $this->addSql('ALTER TABLE service ADD CONSTRAINT FK_E19D9AD23DA5256D FOREIGN KEY (image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY `FK_694309E471BB2404`');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY `FK_694309E498BB94C5`');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY `FK_694309E4D78119FD`');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E471BB2404 FOREIGN KEY (about_image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E498BB94C5 FOREIGN KEY (hero_image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E4D78119FD FOREIGN KEY (favicon_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE site_gallery_item DROP FOREIGN KEY `FK_478E9021EA9FDD75`');
        $this->addSql('ALTER TABLE site_gallery_item ADD CONSTRAINT FK_478E9021EA9FDD75 FOREIGN KEY (media_id) REFERENCES media (id) ON DELETE CASCADE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article DROP FOREIGN KEY FK_23A0E66E2532148');
        $this->addSql('ALTER TABLE article ADD CONSTRAINT `FK_23A0E66E2532148` FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE categorie DROP FOREIGN KEY FK_497DD634E2532148');
        $this->addSql('ALTER TABLE categorie ADD CONSTRAINT `FK_497DD634E2532148` FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE event DROP FOREIGN KEY FK_3BAE0AA73DA5256D');
        $this->addSql('ALTER TABLE event ADD CONSTRAINT `FK_3BAE0AA73DA5256D` FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE page DROP FOREIGN KEY FK_140AB620E2532148');
        $this->addSql('ALTER TABLE page ADD CONSTRAINT `FK_140AB620E2532148` FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE portfolio_item DROP FOREIGN KEY FK_2F2A62E43DA5256D');
        $this->addSql('ALTER TABLE portfolio_item ADD CONSTRAINT `FK_2F2A62E43DA5256D` FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE product DROP FOREIGN KEY FK_D34A04AD3DA5256D');
        $this->addSql('ALTER TABLE product ADD CONSTRAINT `FK_D34A04AD3DA5256D` FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE product_category DROP FOREIGN KEY FK_CDFC73563DA5256D');
        $this->addSql('ALTER TABLE product_category ADD CONSTRAINT `FK_CDFC73563DA5256D` FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE product_image DROP FOREIGN KEY FK_64617F03EA9FDD75');
        $this->addSql('ALTER TABLE product_image ADD CONSTRAINT `FK_64617F03EA9FDD75` FOREIGN KEY (media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE service DROP FOREIGN KEY FK_E19D9AD23DA5256D');
        $this->addSql('ALTER TABLE service ADD CONSTRAINT `FK_E19D9AD23DA5256D` FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E4D78119FD');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E498BB94C5');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E471BB2404');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT `FK_694309E4D78119FD` FOREIGN KEY (favicon_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT `FK_694309E498BB94C5` FOREIGN KEY (hero_image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT `FK_694309E471BB2404` FOREIGN KEY (about_image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site_gallery_item DROP FOREIGN KEY FK_478E9021EA9FDD75');
        $this->addSql('ALTER TABLE site_gallery_item ADD CONSTRAINT `FK_478E9021EA9FDD75` FOREIGN KEY (media_id) REFERENCES media (id)');
    }
}
