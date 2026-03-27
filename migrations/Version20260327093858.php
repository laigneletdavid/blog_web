<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20260327093858 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE article (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, content LONGTEXT NOT NULL, created_at DATETIME NOT NULL, updated_at DATETIME DEFAULT NULL, published_at DATETIME DEFAULT NULL, slug VARCHAR(255) NOT NULL, published TINYINT NOT NULL, featured_text VARCHAR(255) DEFAULT NULL, is_featured TINYINT DEFAULT 0 NOT NULL, visibility VARCHAR(20) DEFAULT \'public\' NOT NULL, blocks JSON DEFAULT NULL, draft_blocks JSON DEFAULT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, featured_media_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_23A0E66989D9B62 (slug), INDEX IDX_23A0E66E2532148 (featured_media_id), INDEX idx_article_published (published), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE article_categorie (article_id INT NOT NULL, categorie_id INT NOT NULL, INDEX IDX_934886107294869C (article_id), INDEX IDX_93488610BCF5E72D (categorie_id), PRIMARY KEY (article_id, categorie_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE categorie (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, color VARCHAR(10) NOT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, featured_media_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_497DD634989D9B62 (slug), INDEX IDX_497DD634E2532148 (featured_media_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE comment (id INT AUTO_INCREMENT NOT NULL, content VARCHAR(255) NOT NULL, created_at DATETIME NOT NULL, article_id INT NOT NULL, user_id INT NOT NULL, INDEX IDX_9474526C7294869C (article_id), INDEX IDX_9474526CA76ED395 (user_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE event (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, short_description LONGTEXT DEFAULT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, date_start DATETIME NOT NULL, date_end DATETIME DEFAULT NULL, location VARCHAR(255) DEFAULT NULL, is_active TINYINT DEFAULT 1 NOT NULL, is_featured TINYINT DEFAULT 0 NOT NULL, notified_at DATETIME DEFAULT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, image_id INT DEFAULT NULL, linked_product_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_3BAE0AA7989D9B62 (slug), INDEX IDX_3BAE0AA73DA5256D (image_id), INDEX IDX_3BAE0AA7D240BD1D (linked_product_id), INDEX idx_event_active (is_active), INDEX idx_event_date_start (date_start), INDEX idx_event_featured (is_featured), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE faq (id INT AUTO_INCREMENT NOT NULL, question VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, icon VARCHAR(100) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, category_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_E8FF75CC989D9B62 (slug), INDEX IDX_E8FF75CC12469DE2 (category_id), INDEX idx_faq_active (is_active), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE faq_category (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, UNIQUE INDEX UNIQ_FAEEE0D6989D9B62 (slug), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE `like` (id INT AUTO_INCREMENT NOT NULL, liked VARCHAR(255) NOT NULL, article_id INT DEFAULT NULL, media_id INT DEFAULT NULL, INDEX IDX_AC6340B37294869C (article_id), INDEX IDX_AC6340B3EA9FDD75 (media_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE media (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, file_name VARCHAR(255) NOT NULL, webp_file_name VARCHAR(255) DEFAULT NULL, PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE menu (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, menu_order INT DEFAULT NULL, is_visible TINYINT NOT NULL, target VARCHAR(255) NOT NULL, location VARCHAR(20) DEFAULT \'header\' NOT NULL, is_system TINYINT DEFAULT 0 NOT NULL, system_key VARCHAR(50) DEFAULT NULL, route VARCHAR(100) DEFAULT NULL, route_params JSON DEFAULT NULL, url VARCHAR(255) DEFAULT NULL, article_id INT DEFAULT NULL, categorie_id INT DEFAULT NULL, page_id INT DEFAULT NULL, parent_id INT DEFAULT NULL, INDEX IDX_7D053A937294869C (article_id), INDEX IDX_7D053A93BCF5E72D (categorie_id), INDEX IDX_7D053A93C4663E4 (page_id), INDEX IDX_7D053A93727ACA70 (parent_id), INDEX idx_menu_is_visible (is_visible), INDEX idx_menu_location (location), UNIQUE INDEX uniq_menu_location_system_key (location, system_key), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE `option` (id INT AUTO_INCREMENT NOT NULL, label VARCHAR(255) NOT NULL, name VARCHAR(255) NOT NULL, value VARCHAR(255) DEFAULT NULL, type VARCHAR(255) NOT NULL, PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE `order` (id INT AUTO_INCREMENT NOT NULL, reference VARCHAR(20) NOT NULL, customer_first_name VARCHAR(255) NOT NULL, customer_last_name VARCHAR(255) NOT NULL, customer_email VARCHAR(255) NOT NULL, customer_phone VARCHAR(50) DEFAULT NULL, customer_message LONGTEXT DEFAULT NULL, items JSON NOT NULL, total_ht NUMERIC(10, 2) NOT NULL, total_vat NUMERIC(10, 2) NOT NULL, total_ttc NUMERIC(10, 2) NOT NULL, payment_method VARCHAR(20) NOT NULL, stripe_session_id VARCHAR(255) DEFAULT NULL, status VARCHAR(20) NOT NULL, created_at DATETIME NOT NULL, paid_at DATETIME DEFAULT NULL, UNIQUE INDEX UNIQ_F5299398AEA34913 (reference), INDEX idx_order_status (status), INDEX idx_order_created (created_at), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE page (id INT AUTO_INCREMENT NOT NULL, visibility VARCHAR(20) DEFAULT \'public\' NOT NULL, title VARCHAR(255) NOT NULL, content LONGTEXT NOT NULL, slug VARCHAR(255) NOT NULL, published TINYINT NOT NULL, created_at DATETIME NOT NULL, updated_at DATETIME DEFAULT NULL, blocks JSON DEFAULT NULL, draft_blocks JSON DEFAULT NULL, template VARCHAR(30) DEFAULT \'default\' NOT NULL, is_system TINYINT DEFAULT 0 NOT NULL, system_key VARCHAR(50) DEFAULT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, featured_media_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_140AB620989D9B62 (slug), UNIQUE INDEX UNIQ_140AB62047280172 (system_key), INDEX IDX_140AB620E2532148 (featured_media_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE page_view (id INT AUTO_INCREMENT NOT NULL, url VARCHAR(500) NOT NULL, ip_hash VARCHAR(64) NOT NULL, user_agent VARCHAR(500) DEFAULT NULL, referer VARCHAR(500) DEFAULT NULL, created_at DATETIME NOT NULL, INDEX idx_pageview_created_at (created_at), INDEX idx_pageview_url (url), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE portfolio_category (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, icon VARCHAR(100) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, UNIQUE INDEX UNIQ_7AC64359989D9B62 (slug), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE portfolio_item (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, short_description LONGTEXT DEFAULT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, client VARCHAR(255) DEFAULT NULL, project_date DATE DEFAULT NULL, project_url VARCHAR(255) DEFAULT NULL, gallery JSON DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, is_featured TINYINT DEFAULT 0 NOT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, category_id INT DEFAULT NULL, image_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_2F2A62E4989D9B62 (slug), INDEX IDX_2F2A62E412469DE2 (category_id), INDEX IDX_2F2A62E43DA5256D (image_id), INDEX idx_portfolio_active (is_active), INDEX idx_portfolio_featured (is_featured), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE portfolio_item_tag (portfolio_item_id INT NOT NULL, tag_id INT NOT NULL, INDEX IDX_9816962944DA7D90 (portfolio_item_id), INDEX IDX_98169629BAD26311 (tag_id), PRIMARY KEY (portfolio_item_id, tag_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE product (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, short_description LONGTEXT DEFAULT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, price_ht NUMERIC(10, 2) DEFAULT NULL, old_price_ht NUMERIC(10, 2) DEFAULT NULL, vat_rate NUMERIC(4, 2) DEFAULT \'20.00\' NOT NULL, availability VARCHAR(20) DEFAULT \'available\' NOT NULL, booking_url VARCHAR(255) DEFAULT NULL, booking_label VARCHAR(100) DEFAULT NULL, is_active TINYINT DEFAULT 1 NOT NULL, is_featured TINYINT DEFAULT 0 NOT NULL, position INT DEFAULT 0 NOT NULL, seo_title VARCHAR(70) DEFAULT NULL, seo_description VARCHAR(160) DEFAULT NULL, seo_keywords VARCHAR(255) DEFAULT NULL, no_index TINYINT DEFAULT 0 NOT NULL, canonical_url VARCHAR(255) DEFAULT NULL, category_id INT DEFAULT NULL, image_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_D34A04AD989D9B62 (slug), INDEX IDX_D34A04AD12469DE2 (category_id), INDEX IDX_D34A04AD3DA5256D (image_id), INDEX idx_product_active (is_active), INDEX idx_product_featured (is_featured), INDEX idx_product_availability (availability), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE product_tag (product_id INT NOT NULL, tag_id INT NOT NULL, INDEX IDX_E3A6E39C4584665A (product_id), INDEX IDX_E3A6E39CBAD26311 (tag_id), PRIMARY KEY (product_id, tag_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE product_related (product_source INT NOT NULL, product_target INT NOT NULL, INDEX IDX_B18E6B203DF63ED7 (product_source), INDEX IDX_B18E6B2024136E58 (product_target), PRIMARY KEY (product_source, product_target)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE product_category (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, description LONGTEXT DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, image_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_CDFC7356989D9B62 (slug), INDEX IDX_CDFC73563DA5256D (image_id), INDEX idx_product_category_active (is_active), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE product_image (id INT AUTO_INCREMENT NOT NULL, position INT DEFAULT 0 NOT NULL, product_id INT NOT NULL, media_id INT DEFAULT NULL, INDEX IDX_64617F034584665A (product_id), INDEX IDX_64617F03EA9FDD75 (media_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE product_variant (id INT AUTO_INCREMENT NOT NULL, label VARCHAR(255) NOT NULL, price_ht NUMERIC(10, 2) DEFAULT NULL, old_price_ht NUMERIC(10, 2) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, product_id INT NOT NULL, INDEX IDX_209AA41D4584665A (product_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE reset_password_request (id INT AUTO_INCREMENT NOT NULL, selector VARCHAR(20) NOT NULL, hashed_token VARCHAR(100) NOT NULL, requested_at DATETIME NOT NULL, expires_at DATETIME NOT NULL, user_id INT NOT NULL, INDEX IDX_7CE748AA76ED395 (user_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE service (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, short_description LONGTEXT DEFAULT NULL, blocks JSON DEFAULT NULL, content LONGTEXT NOT NULL, icon VARCHAR(100) DEFAULT NULL, link VARCHAR(255) DEFAULT NULL, position INT DEFAULT 0 NOT NULL, is_active TINYINT DEFAULT 1 NOT NULL, image_id INT DEFAULT NULL, linked_page_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_E19D9AD2989D9B62 (slug), INDEX IDX_E19D9AD23DA5256D (image_id), INDEX IDX_E19D9AD2670E5B73 (linked_page_id), INDEX idx_service_active (is_active), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE site (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, title VARCHAR(255) NOT NULL, email VARCHAR(255) DEFAULT NULL, town VARCHAR(255) DEFAULT NULL, post_code VARCHAR(255) DEFAULT NULL, address_1 VARCHAR(255) DEFAULT NULL, address_2 VARCHAR(255) DEFAULT NULL, google_maps VARCHAR(255) DEFAULT NULL, phone VARCHAR(10) DEFAULT NULL, default_seo_title VARCHAR(70) DEFAULT NULL, default_seo_description VARCHAR(160) DEFAULT NULL, google_analytics_id VARCHAR(20) DEFAULT NULL, google_search_console VARCHAR(100) DEFAULT NULL, primary_color VARCHAR(7) DEFAULT NULL, secondary_color VARCHAR(7) DEFAULT NULL, accent_color VARCHAR(7) DEFAULT NULL, font_family VARCHAR(100) DEFAULT NULL, font_family_secondary VARCHAR(100) DEFAULT NULL, template VARCHAR(20) DEFAULT \'default\' NOT NULL, catalog_price_display VARCHAR(3) DEFAULT \'ttc\' NOT NULL, enabled_modules JSON DEFAULT \'["vitrine"]\' NOT NULL, stripe_public_key VARCHAR(255) DEFAULT NULL, stripe_secret_key VARCHAR(255) DEFAULT NULL, stripe_webhook_secret VARCHAR(255) DEFAULT NULL, logo_id INT DEFAULT NULL, favicon_id INT DEFAULT NULL, hero_image_id INT DEFAULT NULL, about_image_id INT DEFAULT NULL, owner_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_694309E4F98F144A (logo_id), INDEX IDX_694309E4D78119FD (favicon_id), INDEX IDX_694309E498BB94C5 (hero_image_id), INDEX IDX_694309E471BB2404 (about_image_id), INDEX IDX_694309E47E3C61F9 (owner_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE site_gallery_item (id INT AUTO_INCREMENT NOT NULL, slot VARCHAR(30) NOT NULL, position SMALLINT DEFAULT 0 NOT NULL, title VARCHAR(255) DEFAULT NULL, content LONGTEXT DEFAULT NULL, site_id INT NOT NULL, media_id INT NOT NULL, INDEX IDX_478E9021F6BD1646 (site_id), INDEX IDX_478E9021EA9FDD75 (media_id), INDEX idx_gallery_slot (slot), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE tag (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, UNIQUE INDEX UNIQ_389B783989D9B62 (slug), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE tag_article (tag_id INT NOT NULL, article_id INT NOT NULL, INDEX IDX_300B23CCBAD26311 (tag_id), INDEX IDX_300B23CC7294869C (article_id), PRIMARY KEY (tag_id, article_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE tag_page (tag_id INT NOT NULL, page_id INT NOT NULL, INDEX IDX_FA050996BAD26311 (tag_id), INDEX IDX_FA050996C4663E4 (page_id), PRIMARY KEY (tag_id, page_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE tag_categorie (tag_id INT NOT NULL, categorie_id INT NOT NULL, INDEX IDX_584AEC13BAD26311 (tag_id), INDEX IDX_584AEC13BCF5E72D (categorie_id), PRIMARY KEY (tag_id, categorie_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE tag_media (tag_id INT NOT NULL, media_id INT NOT NULL, INDEX IDX_48C0B80ABAD26311 (tag_id), INDEX IDX_48C0B80AEA9FDD75 (media_id), PRIMARY KEY (tag_id, media_id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE user (id INT AUTO_INCREMENT NOT NULL, email VARCHAR(180) NOT NULL, roles JSON NOT NULL, password VARCHAR(255) NOT NULL, name VARCHAR(255) DEFAULT NULL, first_name VARCHAR(255) DEFAULT NULL, subscribe_news TINYINT DEFAULT NULL, subscribe_articles TINYINT DEFAULT NULL, subscribe_events TINYINT DEFAULT 0 NOT NULL, is_verified TINYINT DEFAULT 0 NOT NULL, bio LONGTEXT DEFAULT NULL, company VARCHAR(255) DEFAULT NULL, job_title VARCHAR(255) DEFAULT NULL, phone VARCHAR(20) DEFAULT NULL, is_directory_visible TINYINT DEFAULT 0 NOT NULL, avatar_id INT DEFAULT NULL, UNIQUE INDEX UNIQ_8D93D649E7927C74 (email), INDEX IDX_8D93D64986383B10 (avatar_id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('CREATE TABLE messenger_messages (id BIGINT AUTO_INCREMENT NOT NULL, body LONGTEXT NOT NULL, headers LONGTEXT NOT NULL, queue_name VARCHAR(190) NOT NULL, created_at DATETIME NOT NULL, available_at DATETIME NOT NULL, delivered_at DATETIME DEFAULT NULL, INDEX IDX_75EA56E0FB7336F0E3BD61CE16BA31DBBF396750 (queue_name, available_at, delivered_at, id), PRIMARY KEY (id)) DEFAULT CHARACTER SET utf8mb4');
        $this->addSql('ALTER TABLE article ADD CONSTRAINT FK_23A0E66E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE article_categorie ADD CONSTRAINT FK_934886107294869C FOREIGN KEY (article_id) REFERENCES article (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE article_categorie ADD CONSTRAINT FK_93488610BCF5E72D FOREIGN KEY (categorie_id) REFERENCES categorie (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE categorie ADD CONSTRAINT FK_497DD634E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE comment ADD CONSTRAINT FK_9474526C7294869C FOREIGN KEY (article_id) REFERENCES article (id)');
        $this->addSql('ALTER TABLE comment ADD CONSTRAINT FK_9474526CA76ED395 FOREIGN KEY (user_id) REFERENCES user (id)');
        $this->addSql('ALTER TABLE event ADD CONSTRAINT FK_3BAE0AA73DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE event ADD CONSTRAINT FK_3BAE0AA7D240BD1D FOREIGN KEY (linked_product_id) REFERENCES product (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE faq ADD CONSTRAINT FK_E8FF75CC12469DE2 FOREIGN KEY (category_id) REFERENCES faq_category (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE `like` ADD CONSTRAINT FK_AC6340B37294869C FOREIGN KEY (article_id) REFERENCES article (id)');
        $this->addSql('ALTER TABLE `like` ADD CONSTRAINT FK_AC6340B3EA9FDD75 FOREIGN KEY (media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE menu ADD CONSTRAINT FK_7D053A937294869C FOREIGN KEY (article_id) REFERENCES article (id)');
        $this->addSql('ALTER TABLE menu ADD CONSTRAINT FK_7D053A93BCF5E72D FOREIGN KEY (categorie_id) REFERENCES categorie (id)');
        $this->addSql('ALTER TABLE menu ADD CONSTRAINT FK_7D053A93C4663E4 FOREIGN KEY (page_id) REFERENCES page (id)');
        $this->addSql('ALTER TABLE menu ADD CONSTRAINT FK_7D053A93727ACA70 FOREIGN KEY (parent_id) REFERENCES menu (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE page ADD CONSTRAINT FK_140AB620E2532148 FOREIGN KEY (featured_media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE portfolio_item ADD CONSTRAINT FK_2F2A62E412469DE2 FOREIGN KEY (category_id) REFERENCES portfolio_category (id) ON DELETE SET NULL');
        $this->addSql('ALTER TABLE portfolio_item ADD CONSTRAINT FK_2F2A62E43DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE portfolio_item_tag ADD CONSTRAINT FK_9816962944DA7D90 FOREIGN KEY (portfolio_item_id) REFERENCES portfolio_item (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE portfolio_item_tag ADD CONSTRAINT FK_98169629BAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE product ADD CONSTRAINT FK_D34A04AD12469DE2 FOREIGN KEY (category_id) REFERENCES product_category (id)');
        $this->addSql('ALTER TABLE product ADD CONSTRAINT FK_D34A04AD3DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE product_tag ADD CONSTRAINT FK_E3A6E39C4584665A FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE product_tag ADD CONSTRAINT FK_E3A6E39CBAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE product_related ADD CONSTRAINT FK_B18E6B203DF63ED7 FOREIGN KEY (product_source) REFERENCES product (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE product_related ADD CONSTRAINT FK_B18E6B2024136E58 FOREIGN KEY (product_target) REFERENCES product (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE product_category ADD CONSTRAINT FK_CDFC73563DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE product_image ADD CONSTRAINT FK_64617F034584665A FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE product_image ADD CONSTRAINT FK_64617F03EA9FDD75 FOREIGN KEY (media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE product_variant ADD CONSTRAINT FK_209AA41D4584665A FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE reset_password_request ADD CONSTRAINT FK_7CE748AA76ED395 FOREIGN KEY (user_id) REFERENCES user (id)');
        $this->addSql('ALTER TABLE service ADD CONSTRAINT FK_E19D9AD23DA5256D FOREIGN KEY (image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE service ADD CONSTRAINT FK_E19D9AD2670E5B73 FOREIGN KEY (linked_page_id) REFERENCES page (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E4F98F144A FOREIGN KEY (logo_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E4D78119FD FOREIGN KEY (favicon_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E498BB94C5 FOREIGN KEY (hero_image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E471BB2404 FOREIGN KEY (about_image_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE site ADD CONSTRAINT FK_694309E47E3C61F9 FOREIGN KEY (owner_id) REFERENCES user (id)');
        $this->addSql('ALTER TABLE site_gallery_item ADD CONSTRAINT FK_478E9021F6BD1646 FOREIGN KEY (site_id) REFERENCES site (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE site_gallery_item ADD CONSTRAINT FK_478E9021EA9FDD75 FOREIGN KEY (media_id) REFERENCES media (id)');
        $this->addSql('ALTER TABLE tag_article ADD CONSTRAINT FK_300B23CCBAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_article ADD CONSTRAINT FK_300B23CC7294869C FOREIGN KEY (article_id) REFERENCES article (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_page ADD CONSTRAINT FK_FA050996BAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_page ADD CONSTRAINT FK_FA050996C4663E4 FOREIGN KEY (page_id) REFERENCES page (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_categorie ADD CONSTRAINT FK_584AEC13BAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_categorie ADD CONSTRAINT FK_584AEC13BCF5E72D FOREIGN KEY (categorie_id) REFERENCES categorie (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_media ADD CONSTRAINT FK_48C0B80ABAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE tag_media ADD CONSTRAINT FK_48C0B80AEA9FDD75 FOREIGN KEY (media_id) REFERENCES media (id) ON DELETE CASCADE');
        $this->addSql('ALTER TABLE user ADD CONSTRAINT FK_8D93D64986383B10 FOREIGN KEY (avatar_id) REFERENCES media (id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE article DROP FOREIGN KEY FK_23A0E66E2532148');
        $this->addSql('ALTER TABLE article_categorie DROP FOREIGN KEY FK_934886107294869C');
        $this->addSql('ALTER TABLE article_categorie DROP FOREIGN KEY FK_93488610BCF5E72D');
        $this->addSql('ALTER TABLE categorie DROP FOREIGN KEY FK_497DD634E2532148');
        $this->addSql('ALTER TABLE comment DROP FOREIGN KEY FK_9474526C7294869C');
        $this->addSql('ALTER TABLE comment DROP FOREIGN KEY FK_9474526CA76ED395');
        $this->addSql('ALTER TABLE event DROP FOREIGN KEY FK_3BAE0AA73DA5256D');
        $this->addSql('ALTER TABLE event DROP FOREIGN KEY FK_3BAE0AA7D240BD1D');
        $this->addSql('ALTER TABLE faq DROP FOREIGN KEY FK_E8FF75CC12469DE2');
        $this->addSql('ALTER TABLE `like` DROP FOREIGN KEY FK_AC6340B37294869C');
        $this->addSql('ALTER TABLE `like` DROP FOREIGN KEY FK_AC6340B3EA9FDD75');
        $this->addSql('ALTER TABLE menu DROP FOREIGN KEY FK_7D053A937294869C');
        $this->addSql('ALTER TABLE menu DROP FOREIGN KEY FK_7D053A93BCF5E72D');
        $this->addSql('ALTER TABLE menu DROP FOREIGN KEY FK_7D053A93C4663E4');
        $this->addSql('ALTER TABLE menu DROP FOREIGN KEY FK_7D053A93727ACA70');
        $this->addSql('ALTER TABLE page DROP FOREIGN KEY FK_140AB620E2532148');
        $this->addSql('ALTER TABLE portfolio_item DROP FOREIGN KEY FK_2F2A62E412469DE2');
        $this->addSql('ALTER TABLE portfolio_item DROP FOREIGN KEY FK_2F2A62E43DA5256D');
        $this->addSql('ALTER TABLE portfolio_item_tag DROP FOREIGN KEY FK_9816962944DA7D90');
        $this->addSql('ALTER TABLE portfolio_item_tag DROP FOREIGN KEY FK_98169629BAD26311');
        $this->addSql('ALTER TABLE product DROP FOREIGN KEY FK_D34A04AD12469DE2');
        $this->addSql('ALTER TABLE product DROP FOREIGN KEY FK_D34A04AD3DA5256D');
        $this->addSql('ALTER TABLE product_tag DROP FOREIGN KEY FK_E3A6E39C4584665A');
        $this->addSql('ALTER TABLE product_tag DROP FOREIGN KEY FK_E3A6E39CBAD26311');
        $this->addSql('ALTER TABLE product_related DROP FOREIGN KEY FK_B18E6B203DF63ED7');
        $this->addSql('ALTER TABLE product_related DROP FOREIGN KEY FK_B18E6B2024136E58');
        $this->addSql('ALTER TABLE product_category DROP FOREIGN KEY FK_CDFC73563DA5256D');
        $this->addSql('ALTER TABLE product_image DROP FOREIGN KEY FK_64617F034584665A');
        $this->addSql('ALTER TABLE product_image DROP FOREIGN KEY FK_64617F03EA9FDD75');
        $this->addSql('ALTER TABLE product_variant DROP FOREIGN KEY FK_209AA41D4584665A');
        $this->addSql('ALTER TABLE reset_password_request DROP FOREIGN KEY FK_7CE748AA76ED395');
        $this->addSql('ALTER TABLE service DROP FOREIGN KEY FK_E19D9AD23DA5256D');
        $this->addSql('ALTER TABLE service DROP FOREIGN KEY FK_E19D9AD2670E5B73');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E4F98F144A');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E4D78119FD');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E498BB94C5');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E471BB2404');
        $this->addSql('ALTER TABLE site DROP FOREIGN KEY FK_694309E47E3C61F9');
        $this->addSql('ALTER TABLE site_gallery_item DROP FOREIGN KEY FK_478E9021F6BD1646');
        $this->addSql('ALTER TABLE site_gallery_item DROP FOREIGN KEY FK_478E9021EA9FDD75');
        $this->addSql('ALTER TABLE tag_article DROP FOREIGN KEY FK_300B23CCBAD26311');
        $this->addSql('ALTER TABLE tag_article DROP FOREIGN KEY FK_300B23CC7294869C');
        $this->addSql('ALTER TABLE tag_page DROP FOREIGN KEY FK_FA050996BAD26311');
        $this->addSql('ALTER TABLE tag_page DROP FOREIGN KEY FK_FA050996C4663E4');
        $this->addSql('ALTER TABLE tag_categorie DROP FOREIGN KEY FK_584AEC13BAD26311');
        $this->addSql('ALTER TABLE tag_categorie DROP FOREIGN KEY FK_584AEC13BCF5E72D');
        $this->addSql('ALTER TABLE tag_media DROP FOREIGN KEY FK_48C0B80ABAD26311');
        $this->addSql('ALTER TABLE tag_media DROP FOREIGN KEY FK_48C0B80AEA9FDD75');
        $this->addSql('ALTER TABLE user DROP FOREIGN KEY FK_8D93D64986383B10');
        $this->addSql('DROP TABLE article');
        $this->addSql('DROP TABLE article_categorie');
        $this->addSql('DROP TABLE categorie');
        $this->addSql('DROP TABLE comment');
        $this->addSql('DROP TABLE event');
        $this->addSql('DROP TABLE faq');
        $this->addSql('DROP TABLE faq_category');
        $this->addSql('DROP TABLE `like`');
        $this->addSql('DROP TABLE media');
        $this->addSql('DROP TABLE menu');
        $this->addSql('DROP TABLE `option`');
        $this->addSql('DROP TABLE `order`');
        $this->addSql('DROP TABLE page');
        $this->addSql('DROP TABLE page_view');
        $this->addSql('DROP TABLE portfolio_category');
        $this->addSql('DROP TABLE portfolio_item');
        $this->addSql('DROP TABLE portfolio_item_tag');
        $this->addSql('DROP TABLE product');
        $this->addSql('DROP TABLE product_tag');
        $this->addSql('DROP TABLE product_related');
        $this->addSql('DROP TABLE product_category');
        $this->addSql('DROP TABLE product_image');
        $this->addSql('DROP TABLE product_variant');
        $this->addSql('DROP TABLE reset_password_request');
        $this->addSql('DROP TABLE service');
        $this->addSql('DROP TABLE site');
        $this->addSql('DROP TABLE site_gallery_item');
        $this->addSql('DROP TABLE tag');
        $this->addSql('DROP TABLE tag_article');
        $this->addSql('DROP TABLE tag_page');
        $this->addSql('DROP TABLE tag_categorie');
        $this->addSql('DROP TABLE tag_media');
        $this->addSql('DROP TABLE user');
        $this->addSql('DROP TABLE messenger_messages');
    }
}
