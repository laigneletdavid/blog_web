<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260429075920 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Familles de tags (TagGroup) + relation tags <-> DirectoryEntry pour filtres annuaire dynamiques.';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE directory_entry_tag (directory_entry_id INT NOT NULL, tag_id INT NOT NULL, INDEX IDX_2E8AEF15BE8E7CAF (directory_entry_id), INDEX IDX_2E8AEF15BAD26311 (tag_id), PRIMARY KEY (directory_entry_id, tag_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE tag_group (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, color VARCHAR(7) DEFAULT \'#6c757d\' NOT NULL, display_order INT DEFAULT 0 NOT NULL, description LONGTEXT DEFAULT NULL, UNIQUE INDEX UNIQ_4F2C5DC3989D9B62 (slug), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE directory_entry_tag ADD CONSTRAINT FK_2E8AEF15BE8E7CAF FOREIGN KEY (directory_entry_id) REFERENCES directory_entry (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE directory_entry_tag ADD CONSTRAINT FK_2E8AEF15BAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag ADD tag_group_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE tag ADD CONSTRAINT FK_389B783C865A29C FOREIGN KEY (tag_group_id) REFERENCES tag_group (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX IDX_389B783C865A29C ON tag (tag_group_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE directory_entry_tag DROP FOREIGN KEY FK_2E8AEF15BE8E7CAF');
        $this->addSql('ALTER TABLE directory_entry_tag DROP FOREIGN KEY FK_2E8AEF15BAD26311');
        $this->addSql('DROP TABLE directory_entry_tag');
        $this->addSql('DROP TABLE tag_group');
        $this->addSql('ALTER TABLE tag DROP FOREIGN KEY FK_389B783C865A29C');
        $this->addSql('DROP INDEX IDX_389B783C865A29C ON tag');
        $this->addSql('ALTER TABLE tag DROP tag_group_id');
    }
}
