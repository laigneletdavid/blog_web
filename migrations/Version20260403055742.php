<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260403055742 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add logoDark to Site entity';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site ADD logo_dark_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E4E3225E88 FOREIGN KEY (logo_dark_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX IDX_694309E4E3225E88 ON site (logo_dark_id)');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E4E3225E88');
        $this->addSql('DROP INDEX IDX_694309E4E3225E88 ON site');
        $this->addSql('ALTER TABLE site DROP logo_dark_id');
    }
}
