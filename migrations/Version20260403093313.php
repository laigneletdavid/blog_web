<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260403093313 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE directory_category (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, icon VARCHAR(100) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, UNIQUE INDEX UNIQ_2F42C2C989D9B62 (slug), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE directory_entry (id INT AUTO_INCREMENT NOT NULL, first_name VARCHAR(255) NOT NULL, last_name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, photo VARCHAR(255) DEFAULT NULL, job_title VARCHAR(255) DEFAULT NULL, company VARCHAR(255) DEFAULT NULL, bio LONGTEXT DEFAULT NULL, email VARCHAR(255) DEFAULT NULL, phone VARCHAR(20) DEFAULT NULL, city VARCHAR(255) DEFAULT NULL, website VARCHAR(255) DEFAULT NULL, linkedin VARCHAR(255) DEFAULT NULL, facebook VARCHAR(255) DEFAULT NULL, instagram VARCHAR(255) DEFAULT NULL, is_active TINYINT DEFAULT 1 NOT NULL, is_featured TINYINT DEFAULT 0 NOT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, category_id INT DEFAULT NULL, user_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_6553C92D989D9B62 (slug), INDEX IDX_6553C92D12469DE2 (category_id), INDEX IDX_6553C92DA76ED395 (user_id), INDEX idx_directory_active (is_active), INDEX idx_directory_featured (is_featured), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE directory_entry ADD CONSTRAINT FK_6553C92D12469DE2 FOREIGN KEY (category_id) REFERENCES directory_category (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE directory_entry ADD CONSTRAINT FK_6553C92DA76ED395 FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE SET NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE directory_entry DROP FOREIGN KEY FK_6553C92D12469DE2');
        $this->addSql('ALTER TABLE directory_entry DROP FOREIGN KEY FK_6553C92DA76ED395');
        $this->addSql('DROP TABLE directory_category');
        $this->addSql('DROP TABLE directory_entry');
    }
}
