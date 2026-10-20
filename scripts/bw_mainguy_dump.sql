/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bw_mainguy
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `slug` varchar(255) NOT NULL,
  `published` tinyint(4) NOT NULL,
  `featured_text` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(4) NOT NULL DEFAULT 0,
  `visibility` varchar(20) NOT NULL DEFAULT 'public',
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `featured_media_id` int(11) DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_23A0E66989D9B62` (`slug`),
  KEY `IDX_23A0E66E2532148` (`featured_media_id`),
  KEY `idx_article_published` (`published`),
  KEY `IDX_23A0E66F675F31B` (`author_id`),
  CONSTRAINT `FK_23A0E66E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_23A0E66F675F31B` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `article_categorie`
--

DROP TABLE IF EXISTS `article_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_categorie` (
  `article_id` int(11) NOT NULL,
  `categorie_id` int(11) NOT NULL,
  PRIMARY KEY (`article_id`,`categorie_id`),
  KEY `IDX_934886107294869C` (`article_id`),
  KEY `IDX_93488610BCF5E72D` (`categorie_id`),
  CONSTRAINT `FK_934886107294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_93488610BCF5E72D` FOREIGN KEY (`categorie_id`) REFERENCES `categorie` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categorie`
--

DROP TABLE IF EXISTS `categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `color` varchar(10) NOT NULL,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `featured_media_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_497DD634989D9B62` (`slug`),
  KEY `IDX_497DD634E2532148` (`featured_media_id`),
  CONSTRAINT `FK_497DD634E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `article_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_9474526C7294869C` (`article_id`),
  KEY `IDX_9474526CA76ED395` (`user_id`),
  CONSTRAINT `FK_9474526C7294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `FK_9474526CA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_message`
--

DROP TABLE IF EXISTS `contact_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `ip_hash` varchar(64) NOT NULL,
  `source_page` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `is_read` tinyint(4) NOT NULL DEFAULT 0,
  `session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_2C9211FE613FECDF` (`session_id`),
  KEY `idx_contact_created` (`created_at`),
  KEY `idx_contact_read` (`is_read`),
  CONSTRAINT `FK_2C9211FE613FECDF` FOREIGN KEY (`session_id`) REFERENCES `stat_session` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory_category`
--

DROP TABLE IF EXISTS `directory_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `directory_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_2F42C2C989D9B62` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory_entry`
--

DROP TABLE IF EXISTS `directory_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `directory_entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `job_title` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `bio` longtext DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `linkedin` varchar(255) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `is_featured` tinyint(4) NOT NULL DEFAULT 0,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `tiktok` varchar(255) DEFAULT NULL,
  `booking_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_6553C92D989D9B62` (`slug`),
  KEY `IDX_6553C92D12469DE2` (`category_id`),
  KEY `IDX_6553C92DA76ED395` (`user_id`),
  KEY `idx_directory_active` (`is_active`),
  KEY `idx_directory_featured` (`is_featured`),
  CONSTRAINT `FK_6553C92D12469DE2` FOREIGN KEY (`category_id`) REFERENCES `directory_category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_6553C92DA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory_entry_tag`
--

DROP TABLE IF EXISTS `directory_entry_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `directory_entry_tag` (
  `directory_entry_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`directory_entry_id`,`tag_id`),
  KEY `IDX_2E8AEF15BE8E7CAF` (`directory_entry_id`),
  KEY `IDX_2E8AEF15BAD26311` (`tag_id`),
  CONSTRAINT `FK_2E8AEF15BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_2E8AEF15BE8E7CAF` FOREIGN KEY (`directory_entry_id`) REFERENCES `directory_entry` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `doctrine_migration_versions`
--

DROP TABLE IF EXISTS `doctrine_migration_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `document` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `extension` varchar(10) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `size` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `short_description` longtext DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `content` longtext NOT NULL,
  `date_start` datetime NOT NULL,
  `date_end` datetime DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `is_featured` tinyint(4) NOT NULL DEFAULT 0,
  `notified_at` datetime DEFAULT NULL,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `image_id` int(11) DEFAULT NULL,
  `linked_product_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_3BAE0AA7989D9B62` (`slug`),
  KEY `IDX_3BAE0AA73DA5256D` (`image_id`),
  KEY `IDX_3BAE0AA7D240BD1D` (`linked_product_id`),
  KEY `idx_event_active` (`is_active`),
  KEY `idx_event_date_start` (`date_start`),
  KEY `idx_event_featured` (`is_featured`),
  CONSTRAINT `FK_3BAE0AA73DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_3BAE0AA7D240BD1D` FOREIGN KEY (`linked_product_id`) REFERENCES `product` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `faq`
--

DROP TABLE IF EXISTS `faq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `faq` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `content` longtext NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_E8FF75CC989D9B62` (`slug`),
  KEY `IDX_E8FF75CC12469DE2` (`category_id`),
  KEY `idx_faq_active` (`is_active`),
  CONSTRAINT `FK_E8FF75CC12469DE2` FOREIGN KEY (`category_id`) REFERENCES `faq_category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `faq_category`
--

DROP TABLE IF EXISTS `faq_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `faq_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_FAEEE0D6989D9B62` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `like`
--

DROP TABLE IF EXISTS `like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `liked` varchar(255) NOT NULL,
  `article_id` int(11) DEFAULT NULL,
  `media_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_AC6340B37294869C` (`article_id`),
  KEY `IDX_AC6340B3EA9FDD75` (`media_id`),
  CONSTRAINT `FK_AC6340B37294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `FK_AC6340B3EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `webp_file_name` varchar(255) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `alt` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `menu_order` int(11) DEFAULT NULL,
  `is_visible` tinyint(4) NOT NULL,
  `target` varchar(255) NOT NULL,
  `location` varchar(20) NOT NULL DEFAULT 'header',
  `is_system` tinyint(4) NOT NULL DEFAULT 0,
  `system_key` varchar(50) DEFAULT NULL,
  `route` varchar(100) DEFAULT NULL,
  `route_params` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`route_params`)),
  `url` varchar(255) DEFAULT NULL,
  `article_id` int(11) DEFAULT NULL,
  `categorie_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_menu_location_system_key` (`location`,`system_key`),
  KEY `IDX_7D053A937294869C` (`article_id`),
  KEY `IDX_7D053A93BCF5E72D` (`categorie_id`),
  KEY `IDX_7D053A93C4663E4` (`page_id`),
  KEY `IDX_7D053A93727ACA70` (`parent_id`),
  KEY `idx_menu_is_visible` (`is_visible`),
  KEY `idx_menu_location` (`location`),
  KEY `IDX_7D053A93ED5CA9E6` (`service_id`),
  CONSTRAINT `FK_7D053A93727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `menu` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_7D053A937294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `FK_7D053A93BCF5E72D` FOREIGN KEY (`categorie_id`) REFERENCES `categorie` (`id`),
  CONSTRAINT `FK_7D053A93C4663E4` FOREIGN KEY (`page_id`) REFERENCES `page` (`id`),
  CONSTRAINT `FK_7D053A93ED5CA9E6` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `messenger_messages`
--

DROP TABLE IF EXISTS `messenger_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `messenger_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `body` longtext NOT NULL,
  `headers` longtext NOT NULL,
  `queue_name` varchar(190) NOT NULL,
  `created_at` datetime NOT NULL,
  `available_at` datetime NOT NULL,
  `delivered_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_75EA56E0FB7336F0E3BD61CE16BA31DBBF396750` (`queue_name`,`available_at`,`delivered_at`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `option`
--

DROP TABLE IF EXISTS `option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(20) NOT NULL,
  `customer_first_name` varchar(255) NOT NULL,
  `customer_last_name` varchar(255) NOT NULL,
  `customer_email` varchar(255) NOT NULL,
  `customer_phone` varchar(50) DEFAULT NULL,
  `customer_message` longtext DEFAULT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`items`)),
  `total_ht` decimal(10,2) NOT NULL,
  `total_vat` decimal(10,2) NOT NULL,
  `total_ttc` decimal(10,2) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `stripe_session_id` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `paid_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_F5299398AEA34913` (`reference`),
  KEY `idx_order_status` (`status`),
  KEY `idx_order_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `page`
--

DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visibility` varchar(20) NOT NULL DEFAULT 'public',
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `slug` varchar(255) NOT NULL,
  `published` tinyint(4) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `template` varchar(30) NOT NULL DEFAULT 'default',
  `is_system` tinyint(4) NOT NULL DEFAULT 0,
  `system_key` varchar(50) DEFAULT NULL,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `featured_media_id` int(11) DEFAULT NULL,
  `cta_text` varchar(100) DEFAULT NULL,
  `cta_url` varchar(500) DEFAULT NULL,
  `show_form` tinyint(1) DEFAULT 1,
  `form_title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_140AB620989D9B62` (`slug`),
  UNIQUE KEY `UNIQ_140AB62047280172` (`system_key`),
  KEY `IDX_140AB620E2532148` (`featured_media_id`),
  CONSTRAINT `FK_140AB620E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `page_view`
--

DROP TABLE IF EXISTS `page_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `page_view` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(500) NOT NULL,
  `ip_hash` varchar(64) NOT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `is_bot` tinyint(4) NOT NULL DEFAULT 0,
  `previous_url` varchar(500) DEFAULT NULL,
  `sequence_number` smallint(6) NOT NULL DEFAULT 1,
  `duration_seconds` smallint(6) DEFAULT NULL,
  `scroll_max_pct` smallint(6) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pageview_created_at` (`created_at`),
  KEY `idx_pageview_url` (`url`),
  KEY `idx_pageview_is_bot` (`is_bot`),
  KEY `idx_pageview_session` (`session_id`),
  CONSTRAINT `FK_7939B754613FECDF` FOREIGN KEY (`session_id`) REFERENCES `stat_session` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1881 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portfolio_category`
--

DROP TABLE IF EXISTS `portfolio_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_7AC64359989D9B62` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portfolio_item`
--

DROP TABLE IF EXISTS `portfolio_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `short_description` longtext DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `content` longtext NOT NULL,
  `client` varchar(255) DEFAULT NULL,
  `project_date` date DEFAULT NULL,
  `project_url` varchar(255) DEFAULT NULL,
  `gallery` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gallery`)),
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `is_featured` tinyint(4) NOT NULL DEFAULT 0,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `image_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_2F2A62E4989D9B62` (`slug`),
  KEY `IDX_2F2A62E412469DE2` (`category_id`),
  KEY `IDX_2F2A62E43DA5256D` (`image_id`),
  KEY `idx_portfolio_active` (`is_active`),
  KEY `idx_portfolio_featured` (`is_featured`),
  CONSTRAINT `FK_2F2A62E412469DE2` FOREIGN KEY (`category_id`) REFERENCES `portfolio_category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_2F2A62E43DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portfolio_item_tag`
--

DROP TABLE IF EXISTS `portfolio_item_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_item_tag` (
  `portfolio_item_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`portfolio_item_id`,`tag_id`),
  KEY `IDX_9816962944DA7D90` (`portfolio_item_id`),
  KEY `IDX_98169629BAD26311` (`tag_id`),
  CONSTRAINT `FK_9816962944DA7D90` FOREIGN KEY (`portfolio_item_id`) REFERENCES `portfolio_item` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_98169629BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `short_description` longtext DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `content` longtext NOT NULL,
  `price_ht` decimal(10,2) DEFAULT NULL,
  `old_price_ht` decimal(10,2) DEFAULT NULL,
  `vat_rate` decimal(4,2) NOT NULL DEFAULT 20.00,
  `availability` varchar(20) NOT NULL DEFAULT 'available',
  `booking_url` varchar(255) DEFAULT NULL,
  `booking_label` varchar(100) DEFAULT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `is_featured` tinyint(4) NOT NULL DEFAULT 0,
  `position` int(11) NOT NULL DEFAULT 0,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `image_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_D34A04AD989D9B62` (`slug`),
  KEY `IDX_D34A04AD12469DE2` (`category_id`),
  KEY `IDX_D34A04AD3DA5256D` (`image_id`),
  KEY `idx_product_active` (`is_active`),
  KEY `idx_product_featured` (`is_featured`),
  KEY `idx_product_availability` (`availability`),
  CONSTRAINT `FK_D34A04AD12469DE2` FOREIGN KEY (`category_id`) REFERENCES `product_category` (`id`),
  CONSTRAINT `FK_D34A04AD3DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category`
--

DROP TABLE IF EXISTS `product_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `image_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_CDFC7356989D9B62` (`slug`),
  KEY `IDX_CDFC73563DA5256D` (`image_id`),
  KEY `idx_product_category_active` (`is_active`),
  CONSTRAINT `FK_CDFC73563DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_image`
--

DROP TABLE IF EXISTS `product_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) NOT NULL DEFAULT 0,
  `product_id` int(11) NOT NULL,
  `media_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_64617F034584665A` (`product_id`),
  KEY `IDX_64617F03EA9FDD75` (`media_id`),
  CONSTRAINT `FK_64617F034584665A` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_64617F03EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_related`
--

DROP TABLE IF EXISTS `product_related`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_related` (
  `product_source` int(11) NOT NULL,
  `product_target` int(11) NOT NULL,
  PRIMARY KEY (`product_source`,`product_target`),
  KEY `IDX_B18E6B203DF63ED7` (`product_source`),
  KEY `IDX_B18E6B2024136E58` (`product_target`),
  CONSTRAINT `FK_B18E6B2024136E58` FOREIGN KEY (`product_target`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B18E6B203DF63ED7` FOREIGN KEY (`product_source`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_tag`
--

DROP TABLE IF EXISTS `product_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_tag` (
  `product_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`product_id`,`tag_id`),
  KEY `IDX_E3A6E39C4584665A` (`product_id`),
  KEY `IDX_E3A6E39CBAD26311` (`tag_id`),
  CONSTRAINT `FK_E3A6E39C4584665A` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_E3A6E39CBAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_variant`
--

DROP TABLE IF EXISTS `product_variant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `price_ht` decimal(10,2) DEFAULT NULL,
  `old_price_ht` decimal(10,2) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_209AA41D4584665A` (`product_id`),
  CONSTRAINT `FK_209AA41D4584665A` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reset_password_request`
--

DROP TABLE IF EXISTS `reset_password_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reset_password_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `selector` varchar(20) NOT NULL,
  `hashed_token` varchar(100) NOT NULL,
  `requested_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_7CE748AA76ED395` (`user_id`),
  CONSTRAINT `FK_7CE748AA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `short_description` longtext DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `content` longtext NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  `image_id` int(11) DEFAULT NULL,
  `linked_page_id` int(11) DEFAULT NULL,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(1) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_E19D9AD2989D9B62` (`slug`),
  KEY `IDX_E19D9AD23DA5256D` (`image_id`),
  KEY `IDX_E19D9AD2670E5B73` (`linked_page_id`),
  KEY `idx_service_active` (`is_active`),
  KEY `IDX_E19D9AD2727ACA70` (`parent_id`),
  CONSTRAINT `FK_E19D9AD23DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_E19D9AD2670E5B73` FOREIGN KEY (`linked_page_id`) REFERENCES `page` (`id`),
  CONSTRAINT `FK_E19D9AD2727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `service` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `site`
--

DROP TABLE IF EXISTS `site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `town` varchar(255) DEFAULT NULL,
  `post_code` varchar(255) DEFAULT NULL,
  `address_1` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `google_maps` varchar(255) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `default_seo_title` varchar(70) DEFAULT NULL,
  `default_seo_description` varchar(160) DEFAULT NULL,
  `google_analytics_id` varchar(20) DEFAULT NULL,
  `google_search_console` varchar(100) DEFAULT NULL,
  `primary_color` varchar(7) DEFAULT NULL,
  `secondary_color` varchar(7) DEFAULT NULL,
  `accent_color` varchar(7) DEFAULT NULL,
  `font_family` varchar(100) DEFAULT NULL,
  `font_family_secondary` varchar(100) DEFAULT NULL,
  `template` varchar(20) NOT NULL DEFAULT 'default',
  `catalog_price_display` varchar(3) NOT NULL DEFAULT 'ttc',
  `enabled_modules` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '["vitrine"]' CHECK (json_valid(`enabled_modules`)),
  `stripe_public_key` varchar(255) DEFAULT NULL,
  `stripe_secret_key` varchar(255) DEFAULT NULL,
  `stripe_webhook_secret` varchar(255) DEFAULT NULL,
  `logo_id` int(11) DEFAULT NULL,
  `favicon_id` int(11) DEFAULT NULL,
  `hero_image_id` int(11) DEFAULT NULL,
  `about_image_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `og_image_id` int(11) DEFAULT NULL,
  `logo_dark_id` int(11) DEFAULT NULL,
  `contact_image_id` int(11) DEFAULT NULL,
  `business_type` varchar(50) DEFAULT NULL,
  `price_range` varchar(10) DEFAULT NULL,
  `opening_hours` longtext DEFAULT NULL,
  `facebook_url` varchar(255) DEFAULT NULL,
  `instagram_url` varchar(255) DEFAULT NULL,
  `linkedin_url` varchar(255) DEFAULT NULL,
  `twitter_handle` varchar(100) DEFAULT NULL,
  `seo_activity` longtext DEFAULT NULL,
  `seo_audience` varchar(255) DEFAULT NULL,
  `seo_strengths` longtext DEFAULT NULL,
  `seo_reach` varchar(20) DEFAULT NULL,
  `seo_areas` longtext DEFAULT NULL,
  `seo_priorities` longtext DEFAULT NULL,
  `seo_customer_words` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_694309E4F98F144A` (`logo_id`),
  KEY `IDX_694309E4D78119FD` (`favicon_id`),
  KEY `IDX_694309E498BB94C5` (`hero_image_id`),
  KEY `IDX_694309E471BB2404` (`about_image_id`),
  KEY `IDX_694309E47E3C61F9` (`owner_id`),
  KEY `IDX_694309E46EFCB8B8` (`og_image_id`),
  KEY `IDX_694309E4E3225E88` (`logo_dark_id`),
  KEY `IDX_694309E4A780B9FA` (`contact_image_id`),
  CONSTRAINT `FK_694309E46EFCB8B8` FOREIGN KEY (`og_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E471BB2404` FOREIGN KEY (`about_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E47E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_694309E498BB94C5` FOREIGN KEY (`hero_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E4A780B9FA` FOREIGN KEY (`contact_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E4D78119FD` FOREIGN KEY (`favicon_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E4E3225E88` FOREIGN KEY (`logo_dark_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E4F98F144A` FOREIGN KEY (`logo_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `site_gallery_item`
--

DROP TABLE IF EXISTS `site_gallery_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_gallery_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slot` varchar(30) NOT NULL,
  `position` smallint(6) NOT NULL DEFAULT 0,
  `title` varchar(255) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `site_id` int(11) NOT NULL,
  `media_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_478E9021F6BD1646` (`site_id`),
  KEY `IDX_478E9021EA9FDD75` (`media_id`),
  KEY `idx_gallery_slot` (`slot`),
  CONSTRAINT `FK_478E9021EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_478E9021F6BD1646` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slug_redirect`
--

DROP TABLE IF EXISTS `slug_redirect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `slug_redirect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(50) NOT NULL,
  `old_slug` varchar(255) NOT NULL,
  `new_slug` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_slug_redirect_lookup` (`entity_type`,`old_slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stat_conversion`
--

DROP TABLE IF EXISTS `stat_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `stat_conversion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `page_url` varchar(500) NOT NULL,
  `detail` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_conversion_session` (`session_id`),
  KEY `idx_conversion_type` (`type`),
  KEY `idx_conversion_created` (`created_at`),
  CONSTRAINT `FK_724550EC613FECDF` FOREIGN KEY (`session_id`) REFERENCES `stat_session` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stat_session`
--

DROP TABLE IF EXISTS `stat_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `stat_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_token` varchar(64) NOT NULL,
  `started_at` datetime NOT NULL,
  `ended_at` datetime NOT NULL,
  `source` varchar(30) NOT NULL,
  `source_detail` varchar(500) DEFAULT NULL,
  `utm_campaign` varchar(255) DEFAULT NULL,
  `utm_medium` varchar(100) DEFAULT NULL,
  `landing_page` varchar(500) NOT NULL,
  `exit_page` varchar(500) NOT NULL,
  `page_count` smallint(6) NOT NULL DEFAULT 1,
  `ip_hash` varchar(64) NOT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `is_bot` tinyint(4) NOT NULL DEFAULT 0,
  `device_type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_34BEA24D844A19ED` (`session_token`),
  KEY `idx_session_started` (`started_at`),
  KEY `idx_session_source` (`source`),
  KEY `idx_session_token` (`session_token`),
  KEY `idx_session_bot` (`is_bot`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscriber`
--

DROP TABLE IF EXISTS `subscriber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriber` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(180) NOT NULL,
  `subscribe_articles` tinyint(4) NOT NULL DEFAULT 0,
  `subscribe_events` tinyint(4) NOT NULL DEFAULT 0,
  `token` varchar(64) NOT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_AD005B69E7927C74` (`email`),
  UNIQUE KEY `UNIQ_AD005B695F37A13B` (`token`),
  KEY `idx_subscriber_articles` (`is_active`,`subscribe_articles`),
  KEY `idx_subscriber_events` (`is_active`,`subscribe_events`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `tag_group_id` int(11) DEFAULT NULL,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(1) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_389B783989D9B62` (`slug`),
  KEY `IDX_389B783C865A29C` (`tag_group_id`),
  CONSTRAINT `FK_389B783C865A29C` FOREIGN KEY (`tag_group_id`) REFERENCES `tag_group` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_article`
--

DROP TABLE IF EXISTS `tag_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_article` (
  `tag_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  PRIMARY KEY (`tag_id`,`article_id`),
  KEY `IDX_300B23CCBAD26311` (`tag_id`),
  KEY `IDX_300B23CC7294869C` (`article_id`),
  CONSTRAINT `FK_300B23CC7294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_300B23CCBAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_categorie`
--

DROP TABLE IF EXISTS `tag_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_categorie` (
  `tag_id` int(11) NOT NULL,
  `categorie_id` int(11) NOT NULL,
  PRIMARY KEY (`tag_id`,`categorie_id`),
  KEY `IDX_584AEC13BAD26311` (`tag_id`),
  KEY `IDX_584AEC13BCF5E72D` (`categorie_id`),
  CONSTRAINT `FK_584AEC13BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_584AEC13BCF5E72D` FOREIGN KEY (`categorie_id`) REFERENCES `categorie` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_group`
--

DROP TABLE IF EXISTS `tag_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `color` varchar(7) NOT NULL DEFAULT '#6c757d',
  `display_order` int(11) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_4F2C5DC3989D9B62` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_media`
--

DROP TABLE IF EXISTS `tag_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_media` (
  `tag_id` int(11) NOT NULL,
  `media_id` int(11) NOT NULL,
  PRIMARY KEY (`tag_id`,`media_id`),
  KEY `IDX_48C0B80ABAD26311` (`tag_id`),
  KEY `IDX_48C0B80AEA9FDD75` (`media_id`),
  CONSTRAINT `FK_48C0B80ABAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_48C0B80AEA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_page`
--

DROP TABLE IF EXISTS `tag_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag_page` (
  `tag_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  PRIMARY KEY (`tag_id`,`page_id`),
  KEY `IDX_FA050996BAD26311` (`tag_id`),
  KEY `IDX_FA050996C4663E4` (`page_id`),
  CONSTRAINT `FK_FA050996BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_FA050996C4663E4` FOREIGN KEY (`page_id`) REFERENCES `page` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(180) NOT NULL,
  `roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`roles`)),
  `password` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(4) NOT NULL DEFAULT 0,
  `bio` longtext DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `job_title` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `is_directory_visible` tinyint(4) NOT NULL DEFAULT 0,
  `avatar_id` int(11) DEFAULT NULL,
  `tour_completed` tinyint(1) NOT NULL DEFAULT 0,
  `admin_expert` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`),
  KEY `IDX_8D93D64986383B10` (`avatar_id`),
  CONSTRAINT `FK_8D93D64986383B10` FOREIGN KEY (`avatar_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-10-20 15:01:36
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bw_mainguy
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Dumping data for table `article`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `article_categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `article_categorie` WRITE;
/*!40000 ALTER TABLE `article_categorie` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_categorie` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `categorie` WRITE;
/*!40000 ALTER TABLE `categorie` DISABLE KEYS */;
INSERT INTO `categorie` VALUES
(1,'Patrimoine','patrimoine','#008000','Transmission patrimoine','Super transmi','Patrimoine,',0,NULL,NULL);
/*!40000 ALTER TABLE `categorie` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `directory_category`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `directory_category` WRITE;
/*!40000 ALTER TABLE `directory_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `directory_category` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `directory_entry`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `directory_entry` WRITE;
/*!40000 ALTER TABLE `directory_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `directory_entry` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `directory_entry_tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `directory_entry_tag` WRITE;
/*!40000 ALTER TABLE `directory_entry_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `directory_entry_tag` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `doctrine_migration_versions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `doctrine_migration_versions` WRITE;
/*!40000 ALTER TABLE `doctrine_migration_versions` DISABLE KEYS */;
INSERT INTO `doctrine_migration_versions` VALUES
('DoctrineMigrations\\Version20260327093858','2026-08-25 08:37:42',2314),
('DoctrineMigrations\\Version20260330175902','2026-08-25 08:37:45',40),
('DoctrineMigrations\\Version20260331051133','2026-08-25 08:37:45',757),
('DoctrineMigrations\\Version20260331120749','2026-08-25 08:37:45',20),
('DoctrineMigrations\\Version20260331134753','2026-08-25 08:37:45',17),
('DoctrineMigrations\\Version20260402035203','2026-08-25 08:37:45',77),
('DoctrineMigrations\\Version20260403055742','2026-08-25 08:37:45',83),
('DoctrineMigrations\\Version20260403093313','2026-08-25 08:37:46',118),
('DoctrineMigrations\\Version20260408055018','2026-08-25 08:37:46',91),
('DoctrineMigrations\\Version20260409085027','2026-08-25 08:37:46',19),
('DoctrineMigrations\\Version20260416073057','2026-08-25 08:37:46',15),
('DoctrineMigrations\\Version20260429075920','2026-08-25 08:37:46',161),
('DoctrineMigrations\\Version20260504063822','2026-08-25 08:37:46',75),
('DoctrineMigrations\\Version20260508090000','2026-08-25 08:37:46',11),
('DoctrineMigrations\\Version20260510131558','2026-08-25 08:37:46',90),
('DoctrineMigrations\\Version20260518170000','2026-08-25 08:37:46',15),
('DoctrineMigrations\\Version20260520120000','2026-08-25 08:37:46',132),
('DoctrineMigrations\\Version20260521043802','2026-08-25 08:37:46',137),
('DoctrineMigrations\\Version20260521051808','2026-08-25 08:37:46',41),
('DoctrineMigrations\\Version20260615180000','2026-08-25 08:37:46',15),
('DoctrineMigrations\\Version20260615185204','2026-08-25 08:37:46',11),
('DoctrineMigrations\\Version20260615192357','2026-08-25 08:37:47',13),
('DoctrineMigrations\\Version20260616040528','2026-08-25 08:37:47',29),
('DoctrineMigrations\\Version20261017055243','2026-10-19 10:16:52',30),
('DoctrineMigrations\\Version20261017061500','2026-10-19 10:16:52',15),
('DoctrineMigrations\\Version20261018054056','2026-10-20 06:41:17',20),
('DoctrineMigrations\\Version20261019061849','2026-10-20 06:40:24',27),
('DoctrineMigrations\\Version20261019081701','2026-10-19 10:17:16',91),
('DoctrineMigrations\\Version20261020044200','2026-10-20 06:42:14',81),
('DoctrineMigrations\\Version20261020051727','2026-10-20 07:17:55',41);
/*!40000 ALTER TABLE `doctrine_migration_versions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `document`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
/*!40000 ALTER TABLE `document` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `event`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `event` WRITE;
/*!40000 ALTER TABLE `event` DISABLE KEYS */;
/*!40000 ALTER TABLE `event` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `faq`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
/*!40000 ALTER TABLE `faq` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `faq_category`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `faq_category` WRITE;
/*!40000 ALTER TABLE `faq_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `faq_category` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `like`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `like` WRITE;
/*!40000 ALTER TABLE `like` DISABLE KEYS */;
/*!40000 ALTER TABLE `like` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `media`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES
(5,'Logo BM blanc transparent','logo-bm-blanc.png','logo-bm-blanc.webp',187,131,NULL),
(6,'Logo BM anthracite transparent','logo-bm-anthracite.png','logo-bm-anthracite.webp',187,131,NULL),
(8,'Affiche video hero - Saint-Martory','hero-bm-affiche.webp',NULL,1600,900,NULL),
(9,'Portrait — Maître Bruno Mainguy','portrait-bruno-mainguy.jpg','portrait-bruno-mainguy.webp',1278,1230,NULL),
(10,'Expertise — immobilier','expertise-immobilier.jpg','expertise-immobilier.webp',888,488,NULL),
(11,'Expertise — famille et patrimoine','expertise-famille.jpg','expertise-famille.webp',888,488,NULL),
(12,'Expertise - formalites','expertise-formalites.webp',NULL,900,675,NULL),
(13,'Expertise — entreprise','expertise-entreprise.jpg','expertise-entreprise.webp',888,488,NULL),
(14,'Expertise — droit rural','expertise-droit-rural.jpg','expertise-droit-rural.webp',888,488,NULL);
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `menu`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES
(1,'Accueil',0,0,'route','header',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'Actualités',40,0,'route','header',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,'Expertises',10,1,'route','header',1,'services','app_service_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'Catalogue',30,0,'route','header',1,'catalogue','app_product_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,'Événements',40,0,'route','header',1,'events','app_event_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,'Annuaire',50,0,'route','header',1,'annuaire','app_directory',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,'Contact',50,1,'route','header',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,'Accueil',0,1,'route','footer_nav',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,'Actualités',40,0,'route','footer_nav',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,'Contact',20,1,'route','footer_nav',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(11,'Mentions légales',0,1,'route','footer_legal',1,'mentions-legales','app_legal_page','{\"type\":\"mentions-legales\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(12,'Politique de confidentialité',10,1,'route','footer_legal',1,'politique-confidentialite','app_legal_page','{\"type\":\"politique-de-confidentialite\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(13,'CGV',20,0,'route','footer_legal',1,'cgv','app_legal_page','{\"type\":\"conditions-generales-de-vente\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(14,'CGU',30,1,'route','footer_legal',1,'cgu','app_legal_page','{\"type\":\"conditions-generales-utilisation\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(15,'Tarifs',40,0,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL,NULL),
(16,'Tarifs',15,0,'page','footer_nav',0,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL,NULL),
(17,'L’Étude',0,1,'url','header',0,NULL,NULL,NULL,'/l-etude',NULL,NULL,NULL,NULL,NULL),
(18,'Votre projet',20,1,'url','header',0,NULL,NULL,NULL,'/votre-projet',NULL,NULL,NULL,NULL,NULL),
(19,'Simulateurs',30,1,'url','header',0,NULL,NULL,NULL,'/simulateurs',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `option`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `option` WRITE;
/*!40000 ALTER TABLE `option` DISABLE KEYS */;
/*!40000 ALTER TABLE `option` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `page`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES
(1,'public','Mentions légales','<p><em>Dernière mise à jour : 25 août 2026</em></p>\n\n<h2>1. Éditeur du site</h2>\n<table class=\"tiptap-table\">\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>Forme juridique</strong></td><td>SELARL à associé unique</td></tr>\n<tr><td><strong>Siège social</strong></td><td>379 rue des Villas, 31360 Saint-Martory</td></tr>\n<tr><td><strong>SIRET</strong></td><td>948 742 523 00012</td></tr>\n<tr><td><strong>N° TVA</strong></td><td>{{TVA}}</td></tr>\n<tr><td><strong>Capital social</strong></td><td>{{CAPITAL}}</td></tr>\n<tr><td><strong>Directeur de publication</strong></td><td>Maître Bruno Mainguy</td></tr>\n<tr><td><strong>Contact</strong></td><td>bruno.mainguy&#64;31061.notaires.fr</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>05 61 90 20 40</td></tr>\n</tbody>\n</table>\n\n<h2>2. Hébergement</h2>\n<table class=\"tiptap-table\">\n<tbody>\n<tr><td><strong>Hébergeur</strong></td><td>OVH SAS</td></tr>\n<tr><td><strong>Adresse</strong></td><td>2 rue Kellermann, 59100 Roubaix, France</td></tr>\n<tr><td><strong>Site web</strong></td><td>https://www.ovhcloud.com/fr/</td></tr>\n</tbody>\n</table>\n<p>L&#039;ensemble des données sont hébergées en France, conformément au RGPD.</p>\n\n<h2>3. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p>\n<p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p>\n\n<h2>4. Protection des données</h2>\n<ul>\n<li>Hébergement 100 % France</li>\n<li>Aucun transfert de données hors UE</li>\n<li>Données personnelles jamais revendues</li>\n</ul>\n<p><strong>Contact DPO :</strong> bruno.mainguy&#64;31061.notaires.fr</p>\n<p>Voir la <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a> pour les détails complets.</p>\n\n<h2>5. Cookies</h2>\n<table class=\"tiptap-table\">\n<thead>\n<tr><th>Cookie</th><th>Type</th><th>Finalité</th><th>Consentement</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP</td><td>Essentiel</td><td>Authentification</td><td>Non requis</td></tr>\n<tr><td>CSRF</td><td>Essentiel</td><td>Sécurité formulaires</td><td>Non requis</td></tr>\n<tr><td>_bw_sid</td><td>Mesure d&#039;audience</td><td>Session de visite anonyme (30 min)</td><td>Non requis (exempt CNIL)</td></tr>\n<tr><td>Google Analytics</td><td>Analytique tiers</td><td>Mesure d&#039;audience</td><td><strong>Requis</strong></td></tr>\n<tr><td>Préférences cookies</td><td>Fonctionnel</td><td>Mémoriser votre choix</td><td>Non requis</td></tr>\n</tbody>\n</table>\n<p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p>\n\n<h2>6. Limitation de responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p>\n<p>L&#039;éditeur décline toute responsabilité en cas d&#039;interruption du site, de survenance de bugs ou d&#039;incompatibilité du site avec certains matériels ou configurations.</p>\n\n<h2>7. Droit applicable et litiges</h2>\n<p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p>\n<p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : {{MEDIATEUR}}.</p>\n\n<h2>8. Contact</h2>\n<table class=\"tiptap-table\">\n<tbody>\n<tr><td><strong>Email</strong></td><td>bruno.mainguy&#64;31061.notaires.fr</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — 379 rue des Villas, 31360 Saint-Martory</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>05 61 90 20 40</td></tr>\n</tbody>\n</table>','mentions-legales',1,'2026-08-25 08:38:40','2026-08-28 14:39:33',NULL,'full-width',1,'mentions-legales',NULL,'Mentions légales du site. Éditeur, hébergeur, propriété intellectuelle et contact.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(2,'public','Politique de confidentialité','<p><em>Dernière mise à jour : 25 août 2026</em></p><h2>1. Responsable du traitement</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>Entité</strong></p></td><td><p>{{RAISON_SOCIALE}}</p></td></tr><tr><td><p><strong>Représentant</strong></p></td><td><p>Maître Bruno Mainguy</p></td></tr><tr><td><p><strong>Siège</strong></p></td><td><p>379 rue des Villas, 31360 Saint-Martory</p></td></tr><tr><td><p><strong>SIRET</strong></p></td><td><p>948 742 523 00012</p></td></tr><tr><td><p><strong>DPO</strong></p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr></tbody></table><h2>2. Données collectées</h2><h3>2.1 Formulaire de contact</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Donnée</p></th><th><p>Finalité</p></th><th><p>Conservation</p></th></tr><tr><td><p>Nom, email</p></td><td><p>Répondre à la demande</p></td><td><p>3 ans</p></td></tr><tr><td><p>Message</p></td><td><p>Traitement de la demande</p></td><td><p>3 ans</p></td></tr></tbody></table><h3>2.2 Commentaires</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Donnée</p></th><th><p>Finalité</p></th><th><p>Conservation</p></th></tr><tr><td><p>Nom, contenu</p></td><td><p>Affichage public</p></td><td><p>Durée de publication</p></td></tr></tbody></table><h3>2.3 Mesure d&#039;audience interne</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Donnée</p></th><th><p>Finalité</p></th><th><p>Conservation</p></th></tr><tr><td><p>IP hashée (SHA-256 &#43; sel journalier)</p></td><td><p>Statistiques pseudonymisées, sécurité</p></td><td><p>13 mois</p></td></tr><tr><td><p>Pages visitées, parcours, durée, scroll</p></td><td><p>Amélioration du site</p></td><td><p>13 mois</p></td></tr><tr><td><p>Source d&#039;arrivée (referer, paramètres UTM)</p></td><td><p>Mesure d&#039;acquisition</p></td><td><p>13 mois</p></td></tr><tr><td><p>Type d&#039;appareil (desktop, mobile, tablette)</p></td><td><p>Statistique technique</p></td><td><p>13 mois</p></td></tr></tbody></table><p>Ces données sont <strong>pseudonymisées</strong> : l’adresse IP est remplacée par une empreinte SHA-256 salée quotidiennement, et aucun nom ne leur est associé. L&#039;adresse IP n&#039;est jamais stockée en clair. Aucune donnée n&#039;est partagée avec des tiers. Ce traitement est exempt de consentement conformément aux recommandations de la CNIL relatives aux outils de mesure d&#039;audience (délibération n°2020-091).</p><h3>2.4 Dépôt documentaire (espace client)</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Donnée</p></th><th><p>Finalité</p></th><th><p>Conservation</p></th></tr><tr><td><p>Nom, e-mail, téléphone</p></td><td><p>Identifier le déposant et lui répondre</p></td><td><p>3 ans</p></td></tr><tr><td><p>Référence de dossier, message</p></td><td><p>Rattacher les pièces au dossier</p></td><td><p>3 ans</p></td></tr><tr><td><p>Documents transmis</p></td><td><p>Instruction du dossier</p></td><td><p>Non conservés par le site : acheminés par courrier électronique puis effacés. Leur conservation relève ensuite de la messagerie et des obligations d&#039;archivage de l&#039;étude</p></td></tr><tr><td><p>Liste des pièces (nom et poids)</p></td><td><p>Garder trace de ce qui a été reçu</p></td><td><p>3 ans</p></td></tr><tr><td><p>IP hashée (SHA-256 &#43; sel journalier)</p></td><td><p>Prévention des abus</p></td><td><p>3 ans</p></td></tr></tbody></table><p>Les pièces déposées <strong>ne sont jamais enregistrées sur le serveur du site</strong> : elles sont lues le temps de la requête, jointes au courrier électronique adressé à l&#039;étude, puis effacées. Le site n&#039;en garde que la liste des noms et des poids.</p><p><strong>Limite du courrier électronique.</strong> Le dépôt lui-même s&#039;effectue par liaison chiffrée, mais le courrier électronique ne chiffre que son transport. Vos pièces transitent et sont conservées en clair chez le prestataire d&#039;envoi, puis dans la messagerie de l&#039;étude. Nous vous recommandons de ne transmettre par ce canal que les pièces nécessaires, et de remettre les documents les plus sensibles par un autre moyen.</p><h2>3. Finalités du traitement</h2><ul><li><p>Gestion des comptes utilisateurs</p></li><li><p>Envoi de notifications relatives aux articles et au site</p></li><li><p>Traitement des demandes de contact</p></li><li><p>Amélioration du site via des statistiques de visite pseudonymisées</p></li></ul><h2>4. Base légale</h2><table class=\"tiptap-table\"><tbody><tr><th><p>Traitement</p></th><th><p>Base légale (RGPD)</p></th></tr><tr><td><p>Compte utilisateur</p></td><td><p>Exécution du contrat (art. 6.1.b)</p></td></tr><tr><td><p>Contact</p></td><td><p>Consentement (art. 6.1.a)</p></td></tr><tr><td><p>Mesure d’audience interne (pseudonymisée)</p></td><td><p>Intérêt légitime (art. 6.1.f) — exempt de consentement CNIL</p></td></tr><tr><td><p>Sécurité / logs</p></td><td><p>Intérêt légitime (art. 6.1.f)</p></td></tr></tbody></table><h2>5. Ce que nous ne faisons PAS</h2><ul><li><p>Vendre ou louer vos données à des tiers</p></li><li><p>Faire de la publicité ciblée</p></li><li><p>Faire du profilage marketing</p></li><li><p>Transférer vos données hors de l&#039;Union Européenne (hors sous-traitants certifiés)</p></li></ul><h2>6. Cookies</h2><h3>Cookies essentiels et de mesure exemptés (sans consentement)</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Cookie</p></th><th><p>Finalité</p></th><th><p>Durée</p></th></tr><tr><td><p>Session PHP (PHPSESSID)</p></td><td><p>Authentification</p></td><td><p>Session</p></td></tr><tr><td><p>CSRF token</p></td><td><p>Sécurité des formulaires</p></td><td><p>Session</p></td></tr><tr><td><p>Préférences cookies</p></td><td><p>Mémoriser votre choix</p></td><td><p>13 mois</p></td></tr><tr><td><p>_bw_sid</p></td><td><p>Mesure d’audience (session de visite)</p></td><td><p>30 minutes</p></td></tr></tbody></table><p>Le cookie <strong>_bw_sid</strong> est un cookie first-party de mesure d&#039;audience. Il n’est pas partagé avec des tiers et expire après 30 minutes d&#039;inactivité. Conformément aux recommandations de la CNIL, ce type de cookie est <strong>exempt de consentement</strong>.</p><h2>7. Sous-traitants</h2><table class=\"tiptap-table\"><tbody><tr><th><p>Prestataire</p></th><th><p>Pays</p></th><th><p>Finalité</p></th></tr><tr><td><p>OVH SAS</p></td><td><p>France</p></td><td><p>Hébergement</p></td></tr><tr><td><p>Brevo</p></td><td><p>France</p></td><td><p>Acheminement des courriers électroniques, y compris les pièces jointes au dépôt documentaire</p></td></tr></tbody></table><h2>8. Vos droits RGPD</h2><table class=\"tiptap-table\"><tbody><tr><th><p>Droit</p></th><th><p>Comment l&#039;exercer</p></th></tr><tr><td><p>Accès</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Rectification</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Suppression</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Portabilité</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Opposition</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Limitation</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr></tbody></table><p><strong>Délai de réponse :</strong> 30 jours maximum.</p><p>En cas de difficulté, vous pouvez adresser une réclamation auprès de la <strong>CNIL</strong> : <a href=\"https://www.cnil.fr\" target=\"_blank\" rel=\"noopener noreferrer\">www.cnil.fr</a> — 3 Place de Fontenoy, 75334 Paris Cedex 07.</p><h2>9. Sécurité</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>Transfert</strong></p></td><td><p>HTTPS / TLS 1.3</p></td></tr><tr><td><p><strong>Mots de passe</strong></p></td><td><p>Hashés (bcrypt/argon2)</p></td></tr><tr><td><p><strong>IP visiteurs</strong></p></td><td><p>Hashées SHA-256 (pseudonymisées)</p></td></tr><tr><td><p><strong>Accès admin</strong></p></td><td><p>Protégé par authentification &#43; CSRF</p></td></tr></tbody></table><h2>10. Modifications</h2><p>Cette politique peut être mise à jour. En cas de changement significatif, les utilisateurs inscrits seront informés par email. La date de mise à jour figure en haut de page.</p><h2>11. Contact</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>DPO</strong></p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p><strong>Courrier</strong></p></td><td><p>{{RAISON_SOCIALE}} — 379 rue des Villas, 31360 Saint-Martory</p></td></tr></tbody></table>','politique-confidentialite',1,'2026-08-25 08:38:40','2026-08-28 14:40:49','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"italic\"}],\"text\":\"Derni\\u00e8re mise \\u00e0 jour : 25 ao\\u00fbt 2026\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"1. Responsable du traitement\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Entit\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"{{RAISON_SOCIALE}}\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Repr\\u00e9sentant\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Ma\\u00eetre Bruno Mainguy\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Si\\u00e8ge\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"379 rue des Villas, 31360 Saint-Martory\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"SIRET\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"948 742 523 00012\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"DPO\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"2. Donn\\u00e9es collect\\u00e9es\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"2.1 Formulaire de contact\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9e\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conservation\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Nom, email\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9pondre \\u00e0 la demande\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"3 ans\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Message\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Traitement de la demande\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"3 ans\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"2.2 Commentaires\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9e\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conservation\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Nom, contenu\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Affichage public\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Dur\\u00e9e de publication\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"2.3 Mesure d\'audience interne\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9e\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conservation\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"IP hash\\u00e9e (SHA-256 + sel journalier)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Statistiques pseudonymis\\u00e9es, s\\u00e9curit\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pages visit\\u00e9es, parcours, dur\\u00e9e, scroll\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Am\\u00e9lioration du site\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Source d\'arriv\\u00e9e (referer, param\\u00e8tres UTM)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mesure d\'acquisition\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Type d\'appareil (desktop, mobile, tablette)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Statistique technique\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Ces donn\\u00e9es sont \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"pseudonymis\\u00e9es\"},{\"type\":\"text\",\"text\":\" : l\\u2019adresse IP est remplac\\u00e9e par une empreinte SHA-256 sal\\u00e9e quotidiennement, et aucun nom ne leur est associ\\u00e9. L\'adresse IP n\'est jamais stock\\u00e9e en clair. Aucune donn\\u00e9e n\'est partag\\u00e9e avec des tiers. Ce traitement est exempt de consentement conform\\u00e9ment aux recommandations de la CNIL relatives aux outils de mesure d\'audience (d\\u00e9lib\\u00e9ration n\\u00b02020-091).\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"3. Finalit\\u00e9s du traitement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Gestion des comptes utilisateurs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Envoi de notifications relatives aux articles et au site\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Traitement des demandes de contact\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Am\\u00e9lioration du site via des statistiques de visite pseudonymis\\u00e9es\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"4. Base l\\u00e9gale\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Traitement\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Base l\\u00e9gale (RGPD)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Compte utilisateur\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Ex\\u00e9cution du contrat (art. 6.1.b)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Contact\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Consentement (art. 6.1.a)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mesure d\\u2019audience interne (pseudonymis\\u00e9e)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Int\\u00e9r\\u00eat l\\u00e9gitime (art. 6.1.f) \\u2014 exempt de consentement CNIL\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9curit\\u00e9 \\/ logs\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Int\\u00e9r\\u00eat l\\u00e9gitime (art. 6.1.f)\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"5. Ce que nous ne faisons PAS\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Vendre ou louer vos donn\\u00e9es \\u00e0 des tiers\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Faire de la publicit\\u00e9 cibl\\u00e9e\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Faire du profilage marketing\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Transf\\u00e9rer vos donn\\u00e9es hors de l\'Union Europ\\u00e9enne (hors sous-traitants certifi\\u00e9s)\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"6. Cookies\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Cookies essentiels et de mesure exempt\\u00e9s (sans consentement)\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cookie\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Dur\\u00e9e\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Session PHP (PHPSESSID)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Authentification\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Session\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"CSRF token\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9curit\\u00e9 des formulaires\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Session\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pr\\u00e9f\\u00e9rences cookies\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"M\\u00e9moriser votre choix\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"_bw_sid\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mesure d\\u2019audience (session de visite)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"30 minutes\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Le cookie \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"_bw_sid\"},{\"type\":\"text\",\"text\":\" est un cookie first-party de mesure d\'audience. Il n\\u2019est pas partag\\u00e9 avec des tiers et expire apr\\u00e8s 30 minutes d\'inactivit\\u00e9. Conform\\u00e9ment aux recommandations de la CNIL, ce type de cookie est \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"exempt de consentement\"},{\"type\":\"text\",\"text\":\".\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"7. Sous-traitants\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Prestataire\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pays\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"OVH SAS\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"France\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9bergement\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Brevo\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"France\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Envoi d\'emails\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"8. Vos droits RGPD\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Droit\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Comment l\'exercer\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Acc\\u00e8s\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Rectification\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Suppression\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Portabilit\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Opposition\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Limitation\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"D\\u00e9lai de r\\u00e9ponse :\"},{\"type\":\"text\",\"text\":\" 30 jours maximum.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"En cas de difficult\\u00e9, vous pouvez adresser une r\\u00e9clamation aupr\\u00e8s de la \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"CNIL\"},{\"type\":\"text\",\"text\":\" : \"},{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"https:\\/\\/www.cnil.fr\",\"target\":\"_blank\",\"rel\":\"noopener\",\"class\":null}}],\"text\":\"www.cnil.fr\"},{\"type\":\"text\",\"text\":\" \\u2014 3 Place de Fontenoy, 75334 Paris Cedex 07.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"9. S\\u00e9curit\\u00e9\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Transfert\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"HTTPS \\/ TLS 1.3\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Mots de passe\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Hash\\u00e9s (bcrypt\\/argon2)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"IP visiteurs\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Hash\\u00e9es SHA-256 (pseudonymis\\u00e9es)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Acc\\u00e8s admin\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Prot\\u00e9g\\u00e9 par authentification + CSRF\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"10. Modifications\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cette politique peut \\u00eatre mise \\u00e0 jour. En cas de changement significatif, les utilisateurs inscrits seront inform\\u00e9s par email. La date de mise \\u00e0 jour figure en haut de page.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"11. Contact\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"DPO\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Courrier\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"{{RAISON_SOCIALE}} \\u2014 379 rue des Villas, 31360 Saint-Martory\"}]}]}]}]}]}','full-width',1,'politique-confidentialite',NULL,'Politique de confidentialité. Données collectées, cookies, droits RGPD et contact DPO.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(3,'public','Conditions générales d\'utilisation','<p><em>Dernière mise à jour : 25 août 2026</em></p>\n\n<h2>1. Objet</h2>\n<p>Les présentes Conditions Générales d&#039;Utilisation (CGU) régissent l&#039;accès et l&#039;utilisation de ce site internet. En accédant au site, vous acceptez sans réserve les présentes CGU.</p>\n\n<h2>2. Éditeur</h2>\n<table class=\"tiptap-table\">\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>948 742 523 00012</td></tr>\n<tr><td><strong>Adresse</strong></td><td>379 rue des Villas, 31360 Saint-Martory</td></tr>\n<tr><td><strong>Email</strong></td><td>bruno.mainguy@31061.notaires.fr</td></tr>\n</tbody>\n</table>\n\n<h2>3. Accès au service</h2>\n<ul>\n<li>Le site est accessible gratuitement à tout utilisateur disposant d&#039;un accès internet</li>\n<li>Les frais d&#039;accès et d&#039;utilisation du réseau de télécommunication sont à la charge de l&#039;utilisateur</li>\n<li>L&#039;éditeur se réserve le droit de suspendre ou interrompre l&#039;accès pour maintenance</li>\n</ul>\n\n<h2>4. Inscription</h2>\n<p>L&#039;accès à certaines fonctionnalités du site nécessite une inscription. L&#039;utilisateur s&#039;engage à :</p>\n<ul>\n<li>Fournir des informations exactes et complètes</li>\n<li>Mettre à jour ses informations en cas de changement</li>\n<li>Préserver la confidentialité de son mot de passe (12 caractères minimum)</li>\n<li>Notifier immédiatement toute utilisation non autorisée de son compte</li>\n</ul>\n<p>L&#039;éditeur se réserve le droit de supprimer tout compte ne respectant pas les présentes CGU.</p>\n\n<h2>5. Services proposés</h2>\n<p>Le site propose les services suivants :</p>\n<ul>\n<li>Publication et consultation de contenus (pages, expertises, prestations)</li>\n<li>Formulaire de contact et prise de rendez-vous</li>\n<li>Simulateurs indicatifs (frais d&#039;acquisition, plus-value, viager, succession, donation)</li>\n<li>Espace client : dépôt documentaire et ouverture d&#039;un dossier</li>\n<li>Inscription aux notifications</li>\n</ul>\n\n<h2>6. Dépôt documentaire</h2>\n<p>L&#039;espace client permet de transmettre à l&#039;étude des pièces relatives à un dossier. Ce service est mis à disposition à titre de commodité et ne constitue pas un mode de transmission formel : il ne vaut ni dépôt officiel, ni notification, ni signification. Il ne fait courir aucun délai.</p>\n<h3>6.1 Formats et limites</h3>\n<ul>\n<li>Formats acceptés : PDF, JPEG et PNG. Le format réel de chaque fichier est vérifié : l&#039;extension seule ne suffit pas.</li>\n<li>8 Mo au maximum par pièce, 20 Mo et 12 fichiers au maximum par dépôt.</li>\n<li>Tout fichier ne respectant pas ces conditions est refusé avant l&#039;envoi.</li>\n</ul>\n<h3>6.2 Engagements de l&#039;utilisateur</h3>\n<ul>\n<li>Ne transmettre que des pièces utiles au dossier concerné.</li>\n<li>S&#039;assurer d&#039;être en droit de communiquer les documents transmis, notamment lorsqu&#039;ils concernent des tiers.</li>\n<li>Ne pas transmettre de fichier exécutable, ni de contenu illicite.</li>\n</ul>\n<h3>6.3 Acheminement et confidentialité</h3>\n<p>Le dépôt s&#039;effectue par liaison chiffrée entre votre navigateur et le site. Les pièces ne sont pas conservées sur le serveur du site : elles sont jointes à un courrier électronique adressé à l&#039;étude puis effacées. Le courrier électronique ne chiffre toutefois que son transport : vos pièces transitent et sont conservées en clair chez le prestataire d&#039;envoi, puis dans la messagerie de l&#039;étude. Pour les documents les plus sensibles, remettez-les à l&#039;étude par un autre moyen.</p>\n<h3>6.4 Réception</h3>\n<p>L&#039;envoi d&#039;un dépôt ne vaut pas accusé de réception ni prise en charge du dossier. L&#039;étude revient vers vous selon ses délais de traitement.</p>\n\n<h2>7. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu du site est protégé par le droit de la propriété intellectuelle :</p>\n<ul>\n<li>Textes, images, vidéos, logos, icônes, sons, logiciels</li>\n<li>Charte graphique et design du site</li>\n<li>Bases de données</li>\n</ul>\n<p>Toute reproduction non autorisée constitue une contrefaçon sanctionnée par les articles L335-2 et suivants du Code de la Propriété Intellectuelle.</p>\n\n<h2>8. Comportement de l&#039;utilisateur</h2>\n<p>L&#039;utilisateur s&#039;engage à ne pas :</p>\n<ul>\n<li>Publier de contenu illicite, diffamatoire, injurieux ou discriminatoire</li>\n<li>Porter atteinte à la vie privée d&#039;autrui</li>\n<li>Tenter d&#039;accéder à des zones non autorisées du site</li>\n<li>Utiliser le site à des fins commerciales non autorisées</li>\n<li>Collecter des données personnelles d&#039;autres utilisateurs</li>\n</ul>\n\n<h2>9. Responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible, mais ne garantit pas :</p>\n<ul>\n<li>L&#039;exactitude, la complétude ou l&#039;actualité des informations publiées</li>\n<li>La disponibilité permanente du site</li>\n<li>L&#039;absence de virus ou de défauts de fonctionnement</li>\n</ul>\n<p>L&#039;éditeur décline toute responsabilité pour les dommages directs ou indirects résultant de l&#039;utilisation du site.</p>\n\n<h2>10. Liens hypertextes</h2>\n<p>Le site peut contenir des liens vers des sites tiers. L&#039;éditeur n&#039;est pas responsable du contenu de ces sites et n&#039;exerce aucun contrôle sur eux.</p>\n\n<h2>11. Données personnelles</h2>\n<p>Le traitement des données personnelles est décrit dans notre <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a>, accessible depuis le pied de page du site.</p>\n\n<h2>12. Modification des CGU</h2>\n<p>L&#039;éditeur se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs inscrits seront informés par email de toute modification substantielle. La date de mise à jour figure en haut de page.</p>\n\n<h2>13. Droit applicable</h2>\n<p>Les présentes CGU sont régies par le droit français. En cas de litige, les tribunaux français seront compétents.</p>\n\n<h2>14. Contact</h2>\n<table class=\"tiptap-table\">\n<tbody>\n<tr><td><strong>Email</strong></td><td>bruno.mainguy@31061.notaires.fr</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — 379 rue des Villas, 31360 Saint-Martory</td></tr>\n</tbody>\n</table>','cgu',1,'2026-08-25 08:38:50','2026-08-25 10:04:04',NULL,'full-width',1,'cgu',NULL,'Conditions générales d\'utilisation. Accès au service, inscription, propriété intellectuelle et responsabilité.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(4,'public','Tarifs','<p class=\"lead\">La somme que l’on verse au notaire, que l’on nomme communément et improprement « frais de notaire », comprend en réalité les taxes reversées au Trésor Public, les déboursés, et la rémunération au titre du service notarial.</p>\n\n<p>Parce que le notaire remplit une fonction d’intérêt public, la rémunération au titre du service notarial est strictement réglementée et fait l’objet d’un tarif.</p>\n\n<h2>Composition des frais de notaire</h2>\n\n<div class=\"bw-fees\">\n  <div class=\"bw-fee\">\n    <span class=\"bw-fee__share\">8<span class=\"bw-fee__unit\">/10</span></span>\n    <h3 class=\"bw-fee__title\">Taxes et impôts</h3>\n    <p class=\"bw-fee__text\">Les sommes que le notaire est tenu de percevoir et de reverser à l’État et aux collectivités locales pour le compte de son client. Elles varient suivant la nature de l’acte et du bien.</p>\n  </div>\n  <div class=\"bw-fee\">\n    <span class=\"bw-fee__share\">1<span class=\"bw-fee__unit\">/10</span></span>\n    <h3 class=\"bw-fee__title\">Déboursés</h3>\n    <p class=\"bw-fee__text\">Les sommes avancées par l’étude pour le compte de son client afin de réunir les pièces et documents nécessaires à l’établissement de l’acte.</p>\n  </div>\n  <div class=\"bw-fee\">\n    <span class=\"bw-fee__share\">1<span class=\"bw-fee__unit\">/10</span></span>\n    <h3 class=\"bw-fee__title\">Service notarial</h3>\n    <p class=\"bw-fee__text\">La rémunération du service rendu, qui couvre les charges de l’office, les collaborateurs et les notaires.</p>\n  </div>\n</div>\n\n<h2>Un tarif fixé par décret</h2>\n<p>Ce tarif, fixé par le décret du 8 mars 1978, a été modifié à quatre reprises : par les décrets du 16 mai 2006, du 21 mars 2007, du 17 février 2011, et enfin par le décret et l’arrêté du 26 février 2016.</p>\n\n<p>Le tarif comprend donc :</p>\n<ul>\n  <li><strong>des émoluments proportionnels et fixes</strong>, fixés par décret et arrêté, pour tous les actes et formalités pour lesquels les pouvoirs publics l’ont décidé : ventes, donations, successions, prêts…</li>\n  <li><strong>des honoraires</strong> pour tous les actes dont le décret prévoit que la rémunération est librement convenue entre le notaire et son client : baux commerciaux, actes de sociétés, négociations immobilières, consultations détachables…</li>\n</ul>\n\n<h2>Le conseil est gratuit</h2>\n<p>Nous avons à cœur de fournir un accompagnement de qualité et d’établir une relation de confiance avec nos clients. N’hésitez pas à nous exposer votre projet : nous vous communiquerons une estimation des frais correspondant à votre situation.</p>','tarifs',0,'2026-08-25 08:22:58','2026-08-26 14:56:35','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les \\u00ab frais de notaire \\u00bb sont l\\u2019un des sujets qui inqui\\u00e8tent le plus au moment d\\u2019un achat. Dans les faits, ils ne correspondent que tr\\u00e8s marginalement \\u00e0 la r\\u00e9mun\\u00e9ration de l\\u2019office : l\\u2019essentiel est revers\\u00e9 \\u00e0 l\\u2019\\u00c9tat et aux collectivit\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Ce que recouvrent r\\u00e9ellement les frais\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Sur l\\u2019ensemble des sommes vers\\u00e9es \\u00e0 l\\u2019\\u00e9tude lors d\\u2019une acquisition immobili\\u00e8re, la r\\u00e9partition est, en ordre de grandeur, la suivante.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"8\\/10\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Taxes et imp\\u00f4ts\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les droits de mutation, revers\\u00e9s \\u00e0 l\\u2019\\u00c9tat, au d\\u00e9partement et \\u00e0 la commune. Le notaire les collecte pour leur compte : ils ne lui reviennent pas.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"1\\/10\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9bours\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les sommes avanc\\u00e9es par l\\u2019\\u00e9tude pour votre compte : documents d\\u2019urbanisme, actes d\\u2019\\u00e9tat civil, g\\u00e9om\\u00e8tre, formalit\\u00e9s de publicit\\u00e9 fonci\\u00e8re.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"1\\/10\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9moluments\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"La r\\u00e9mun\\u00e9ration du notaire \\u00e0 proprement parler, fix\\u00e9e par un tarif r\\u00e9glement\\u00e9 et identique dans toute la France.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Des \\u00e9muluments fix\\u00e9s par les pouvoirs publics\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Le tarif des notaires est r\\u00e9glement\\u00e9 : il s\\u2019applique de la m\\u00eame fa\\u00e7on dans toutes les \\u00e9tudes de France. Le notaire ne fixe donc pas librement sa r\\u00e9mun\\u00e9ration, et vous ne paierez pas davantage ici qu\\u2019ailleurs pour un m\\u00eame acte.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Certaines prestations de conseil rel\\u00e8vent en revanche d\\u2019honoraires libres. Leur montant vous est alors annonc\\u00e9 et convenu avec vous avant toute intervention.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Deux notaires, aucun surco\\u00fbt\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Lorsque l\\u2019acqu\\u00e9reur et le vendeur souhaitent chacun \\u00eatre accompagn\\u00e9s par leur propre notaire, les deux \\u00e9tudes se partagent les \\u00e9moluments pr\\u00e9vus pour l\\u2019op\\u00e9ration. Faire appel \\u00e0 un second notaire n\\u2019entra\\u00eene donc \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"aucun frais suppl\\u00e9mentaire\"},{\"type\":\"text\",\"text\":\" pour vous.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Une estimation avant de vous engager\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Chaque dossier a ses particularit\\u00e9s. Le plus s\\u00fbr reste de nous exposer votre projet : nous vous communiquons une estimation des frais correspondant \\u00e0 votre situation, avant que vous ne preniez d\\u2019engagement.\"}]}]}','full-width',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,1,NULL),
(5,'public','Expertises','<p>Notre raison d’être est de vous permettre d’anticiper tous les événements de votre vie en toute sérénité.</p>\n\n<p>Située à Saint-Martory, l’Étude vous reçoit au 379 rue des Villas. L’office BM NOTAIRE a conscience que ses clients évoluent dans un environnement toujours plus complexe et mouvant. Il est garant de la sécurité juridique et apporte son expertise dans l’élaboration des contrats qui lui sont confiés.</p>\n\n<h2>Notre philosophie</h2>\n<p>L’accompagnement avec humanité, rendre le droit accessible au plus grand nombre, l’écoute attentive, la réactivité, la satisfaction, l’empathie : ce sont les qualités qui traduisent notre philosophie et qui sont au cœur des préoccupations de l’office.</p>\n<p>L’Étude s’appuie sur une équipe soudée et fidèle, partageant des convictions fortes : la considération, l’écoute et la confiance mutuelle sont essentielles à la réussite de vos objectifs personnels et patrimoniaux.</p>\n\n<h2>Un office moderne</h2>\n<p>L’Office Notarial de Saint-Martory met à disposition ses nouvelles technologies : signature des actes sur support électronique, visioconférence, procuration à distance.</p>\n\n<h2>Transparence</h2>\n<p>Le conseil est gratuit. Nous avons à cœur de fournir un accompagnement de qualité et d’établir une relation de confiance avec nos clients.</p>\n\n<h2>Éco-responsable</h2>\n<p>Soucieux de l’environnement, nous mettons tout en œuvre pour limiter les impressions et privilégier une gestion dématérialisée des actes notariés.</p>\n\n<h2>Réactivité</h2>\n<p>L’ensemble de nos collaborateurs s’engagent à vous répondre dans les meilleurs délais.</p>\n\n<h2>Nos domaines d’intervention</h2>\n<p>L’étude accompagne les particuliers comme les professionnels et les collectivités.</p>','expertises-introduction',1,'2026-08-25 08:37:21','2026-08-28 15:00:19',NULL,'full-width',1,'services_intro',NULL,NULL,NULL,0,NULL,9,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `page` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `portfolio_category`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `portfolio_category` WRITE;
/*!40000 ALTER TABLE `portfolio_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_category` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `portfolio_item`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `portfolio_item` WRITE;
/*!40000 ALTER TABLE `portfolio_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_item` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `portfolio_item_tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `portfolio_item_tag` WRITE;
/*!40000 ALTER TABLE `portfolio_item_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_item_tag` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `product`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `product_category`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product_category` WRITE;
/*!40000 ALTER TABLE `product_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_category` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `product_image`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product_image` WRITE;
/*!40000 ALTER TABLE `product_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_image` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `product_related`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product_related` WRITE;
/*!40000 ALTER TABLE `product_related` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_related` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `product_tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product_tag` WRITE;
/*!40000 ALTER TABLE `product_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_tag` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `product_variant`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product_variant` WRITE;
/*!40000 ALTER TABLE `product_variant` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_variant` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `service`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES
(6,'Immobilier','immobilier','Acquérir. Vendre. Construire. Sécuriser chaque étape d’un projet immobilier, de l’avant-contrat à la signature définitive.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019immobilier engage souvent une part essentielle d\\u2019un patrimoine. L\\u2019\\u00e9tude vous accompagne dans la pr\\u00e9paration, la v\\u00e9rification et la r\\u00e9alisation de l\\u2019op\\u00e9ration, en coordonnant les dimensions juridiques, fiscales et fonci\\u00e8res.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation appelle une analyse particuli\\u00e8re. L\\u2019\\u00e9tude identifie les enjeux, rassemble les pi\\u00e8ces utiles, coordonne les intervenants et s\\u00e9curise l\\u2019acte jusqu\\u2019\\u00e0 son aboutissement.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Notre accompagnement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Vente \\u2014 Pr\\u00e9parer le dossier, anticiper les pi\\u00e8ces et s\\u00e9curiser les d\\u00e9lais.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acquisition \\u2014 Analyser le bien, les conditions de l\\u2019op\\u00e9ration et le financement.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Foncier \\u2014 Traiter les divisions, servitudes et particularit\\u00e9s du terrain.\"}]}]}]}]}','<p>L’immobilier engage souvent une part essentielle d’un patrimoine. L’étude vous accompagne dans la préparation, la vérification et la réalisation de l’opération, en coordonnant les dimensions juridiques, fiscales et foncières.</p><p>Chaque situation appelle une analyse particulière. L’étude identifie les enjeux, rassemble les pièces utiles, coordonne les intervenants et sécurise l’acte jusqu’à son aboutissement.</p><h3>Notre accompagnement</h3><ul><li><p>Vente — Préparer le dossier, anticiper les pièces et sécuriser les délais.</p></li><li><p>Acquisition — Analyser le bien, les conditions de l’opération et le financement.</p></li><li><p>Foncier — Traiter les divisions, servitudes et particularités du terrain.</p></li></ul>',NULL,NULL,10,1,10,NULL,NULL,NULL,NULL,0,NULL,NULL),
(7,'Acheter & vendre','immobilier-acheter-vendre','Sécuriser chaque étape de la vente ou de l’acquisition.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avant-contrat\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Conditions suspensives\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Financement\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte authentique et remise des cl\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titre de propri\\u00e9t\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat civil et situation matrimoniale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Diagnostics disponibles\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Informations sur les travaux et \\u00e9quipements\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand contacter l\\u2019\\u00e9tude ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le plus t\\u00f4t possible, id\\u00e9alement avant de formaliser d\\u00e9finitivement les conditions de l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quels documents apporter ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La liste d\\u00e9pend du bien et du projet. Un premier \\u00e9change permet d\\u2019identifier imm\\u00e9diatement les pi\\u00e8ces utiles.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude peut-elle coordonner les autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui, le dossier peut n\\u00e9cessiter des \\u00e9changes avec agence, banque, g\\u00e9om\\u00e8tre, syndic, collectivit\\u00e9s ou autres conseils.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Avant-contrat</p></li><li><p>Conditions suspensives</p></li><li><p>Financement</p></li><li><p>Acte authentique et remise des clés</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titre de propriété</p></li><li><p>État civil et situation matrimoniale</p></li><li><p>Diagnostics disponibles</p></li><li><p>Informations sur les travaux et équipements</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand contacter l’étude ?</h4><p>Le plus tôt possible, idéalement avant de formaliser définitivement les conditions de l’opération.</p><h4>Quels documents apporter ?</h4><p>La liste dépend du bien et du projet. Un premier échange permet d’identifier immédiatement les pièces utiles.</p><h4>L’étude peut-elle coordonner les autres intervenants ?</h4><p>Oui, le dossier peut nécessiter des échanges avec agence, banque, géomètre, syndic, collectivités ou autres conseils.</p>',NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL,0,NULL,6),
(8,'Construction & VEFA','immobilier-construction-vefa','Accompagner les projets neufs et les opérations de construction.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cadre juridique du projet\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Garanties et financement\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Appels de fonds\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Livraison et acte\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet et plans\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Contrat ou r\\u00e9servation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Financement\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Documents techniques disponibles\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand contacter l\\u2019\\u00e9tude ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le plus t\\u00f4t possible, id\\u00e9alement avant de formaliser d\\u00e9finitivement les conditions de l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quels documents apporter ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La liste d\\u00e9pend du bien et du projet. Un premier \\u00e9change permet d\\u2019identifier imm\\u00e9diatement les pi\\u00e8ces utiles.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude peut-elle coordonner les autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui, le dossier peut n\\u00e9cessiter des \\u00e9changes avec agence, banque, g\\u00e9om\\u00e8tre, syndic, collectivit\\u00e9s ou autres conseils.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Cadre juridique du projet</p></li><li><p>Garanties et financement</p></li><li><p>Appels de fonds</p></li><li><p>Livraison et acte</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Projet et plans</p></li><li><p>Contrat ou réservation</p></li><li><p>Financement</p></li><li><p>Documents techniques disponibles</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand contacter l’étude ?</h4><p>Le plus tôt possible, idéalement avant de formaliser définitivement les conditions de l’opération.</p><h4>Quels documents apporter ?</h4><p>La liste dépend du bien et du projet. Un premier échange permet d’identifier immédiatement les pièces utiles.</p><h4>L’étude peut-elle coordonner les autres intervenants ?</h4><p>Oui, le dossier peut nécessiter des échanges avec agence, banque, géomètre, syndic, collectivités ou autres conseils.</p>',NULL,NULL,20,1,NULL,NULL,NULL,NULL,NULL,0,NULL,6),
(9,'Division & lotissement','immobilier-division-lotissement','Structurer le foncier avant la vente ou la construction.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Analyse fonci\\u00e8re\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Urbanisme et g\\u00e9om\\u00e8tre\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cr\\u00e9ation des lots\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Vente et organisation future\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres et plans\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Documents d\\u2019urbanisme\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet de division\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9l\\u00e9ments de bornage\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand contacter l\\u2019\\u00e9tude ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le plus t\\u00f4t possible, id\\u00e9alement avant de formaliser d\\u00e9finitivement les conditions de l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quels documents apporter ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La liste d\\u00e9pend du bien et du projet. Un premier \\u00e9change permet d\\u2019identifier imm\\u00e9diatement les pi\\u00e8ces utiles.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude peut-elle coordonner les autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui, le dossier peut n\\u00e9cessiter des \\u00e9changes avec agence, banque, g\\u00e9om\\u00e8tre, syndic, collectivit\\u00e9s ou autres conseils.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Analyse foncière</p></li><li><p>Urbanisme et géomètre</p></li><li><p>Création des lots</p></li><li><p>Vente et organisation future</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres et plans</p></li><li><p>Documents d’urbanisme</p></li><li><p>Projet de division</p></li><li><p>Éléments de bornage</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand contacter l’étude ?</h4><p>Le plus tôt possible, idéalement avant de formaliser définitivement les conditions de l’opération.</p><h4>Quels documents apporter ?</h4><p>La liste dépend du bien et du projet. Un premier échange permet d’identifier immédiatement les pièces utiles.</p><h4>L’étude peut-elle coordonner les autres intervenants ?</h4><p>Oui, le dossier peut nécessiter des échanges avec agence, banque, géomètre, syndic, collectivités ou autres conseils.</p>',NULL,NULL,30,1,NULL,NULL,NULL,NULL,NULL,0,NULL,6),
(10,'Copropriété','immobilier-copropriete','Vendre, acquérir ou organiser un bien soumis à la copropriété.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Identification des lots\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Information de l\\u2019acqu\\u00e9reur\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation financi\\u00e8re\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte et formalit\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e8glement de copropri\\u00e9t\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat descriptif de division\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Proc\\u00e8s-verbaux disponibles\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Charges et documents du syndic\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand contacter l\\u2019\\u00e9tude ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le plus t\\u00f4t possible, id\\u00e9alement avant de formaliser d\\u00e9finitivement les conditions de l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quels documents apporter ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La liste d\\u00e9pend du bien et du projet. Un premier \\u00e9change permet d\\u2019identifier imm\\u00e9diatement les pi\\u00e8ces utiles.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude peut-elle coordonner les autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui, le dossier peut n\\u00e9cessiter des \\u00e9changes avec agence, banque, g\\u00e9om\\u00e8tre, syndic, collectivit\\u00e9s ou autres conseils.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Identification des lots</p></li><li><p>Information de l’acquéreur</p></li><li><p>Situation financière</p></li><li><p>Acte et formalités</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Règlement de copropriété</p></li><li><p>État descriptif de division</p></li><li><p>Procès-verbaux disponibles</p></li><li><p>Charges et documents du syndic</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand contacter l’étude ?</h4><p>Le plus tôt possible, idéalement avant de formaliser définitivement les conditions de l’opération.</p><h4>Quels documents apporter ?</h4><p>La liste dépend du bien et du projet. Un premier échange permet d’identifier immédiatement les pièces utiles.</p><h4>L’étude peut-elle coordonner les autres intervenants ?</h4><p>Oui, le dossier peut nécessiter des échanges avec agence, banque, géomètre, syndic, collectivités ou autres conseils.</p>',NULL,NULL,40,1,NULL,NULL,NULL,NULL,NULL,0,NULL,6),
(11,'Servitudes & accès','immobilier-servitudes-acces','Clarifier les droits de passage, réseaux et contraintes attachées au bien.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Analyse des titres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9finition de l\\u2019assiette\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Coordination technique\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9daction et publicit\\u00e9\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres ant\\u00e9rieurs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Plans et cadastre\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9l\\u00e9ments sur l\\u2019usage existant\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet envisag\\u00e9\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand contacter l\\u2019\\u00e9tude ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le plus t\\u00f4t possible, id\\u00e9alement avant de formaliser d\\u00e9finitivement les conditions de l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quels documents apporter ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La liste d\\u00e9pend du bien et du projet. Un premier \\u00e9change permet d\\u2019identifier imm\\u00e9diatement les pi\\u00e8ces utiles.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude peut-elle coordonner les autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui, le dossier peut n\\u00e9cessiter des \\u00e9changes avec agence, banque, g\\u00e9om\\u00e8tre, syndic, collectivit\\u00e9s ou autres conseils.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Analyse des titres</p></li><li><p>Définition de l’assiette</p></li><li><p>Coordination technique</p></li><li><p>Rédaction et publicité</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres antérieurs</p></li><li><p>Plans et cadastre</p></li><li><p>Éléments sur l’usage existant</p></li><li><p>Projet envisagé</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand contacter l’étude ?</h4><p>Le plus tôt possible, idéalement avant de formaliser définitivement les conditions de l’opération.</p><h4>Quels documents apporter ?</h4><p>La liste dépend du bien et du projet. Un premier échange permet d’identifier immédiatement les pièces utiles.</p><h4>L’étude peut-elle coordonner les autres intervenants ?</h4><p>Oui, le dossier peut nécessiter des échanges avec agence, banque, géomètre, syndic, collectivités ou autres conseils.</p>',NULL,NULL,50,1,NULL,NULL,NULL,NULL,NULL,0,NULL,6),
(12,'Immobilier professionnel','immobilier-immobilier-professionnel','Sécuriser les murs, locaux et opérations immobilières de l’entreprise.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Audit du bien\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Organisation de la d\\u00e9tention\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Vente ou acquisition\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Coordination avec les conseils\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres ou projet\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux existants\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation de la soci\\u00e9t\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Financement\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand contacter l\\u2019\\u00e9tude ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le plus t\\u00f4t possible, id\\u00e9alement avant de formaliser d\\u00e9finitivement les conditions de l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quels documents apporter ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La liste d\\u00e9pend du bien et du projet. Un premier \\u00e9change permet d\\u2019identifier imm\\u00e9diatement les pi\\u00e8ces utiles.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude peut-elle coordonner les autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui, le dossier peut n\\u00e9cessiter des \\u00e9changes avec agence, banque, g\\u00e9om\\u00e8tre, syndic, collectivit\\u00e9s ou autres conseils.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Audit du bien</p></li><li><p>Organisation de la détention</p></li><li><p>Vente ou acquisition</p></li><li><p>Coordination avec les conseils</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres ou projet</p></li><li><p>Baux existants</p></li><li><p>Situation de la société</p></li><li><p>Financement</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand contacter l’étude ?</h4><p>Le plus tôt possible, idéalement avant de formaliser définitivement les conditions de l’opération.</p><h4>Quels documents apporter ?</h4><p>La liste dépend du bien et du projet. Un premier échange permet d’identifier immédiatement les pièces utiles.</p><h4>L’étude peut-elle coordonner les autres intervenants ?</h4><p>Oui, le dossier peut nécessiter des échanges avec agence, banque, géomètre, syndic, collectivités ou autres conseils.</p>',NULL,NULL,60,1,NULL,NULL,NULL,NULL,NULL,0,NULL,6),
(13,'Famille & patrimoine','famille','Protéger. Structurer. Transmettre. Accompagner les moments essentiels de la vie familiale et organiser votre patrimoine avec précision, écoute et anticipation.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le droit de la famille et le droit patrimonial sont \\u00e9troitement li\\u00e9s. L\\u2019\\u00e9tude construit avec vous des solutions coh\\u00e9rentes pour prot\\u00e9ger vos proches, organiser la d\\u00e9tention de vos biens, anticiper la transmission et articuler les cons\\u00e9quences civiles et fiscales de vos choix.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation appelle une analyse particuli\\u00e8re. L\\u2019\\u00e9tude identifie les enjeux, rassemble les pi\\u00e8ces utiles, coordonne les intervenants et s\\u00e9curise l\\u2019acte jusqu\\u2019\\u00e0 son aboutissement.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Notre accompagnement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Anticiper \\u2014 Choisir les outils adapt\\u00e9s avant qu\\u2019une difficult\\u00e9 ne survienne.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmettre \\u2014 Organiser la transmission en tenant compte de la famille et du patrimoine.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9gler \\u2014 Conduire les op\\u00e9rations successorales jusqu\\u2019au partage.\"}]}]}]}]}','<p>Le droit de la famille et le droit patrimonial sont étroitement liés. L’étude construit avec vous des solutions cohérentes pour protéger vos proches, organiser la détention de vos biens, anticiper la transmission et articuler les conséquences civiles et fiscales de vos choix.</p><p>Chaque situation appelle une analyse particulière. L’étude identifie les enjeux, rassemble les pièces utiles, coordonne les intervenants et sécurise l’acte jusqu’à son aboutissement.</p><h3>Notre accompagnement</h3><ul><li><p>Anticiper — Choisir les outils adaptés avant qu’une difficulté ne survienne.</p></li><li><p>Transmettre — Organiser la transmission en tenant compte de la famille et du patrimoine.</p></li><li><p>Régler — Conduire les opérations successorales jusqu’au partage.</p></li></ul>',NULL,NULL,20,1,11,NULL,NULL,NULL,NULL,0,NULL,NULL),
(14,'Succession','famille-succession','Régler une succession avec méthode, visibilité et coordination.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Identification des h\\u00e9ritiers\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Bilan du patrimoine\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Options et fiscalit\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Attestations, d\\u00e9claration et partage\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte de d\\u00e9c\\u00e8s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Livret de famille\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Testament ou donation entre \\u00e9poux s\\u2019il en existe\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres de propri\\u00e9t\\u00e9 et \\u00e9l\\u00e9ments patrimoniaux\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il pr\\u00e9parer le rendez-vous ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier \\u00e9change beaucoup plus efficace.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper avant qu\\u2019une difficult\\u00e9 apparaisse ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Une grande partie du travail notarial consiste pr\\u00e9cis\\u00e9ment \\u00e0 organiser et s\\u00e9curiser la situation en amont.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation familiale appelle-t-elle la m\\u00eame solution ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. Les objectifs, la composition familiale et le patrimoine doivent \\u00eatre analys\\u00e9s ensemble avant de retenir un outil.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Identification des héritiers</p></li><li><p>Bilan du patrimoine</p></li><li><p>Options et fiscalité</p></li><li><p>Attestations, déclaration et partage</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Acte de décès</p></li><li><p>Livret de famille</p></li><li><p>Testament ou donation entre époux s’il en existe</p></li><li><p>Titres de propriété et éléments patrimoniaux</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Faut-il préparer le rendez-vous ?</h4><p>Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier échange beaucoup plus efficace.</p><h4>Peut-on anticiper avant qu’une difficulté apparaisse ?</h4><p>Oui. Une grande partie du travail notarial consiste précisément à organiser et sécuriser la situation en amont.</p><h4>Chaque situation familiale appelle-t-elle la même solution ?</h4><p>Non. Les objectifs, la composition familiale et le patrimoine doivent être analysés ensemble avant de retenir un outil.</p>',NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(15,'Donation & donation-partage','famille-donation','Transmettre de son vivant en préservant les équilibres familiaux.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Objectifs de transmission\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Choix de l\\u2019outil\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9valuation et fiscalit\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Signature et formalit\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat civil\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Composition de la famille\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres et valorisations\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Donations ant\\u00e9rieures\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il pr\\u00e9parer le rendez-vous ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier \\u00e9change beaucoup plus efficace.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper avant qu\\u2019une difficult\\u00e9 apparaisse ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Une grande partie du travail notarial consiste pr\\u00e9cis\\u00e9ment \\u00e0 organiser et s\\u00e9curiser la situation en amont.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation familiale appelle-t-elle la m\\u00eame solution ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. Les objectifs, la composition familiale et le patrimoine doivent \\u00eatre analys\\u00e9s ensemble avant de retenir un outil.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Objectifs de transmission</p></li><li><p>Choix de l’outil</p></li><li><p>Évaluation et fiscalité</p></li><li><p>Signature et formalités</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>État civil</p></li><li><p>Composition de la famille</p></li><li><p>Titres et valorisations</p></li><li><p>Donations antérieures</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Faut-il préparer le rendez-vous ?</h4><p>Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier échange beaucoup plus efficace.</p><h4>Peut-on anticiper avant qu’une difficulté apparaisse ?</h4><p>Oui. Une grande partie du travail notarial consiste précisément à organiser et sécuriser la situation en amont.</p><h4>Chaque situation familiale appelle-t-elle la même solution ?</h4><p>Non. Les objectifs, la composition familiale et le patrimoine doivent être analysés ensemble avant de retenir un outil.</p>',NULL,NULL,20,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(16,'Transmission','patrimoine-transmission','Organiser la transmission du patrimoine dans la durée.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Diagnostic\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Objectifs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sc\\u00e9narios de transmission\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Mise en \\u0153uvre\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat civil\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Composition familiale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Actifs et passifs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Donations ant\\u00e9rieures\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Par o\\u00f9 commencer ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et op\\u00e9rations d\\u00e9j\\u00e0 r\\u00e9alis\\u00e9es.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il raisonner uniquement en fiscalit\\u00e9 ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. La fiscalit\\u00e9 s\\u2019int\\u00e8gre \\u00e0 une organisation civile et patrimoniale plus large.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on coordonner plusieurs outils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Donation, d\\u00e9membrement, soci\\u00e9t\\u00e9 civile, testament ou assurance-vie peuvent devoir \\u00eatre pens\\u00e9s ensemble.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Diagnostic</p></li><li><p>Objectifs</p></li><li><p>Scénarios de transmission</p></li><li><p>Mise en œuvre</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>État civil</p></li><li><p>Composition familiale</p></li><li><p>Actifs et passifs</p></li><li><p>Donations antérieures</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Par où commencer ?</h4><p>Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et opérations déjà réalisées.</p><h4>Faut-il raisonner uniquement en fiscalité ?</h4><p>Non. La fiscalité s’intègre à une organisation civile et patrimoniale plus large.</p><h4>Peut-on coordonner plusieurs outils ?</h4><p>Oui. Donation, démembrement, société civile, testament ou assurance-vie peuvent devoir être pensés ensemble.</p>',NULL,NULL,30,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(17,'Testament','famille-testament','Exprimer ses volontés dans un cadre juridiquement sécurisé.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Analyse de la situation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Choix de la forme\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9daction\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Conservation et mise en \\u0153uvre\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat civil\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation familiale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Patrimoine concern\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Volont\\u00e9s particuli\\u00e8res\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il pr\\u00e9parer le rendez-vous ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier \\u00e9change beaucoup plus efficace.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper avant qu\\u2019une difficult\\u00e9 apparaisse ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Une grande partie du travail notarial consiste pr\\u00e9cis\\u00e9ment \\u00e0 organiser et s\\u00e9curiser la situation en amont.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation familiale appelle-t-elle la m\\u00eame solution ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. Les objectifs, la composition familiale et le patrimoine doivent \\u00eatre analys\\u00e9s ensemble avant de retenir un outil.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Analyse de la situation</p></li><li><p>Choix de la forme</p></li><li><p>Rédaction</p></li><li><p>Conservation et mise en œuvre</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>État civil</p></li><li><p>Situation familiale</p></li><li><p>Patrimoine concerné</p></li><li><p>Volontés particulières</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Faut-il préparer le rendez-vous ?</h4><p>Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier échange beaucoup plus efficace.</p><h4>Peut-on anticiper avant qu’une difficulté apparaisse ?</h4><p>Oui. Une grande partie du travail notarial consiste précisément à organiser et sécuriser la situation en amont.</p><h4>Chaque situation familiale appelle-t-elle la même solution ?</h4><p>Non. Les objectifs, la composition familiale et le patrimoine doivent être analysés ensemble avant de retenir un outil.</p>',NULL,NULL,40,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(18,'Couple & mariage','famille-couple-mariage','Choisir ou adapter l’organisation patrimoniale du couple.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Diagnostic matrimonial\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Choix du r\\u00e9gime\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Protection du conjoint\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte et formalit\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat civil\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Contrat existant\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Patrimoine de chacun\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet familial ou professionnel\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il pr\\u00e9parer le rendez-vous ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier \\u00e9change beaucoup plus efficace.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper avant qu\\u2019une difficult\\u00e9 apparaisse ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Une grande partie du travail notarial consiste pr\\u00e9cis\\u00e9ment \\u00e0 organiser et s\\u00e9curiser la situation en amont.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation familiale appelle-t-elle la m\\u00eame solution ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. Les objectifs, la composition familiale et le patrimoine doivent \\u00eatre analys\\u00e9s ensemble avant de retenir un outil.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Diagnostic matrimonial</p></li><li><p>Choix du régime</p></li><li><p>Protection du conjoint</p></li><li><p>Acte et formalités</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>État civil</p></li><li><p>Contrat existant</p></li><li><p>Patrimoine de chacun</p></li><li><p>Projet familial ou professionnel</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Faut-il préparer le rendez-vous ?</h4><p>Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier échange beaucoup plus efficace.</p><h4>Peut-on anticiper avant qu’une difficulté apparaisse ?</h4><p>Oui. Une grande partie du travail notarial consiste précisément à organiser et sécuriser la situation en amont.</p><h4>Chaque situation familiale appelle-t-elle la même solution ?</h4><p>Non. Les objectifs, la composition familiale et le patrimoine doivent être analysés ensemble avant de retenir un outil.</p>',NULL,NULL,50,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(19,'PACS','famille-pacs','Organiser la vie patrimoniale du couple et anticiper la transmission.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Convention\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Organisation des biens\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Protection et testament\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Formalit\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Pi\\u00e8ces d\\u2019identit\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat civil\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation patrimoniale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet commun\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il pr\\u00e9parer le rendez-vous ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier \\u00e9change beaucoup plus efficace.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper avant qu\\u2019une difficult\\u00e9 apparaisse ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Une grande partie du travail notarial consiste pr\\u00e9cis\\u00e9ment \\u00e0 organiser et s\\u00e9curiser la situation en amont.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation familiale appelle-t-elle la m\\u00eame solution ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. Les objectifs, la composition familiale et le patrimoine doivent \\u00eatre analys\\u00e9s ensemble avant de retenir un outil.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Convention</p></li><li><p>Organisation des biens</p></li><li><p>Protection et testament</p></li><li><p>Formalités</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Pièces d’identité</p></li><li><p>État civil</p></li><li><p>Situation patrimoniale</p></li><li><p>Projet commun</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Faut-il préparer le rendez-vous ?</h4><p>Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier échange beaucoup plus efficace.</p><h4>Peut-on anticiper avant qu’une difficulté apparaisse ?</h4><p>Oui. Une grande partie du travail notarial consiste précisément à organiser et sécuriser la situation en amont.</p><h4>Chaque situation familiale appelle-t-elle la même solution ?</h4><p>Non. Les objectifs, la composition familiale et le patrimoine doivent être analysés ensemble avant de retenir un outil.</p>',NULL,NULL,60,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(20,'Divorce & partage','famille-divorce-partage','Liquider et partager le patrimoine avec une vision claire des conséquences.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Reconstitution patrimoniale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Comptes entre \\u00e9poux\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9valuation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat liquidatif et partage\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Contrat de mariage\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Comptes et pr\\u00eats\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9l\\u00e9ments de valorisation\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il pr\\u00e9parer le rendez-vous ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier \\u00e9change beaucoup plus efficace.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper avant qu\\u2019une difficult\\u00e9 apparaisse ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Une grande partie du travail notarial consiste pr\\u00e9cis\\u00e9ment \\u00e0 organiser et s\\u00e9curiser la situation en amont.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation familiale appelle-t-elle la m\\u00eame solution ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. Les objectifs, la composition familiale et le patrimoine doivent \\u00eatre analys\\u00e9s ensemble avant de retenir un outil.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Reconstitution patrimoniale</p></li><li><p>Comptes entre époux</p></li><li><p>Évaluation</p></li><li><p>État liquidatif et partage</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Contrat de mariage</p></li><li><p>Titres</p></li><li><p>Comptes et prêts</p></li><li><p>Éléments de valorisation</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Faut-il préparer le rendez-vous ?</h4><p>Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier échange beaucoup plus efficace.</p><h4>Peut-on anticiper avant qu’une difficulté apparaisse ?</h4><p>Oui. Une grande partie du travail notarial consiste précisément à organiser et sécuriser la situation en amont.</p><h4>Chaque situation familiale appelle-t-elle la même solution ?</h4><p>Non. Les objectifs, la composition familiale et le patrimoine doivent être analysés ensemble avant de retenir un outil.</p>',NULL,NULL,70,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(21,'Adoption','famille-adoption','Accompagner les actes notariés et consentements nécessaires au projet familial.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Analyse du projet\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Consentements requis\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Actes notari\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Suivi des formalit\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9tat civil\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Livret de famille\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9cisions ou pi\\u00e8ces du dossier\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Coordonn\\u00e9es des personnes concern\\u00e9es\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il pr\\u00e9parer le rendez-vous ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier \\u00e9change beaucoup plus efficace.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper avant qu\\u2019une difficult\\u00e9 apparaisse ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Une grande partie du travail notarial consiste pr\\u00e9cis\\u00e9ment \\u00e0 organiser et s\\u00e9curiser la situation en amont.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation familiale appelle-t-elle la m\\u00eame solution ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. Les objectifs, la composition familiale et le patrimoine doivent \\u00eatre analys\\u00e9s ensemble avant de retenir un outil.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Analyse du projet</p></li><li><p>Consentements requis</p></li><li><p>Actes notariés</p></li><li><p>Suivi des formalités</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>État civil</p></li><li><p>Livret de famille</p></li><li><p>Décisions ou pièces du dossier</p></li><li><p>Coordonnées des personnes concernées</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Faut-il préparer le rendez-vous ?</h4><p>Quelques documents simples sur la famille et le patrimoine permettent de rendre le premier échange beaucoup plus efficace.</p><h4>Peut-on anticiper avant qu’une difficulté apparaisse ?</h4><p>Oui. Une grande partie du travail notarial consiste précisément à organiser et sécuriser la situation en amont.</p><h4>Chaque situation familiale appelle-t-elle la même solution ?</h4><p>Non. Les objectifs, la composition familiale et le patrimoine doivent être analysés ensemble avant de retenir un outil.</p>',NULL,NULL,80,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(22,'Démembrement','patrimoine-demembrement','Répartir usufruit et nue-propriété en cohérence avec vos objectifs.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Analyse civile\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Valorisation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Organisation des pouvoirs et charges\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Valorisation des biens\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation familiale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revenus et besoins\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Par o\\u00f9 commencer ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et op\\u00e9rations d\\u00e9j\\u00e0 r\\u00e9alis\\u00e9es.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il raisonner uniquement en fiscalit\\u00e9 ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. La fiscalit\\u00e9 s\\u2019int\\u00e8gre \\u00e0 une organisation civile et patrimoniale plus large.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on coordonner plusieurs outils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Donation, d\\u00e9membrement, soci\\u00e9t\\u00e9 civile, testament ou assurance-vie peuvent devoir \\u00eatre pens\\u00e9s ensemble.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Analyse civile</p></li><li><p>Valorisation</p></li><li><p>Organisation des pouvoirs et charges</p></li><li><p>Acte</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres</p></li><li><p>Valorisation des biens</p></li><li><p>Situation familiale</p></li><li><p>Revenus et besoins</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Par où commencer ?</h4><p>Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et opérations déjà réalisées.</p><h4>Faut-il raisonner uniquement en fiscalité ?</h4><p>Non. La fiscalité s’intègre à une organisation civile et patrimoniale plus large.</p><h4>Peut-on coordonner plusieurs outils ?</h4><p>Oui. Donation, démembrement, société civile, testament ou assurance-vie peuvent devoir être pensés ensemble.</p>',NULL,NULL,90,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(23,'SCI & sociétés civiles','patrimoine-sci','Structurer la détention et la transmission d’un patrimoine immobilier.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Choix de la structure\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Statuts\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Apports ou acquisitions\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Gouvernance et transmission\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Biens concern\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Associ\\u00e9s envisag\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Financement\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Objectifs de gestion et transmission\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Par o\\u00f9 commencer ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et op\\u00e9rations d\\u00e9j\\u00e0 r\\u00e9alis\\u00e9es.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il raisonner uniquement en fiscalit\\u00e9 ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. La fiscalit\\u00e9 s\\u2019int\\u00e8gre \\u00e0 une organisation civile et patrimoniale plus large.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on coordonner plusieurs outils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Donation, d\\u00e9membrement, soci\\u00e9t\\u00e9 civile, testament ou assurance-vie peuvent devoir \\u00eatre pens\\u00e9s ensemble.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Choix de la structure</p></li><li><p>Statuts</p></li><li><p>Apports ou acquisitions</p></li><li><p>Gouvernance et transmission</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Biens concernés</p></li><li><p>Associés envisagés</p></li><li><p>Financement</p></li><li><p>Objectifs de gestion et transmission</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Par où commencer ?</h4><p>Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et opérations déjà réalisées.</p><h4>Faut-il raisonner uniquement en fiscalité ?</h4><p>Non. La fiscalité s’intègre à une organisation civile et patrimoniale plus large.</p><h4>Peut-on coordonner plusieurs outils ?</h4><p>Oui. Donation, démembrement, société civile, testament ou assurance-vie peuvent devoir être pensés ensemble.</p>',NULL,NULL,100,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(24,'Assurance-vie','patrimoine-assurance-vie','Coordonner les contrats d’assurance-vie avec l’organisation successorale globale.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Lecture des clauses\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Coh\\u00e9rence successorale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9membrement le cas \\u00e9ch\\u00e9ant\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Coordination avec les autres actifs\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Contrats et clauses b\\u00e9n\\u00e9ficiaires\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation familiale\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Donations et testament\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Objectifs\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Par o\\u00f9 commencer ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et op\\u00e9rations d\\u00e9j\\u00e0 r\\u00e9alis\\u00e9es.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il raisonner uniquement en fiscalit\\u00e9 ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. La fiscalit\\u00e9 s\\u2019int\\u00e8gre \\u00e0 une organisation civile et patrimoniale plus large.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on coordonner plusieurs outils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Donation, d\\u00e9membrement, soci\\u00e9t\\u00e9 civile, testament ou assurance-vie peuvent devoir \\u00eatre pens\\u00e9s ensemble.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Lecture des clauses</p></li><li><p>Cohérence successorale</p></li><li><p>Démembrement le cas échéant</p></li><li><p>Coordination avec les autres actifs</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Contrats et clauses bénéficiaires</p></li><li><p>Situation familiale</p></li><li><p>Donations et testament</p></li><li><p>Objectifs</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Par où commencer ?</h4><p>Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et opérations déjà réalisées.</p><h4>Faut-il raisonner uniquement en fiscalité ?</h4><p>Non. La fiscalité s’intègre à une organisation civile et patrimoniale plus large.</p><h4>Peut-on coordonner plusieurs outils ?</h4><p>Oui. Donation, démembrement, société civile, testament ou assurance-vie peuvent devoir être pensés ensemble.</p>',NULL,NULL,110,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(25,'Fiscalité patrimoniale','patrimoine-fiscalite-patrimoniale','Intégrer la fiscalité à une stratégie civile et patrimoniale cohérente.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Qualification juridique\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Simulation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Choix du calendrier\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Documentation des op\\u00e9rations\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Composition du patrimoine\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Valeurs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revenus utiles au projet\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Op\\u00e9rations envisag\\u00e9es\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Par o\\u00f9 commencer ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et op\\u00e9rations d\\u00e9j\\u00e0 r\\u00e9alis\\u00e9es.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il raisonner uniquement en fiscalit\\u00e9 ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. La fiscalit\\u00e9 s\\u2019int\\u00e8gre \\u00e0 une organisation civile et patrimoniale plus large.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on coordonner plusieurs outils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Donation, d\\u00e9membrement, soci\\u00e9t\\u00e9 civile, testament ou assurance-vie peuvent devoir \\u00eatre pens\\u00e9s ensemble.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Qualification juridique</p></li><li><p>Simulation</p></li><li><p>Choix du calendrier</p></li><li><p>Documentation des opérations</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Composition du patrimoine</p></li><li><p>Valeurs</p></li><li><p>Revenus utiles au projet</p></li><li><p>Opérations envisagées</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Par où commencer ?</h4><p>Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et opérations déjà réalisées.</p><h4>Faut-il raisonner uniquement en fiscalité ?</h4><p>Non. La fiscalité s’intègre à une organisation civile et patrimoniale plus large.</p><h4>Peut-on coordonner plusieurs outils ?</h4><p>Oui. Donation, démembrement, société civile, testament ou assurance-vie peuvent devoir être pensés ensemble.</p>',NULL,NULL,120,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(26,'International','patrimoine-international','Coordonner les situations patrimoniales comportant un élément d’extranéité.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Loi applicable\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Coordination des conseils locaux\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Fiscalit\\u00e9 transfrontali\\u00e8re\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Actes et reconnaissance\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Nationalit\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9sidences successives\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Localisation des biens\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Actes \\u00e9trangers disponibles\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Par o\\u00f9 commencer ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et op\\u00e9rations d\\u00e9j\\u00e0 r\\u00e9alis\\u00e9es.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il raisonner uniquement en fiscalit\\u00e9 ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. La fiscalit\\u00e9 s\\u2019int\\u00e8gre \\u00e0 une organisation civile et patrimoniale plus large.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on coordonner plusieurs outils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Donation, d\\u00e9membrement, soci\\u00e9t\\u00e9 civile, testament ou assurance-vie peuvent devoir \\u00eatre pens\\u00e9s ensemble.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Loi applicable</p></li><li><p>Coordination des conseils locaux</p></li><li><p>Fiscalité transfrontalière</p></li><li><p>Actes et reconnaissance</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Nationalités</p></li><li><p>Résidences successives</p></li><li><p>Localisation des biens</p></li><li><p>Actes étrangers disponibles</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Par où commencer ?</h4><p>Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et opérations déjà réalisées.</p><h4>Faut-il raisonner uniquement en fiscalité ?</h4><p>Non. La fiscalité s’intègre à une organisation civile et patrimoniale plus large.</p><h4>Peut-on coordonner plusieurs outils ?</h4><p>Oui. Donation, démembrement, société civile, testament ou assurance-vie peuvent devoir être pensés ensemble.</p>',NULL,NULL,130,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13),
(27,'Entreprise','entreprise','Créer. Développer. Transmettre. Accompagner l’entrepreneur dans les opérations qui engagent son activité et son patrimoine.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Entreprise et patrimoine personnel sont souvent \\u00e9troitement li\\u00e9s. L\\u2019\\u00e9tude intervient sur les actes structurants afin de s\\u00e9curiser les op\\u00e9rations, l\\u2019immobilier professionnel et la transmission.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation appelle une analyse particuli\\u00e8re. L\\u2019\\u00e9tude identifie les enjeux, rassemble les pi\\u00e8ces utiles, coordonne les intervenants et s\\u00e9curise l\\u2019acte jusqu\\u2019\\u00e0 son aboutissement.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Notre accompagnement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Entreprendre \\u2014 S\\u00e9curiser les actes qui accompagnent le d\\u00e9veloppement.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9tenir \\u2014 Organiser l\\u2019immobilier et les actifs professionnels.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmettre \\u2014 Pr\\u00e9parer la cession ou la transmission de l\\u2019entreprise.\"}]}]}]}]}','<p>Entreprise et patrimoine personnel sont souvent étroitement liés. L’étude intervient sur les actes structurants afin de sécuriser les opérations, l’immobilier professionnel et la transmission.</p><p>Chaque situation appelle une analyse particulière. L’étude identifie les enjeux, rassemble les pièces utiles, coordonne les intervenants et sécurise l’acte jusqu’à son aboutissement.</p><h3>Notre accompagnement</h3><ul><li><p>Entreprendre — Sécuriser les actes qui accompagnent le développement.</p></li><li><p>Détenir — Organiser l’immobilier et les actifs professionnels.</p></li><li><p>Transmettre — Préparer la cession ou la transmission de l’entreprise.</p></li></ul>',NULL,NULL,30,1,13,NULL,NULL,NULL,NULL,0,NULL,NULL),
(28,'Création & structuration','entreprise-creation-structuration','Donner au projet entrepreneurial une architecture juridique lisible.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Choix de la structure\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Statuts et gouvernance\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Apports\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Mise en place\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Associ\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Financement\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Actifs concern\\u00e9s\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand associer le notaire au projet ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"En amont, lorsque la structuration patrimoniale, l\\u2019immobilier ou la transmission sont susceptibles d\\u2019influencer l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude travaille-t-elle avec les autres conseils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Les dossiers d\\u2019entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils sp\\u00e9cialis\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper la transmission d\\u00e8s la cr\\u00e9ation ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. La gouvernance, la d\\u00e9tention des actifs et les objectifs familiaux peuvent \\u00eatre int\\u00e9gr\\u00e9s tr\\u00e8s t\\u00f4t \\u00e0 la r\\u00e9flexion.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Choix de la structure</p></li><li><p>Statuts et gouvernance</p></li><li><p>Apports</p></li><li><p>Mise en place</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Projet</p></li><li><p>Associés</p></li><li><p>Financement</p></li><li><p>Actifs concernés</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand associer le notaire au projet ?</h4><p>En amont, lorsque la structuration patrimoniale, l’immobilier ou la transmission sont susceptibles d’influencer l’opération.</p><h4>L’étude travaille-t-elle avec les autres conseils ?</h4><p>Oui. Les dossiers d’entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils spécialisés.</p><h4>Peut-on anticiper la transmission dès la création ?</h4><p>Oui. La gouvernance, la détention des actifs et les objectifs familiaux peuvent être intégrés très tôt à la réflexion.</p>',NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL,0,NULL,27),
(29,'Cession & acquisition','entreprise-cession-acquisition','Préparer et sécuriser la transmission d’une activité ou de titres.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Audit juridique\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avant-contrat\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Conditions\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte et formalit\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Comptes et statuts\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres ou actifs c\\u00e9d\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux et contrats utiles\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet de financement\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand associer le notaire au projet ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"En amont, lorsque la structuration patrimoniale, l\\u2019immobilier ou la transmission sont susceptibles d\\u2019influencer l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude travaille-t-elle avec les autres conseils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Les dossiers d\\u2019entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils sp\\u00e9cialis\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper la transmission d\\u00e8s la cr\\u00e9ation ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. La gouvernance, la d\\u00e9tention des actifs et les objectifs familiaux peuvent \\u00eatre int\\u00e9gr\\u00e9s tr\\u00e8s t\\u00f4t \\u00e0 la r\\u00e9flexion.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Audit juridique</p></li><li><p>Avant-contrat</p></li><li><p>Conditions</p></li><li><p>Acte et formalités</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Comptes et statuts</p></li><li><p>Titres ou actifs cédés</p></li><li><p>Baux et contrats utiles</p></li><li><p>Projet de financement</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand associer le notaire au projet ?</h4><p>En amont, lorsque la structuration patrimoniale, l’immobilier ou la transmission sont susceptibles d’influencer l’opération.</p><h4>L’étude travaille-t-elle avec les autres conseils ?</h4><p>Oui. Les dossiers d’entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils spécialisés.</p><h4>Peut-on anticiper la transmission dès la création ?</h4><p>Oui. La gouvernance, la détention des actifs et les objectifs familiaux peuvent être intégrés très tôt à la réflexion.</p>',NULL,NULL,20,1,NULL,NULL,NULL,NULL,NULL,0,NULL,27),
(30,'Fonds de commerce','entreprise-fonds-commerce','Accompagner la cession ou l’acquisition du fonds et de ses éléments essentiels.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"P\\u00e9rim\\u00e8tre de la cession\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avant-contrat\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Formalit\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9questre et r\\u00e9alisation\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titre ou origine du fonds\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Bail\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9l\\u00e9ments comptables\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Salari\\u00e9s et contrats utiles\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand associer le notaire au projet ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"En amont, lorsque la structuration patrimoniale, l\\u2019immobilier ou la transmission sont susceptibles d\\u2019influencer l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude travaille-t-elle avec les autres conseils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Les dossiers d\\u2019entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils sp\\u00e9cialis\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper la transmission d\\u00e8s la cr\\u00e9ation ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. La gouvernance, la d\\u00e9tention des actifs et les objectifs familiaux peuvent \\u00eatre int\\u00e9gr\\u00e9s tr\\u00e8s t\\u00f4t \\u00e0 la r\\u00e9flexion.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Périmètre de la cession</p></li><li><p>Avant-contrat</p></li><li><p>Formalités</p></li><li><p>Séquestre et réalisation</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titre ou origine du fonds</p></li><li><p>Bail</p></li><li><p>Éléments comptables</p></li><li><p>Salariés et contrats utiles</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand associer le notaire au projet ?</h4><p>En amont, lorsque la structuration patrimoniale, l’immobilier ou la transmission sont susceptibles d’influencer l’opération.</p><h4>L’étude travaille-t-elle avec les autres conseils ?</h4><p>Oui. Les dossiers d’entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils spécialisés.</p><h4>Peut-on anticiper la transmission dès la création ?</h4><p>Oui. La gouvernance, la détention des actifs et les objectifs familiaux peuvent être intégrés très tôt à la réflexion.</p>',NULL,NULL,30,1,NULL,NULL,NULL,NULL,NULL,0,NULL,27),
(31,'Immobilier d’entreprise','entreprise-immobilier-entreprise','Articuler activité professionnelle et détention des murs.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Mode de d\\u00e9tention\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acquisition\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Bail et flux\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmission future\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet immobilier\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Structure d\\u2019exploitation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Financement\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux existants\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand associer le notaire au projet ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"En amont, lorsque la structuration patrimoniale, l\\u2019immobilier ou la transmission sont susceptibles d\\u2019influencer l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude travaille-t-elle avec les autres conseils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Les dossiers d\\u2019entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils sp\\u00e9cialis\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper la transmission d\\u00e8s la cr\\u00e9ation ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. La gouvernance, la d\\u00e9tention des actifs et les objectifs familiaux peuvent \\u00eatre int\\u00e9gr\\u00e9s tr\\u00e8s t\\u00f4t \\u00e0 la r\\u00e9flexion.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Mode de détention</p></li><li><p>Acquisition</p></li><li><p>Bail et flux</p></li><li><p>Transmission future</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Projet immobilier</p></li><li><p>Structure d’exploitation</p></li><li><p>Financement</p></li><li><p>Baux existants</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand associer le notaire au projet ?</h4><p>En amont, lorsque la structuration patrimoniale, l’immobilier ou la transmission sont susceptibles d’influencer l’opération.</p><h4>L’étude travaille-t-elle avec les autres conseils ?</h4><p>Oui. Les dossiers d’entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils spécialisés.</p><h4>Peut-on anticiper la transmission dès la création ?</h4><p>Oui. La gouvernance, la détention des actifs et les objectifs familiaux peuvent être intégrés très tôt à la réflexion.</p>',NULL,NULL,40,1,NULL,NULL,NULL,NULL,NULL,0,NULL,27),
(32,'Transmission d’entreprise','entreprise-transmission-entreprise','Anticiper la transmission familiale ou la cession de l’outil professionnel.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Diagnostic\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sc\\u00e9narios\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmission ou cession\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Mise en \\u0153uvre\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Organigramme\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Statuts\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Valorisations\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation familiale\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand associer le notaire au projet ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"En amont, lorsque la structuration patrimoniale, l\\u2019immobilier ou la transmission sont susceptibles d\\u2019influencer l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude travaille-t-elle avec les autres conseils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Les dossiers d\\u2019entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils sp\\u00e9cialis\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper la transmission d\\u00e8s la cr\\u00e9ation ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. La gouvernance, la d\\u00e9tention des actifs et les objectifs familiaux peuvent \\u00eatre int\\u00e9gr\\u00e9s tr\\u00e8s t\\u00f4t \\u00e0 la r\\u00e9flexion.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Diagnostic</p></li><li><p>Scénarios</p></li><li><p>Transmission ou cession</p></li><li><p>Mise en œuvre</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Organigramme</p></li><li><p>Statuts</p></li><li><p>Valorisations</p></li><li><p>Situation familiale</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand associer le notaire au projet ?</h4><p>En amont, lorsque la structuration patrimoniale, l’immobilier ou la transmission sont susceptibles d’influencer l’opération.</p><h4>L’étude travaille-t-elle avec les autres conseils ?</h4><p>Oui. Les dossiers d’entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils spécialisés.</p><h4>Peut-on anticiper la transmission dès la création ?</h4><p>Oui. La gouvernance, la détention des actifs et les objectifs familiaux peuvent être intégrés très tôt à la réflexion.</p>',NULL,NULL,50,1,NULL,NULL,NULL,NULL,NULL,0,NULL,27),
(33,'Holding & organisation','entreprise-holding','Structurer la détention de participations et les flux avec cohérence.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Architecture\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Apports et d\\u00e9tention\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Gouvernance\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Coordination fiscale et patrimoniale\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Organigramme\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Statuts\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Participations\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Objectifs d\\u2019investissement ou transmission\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Quand associer le notaire au projet ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"En amont, lorsque la structuration patrimoniale, l\\u2019immobilier ou la transmission sont susceptibles d\\u2019influencer l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude travaille-t-elle avec les autres conseils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Les dossiers d\\u2019entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils sp\\u00e9cialis\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on anticiper la transmission d\\u00e8s la cr\\u00e9ation ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. La gouvernance, la d\\u00e9tention des actifs et les objectifs familiaux peuvent \\u00eatre int\\u00e9gr\\u00e9s tr\\u00e8s t\\u00f4t \\u00e0 la r\\u00e9flexion.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Architecture</p></li><li><p>Apports et détention</p></li><li><p>Gouvernance</p></li><li><p>Coordination fiscale et patrimoniale</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Organigramme</p></li><li><p>Statuts</p></li><li><p>Participations</p></li><li><p>Objectifs d’investissement ou transmission</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Quand associer le notaire au projet ?</h4><p>En amont, lorsque la structuration patrimoniale, l’immobilier ou la transmission sont susceptibles d’influencer l’opération.</p><h4>L’étude travaille-t-elle avec les autres conseils ?</h4><p>Oui. Les dossiers d’entreprise sont souvent conduits en coordination avec expert-comptable, avocat, banque et conseils spécialisés.</p><h4>Peut-on anticiper la transmission dès la création ?</h4><p>Oui. La gouvernance, la détention des actifs et les objectifs familiaux peuvent être intégrés très tôt à la réflexion.</p>',NULL,NULL,60,1,NULL,NULL,NULL,NULL,NULL,0,NULL,27),
(34,'Droit rural','droit-rural','Exploiter. Transmettre. Préserver. Une expertise dédiée au foncier, à l’exploitation et à la transmission du patrimoine rural.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Le droit rural impose de croiser propri\\u00e9t\\u00e9, exploitation, dur\\u00e9e, pr\\u00e9emption et transmission. L\\u2019\\u00e9tude accompagne propri\\u00e9taires, exploitants et familles dans la structuration de leurs op\\u00e9rations rurales.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Chaque situation appelle une analyse particuli\\u00e8re. L\\u2019\\u00e9tude identifie les enjeux, rassemble les pi\\u00e8ces utiles, coordonne les intervenants et s\\u00e9curise l\\u2019acte jusqu\\u2019\\u00e0 son aboutissement.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Notre accompagnement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Foncier \\u2014 Identifier les contraintes et droits attach\\u00e9s aux parcelles.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Exploitation \\u2014 Formaliser une occupation adapt\\u00e9e \\u00e0 la r\\u00e9alit\\u00e9 agricole.\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmission \\u2014 Pr\\u00e9server la coh\\u00e9rence du patrimoine rural dans le temps.\"}]}]}]}]}','<p>Le droit rural impose de croiser propriété, exploitation, durée, préemption et transmission. L’étude accompagne propriétaires, exploitants et familles dans la structuration de leurs opérations rurales.</p><p>Chaque situation appelle une analyse particulière. L’étude identifie les enjeux, rassemble les pièces utiles, coordonne les intervenants et sécurise l’acte jusqu’à son aboutissement.</p><h3>Notre accompagnement</h3><ul><li><p>Foncier — Identifier les contraintes et droits attachés aux parcelles.</p></li><li><p>Exploitation — Formaliser une occupation adaptée à la réalité agricole.</p></li><li><p>Transmission — Préserver la cohérence du patrimoine rural dans le temps.</p></li></ul>',NULL,NULL,40,1,14,NULL,NULL,NULL,NULL,0,NULL,NULL),
(35,'Bail rural','droit-rural-bail-rural','Encadrer durablement la mise à disposition de terres et bâtiments agricoles.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Qualification\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Dur\\u00e9e et fermage\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Clauses\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Signature et formalit\\u00e9s\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parcelles\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Identit\\u00e9 des parties\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Conditions d\\u2019exploitation\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi faire analyser les titres et baux ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parce que l\\u2019occupation, les droits de pr\\u00e9emption, les acc\\u00e8s et l\\u2019historique foncier peuvent modifier sensiblement l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Le foncier et l\\u2019exploitation doivent-ils \\u00eatre \\u00e9tudi\\u00e9s ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tr\\u00e8s souvent. La propri\\u00e9t\\u00e9 des terres, les structures d\\u2019exploitation et la transmission forment un ensemble coh\\u00e9rent.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude coordonne-t-elle g\\u00e9om\\u00e8tre et autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Selon le dossier, oui, notamment lorsque des divisions, bornages, acc\\u00e8s ou conventions techniques sont n\\u00e9cessaires.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Qualification</p></li><li><p>Durée et fermage</p></li><li><p>Clauses</p></li><li><p>Signature et formalités</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres</p></li><li><p>Parcelles</p></li><li><p>Identité des parties</p></li><li><p>Conditions d’exploitation</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Pourquoi faire analyser les titres et baux ?</h4><p>Parce que l’occupation, les droits de préemption, les accès et l’historique foncier peuvent modifier sensiblement l’opération.</p><h4>Le foncier et l’exploitation doivent-ils être étudiés ensemble ?</h4><p>Très souvent. La propriété des terres, les structures d’exploitation et la transmission forment un ensemble cohérent.</p><h4>L’étude coordonne-t-elle géomètre et autres intervenants ?</h4><p>Selon le dossier, oui, notamment lorsque des divisions, bornages, accès ou conventions techniques sont nécessaires.</p>',NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL,0,NULL,34),
(36,'Bail à long terme','droit-rural-bail-long-terme','Organiser une relation foncière agricole stable sur le long terme.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Dur\\u00e9e\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Clauses sp\\u00e9cifiques\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmission\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parcelles\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet d\\u2019exploitation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Conditions \\u00e9conomiques\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi faire analyser les titres et baux ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parce que l\\u2019occupation, les droits de pr\\u00e9emption, les acc\\u00e8s et l\\u2019historique foncier peuvent modifier sensiblement l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Le foncier et l\\u2019exploitation doivent-ils \\u00eatre \\u00e9tudi\\u00e9s ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tr\\u00e8s souvent. La propri\\u00e9t\\u00e9 des terres, les structures d\\u2019exploitation et la transmission forment un ensemble coh\\u00e9rent.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude coordonne-t-elle g\\u00e9om\\u00e8tre et autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Selon le dossier, oui, notamment lorsque des divisions, bornages, acc\\u00e8s ou conventions techniques sont n\\u00e9cessaires.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Durée</p></li><li><p>Clauses spécifiques</p></li><li><p>Transmission</p></li><li><p>Acte</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres</p></li><li><p>Parcelles</p></li><li><p>Projet d’exploitation</p></li><li><p>Conditions économiques</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Pourquoi faire analyser les titres et baux ?</h4><p>Parce que l’occupation, les droits de préemption, les accès et l’historique foncier peuvent modifier sensiblement l’opération.</p><h4>Le foncier et l’exploitation doivent-ils être étudiés ensemble ?</h4><p>Très souvent. La propriété des terres, les structures d’exploitation et la transmission forment un ensemble cohérent.</p><h4>L’étude coordonne-t-elle géomètre et autres intervenants ?</h4><p>Selon le dossier, oui, notamment lorsque des divisions, bornages, accès ou conventions techniques sont nécessaires.</p>',NULL,NULL,20,1,NULL,NULL,NULL,NULL,NULL,0,NULL,34),
(37,'GFA','droit-rural-gfa','Structurer la propriété foncière agricole et sa transmission.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Constitution ou r\\u00e9organisation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Apports\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Gouvernance\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmission des parts\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Foncier\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Associ\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Valeurs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux existants\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi faire analyser les titres et baux ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parce que l\\u2019occupation, les droits de pr\\u00e9emption, les acc\\u00e8s et l\\u2019historique foncier peuvent modifier sensiblement l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Le foncier et l\\u2019exploitation doivent-ils \\u00eatre \\u00e9tudi\\u00e9s ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tr\\u00e8s souvent. La propri\\u00e9t\\u00e9 des terres, les structures d\\u2019exploitation et la transmission forment un ensemble coh\\u00e9rent.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude coordonne-t-elle g\\u00e9om\\u00e8tre et autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Selon le dossier, oui, notamment lorsque des divisions, bornages, acc\\u00e8s ou conventions techniques sont n\\u00e9cessaires.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Constitution ou réorganisation</p></li><li><p>Apports</p></li><li><p>Gouvernance</p></li><li><p>Transmission des parts</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Foncier</p></li><li><p>Associés</p></li><li><p>Valeurs</p></li><li><p>Baux existants</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Pourquoi faire analyser les titres et baux ?</h4><p>Parce que l’occupation, les droits de préemption, les accès et l’historique foncier peuvent modifier sensiblement l’opération.</p><h4>Le foncier et l’exploitation doivent-ils être étudiés ensemble ?</h4><p>Très souvent. La propriété des terres, les structures d’exploitation et la transmission forment un ensemble cohérent.</p><h4>L’étude coordonne-t-elle géomètre et autres intervenants ?</h4><p>Selon le dossier, oui, notamment lorsque des divisions, bornages, accès ou conventions techniques sont nécessaires.</p>',NULL,NULL,30,1,NULL,NULL,NULL,NULL,NULL,0,NULL,34),
(38,'Transmission agricole','droit-rural-transmission-agricole','Préparer le passage de l’exploitation et du foncier à la génération suivante.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Diagnostic\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9partition foncier\\/exploitation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Donation ou cession\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Calendrier\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Foncier\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Structures d\\u2019exploitation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation familiale\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi faire analyser les titres et baux ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parce que l\\u2019occupation, les droits de pr\\u00e9emption, les acc\\u00e8s et l\\u2019historique foncier peuvent modifier sensiblement l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Le foncier et l\\u2019exploitation doivent-ils \\u00eatre \\u00e9tudi\\u00e9s ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tr\\u00e8s souvent. La propri\\u00e9t\\u00e9 des terres, les structures d\\u2019exploitation et la transmission forment un ensemble coh\\u00e9rent.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude coordonne-t-elle g\\u00e9om\\u00e8tre et autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Selon le dossier, oui, notamment lorsque des divisions, bornages, acc\\u00e8s ou conventions techniques sont n\\u00e9cessaires.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Diagnostic</p></li><li><p>Répartition foncier/exploitation</p></li><li><p>Donation ou cession</p></li><li><p>Calendrier</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Foncier</p></li><li><p>Structures d’exploitation</p></li><li><p>Baux</p></li><li><p>Situation familiale</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Pourquoi faire analyser les titres et baux ?</h4><p>Parce que l’occupation, les droits de préemption, les accès et l’historique foncier peuvent modifier sensiblement l’opération.</p><h4>Le foncier et l’exploitation doivent-ils être étudiés ensemble ?</h4><p>Très souvent. La propriété des terres, les structures d’exploitation et la transmission forment un ensemble cohérent.</p><h4>L’étude coordonne-t-elle géomètre et autres intervenants ?</h4><p>Selon le dossier, oui, notamment lorsque des divisions, bornages, accès ou conventions techniques sont nécessaires.</p>',NULL,NULL,40,1,NULL,NULL,NULL,NULL,NULL,0,NULL,34),
(39,'Droit de préemption','droit-rural-preemption','Identifier et purger les droits de préemption applicables à l’opération.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Identification du droit\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Notification\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9lais\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9alisation de la vente\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet de vente\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parcelles\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Occupation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi faire analyser les titres et baux ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parce que l\\u2019occupation, les droits de pr\\u00e9emption, les acc\\u00e8s et l\\u2019historique foncier peuvent modifier sensiblement l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Le foncier et l\\u2019exploitation doivent-ils \\u00eatre \\u00e9tudi\\u00e9s ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tr\\u00e8s souvent. La propri\\u00e9t\\u00e9 des terres, les structures d\\u2019exploitation et la transmission forment un ensemble coh\\u00e9rent.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude coordonne-t-elle g\\u00e9om\\u00e8tre et autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Selon le dossier, oui, notamment lorsque des divisions, bornages, acc\\u00e8s ou conventions techniques sont n\\u00e9cessaires.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Identification du droit</p></li><li><p>Notification</p></li><li><p>Délais</p></li><li><p>Réalisation de la vente</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Projet de vente</p></li><li><p>Parcelles</p></li><li><p>Occupation</p></li><li><p>Titres</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Pourquoi faire analyser les titres et baux ?</h4><p>Parce que l’occupation, les droits de préemption, les accès et l’historique foncier peuvent modifier sensiblement l’opération.</p><h4>Le foncier et l’exploitation doivent-ils être étudiés ensemble ?</h4><p>Très souvent. La propriété des terres, les structures d’exploitation et la transmission forment un ensemble cohérent.</p><h4>L’étude coordonne-t-elle géomètre et autres intervenants ?</h4><p>Selon le dossier, oui, notamment lorsque des divisions, bornages, accès ou conventions techniques sont nécessaires.</p>',NULL,NULL,50,1,NULL,NULL,NULL,NULL,NULL,0,NULL,34),
(40,'Foncier agricole','droit-rural-foncier-agricole','Sécuriser ventes, acquisitions, échanges et divisions de parcelles agricoles.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Situation fonci\\u00e8re\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Occupation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Pr\\u00e9emptions\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cadastre\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Bornages disponibles\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi faire analyser les titres et baux ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parce que l\\u2019occupation, les droits de pr\\u00e9emption, les acc\\u00e8s et l\\u2019historique foncier peuvent modifier sensiblement l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Le foncier et l\\u2019exploitation doivent-ils \\u00eatre \\u00e9tudi\\u00e9s ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tr\\u00e8s souvent. La propri\\u00e9t\\u00e9 des terres, les structures d\\u2019exploitation et la transmission forment un ensemble coh\\u00e9rent.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude coordonne-t-elle g\\u00e9om\\u00e8tre et autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Selon le dossier, oui, notamment lorsque des divisions, bornages, acc\\u00e8s ou conventions techniques sont n\\u00e9cessaires.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Situation foncière</p></li><li><p>Occupation</p></li><li><p>Préemptions</p></li><li><p>Acte</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres</p></li><li><p>Cadastre</p></li><li><p>Baux</p></li><li><p>Bornages disponibles</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Pourquoi faire analyser les titres et baux ?</h4><p>Parce que l’occupation, les droits de préemption, les accès et l’historique foncier peuvent modifier sensiblement l’opération.</p><h4>Le foncier et l’exploitation doivent-ils être étudiés ensemble ?</h4><p>Très souvent. La propriété des terres, les structures d’exploitation et la transmission forment un ensemble cohérent.</p><h4>L’étude coordonne-t-elle géomètre et autres intervenants ?</h4><p>Selon le dossier, oui, notamment lorsque des divisions, bornages, accès ou conventions techniques sont nécessaires.</p>',NULL,NULL,60,1,NULL,NULL,NULL,NULL,NULL,0,NULL,34),
(41,'Photovoltaïque & conventions','droit-rural-photovoltaique','Articuler projet énergétique, foncier et exploitation agricole.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Qualification de la convention\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Dur\\u00e9e et acc\\u00e8s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Compatibilit\\u00e9 avec l\\u2019exploitation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte et publicit\\u00e9\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Titres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Projet technique\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux ou conventions existants\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Plans\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi faire analyser les titres et baux ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Parce que l\\u2019occupation, les droits de pr\\u00e9emption, les acc\\u00e8s et l\\u2019historique foncier peuvent modifier sensiblement l\\u2019op\\u00e9ration.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Le foncier et l\\u2019exploitation doivent-ils \\u00eatre \\u00e9tudi\\u00e9s ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tr\\u00e8s souvent. La propri\\u00e9t\\u00e9 des terres, les structures d\\u2019exploitation et la transmission forment un ensemble coh\\u00e9rent.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"L\\u2019\\u00e9tude coordonne-t-elle g\\u00e9om\\u00e8tre et autres intervenants ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Selon le dossier, oui, notamment lorsque des divisions, bornages, acc\\u00e8s ou conventions techniques sont n\\u00e9cessaires.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Qualification de la convention</p></li><li><p>Durée et accès</p></li><li><p>Compatibilité avec l’exploitation</p></li><li><p>Acte et publicité</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Titres</p></li><li><p>Projet technique</p></li><li><p>Baux ou conventions existants</p></li><li><p>Plans</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Pourquoi faire analyser les titres et baux ?</h4><p>Parce que l’occupation, les droits de préemption, les accès et l’historique foncier peuvent modifier sensiblement l’opération.</p><h4>Le foncier et l’exploitation doivent-ils être étudiés ensemble ?</h4><p>Très souvent. La propriété des terres, les structures d’exploitation et la transmission forment un ensemble cohérent.</p><h4>L’étude coordonne-t-elle géomètre et autres intervenants ?</h4><p>Selon le dossier, oui, notamment lorsque des divisions, bornages, accès ou conventions techniques sont nécessaires.</p>',NULL,NULL,70,1,NULL,NULL,NULL,NULL,NULL,0,NULL,34),
(42,'IFI','patrimoine-ifi','Identifier le patrimoine immobilier concerné et organiser la documentation utile.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un premier \\u00e9change permet de replacer votre projet dans son contexte, d\\u2019identifier les points de vigilance et de d\\u00e9terminer le chemin le plus adapt\\u00e9. L\\u2019\\u00e9tude vous accompagne ensuite jusqu\\u2019\\u00e0 la r\\u00e9alisation des actes et formalit\\u00e9s n\\u00e9cessaires.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Votre dossier, \\u00e9tape par \\u00e9tape\"}]},{\"type\":\"orderedList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"P\\u00e9rim\\u00e8tre\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Valorisation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Passif et d\\u00e9tention indirecte\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Pr\\u00e9paration des \\u00e9l\\u00e9ments d\\u00e9claratifs\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les premiers \\u00e9l\\u00e9ments \\u00e0 r\\u00e9unir\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Biens immobiliers\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Dettes\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Structures de d\\u00e9tention\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9valuations disponibles\"}]}]}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cette liste constitue un point de d\\u00e9part. Les pi\\u00e8ces r\\u00e9ellement n\\u00e9cessaires sont pr\\u00e9cis\\u00e9es apr\\u00e8s examen de votre situation.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Avant le rendez-vous\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Par o\\u00f9 commencer ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et op\\u00e9rations d\\u00e9j\\u00e0 r\\u00e9alis\\u00e9es.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Faut-il raisonner uniquement en fiscalit\\u00e9 ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Non. La fiscalit\\u00e9 s\\u2019int\\u00e8gre \\u00e0 une organisation civile et patrimoniale plus large.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Peut-on coordonner plusieurs outils ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui. Donation, d\\u00e9membrement, soci\\u00e9t\\u00e9 civile, testament ou assurance-vie peuvent devoir \\u00eatre pens\\u00e9s ensemble.\"}]}]}','<p>Un premier échange permet de replacer votre projet dans son contexte, d’identifier les points de vigilance et de déterminer le chemin le plus adapté. L’étude vous accompagne ensuite jusqu’à la réalisation des actes et formalités nécessaires.</p><h3>Votre dossier, étape par étape</h3><ol><li><p>Périmètre</p></li><li><p>Valorisation</p></li><li><p>Passif et détention indirecte</p></li><li><p>Préparation des éléments déclaratifs</p></li></ol><h3>Les premiers éléments à réunir</h3><ul><li><p>Biens immobiliers</p></li><li><p>Dettes</p></li><li><p>Structures de détention</p></li><li><p>Évaluations disponibles</p></li></ul><p>Cette liste constitue un point de départ. Les pièces réellement nécessaires sont précisées après examen de votre situation.</p><h3>Avant le rendez-vous</h3><h4>Par où commencer ?</h4><p>Par un diagnostic global : famille, patrimoine, objectifs, horizon de temps et opérations déjà réalisées.</p><h4>Faut-il raisonner uniquement en fiscalité ?</h4><p>Non. La fiscalité s’intègre à une organisation civile et patrimoniale plus large.</p><h4>Peut-on coordonner plusieurs outils ?</h4><p>Oui. Donation, démembrement, société civile, testament ou assurance-vie peuvent devoir être pensés ensemble.</p>',NULL,NULL,140,1,NULL,NULL,NULL,NULL,NULL,0,NULL,13);
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `site`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `site` WRITE;
/*!40000 ALTER TABLE `site` DISABLE KEYS */;
INSERT INTO `site` VALUES
(1,'Maître Bruno Mainguy, notaire à Saint-Martory','Office notarial — Saint-Martory','bruno.mainguy@31061.notaires.fr','Saint-Martory','31360','379 rue des Villas',NULL,'documents/medias/carte-maitre-bruno-mainguy-notaire-a-saint-martory.webp','0561902040','Maître Bruno Mainguy — Notaire à Saint-Martory','Office notarial BM NOTAIRE à Saint-Martory (31) : immobilier, famille, patrimoine, entreprise. Anticiper les événements de votre vie en toute sérénité.',NULL,NULL,'#142019','#778078','#f2eadf','\'DM Sans\', sans-serif','\'Playfair Display\', serif','corporate','ttc','[\"vitrine\",\"services\",\"marketing\"]',NULL,NULL,NULL,6,NULL,8,9,NULL,NULL,5,NULL,'ProfessionalService',NULL,'Mo 09:00-12:00\nMo 14:00-18:00\nTu 09:00-12:00\nTu 14:00-18:00\nWe 09:00-12:00\nWe 14:00-18:00\nTh 09:00-12:00\nTh 14:00-18:00\nFr 09:00-12:00\nFr 14:00-18:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `site` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `site_gallery_item`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `site_gallery_item` WRITE;
/*!40000 ALTER TABLE `site_gallery_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_gallery_item` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `slug_redirect`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `slug_redirect` WRITE;
/*!40000 ALTER TABLE `slug_redirect` DISABLE KEYS */;
/*!40000 ALTER TABLE `slug_redirect` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `tag_article`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag_article` WRITE;
/*!40000 ALTER TABLE `tag_article` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_article` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `tag_categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag_categorie` WRITE;
/*!40000 ALTER TABLE `tag_categorie` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_categorie` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `tag_group`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag_group` WRITE;
/*!40000 ALTER TABLE `tag_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_group` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `tag_media`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag_media` WRITE;
/*!40000 ALTER TABLE `tag_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_media` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `tag_page`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag_page` WRITE;
/*!40000 ALTER TABLE `tag_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_page` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-10-20 15:01:36
