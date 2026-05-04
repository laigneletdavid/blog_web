<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20260504063822 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Ajout de site.contact_image_id (image dediee a la colonne droite du formulaire de contact).';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site ADD contact_image_id INT DEFAULT NULL');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E4A780B9FA FOREIGN KEY (contact_image_id) REFERENCES media (id) ON DELETE SET NULL');
        $this->addSql('CREATE INDEX IDX_694309E4A780B9FA ON site (contact_image_id)');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E4A780B9FA');
        $this->addSql('DROP INDEX IDX_694309E4A780B9FA ON site');
        $this->addSql('ALTER TABLE site DROP contact_image_id');
    }
}
