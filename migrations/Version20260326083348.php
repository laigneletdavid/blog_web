<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260326083348 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE portfolio_category (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, icon VARCHAR(100) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, UNIQUE INDEX UNIQ_7AC64359989D9B62 (slug), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE portfolio_item (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, short_description LONGTEXT DEFAULT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, client VARCHAR(255) DEFAULT NULL, project_date DATE DEFAULT NULL, project_url VARCHAR(255) DEFAULT NULL, gallery JSON DEFAULT NULL, tags VARCHAR(255) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, is_featured TINYINT DEFAULT 0 NOT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, category_id INT DEFAULT NULL, image_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_2F2A62E4989D9B62 (slug), INDEX IDX_2F2A62E412469DE2 (category_id), INDEX IDX_2F2A62E43DA5256D (image_id), INDEX idx_portfolio_active (is_active), INDEX idx_portfolio_featured (is_featured), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE portfolio_item ADD CONSTRAINT FK_2F2A62E412469DE2 FOREIGN KEY (category_id) REFERENCES portfolio_category (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE portfolio_item ADD CONSTRAINT FK_2F2A62E43DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE portfolio_item DROP FOREIGN KEY FK_2F2A62E412469DE2');
        $this->addSql('ALTER TABLE portfolio_item DROP FOREIGN KEY FK_2F2A62E43DA5256D');
        $this->addSql('DROP TABLE portfolio_category');
        $this->addSql('DROP TABLE portfolio_item');
    }
}
