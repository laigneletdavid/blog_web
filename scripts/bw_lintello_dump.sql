/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bw_lintello
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=601 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-10-23  4:24:24
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bw_lintello
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
(1,'Guides pratiques','guides-pratiques','#2563eb','Guides pratiques LintellO : l’IA au quotidien, pas à pas','Des guides pas à pas pour régler un vrai besoin avec LintellO : écrire, réviser, chercher, rédiger un document.',NULL,0,NULL,NULL),
(2,'Comprendre l’IA','comprendre-l-ia','#2563eb','Comprendre l’IA : ce qu’elle fait de vos données','Ce que fait une IA, ce qu’elle fait de vos données et comment la choisir, expliqué sans jargon.',NULL,0,NULL,NULL),
(3,'Nouveautés','nouveautes','#2563eb','Nouveautés LintellO','Ce qui arrive dans LintellO, version après version.',NULL,0,NULL,NULL);
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
('DoctrineMigrations\\Version20260327093858','2026-10-20 08:31:36',3910),
('DoctrineMigrations\\Version20260330175902','2026-10-20 08:31:40',64),
('DoctrineMigrations\\Version20260331051133','2026-10-20 08:31:40',827),
('DoctrineMigrations\\Version20260331120749','2026-10-20 08:31:41',28),
('DoctrineMigrations\\Version20260331134753','2026-10-20 08:31:41',18),
('DoctrineMigrations\\Version20260402035203','2026-10-20 08:31:41',82),
('DoctrineMigrations\\Version20260403055742','2026-10-20 08:31:41',97),
('DoctrineMigrations\\Version20260403093313','2026-10-20 08:31:41',308),
('DoctrineMigrations\\Version20260408055018','2026-10-20 08:31:41',77),
('DoctrineMigrations\\Version20260409085027','2026-10-20 08:31:41',35),
('DoctrineMigrations\\Version20260416073057','2026-10-20 08:31:41',87),
('DoctrineMigrations\\Version20260429075920','2026-10-20 08:31:41',376),
('DoctrineMigrations\\Version20260504063822','2026-10-20 08:31:42',170),
('DoctrineMigrations\\Version20260508090000','2026-10-20 08:31:42',14),
('DoctrineMigrations\\Version20260510131558','2026-10-20 08:31:42',136),
('DoctrineMigrations\\Version20260518170000','2026-10-20 08:31:42',18),
('DoctrineMigrations\\Version20260520120000','2026-10-20 08:31:42',165),
('DoctrineMigrations\\Version20260521043802','2026-10-20 08:31:42',166),
('DoctrineMigrations\\Version20260521051808','2026-10-20 08:31:42',56),
('DoctrineMigrations\\Version20260615180000','2026-10-20 08:31:42',14),
('DoctrineMigrations\\Version20260615185204','2026-10-20 08:31:42',15),
('DoctrineMigrations\\Version20260615192357','2026-10-20 08:31:43',15),
('DoctrineMigrations\\Version20260616040528','2026-10-20 08:31:43',19),
('DoctrineMigrations\\Version20261017055243','2026-10-20 08:31:43',16),
('DoctrineMigrations\\Version20261017061500','2026-10-20 08:31:43',16),
('DoctrineMigrations\\Version20261018054056','2026-10-20 08:31:43',14),
('DoctrineMigrations\\Version20261019061849','2026-10-20 08:31:43',22),
('DoctrineMigrations\\Version20261019081701','2026-10-20 08:31:43',70),
('DoctrineMigrations\\Version20261020044200','2026-10-20 08:31:43',71),
('DoctrineMigrations\\Version20261020051727','2026-10-20 08:31:43',16);
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
INSERT INTO `faq` VALUES
(1,'Où sont mes données ?','ou-sont-stockees-mes-donnees',NULL,'<p>En France. Vos conversations, vos documents et vos fichiers sont chiffrés sur nos serveurs à Strasbourg, et l\'IA est un moteur français. Tout est détaillé sur la page <a href=\"/page/confiance\">Confiance</a>.</p>',NULL,0,1,1),
(2,'Mes documents servent-ils à entraîner l\'IA ?','mes-conversations-servent-elles-a-entrainer-l-ia',NULL,'<p>Non, jamais. Vos conversations et vos documents servent à vous répondre, à rien d\'autre. C\'est écrit dans nos CGU (article 6.2).</p>',NULL,10,1,1),
(3,'Faut-il savoir utiliser l\'IA ?','faut-il-savoir-utiliser-l-ia',NULL,'<p>Non. Écrivez comme à un collègue : LintellO s\'adapte, qu\'il s\'agisse d\'une réponse courte, d\'un document à rédiger ou d\'une recherche sur le web. Pas de réglage.</p>',NULL,20,1,2),
(4,'Combien ça coûte ?','combien-ca-coute',NULL,'<p>Vous commencez gratuitement : 20 messages par jour, sans engagement. Les offres payantes vont de 4,99 € TTC par mois pour les études à 19,90 € HT par mois pour les pros, résiliables quand vous voulez.</p>',NULL,30,1,3),
(5,'Comment récupérer mes données ?','comment-recuperer-mes-donnees',NULL,'<p>Sur toutes les offres, vous exportez vos données en JSON ou en PDF depuis vos réglages. Vous pouvez aussi supprimer votre compte quand vous le souhaitez.</p>',NULL,40,1,1),
(6,'Comment sont comptées les recherches ?','comment-sont-comptees-les-recherches',NULL,'<p>En crédits. Une recherche lancée depuis le chat coûte un crédit, une recherche dans l’outil Recherche en coûte deux. Chaque offre donne un nombre de crédits par mois, de 50 avec l’offre Gratuite à 8 000 avec l’offre LintellO : le détail est sur la page <a href=\"/page/tarifs\">Tarifs</a>.</p>',NULL,50,1,2),
(7,'Fonctionne-t-il sur mobile ?','fonctionne-t-il-sur-mobile',NULL,'<p>Oui, dans le navigateur de votre téléphone : le menu s’adapte, vous pouvez prendre une photo et le panneau de document passe en plein écran. Il n’y a pas d’application à installer.</p>',NULL,60,1,2),
(8,'Puis-je créer mes propres modes ?','puis-je-creer-mes-propres-modes',NULL,'<p>Oui, avec l’offre LintellO : vous créez des modes adaptés à votre métier, en plus des 18 modes proposés.</p>',NULL,70,0,2),
(9,'Comment changer d’offre ou résilier ?','comment-changer-d-offre-ou-resilier',NULL,'<p>Quand vous changez d’offre, la différence est facturée tout de suite, au prorata. Vous pouvez résilier à la fin de la période en cours ou immédiatement.</p>',NULL,80,1,3),
(10,'L’offre Étudiant demande-t-elle un justificatif ?','l-offre-etudiant-demande-t-elle-un-justificatif',NULL,'<p>Non. L’offre Étudiant s’ouvre sur simple déclaration, sans justificatif à fournir (CGV, article 3).</p>',NULL,90,1,3),
(11,'Puis-je me rétracter ?','puis-je-me-retracter',NULL,'<p>Oui. Les consommateurs disposent de 14 jours pour se rétracter, et sont remboursés au prorata. Les conditions complètes sont dans les <a href=\"https://www.lintello.ai/conditions\">CGV</a>.</p>',NULL,100,1,3),
(12,'Qu\'est-ce qui change par rapport aux autres IA ?','qu-est-ce-qui-change-par-rapport-aux-autres-ia',NULL,'<p>LintellO est conçu et hébergé en France, et vos données ne servent jamais à l\'entraînement. Et tout est relié : une réponse devient un document, une recherche revient dans le chat, et tout se range dans vos projets.</p>',NULL,25,1,2);
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
INSERT INTO `faq_category` VALUES
(1,'Vos données','vos-donnees',0,1),
(2,'Utiliser LintellO','utiliser-lintello',10,1),
(3,'Offres et abonnement','offres-et-abonnement',20,1);
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
(1,'logo principal','logo-long-noir-d06cce52-596e-499e-9641-b76332470e8e.png','logo-long-noir-d06cce52-596e-499e-9641-b76332470e8e.webp',437,96,'LintellO - IA souveraine et 100% française'),
(2,'logo principal - gris','logo-long-gris-1aea00c5-9412-4ef1-8820-64d09ec28f3b.png','logo-long-gris-1aea00c5-9412-4ef1-8820-64d09ec28f3b.webp',437,96,'LintellO - IA souveraine et 100% française'),
(3,'Logo carré principal','logo-carre-noir-fec865dd-2e33-4f95-b36f-086bd76b7fc2.png','logo-carre-noir-fec865dd-2e33-4f95-b36f-086bd76b7fc2.webp',451,451,'LintellO - IA souveraine et 100% française'),
(4,'Logo carré - gris','logo-carre-gris-43726ca4-6711-4faa-8613-317cd36255cd.png','logo-carre-gris-43726ca4-6711-4faa-8613-317cd36255cd.webp',451,451,'LintellO - IA souveraine et 100% française'),
(5,'Profil Laignelet David','dl-3-carre-1d44b975-02d3-4fd1-90e9-c82e1a08907b.jpg','dl-3-carre-1d44b975-02d3-4fd1-90e9-c82e1a08907b.webp',1920,1920,'LintellO - David Laignelet Fondateur');
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
(2,'Apprendre',30,1,'route','header',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,'Services',20,0,'route','header',1,'services','app_service_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'Catalogue',30,0,'route','header',1,'catalogue','app_product_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,'Événements',40,0,'route','header',1,'events','app_event_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,'Annuaire',50,0,'route','header',1,'annuaire','app_directory',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,'Contact',60,0,'route','header',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,'Accueil',0,1,'route','footer_nav',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,'Blog',10,1,'route','footer_nav',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,'Contact',20,1,'route','footer_nav',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(11,'Mentions légales',0,1,'route','footer_legal',1,'mentions-legales','app_legal_page','{\"type\":\"mentions-legales\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(12,'Politique de confidentialité',10,1,'route','footer_legal',1,'politique-confidentialite','app_legal_page','{\"type\":\"politique-de-confidentialite\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(13,'CGV',20,0,'route','footer_legal',1,'cgv','app_legal_page','{\"type\":\"conditions-generales-de-vente\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(14,'CGU',30,0,'route','footer_legal',1,'cgu','app_legal_page','{\"type\":\"conditions-generales-utilisation\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(15,'Fonctionnalités',10,1,'url','header',0,NULL,NULL,NULL,NULL,NULL,NULL,11,NULL,NULL),
(16,'Pour qui',20,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,5,NULL,NULL),
(17,'Confiance',0,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL,NULL),
(18,'Tarifs',40,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,3,NULL,NULL),
(19,'Études',10,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,5,16,NULL),
(20,'À la maison',20,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,6,16,NULL),
(21,'Pros',0,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,7,16,NULL);
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
(1,'public','Mentions légales','<p><em>Dernière mise à jour : 20 octobre 2026</em></p>\n\n<h2>1. Éditeur du site</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>David Laignelet (LintellO)</td></tr>\n<tr><td><strong>Forme juridique</strong></td><td>Entrepreneur individuel (micro-entreprise)</td></tr>\n<tr><td><strong>Siège social</strong></td><td>3 place des Templiers, 31260 Montsaunes, France</td></tr>\n<tr><td><strong>SIRET</strong></td><td>498 614 825 00046</td></tr>\n<tr><td><strong>N° TVA</strong></td><td>FR 18 498 614 825</td></tr>\n<tr><td><strong>Capital social</strong></td><td>Non applicable</td></tr>\n<tr><td><strong>Directeur de publication</strong></td><td>David Laignelet</td></tr>\n<tr><td><strong>Contact</strong></td><td>david@lintello.ai</td></tr>\n\n</tbody>\n</table>\n\n<h2>2. Hébergement</h2>\n<table>\n<tbody>\n<tr><td><strong>Hébergeur</strong></td><td>OVH SAS</td></tr>\n<tr><td><strong>Adresse</strong></td><td>2 rue Kellermann, 59100 Roubaix, France</td></tr>\n<tr><td><strong>Site web</strong></td><td>https://www.ovhcloud.com/fr/</td></tr>\n</tbody>\n</table>\n<p>L&#039;ensemble des données sont hébergées en France, conformément au RGPD.</p>\n\n<h2>3. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p>\n<p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p>\n\n<h2>4. Protection des données</h2>\n<ul>\n<li>Hébergement 100 % France</li>\n<li>Aucune donnée de LintellO transférée hors de l’Union européenne (seules les données de paiement, traitées par notre prestataire de paiement, peuvent l’être)</li>\n<li>Données personnelles jamais revendues</li>\n</ul>\n<p><strong>Contact DPO :</strong> david@lintello.ai</p>\n<p>Voir la <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a> pour les détails complets.</p>\n\n<h2>5. Cookies</h2>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Type</th><th>Finalité</th><th>Consentement</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP</td><td>Essentiel</td><td>Authentification</td><td>Non requis</td></tr>\n<tr><td>CSRF</td><td>Essentiel</td><td>Sécurité formulaires</td><td>Non requis</td></tr>\n<tr><td>_bw_sid</td><td>Mesure d&#039;audience</td><td>Session de visite anonyme (30 min)</td><td>Non requis (exempt CNIL)</td></tr>\n<tr><td>Google Analytics</td><td>Analytique tiers</td><td>Mesure d&#039;audience</td><td><strong>Requis</strong></td></tr>\n<tr><td>Préférences cookies</td><td>Fonctionnel</td><td>Mémoriser votre choix</td><td>Non requis</td></tr>\n</tbody>\n</table>\n<p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p>\n\n<h2>6. Limitation de responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p>\n<p>L&#039;éditeur décline toute responsabilité en cas d&#039;interruption du site, de survenance de bugs ou d&#039;incompatibilité du site avec certains matériels ou configurations.</p>\n\n<h2>7. Droit applicable et litiges</h2>\n<p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p>\n<p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : Non applicable.</p>\n\n<h2>8. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>david@lintello.ai</td></tr>\n<tr><td><strong>Courrier</strong></td><td>David Laignelet (LintellO) — 3 place des Templiers, 31260 Montsaunes, France</td></tr>\n\n</tbody>\n</table>','mentions-legales',1,'2026-10-20 08:32:11',NULL,NULL,'full-width',1,'mentions-legales',NULL,'Mentions légales du site. Éditeur, hébergeur, propriété intellectuelle et contact.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(2,'public','Politique de confidentialité','<p class=\"legal-updated\">Dernière mise à jour : 21 octobre 2026</p>\n<div class=\"privacy-highlights\">\n  <div class=\"privacy-highlight\">\n    <div>\n      <strong>Hébergé en France</strong>\n      <span>Serveurs OVH, modèles d\'IA de Mistral AI dans l\'UE</span>\n    </div>\n  </div>\n  <div class=\"privacy-highlight\">\n    <div>\n      <strong>Chiffrement AES-256-GCM</strong>\n      <span>Vos contenus, chiffrés avant d\'être enregistrés</span>\n    </div>\n  </div>\n  <div class=\"privacy-highlight\">\n    <div>\n      <strong>Ni revente, ni entraînement</strong>\n      <span>Vos contenus n\'entraînent aucun modèle</span>\n    </div>\n  </div>\n</div>\n<section class=\"legal-section\">\n  <h2>1. Qui est responsable</h2>\n  <p>Le responsable du traitement de vos données personnelles est :</p>\n  <ul>\n    <li><strong>Entité :</strong> David Laignelet, entrepreneur individuel (SIREN 498 614 825)</li>\n    <li><strong>Adresse :</strong> 3 place des Templiers, 31260 Montsaunes, France</li>\n    <li><strong>E-mail :</strong> david@lintello.ai</li>\n  </ul>\n  <p>\n    Cette politique décrit ce que LintellO fait de vos données lorsqu\'il en décide seul : votre\n    compte, la facturation, la sécurité, la mesure de l\'usage. Lorsque vous utilisez LintellO\n    dans un cadre professionnel, les données personnelles contenues dans ce que vous nous\n    soumettez (messages, fichiers, documents) sont traitées pour votre compte : LintellO est\n    alors votre sous-traitant, dans les conditions de l\'article 6 des conditions générales\n    d\'utilisation et de leur annexe « Sous-traitance ».\n  </p>\n  <p>LintellO est ouvert à partir de 15 ans.</p>\n</section>\n<section class=\"legal-section\">\n  <h2>2. Ce que nous collectons, pourquoi, et combien de temps</h2>\n  <h3>2.1 Ce que vous nous confiez</h3>\n  <table class=\"legal-table\">\n    <thead>\n      <tr>\n        <th>Données</th>\n        <th>Pour quoi faire</th>\n        <th>Base légale</th>\n        <th>Conservation</th>\n      </tr>\n    </thead>\n    <tbody>\n      <tr>\n        <td>Adresse e-mail, mot de passe</td>\n        <td>Vous connecter, vous écrire au sujet du service</td>\n        <td>Contrat</td>\n        <td>Jusqu\'à la fermeture du compte</td>\n      </tr>\n      <tr>\n        <td>Profil : prénom, activité, objectifs, contexte, préférences de travail, études, contexte professionnel, aliments à éviter</td>\n        <td>Adapter les réponses à votre situation</td>\n        <td>Contrat</td>\n        <td>Jusqu\'à ce que vous les modifiiez, ou la fermeture du compte</td>\n      </tr>\n      <tr>\n        <td>Coordonnées de courrier : nom, adresse, téléphone, e-mail professionnel, signature, SIRET</td>\n        <td>Composer vos lettres et documents</td>\n        <td>Contrat</td>\n        <td>Idem</td>\n      </tr>\n      <tr>\n        <td>Données de santé (voir § 3)</td>\n        <td>Adapter les conseils sport et alimentation</td>\n        <td>Votre consentement explicite</td>\n        <td>Jusqu\'au retrait de votre accord, ou la fermeture du compte</td>\n      </tr>\n      <tr>\n        <td>Conversations, projets et leurs instructions, documents, résumés</td>\n        <td>Le service lui-même</td>\n        <td>Contrat</td>\n        <td>Jusqu\'à ce que vous les supprimiez, ou la fermeture du compte</td>\n      </tr>\n      <tr>\n        <td>Documents mis à la corbeille</td>\n        <td>Vous permettre de revenir sur une suppression</td>\n        <td>Contrat</td>\n        <td>Rien n\'expire tout seul : la corbeille se vide quand vous le décidez, ou avec votre compte</td>\n      </tr>\n      <tr>\n        <td>Fichiers déposés : texte extrait, résumé ; images (dans le chat et dans vos documents)</td>\n        <td>Lire vos fichiers, les réafficher, les incorporer à vos exports</td>\n        <td>Contrat</td>\n        <td>Idem. Le fichier d\'origine d\'un document texte n\'est pas gardé ; une image l\'est, chiffrée</td>\n      </tr>\n      <tr>\n        <td>Recherches enregistrées, images que vous avez aimées et la question qui les accompagnait</td>\n        <td>Les retrouver</td>\n        <td>Contrat</td>\n        <td>Jusqu\'à ce que vous les supprimiez, ou la fermeture du compte</td>\n      </tr>\n      <tr>\n        <td>Facturation : raison sociale, SIRET, TVA, nom, adresse</td>\n        <td>Établir vos factures</td>\n        <td>Obligation légale</td>\n        <td>Dans LintellO, jusqu\'à la fermeture du compte. Les factures émises sont conservées 10 ans dans notre logiciel de facturation (Qonto), comme la loi l\'impose</td>\n      </tr>\n      <tr>\n        <td>Signalements de bug ou d\'idée : message, capture d\'écran si vous la joignez, contexte technique (page, navigateur, appareil, écran), et la conversation si vous cochez la case qui le propose</td>\n        <td>Comprendre et corriger le problème</td>\n        <td>Intérêt légitime ; consentement pour la conversation jointe</td>\n        <td>Jusqu\'à la fermeture du compte</td>\n      </tr>\n      <tr>\n        <td>Votre avis sur une réponse (pouce, commentaire)</td>\n        <td>Améliorer les réponses</td>\n        <td>Intérêt légitime</td>\n        <td>Jusqu\'à la fermeture du compte</td>\n      </tr>\n    </tbody>\n  </table>\n  <h3>2.2 Ce qui est enregistré quand vous utilisez le service</h3>\n  <table class=\"legal-table\">\n    <thead>\n      <tr>\n        <th>Données</th>\n        <th>Pour quoi faire</th>\n        <th>Base légale</th>\n        <th>Conservation</th>\n      </tr>\n    </thead>\n    <tbody>\n      <tr>\n        <td>Usage : date, modèle utilisé, volume consommé, coût — sans le contenu</td>\n        <td>Quotas, facturation, coût de revient</td>\n        <td>Contrat</td>\n        <td>Anonymisé à la fermeture du compte</td>\n      </tr>\n      <tr>\n        <td>Usage des outils : quel outil vous utilisez et quand (un export, l\'ouverture de l\'éditeur…) — jamais le contenu</td>\n        <td>Savoir quels outils servent, pour améliorer le service ; uniquement en statistiques d\'ensemble, jamais par personne</td>\n        <td>Intérêt légitime</td>\n        <td>12 mois, puis seulement des compteurs anonymes par mois</td>\n      </tr>\n      <tr>\n        <td>Astuces : celles que vous avez vues, fermées ou essayées, et si vous les avez coupées</td>\n        <td>Vous proposer, au plus une fois par jour, un outil que vous n\'avez pas encore utilisé — choisi d\'après les outils dont vous vous êtes déjà servi</td>\n        <td>Intérêt légitime</td>\n        <td>Jusqu\'à la fermeture du compte ; « Ne plus afficher d\'astuces » les arrête</td>\n      </tr>\n      <tr>\n        <td>Traces de modération : catégorie, scores, date — jamais le contenu du message</td>\n        <td>Sécurité du service (voir § 4)</td>\n        <td>Intérêt légitime</td>\n        <td>6 mois</td>\n      </tr>\n      <tr>\n        <td>Erreurs techniques : message d\'erreur, page, navigateur, empreinte de l\'adresse IP</td>\n        <td>Sécurité, correction des pannes</td>\n        <td>Intérêt légitime</td>\n        <td>6 mois</td>\n      </tr>\n      <tr>\n        <td>Journaux d\'accès du serveur : adresse IP, page demandée, navigateur</td>\n        <td>Sécurité</td>\n        <td>Intérêt légitime</td>\n        <td>6 mois</td>\n      </tr>\n      <tr>\n        <td>Limitation de fréquence : adresse IP</td>\n        <td>Empêcher les abus</td>\n        <td>Intérêt légitime</td>\n        <td>De 5 minutes à 24 heures</td>\n      </tr>\n      <tr>\n        <td>Preuve de votre acceptation des conditions et de votre consentement santé : version du texte, date, empreinte de l\'adresse IP</td>\n        <td>Prouver ce que vous avez accepté</td>\n        <td>Obligation légale, intérêt légitime</td>\n        <td>La durée du compte, puis 5 ans (le délai pendant lequel un litige reste possible)</td>\n      </tr>\n      <tr>\n        <td>Signalement « image non pertinente » : la question, l\'image, sans lien avec votre compte</td>\n        <td>Régler le choix des images</td>\n        <td>Intérêt légitime</td>\n        <td>12 mois</td>\n      </tr>\n    </tbody>\n  </table>\n  <p>\n    Une <strong>empreinte</strong> d\'adresse IP est le résultat d\'un calcul irréversible, salé\n    par un secret de LintellO : elle permet de reconnaître deux fois la même adresse, pas de la\n    retrouver.\n  </p>\n  <h3>2.3 Combien de temps nous gardons quoi, en résumé</h3>\n  <table class=\"legal-table\">\n    <thead>\n      <tr>\n        <th>Donnée</th>\n        <th>Durée</th>\n      </tr>\n    </thead>\n    <tbody>\n      <tr><td>Compte utilisateur</td><td>Jusqu\'à la suppression du compte</td></tr>\n      <tr><td>Conversations</td><td>Jusqu\'à leur suppression par vous, ou celle du compte</td></tr>\n      <tr><td>Documents</td><td>Jusqu\'à leur suppression par vous, ou celle du compte</td></tr>\n      <tr><td>Fichiers déposés</td><td>Supprimés immédiatement après extraction du texte (le texte extrait, chiffré, suit la durée du document ou de la conversation)</td></tr>\n      <tr><td>Recherches</td><td>12 mois, puis seulement des volumes anonymes</td></tr>\n      <tr><td>Journaux d\'erreurs</td><td>6 mois, adresse IP hachée</td></tr>\n      <tr><td>Journaux du serveur</td><td>6 mois</td></tr>\n      <tr><td>Logs d\'utilisation</td><td>Anonymisés après la suppression du compte</td></tr>\n      <tr><td>Traces de modération (sans le contenu des messages)</td><td>6 mois</td></tr>\n      <tr><td>Preuve d\'acceptation des conditions</td><td>Durée du compte + 5 ans</td></tr>\n      <tr><td>Données de facturation</td><td>10 ans (obligation légale comptable)</td></tr>\n    </tbody>\n  </table>\n</section>\n<section class=\"legal-section\">\n  <h2>3. Vos données de santé</h2>\n  <p>\n    L\'onglet Santé de vos paramètres permet d\'indiquer votre taille, votre poids, votre sexe,\n    votre niveau d\'activité, les sports que vous pratiquez, vos objectifs et les mouvements\n    ou efforts à éviter. Ce sont des données de santé au sens de l\'article 9 du RGPD.\n  </p>\n  <ul>\n    <li>\n      <strong>Rien n\'est collecté sans votre accord.</strong> Une case, en tête de l\'onglet, le\n      recueille ; tant qu\'elle n\'est pas cochée, le formulaire ne s\'ouvre pas et notre serveur\n      refuse ces informations.\n    </li>\n    <li>\n      <strong>Elles ne servent qu\'à une chose</strong> : adapter les conseils sport et\n      alimentation que LintellO vous donne.\n    </li>\n    <li>\n      <strong>Elles ne sont transmises au modèle d\'IA (Mistral AI) que lorsque vous posez une\n      question de sport, d\'alimentation ou de santé</strong>, ou lorsque vous avez choisi\n      vous-même le mode Santé &amp; Sport. Jamais pour une autre question.\n    </li>\n    <li><strong>Elles sont chiffrées</strong> (AES-256-GCM).</li>\n    <li>\n      <strong>Retirer votre accord les efface</strong> : il suffit de décocher la case. Votre\n      accord, puis son retrait, sont datés pour en garder la preuve.\n    </li>\n    <li>\n      Nous ne vous demandons jamais de diagnostic : « sauts, charges lourdes » plutôt qu\'une\n      maladie. Les aliments à éviter ne sont pas une donnée de santé — on peut éviter le\n      lactose par goût — et sont utilisés sans cette case, y compris pour une recette.\n    </li>\n  </ul>\n  <p>\n    Ce que vous écrivez de vous-même dans une conversation, sur votre santé ou sur tout autre\n    sujet, est traité comme le reste de la conversation (§ 2.1 et § 4).\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>4. Ce que reçoit le modèle d\'IA</h2>\n  <p>\n    Pour vous répondre, LintellO déchiffre ce qui est nécessaire et le transmet à\n    <strong> Mistral AI</strong>, dont les modèles sont exécutés dans l\'Union européenne :\n  </p>\n  <ul>\n    <li>votre message et l\'historique utile de la conversation ;</li>\n    <li>le texte de vos fichiers et vos images, quand vous les joignez ou qu\'ils sont dans le projet ;</li>\n    <li>votre profil, <strong>sans vos données de santé</strong> sauf dans le cas décrit au § 3 ;</li>\n    <li>\n      chaque message, recherche et appel d\'API, pour une <strong>modération automatique</strong>\n      avant toute réponse ; lorsqu\'un message est refusé, ou laisse penser à une détresse, une\n      trace de l\'événement est conservée, jamais le message ;\n    </li>\n    <li>votre message encore, pour en comprendre la nature (question, rédaction, recherche…) ;</li>\n    <li>les questions des images aimées, réduites en une représentation numérique qui sert à retrouver une image par le sens ;</li>\n    <li>vos signalements (message, capture, conversation si vous l\'avez jointe), pour en préparer l\'analyse.</li>\n  </ul>\n  <p>\n    <strong>Vos contenus ne servent à entraîner aucun modèle</strong>, ni chez LintellO ni chez\n    Mistral AI. <strong>Nous ne vendons jamais vos données</strong> et ne les utilisons à\n    aucune fin publicitaire.\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>5. La recherche web et L\'dicO</h2>\n  <p>\n    Quand LintellO cherche sur le web, <strong>la requête part au nom de LintellO</strong> :\n    ce qui est cherché sort, jamais qui cherche. Cette requête n\'est pas votre message : elle\n    est reformulée à partir de lui, et peut donc en reprendre des éléments.\n  </p>\n  <p>Ce que nous gardons des recherches, sans jamais les relier à votre compte :</p>\n  <ul>\n    <li>\n      <strong>Les mots-clés, le thème et le lieu</strong> d\'une recherche, avec sa date, le mode\n      et la formule d\'abonnement, pendant <strong>12 mois</strong>. Ensuite, ils ne survivent\n      qu\'en <strong>volumes anonymes</strong> — combien de recherches par mot-clé, par mois, par\n      thème et par lieu — et aucun volume ne porte sur moins de 5 recherches : un mot rare, un\n      nom, une adresse disparaissent d\'eux-mêmes.\n    </li>\n    <li>\n      <strong>La question qui a fait aimer une image</strong> : les 20 plus récentes par image,\n      pour que la banque d\'images retrouve une image par le sens.\n    </li>\n    <li>\n      <strong>La question d\'une image qui n\'a pas pu être gardée</strong> : 12 mois, pour savoir\n      ce qui manque à la banque.\n    </li>\n  </ul>\n  <p>\n    Votre historique de recherches personnel, lui, est chiffré, visible de vous seul et\n    supprimable à tout moment. Les images trouvées sur le web vous sont transmises par nos\n    serveurs : le site d\'origine voit l\'adresse de LintellO, pas la vôtre.\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>6. Nos sous-traitants</h2>\n  <p>\n    Toutes les données de LintellO (votre compte, vos conversations, vos documents, vos\n    fichiers et vos recherches enregistrées) sont hébergées sur des serveurs OVH en France,\n    conformément au RGPD. Elles ne sont jamais transférées hors de l\'Union européenne.\n  </p>\n  <p>\n    Seul notre prestataire de paiement, Stripe, peut transférer des données de paiement vers\n    les États-Unis (voir § 7). Il ne reçoit aucune donnée de LintellO : ni vos conversations,\n    ni vos documents, ni vos fichiers.\n  </p>\n  <table class=\"legal-table\">\n    <thead>\n      <tr>\n        <th>Sous-traitant</th>\n        <th>Service</th>\n        <th>Localisation</th>\n        <th>Données concernées</th>\n      </tr>\n    </thead>\n    <tbody>\n      <tr>\n        <td>Mistral AI</td>\n        <td>Modèles d\'IA, modération</td>\n        <td>France / UE</td>\n        <td>Ce qui est décrit au § 4</td>\n      </tr>\n      <tr>\n        <td>OVH</td>\n        <td>Hébergement (Strasbourg), sauvegardes (Gravelines)</td>\n        <td>France</td>\n        <td>Toutes les données hébergées, sauvegardes chiffrées</td>\n      </tr>\n      <tr>\n        <td>Stripe (Stripe Payments Europe)</td>\n        <td>Paiement</td>\n        <td>Irlande (UE) — transferts possibles vers les États-Unis (§ 7)</td>\n        <td>E-mail, identifiant client, nom, adresse, SIRET, TVA ; vos données de carte ne passent jamais par nous</td>\n      </tr>\n      <tr>\n        <td>Qonto</td>\n        <td>Facturation</td>\n        <td>France</td>\n        <td>Les données figurant sur vos factures</td>\n      </tr>\n      <tr>\n        <td>Brevo</td>\n        <td>Envoi des e-mails</td>\n        <td>France</td>\n        <td>Votre adresse e-mail et le contenu des e-mails du service (bienvenue, vérification de l\'adresse, mot de passe, factures) ; les alertes d\'erreur envoyées à l\'administrateur, qui peuvent citer l\'adresse e-mail du compte concerné</td>\n      </tr>\n      <tr>\n        <td>Staan</td>\n        <td>Recherche web (moteur principal)</td>\n        <td>UE</td>\n        <td>Le texte de la requête, envoyé au nom de LintellO</td>\n      </tr>\n      <tr>\n        <td>Mojeek</td>\n        <td>Recherche web (recours)</td>\n        <td>Royaume-Uni</td>\n        <td>Idem</td>\n      </tr>\n      <tr>\n        <td>SearXNG (hébergé par LintellO) et les moteurs qu\'il interroge</td>\n        <td>Recherche web (dernier recours)</td>\n        <td>Serveur en France ; moteurs hors UE, notamment aux États-Unis</td>\n        <td>Idem</td>\n      </tr>\n      <tr>\n        <td>Dropcontact</td>\n        <td>Adresses professionnelles (LintellO Prospect)</td>\n        <td>France</td>\n        <td>Nom et entreprise du contact recherché, sur commande du client</td>\n      </tr>\n      <tr>\n        <td>API Recherche d\'entreprises (service public de l\'État)</td>\n        <td>Données d\'entreprise (API, Prospect)</td>\n        <td>France</td>\n        <td>Numéro SIREN ou nom de l\'entreprise recherchée</td>\n      </tr>\n    </tbody>\n  </table>\n  <p>\n    Les polices de caractères sont servies par nos propres serveurs : votre navigateur ne\n    contacte ni Google Fonts ni aucun autre service tiers pour afficher LintellO.\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>7. Transferts hors de l\'Union européenne</h2>\n  <p><strong>Les données de LintellO ne quittent jamais l\'Union européenne.</strong></p>\n  <p>\n    <strong>Paiement.</strong> Stripe traite les paiements depuis l\'Irlande. Certaines données\n    de paiement peuvent être transférées vers les États-Unis, dans le cadre des garanties\n    prévues par le RGPD. Stripe ne reçoit aucune donnée de LintellO.\n  </p>\n  <p>\n    <strong>Recherche web.</strong> C\'est notre serveur qui interroge les moteurs de recherche,\n    au nom de LintellO. Seul le texte de la requête est envoyé, sans votre identité, votre\n    compte ni votre adresse IP. Si le moteur principal ne répond pas, des moteurs de recours,\n    dont certains situés hors de l\'Union européenne, peuvent recevoir ce texte (voir § 6).\n  </p>\n  <p>\n    Nous pouvons être tenus de communiquer des données si la loi l\'exige (réquisition\n    judiciaire, enquête pénale).\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>8. Sécurité</h2>\n  <h3>8.1 Ce qui est chiffré</h3>\n  <p>\n    LintellO chiffre lui-même, avec l\'algorithme <strong>AES-256-GCM</strong>, avant de les\n    enregistrer : vos messages, vos documents, le texte extrait de vos fichiers et vos images,\n    les instructions de vos projets, les résumés de vos conversations, vos recherches\n    enregistrées, votre adresse e-mail, vos données de santé, les champs libres et les\n    coordonnées de votre profil, votre identité de facturation (raison sociale, SIRET, TVA,\n    nom, adresse) et la conversation jointe à un signalement. La clé est\n    conservée hors de la base : une copie de la base, seule, ne permet pas de les lire.\n  </p>\n  <p>\n    Votre mot de passe n\'est jamais conservé, seule une empreinte irréversible l\'est. Les\n    échanges avec LintellO sont chiffrés (HTTPS). Les sauvegardes sont chiffrées avant de\n    quitter le serveur, et la clé qui permet de les relire n\'est pas sur le serveur.\n  </p>\n  <h3>8.2 Ce qui ne l\'est pas encore</h3>\n  <p>\n    Nous préférons le dire : sont aujourd\'hui enregistrés <strong>sans chiffrement</strong>\n    les titres de conversation ; les noms de projets, d\'étiquettes et de fichiers ; les\n    messages et captures d\'écran des signalements, et leur analyse ; les commentaires laissés\n    sur une réponse ; la question liée à une image aimée ; les champs à choix de votre profil\n    (style et langue de réponse, aisance avec l\'IA, préférences de travail, niveau et année\n    d\'études, type d\'établissement, matières, examens préparés et leur date, style\n    d\'apprentissage, taille d\'entreprise, ancienneté, niveau de responsabilité, taille\n    d\'équipe) ; le code postal, la ville et le pays de facturation ; l\'adresse e-mail d\'un\n    compte dans le journal des actions de l\'administrateur. Ils restent sur nos serveurs en\n    France, et leur chiffrement est prévu.\n  </p>\n  <h3>8.3 Ce que le chiffrement ne fait pas</h3>\n  <p>\n    Pour vous répondre, LintellO déchiffre votre message et le transmet au modèle d\'IA :\n    c\'est un chiffrement de vos données stockées, pas un chiffrement de bout en bout.\n  </p>\n  <h3>8.4 Qui y accède</h3>\n  <p>\n    L\'accès aux données est réservé à l\'administrateur de LintellO, pour la maintenance, la\n    sécurité et le support. Il lit les signalements que vous envoyez, et, lorsque vous\n    commentez une réponse, la question et la réponse concernées.\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>9. Les sauvegardes</h2>\n  <p>\n    Nos bases sont sauvegardées chaque nuit, chiffrées : 14 jours sur le serveur, 90 jours\n    sur un second hébergement OVH. <strong>Une donnée que vous supprimez peut donc survivre\n    jusqu\'à 90 jours dans une sauvegarde chiffrée</strong>, avant de disparaître avec elle.\n    Une sauvegarde ne sert qu\'à reconstruire le service après un incident.\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>10. Vos droits</h2>\n  <p>Conformément au RGPD, vous disposez des droits suivants :</p>\n  <div class=\"rights-grid\">\n    <div class=\"right-card\">\n      <h4>Accès et portabilité</h4>\n      <p>Obtenez une copie de vos données, en JSON ou en PDF.</p>\n      <span>Paramètres &gt; Compte &gt; Exporter mes données</span>\n    </div>\n    <div class=\"right-card\">\n      <h4>Effacement</h4>\n      <p>Fermez votre compte : vos données sont supprimées, et votre abonnement résilié immédiatement.</p>\n      <span>Paramètres &gt; Compte &gt; Supprimer mon compte</span>\n    </div>\n    <div class=\"right-card\">\n      <h4>Rectification</h4>\n      <p>Modifiez vos informations à tout moment.</p>\n      <span>Paramètres &gt; Mon profil</span>\n    </div>\n    <div class=\"right-card\">\n      <h4>Retrait du consentement</h4>\n      <p>Décochez la case de l\'onglet Santé : vos données de santé sont effacées.</p>\n      <span>Paramètres &gt; Mon profil &gt; Santé</span>\n    </div>\n    <div class=\"right-card\">\n      <h4>Opposition et limitation</h4>\n      <p>Vous pouvez vous opposer à un traitement fondé sur notre intérêt légitime, ou en demander la limitation.</p>\n      <span>david@lintello.ai</span>\n    </div>\n  </div>\n  <p>\n    Pour exercer ces droits ou pour toute question, écrivez à <strong>david@lintello.ai</strong>.\n    Nous répondons dans un délai d\'un mois. Vous pouvez aussi introduire une réclamation\n    auprès de la CNIL :\n    <a href=\"https://www.cnil.fr\" target=\"_blank\" rel=\"noopener noreferrer\"> www.cnil.fr</a>.\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>11. Ce que LintellO garde dans votre navigateur</h2>\n  <p>\n    LintellO n\'utilise <strong>aucun cookie</strong>, ni publicitaire ni de mesure d\'audience.\n    Il garde dans le stockage local de votre navigateur :\n  </p>\n  <ul>\n    <li><strong>token</strong> : votre jeton de connexion, valable 5 heures ;</li>\n    <li><strong>auth-storage</strong> : vos préférences d\'affichage et les informations de votre compte — plus votre profil, qui est rechargé depuis nos serveurs ;</li>\n    <li>quelques préférences d\'interface (largeur des colonnes, onglet ouvert).</li>\n  </ul>\n  <p>Les effacer depuis votre navigateur vous déconnecte, sans autre conséquence.</p>\n</section>\n<section class=\"legal-section\">\n  <h2>12. Modifications</h2>\n  <p>\n    Nous pouvons mettre à jour cette politique. En cas de modification importante, nous vous en\n    informerons dans l\'application ou par e-mail. La date de la dernière mise à jour figure en\n    haut de cette page.\n  </p>\n</section>\n<section class=\"legal-section\">\n  <h2>13. Contact</h2>\n  <ul>\n    <li><strong>E-mail :</strong> david@lintello.ai</li>\n    <li><strong>Adresse :</strong> David Laignelet, 3 place des Templiers, 31260 Montsaunes, France</li>\n  </ul>\n</section>','politique-confidentialite',1,'2026-10-20 08:32:11','2026-10-21 18:07:53',NULL,'full-width',1,'politique-confidentialite','Politique de confidentialité - LintellO L\'IA à la française','Politique de confidentialité. Données collectées, cookies, droits RGPD et contact DPO.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(3,'public','Tarifs','','tarifs',1,'2026-10-20 07:05:33',NULL,NULL,'full-width',0,NULL,'Tarifs LintellO : offres Gratuit, Étudiant, Perso, Pro et LintellO','Comparez les offres LintellO : Gratuit, Étudiant dès 4,99 € TTC, Perso, Pro et LintellO. IA avancée, crédits de recherche et modes, ligne par ligne.',NULL,0,NULL,NULL,NULL,NULL,1,NULL),
(4,'public','Confiance','','confiance',1,'2026-10-20 07:14:04',NULL,NULL,'full-width',0,NULL,'Vos données avec LintellO : hébergement, chiffrement, RGPD','Où sont stockées vos données avec LintellO ? Serveur dédié à Strasbourg, moteur IA français, chiffrement et durées de conservation, sans détour.',NULL,0,NULL,NULL,NULL,NULL,1,NULL),
(5,'public','Étudiants','','etudiants',1,'2026-10-20 07:20:10',NULL,NULL,'full-width',0,NULL,'LintellO pour les études : une IA pour comprendre ses cours','Une IA française pour réviser et comprendre ses cours sans recopier : cinq modes Éducation, offre Étudiant à 4,99 € TTC par mois, sans justificatif.',NULL,0,NULL,NULL,NULL,NULL,1,NULL),
(6,'public','À la maison','','particuliers',1,'2026-10-20 07:24:16',NULL,NULL,'full-width',0,NULL,'LintellO à la maison : une IA française pour le quotidien','Lettres, démarches, idées, recherches : une IA française qui respecte vos données, hébergée à Strasbourg. Offre Gratuite, puis Perso à 9,90 € TTC par mois.',NULL,0,NULL,NULL,NULL,NULL,1,NULL),
(7,'public','Pros','','professionnels',1,'2026-10-20 07:24:16','2026-10-20 21:11:53',NULL,'full-width',0,NULL,'LintellO pour les pros : une IA souveraine, 100 % française','Une IA française pour travailler sans exposer vos documents : 18 modes, gabarits pros, export Word et PDF, chiffrement en base. Offre Pro à 19,90 € HT.',NULL,0,NULL,NULL,NULL,NULL,1,NULL),
(10,'public','CGU et CGV de l’application','<p><em>Ces conditions sont celles de l’application LintellO : CGU dans leur version du 9 octobre 2026, CGV dans leur version du 28 septembre 2026. Le texte qui fait foi est publié sur <a href=\"https://www.lintello.ai/conditions\">lintello.ai/conditions</a>.</em></p>\n<ul>\n<li><a href=\"#cgu\">Conditions générales d’utilisation</a></li>\n<li><a href=\"#cgv\">Conditions générales de vente</a></li>\n</ul>\n<h2 id=\"cgu\">Conditions générales d’utilisation</h2>\n<blockquote>\n<p><strong>PROJET — version de travail du 9 octobre 2026, à faire valider par l&#039;avocat.</strong>\nRédigé depuis la spec <code>docs/specs/auth/cgu.md</code> et ce que le code fait réellement.\n<strong>[À COMPLÉTER]</strong> &#61; une information que seul l&#039;éditeur connaît. <strong>⚖️</strong> &#61; un point à trancher par\nl&#039;avocat. Ces deux marques disparaissent de la version publiée.</p>\n</blockquote>\n<p><strong>Version :</strong> [À COMPLÉTER : date d&#039;entrée en vigueur, ex. 2026-10-01]</p>\n<hr />\n<h3>Article 1 — Qui édite LintellO</h3>\n<p>LintellO est édité par <strong>Laignelet David</strong>, Auto entrepreneur, immatriculée au RCS de Toulouse sous le numéro 498614825, dont le siège est situé\n3 place des Templiers 31260 Montsaunes (ci-après « <strong>LintellO</strong> » ou « <strong>nous</strong> »).</p>\n<p>Contact : <a href=\"mailto:david&#64;lintello.ai\">david&#64;lintello.ai</a>. Les mentions légales complètes sont\naccessibles depuis le pied de chaque page.</p>\n<h3>Article 2 — Objet</h3>\n<p>Les présentes conditions générales d&#039;utilisation (« <strong>CGU</strong> ») fixent les règles d&#039;utilisation\ndes services LintellO par toute personne qui crée un compte (« <strong>l&#039;Utilisateur</strong> » ou « <strong>vous</strong> »),\net, pour les services qui les concernent, par les clients de l&#039;API.</p>\n<p>L&#039;achat d&#039;un abonnement payant est régi en outre par les <strong>conditions générales de vente</strong>\n(« CGV »). En cas de contradiction sur une question de vente, les CGV prévalent.</p>\n<h3>Article 3 — Les services</h3>\n<p>LintellO est un assistant d&#039;intelligence artificielle. Selon votre offre, il comprend :</p>\n<ul>\n<li><strong>le chat</strong> : des conversations avec l&#039;IA, organisées en projets, avec des fichiers joints, des\ndocuments produits et modifiables, des schémas et des illustrations ;</li>\n<li><strong>Flow</strong> : une réflexion approfondie en plusieurs étapes ;</li>\n<li><strong>L&#039;dicO</strong> : un moteur de recherche web dont l&#039;IA résume les résultats en citant ses sources ;</li>\n<li><strong>l&#039;API</strong> : un accès programmatique à certaines fonctions, réservé aux clients professionnels\nqui l&#039;ont souscrit (article 12) ;</li>\n<li><strong>LintellO Farming</strong> : un sytsème de travail et réflexion autonome dont un service de recherche d&#039;entreprises et de contacts professionnels,\nréservé aux clients professionnels (article 13).</li>\n</ul>\n<p>Le contenu de chaque offre (fonctions, quotas, modes) est décrit sur la page Tarifs, qui fait foi\nà la date de votre souscription.</p>\n<h3>Article 4 — Votre compte</h3>\n<p>4.1. <strong>Création.</strong> Le compte se crée avec une adresse e-mail que vous confirmez par un lien.\n<strong>Vous devez accepter les présentes CGU pour créer un compte</strong> ; la case correspondante n&#039;est\njamais pré-cochée.</p>\n<p>4.2. <strong>Âge.</strong> LintellO est ouvert à partir de <strong>15 ans</strong>, sur déclaration lors de l&#039;inscription.\nUn utilisateur mineur ne peut souscrire une offre payante qu&#039;avec l&#039;accord de son représentant\nlégal.</p>\n<p>4.3. <strong>Exactitude et sécurité.</strong> Vous fournissez des informations exactes et gardez vos\nidentifiants confidentiels. Toute action faite depuis votre compte est réputée faite par vous.\nSignalez-nous sans délai toute utilisation que vous n&#039;avez pas autorisée.</p>\n<p>4.4. <strong>Un compte par personne.</strong> Un compte est personnel. Le nombre de comptes créés depuis une\nmême adresse est limité, et les adresses e-mail jetables sont refusées.</p>\n<h3>Article 5 — Ce que LintellO est, et ce qu&#039;il n&#039;est pas</h3>\n<p>5.1. <strong>Un prestataire.</strong> Pour tout ce que vous lui confiez — ce que vous déposez, ce que vous\ndemandez de chercher ou de produire, les contacts que vous commandez, vos appels d&#039;API —\nLintellO <strong>exécute vos instructions</strong>. C&#039;est vous qui décidez de l&#039;usage et qui en répondez.</p>\n<p>5.2. <strong>L&#039;IA se trompe.</strong> Les réponses sont produites par des modèles statistiques. Elles peuvent\nêtre inexactes, incomplètes, datées ou inventées, y compris quand elles citent une source.\n<strong>Vous vérifiez toute réponse avant de vous en servir</strong>, et plus encore avant une décision de\nsanté, juridique, financière ou qui touche une autre personne. LintellO ne remplace pas un\nmédecin, un avocat, un expert-comptable ni aucun professionnel.</p>\n<p>5.3. <strong>Aucune garantie de résultat.</strong> LintellO est tenu d&#039;une obligation de moyens. Le service\nest fourni sans garantie de disponibilité continue : des maintenances et des incidents peuvent\nl&#039;interrompre.</p>\n<h3>Article 6 — Vos données, et ce que nous en faisons</h3>\n<p>6.1. <strong>Deux rôles.</strong></p>\n<ul>\n<li><strong>LintellO responsable de traitement.</strong> LintellO détermine seul les finalités et\nles moyens des traitements suivants, décrits dans la politique de confidentialité :\ngestion de votre compte, facturation, sécurité et prévention des abus, mesure de\nl&#039;usage, statistiques agrégées, et constitution des bases de données propres à\nLintellO (notamment le module Prospect).</li>\n<li><strong>LintellO sous-traitant.</strong> Lorsque vous utilisez LintellO dans le cadre d&#039;une\nactivité professionnelle, les données personnelles figurant dans les contenus que\nvous nous soumettez (messages, fichiers, documents, requêtes) sont traitées par\nLintellO pour votre compte, uniquement pour vous fournir le Service. Vous êtes\nresponsable de traitement et LintellO est votre sous-traitant au sens de\nl&#039;article 28 du RGPD. L&#039;Annexe « Sous-traitance » fait partie intégrante des\nprésentes ; son acceptation électronique vaut contrat écrit (art. 28.9 RGPD).</li>\n<li><strong>Usage personnel.</strong> Lorsque vous utilisez LintellO à des fins strictement\npersonnelles ou domestiques, le RGPD ne vous est pas applicable (art. 2.2.c) ;\nLintellO traite alors ces contenus dans les conditions de la politique de\nconfidentialité.</li>\n<li><strong>Données exclues.</strong> Sauf offre dédiée le prévoyant expressément, vous vous\ninterdisez de soumettre des données de santé identifiantes relevant de\nl&#039;hébergement de données de santé (art. L.1111-8 CSP).</li>\n<li><strong>Votre profil santé.</strong> Les informations de santé que vous pouvez indiquer dans\nl&#039;onglet Santé de votre profil (mesures, activité, objectifs, mouvements à éviter)\nne sont enregistrées qu&#039;avec votre consentement explicite, donné en cochant la\ncase prévue à cet effet, et servent uniquement à adapter les conseils sport et\nalimentation. Décocher cette case retire votre consentement et efface ces\ninformations. Le détail figure dans la politique de confidentialité.</li>\n</ul>\n<p>6.2. <strong>Aucun entraînement.</strong> Vos contenus ne servent à entraîner aucun modèle d&#039;IA, ni chez\nLintellO ni chez nos prestataires.</p>\n<p>6.3. <strong>Ce qui est conservé, par service.</strong></p>\n<ul>\n<li><strong>Chat et projets</strong> : vos conversations, documents, le texte extrait de vos fichiers et vos\nimages sont conservés <strong>chiffrés</strong> jusqu&#039;à ce que vous les supprimiez ou que vous fermiez votre\ncompte. Le fichier d&#039;origine d&#039;un document texte n&#039;est pas conservé une fois son contenu\nextrait ; une image l&#039;est, chiffrée, pour pouvoir vous être réaffichée.</li>\n<li><strong>API</strong> : le contenu d&#039;un appel n&#039;est pas conservé ; seules sont gardées les données de\nfacturation de l&#039;appel (date, route, volume, coût).</li>\n<li><strong>Prospect</strong> : voir l&#039;article 13.</li>\n<li><strong>Modération</strong> : voir l&#039;article 8.</li>\n</ul>\n<p>6.4. <strong>Sécurité et chiffrement.</strong></p>\n<ul>\n<li><strong>Vos contenus sont chiffrés avant d&#039;être enregistrés</strong>, par LintellO lui-même, avec\nl&#039;algorithme <strong>AES-256-GCM</strong> : vos messages, vos documents, le texte extrait de vos fichiers\net vos images, les instructions de vos projets, vos recherches enregistrées, votre adresse\ne-mail, vos informations de santé, les champs libres et les coordonnées de votre profil, et\nvotre identité de facturation. La clé de chiffrement est conservée à part, hors de la base de\ndonnées : une copie de la base, seule, ne permet pas de les lire. Ce qui n&#039;est pas encore\nchiffré est indiqué dans la politique de confidentialité.</li>\n<li><strong>Votre mot de passe n&#039;est jamais conservé</strong> : seule une empreinte irréversible l&#039;est.</li>\n<li><strong>Les échanges</strong> entre votre navigateur et LintellO sont chiffrés (HTTPS).</li>\n<li><strong>Les sauvegardes</strong> sont chiffrées avant de quitter le serveur, et la clé qui permet de les\nrelire n&#039;est pas sur le serveur.</li>\n<li><strong>Ce que le chiffrement ne fait pas</strong> : pour vous répondre, LintellO déchiffre votre message et\nle transmet au modèle d&#039;IA (Mistral AI). Il s&#039;agit d&#039;un chiffrement de vos données stockées,\npas d&#039;un chiffrement de bout en bout.</li>\n</ul>\n<p>6.5. <strong>Où.</strong> Nos serveurs sont en France. Les modèles d&#039;IA (Mistral AI) sont exécutés dans\nl&#039;Union européenne. La liste de nos sous-traitants figure dans la politique de confidentialité. Notre système est conçu pour que vos données restent dans l&#039;Union européenne, avec les exceptions dites à l&#039;article 7 (recherche en recours) et dans la politique de confidentialité (paiement).</p>\n<p>6.6. <strong>Vos droits.</strong> Vous pouvez à tout moment exporter vos données depuis votre compte, supprimer\nune conversation, toutes vos conversations, ou fermer votre compte.</p>\n<h3>Article 7 — La recherche web</h3>\n<p>Quand LintellO cherche sur le web (L&#039;dicO ou le chat), <strong>la requête part au nom de LintellO</strong> :\nce qui est cherché sort, jamais qui cherche. La requête n&#039;est transmise aux moteurs qu&#039;avec ce qui\nest nécessaire à la recherche.</p>\n<p>Nous utilisons un moteur européen en priorité. Lorsqu&#039;il ne répond pas, la requête peut être\ntransmise, en recours, à des moteurs situés hors de l&#039;Union européenne, qui ne reçoivent que le\ntexte de la requête.</p>\n<p>Les pages publiques trouvées peuvent enrichir l&#039;index de LintellO. <strong>Votre requête n&#039;est jamais\nreliée à votre compte.</strong> Pour améliorer le moteur, LintellO en garde les mots-clés, le thème et\nle lieu pendant douze mois ; au-delà, il n&#039;en reste que des volumes anonymes (combien de\nrecherches par mot-clé), dont aucun ne porte sur moins de cinq recherches. Votre historique de\nrecherches L&#039;dicO, lui, la garde pour vous : chiffrée (article 6.4), visible de vous seul, et\nsupprimable à tout moment.</p>\n<h3>Article 8 — La modération</h3>\n<p>8.1. <strong>Pour la sécurité du service</strong>, chaque message du chat, chaque recherche L&#039;dicO et chaque\nappel d&#039;API est analysé automatiquement (Mistral AI) <strong>avant</strong> toute réponse.</p>\n<p>8.2. <strong>Ce qui est refusé</strong> : les demandes à caractère sexuel explicite, haineuses, violentes ou\nmenaçantes, dangereuses ou criminelles, et les tentatives de contourner les règles de l&#039;assistant.\n<strong>Les demandes de conseil médical, juridique ou financier et les données personnelles ne sont\njamais refusées pour ce seul motif</strong> : c&#039;est un usage normal de LintellO. Les seuils sont plus\nstricts sur l&#039;offre Étudiant.</p>\n<p>8.3. <strong>La détresse.</strong> Si un message laisse penser que vous traversez un moment très difficile,\nLintellO ne vous bloque pas : il vous répond, et vous indique le <strong>3114</strong>, numéro national de\nprévention du suicide, gratuit, 24 h/24 et 7 j/7.</p>\n<p>8.4. <strong>Un refus ne consomme rien</strong>, et le message refusé n&#039;est pas enregistré. Vous pouvez\nsignaler un refus que vous estimez injustifié.</p>\n<p>8.5. <strong>Ce que nous gardons</strong> : une trace de l&#039;événement (catégorie, scores, date), <strong>jamais le\ncontenu du message</strong>, pendant <strong>six mois</strong>. Des tentatives répétées de contournement peuvent\nconduire à l&#039;examen de votre compte (article 10).</p>\n<h3>Article 9 — Ce que vous vous engagez à ne pas faire</h3>\n<p>Vous vous engagez à ne pas utiliser LintellO pour :</p>\n<ul>\n<li>traiter des <strong>données sensibles</strong> (santé d&#039;autrui, opinions, religion, orientation sexuelle,\ndonnées biométriques…) ou des <strong>données pénales</strong> sans une exception prévue par la loi ;</li>\n<li><strong>collecter déloyalement</strong> des données personnelles, <strong>surveiller ou profiler</strong> une personne à\nson insu, ou traiter des <strong>images faciales</strong> pour identifier quelqu&#039;un ;</li>\n<li>prospecter en violation de l&#039;article L. 34-5 du code des postes et des communications\nélectroniques ;</li>\n<li>mettre en œuvre un <strong>usage à haut risque</strong> au sens du règlement européen sur l&#039;IA sans en\nremplir les obligations ;</li>\n<li>produire des contenus illicites, trompeurs (faux avis, faux témoignages…) ou portant atteinte\naux droits d&#039;autrui ;</li>\n<li><strong>contourner</strong> les limites techniques, les quotas ou la modération, ou automatiser l&#039;accès au\nservice hors de l&#039;API ;</li>\n<li><strong>revendre ou redistribuer</strong> un accès brut au service ou aux modèles.</li>\n</ul>\n<p>Vous restez responsable de la <strong>base légale</strong> de vos traitements et de l&#039;<strong>information des\npersonnes</strong> dont vous traitez les données (article 14 du RGPD).</p>\n<h3>Article 10 — Suspension et fermeture</h3>\n<p>10.1. <strong>Devoir d&#039;alerte.</strong> Si une instruction nous paraît manifestement illicite, nous pouvons\nsuspendre son exécution (une clé d&#039;API, une commande Prospect) après vous en avoir informé\n(article 28.3 du RGPD).</p>\n<p>10.2. <strong>Manquement.</strong> En cas de manquement aux présentes CGU, nous vous en informons par e-mail\net vous disposez de <strong>7 jours</strong> pour nous répondre. À défaut de réponse ou de régularisation, nous\npouvons suspendre votre compte, temporairement ou définitivement. En cas d&#039;urgence — contenu\nmanifestement illicite, atteinte à la sécurité du service — ou d&#039;obligation légale, la suspension\npeut être immédiate ; vous en êtes informé dans le même temps. Vos données restent exportables\npendant la suspension.</p>\n<p>10.3. <strong>Fermeture par vous.</strong> Vous fermez votre compte à tout moment depuis vos paramètres. Un\nabonnement en cours suit alors les règles de résiliation des CGV.</p>\n<h3>Article 11 — Propriété</h3>\n<p>11.1. <strong>Vos contenus</strong> restent les vôtres. Vous nous accordez le seul droit de les traiter pour\nvous rendre le service.</p>\n<p>11.2. <strong>Les réponses produites</strong> pour vous peuvent être utilisées librement par vous, sous votre\nresponsabilité (article 5.2) et dans le respect des droits des tiers.\n[⚖️ Préciser le régime des sorties d&#039;IA.]</p>\n<p>11.3. <strong>LintellO</strong> (marque, logiciel, interface, index L&#039;dicO) reste notre propriété.</p>\n<h3>Article 12 — Clients de l&#039;API</h3>\n<p>L&#039;API est réservée aux clients professionnels. Son accès suppose, en plus des présentes CGU,\nl&#039;acceptation de l&#039;<strong>annexe Sous-traitance</strong> au moment de la création de votre accès ; sans elle,\naucune route n&#039;est servie. Chaque clé est personnelle au client, limitée en débit et en\nconsommation. Les contenus envoyés ne sont pas conservés (article 6.3). La modération y détecte\nles tentatives de détournement des instructions (article 8).</p>\n<h3>Article 13 — LintellO Prospect - Farming</h3>\n<p>LintellO Prospect est réservé aux clients professionnels, sur commande et avec l&#039;annexe\nSous-traitance.</p>\n<ul>\n<li><strong>Rien ne se déclenche sans votre instruction.</strong> Le ciblage est le vôtre ; LintellO ne vous\nrecommande pas de cibles.</li>\n<li><strong>Seule la donnée d&#039;entreprise non personnelle est conservée.</strong> Les contacts professionnels\ntrouvés transitent : ils vous sont restitués puis <strong>purgés</strong> chez nous.</li>\n<li><strong>Liste d&#039;opposition permanente</strong>, vérifiée <strong>avant</strong> tout traitement d&#039;un nom. Vous nous\nrelayez les oppositions que vous recevez.</li>\n<li><strong>Un contact ne vous est jamais livré deux fois.</strong> LintellO livre moins plutôt que moins bien.</li>\n<li><strong>Dropcontact</strong> intervient comme sous-traitant ultérieur pour la recherche d&#039;adresses\nprofessionnelles.</li>\n</ul>\n<h3>Article 14 — Responsabilité</h3>\n<p>LintellO répond des dommages directs causés par un manquement prouvé à ses obligations. Il ne\nrépond pas des décisions prises sur la foi d&#039;une réponse de l&#039;IA (article 5.2), ni de l&#039;usage que\nvous faites du service en violation des présentes CGU.</p>\n<p>Envers un <strong>professionnel</strong>, la responsabilité de LintellO est limitée aux dommages directs et\nplafonnée aux sommes qu&#039;il a payées au cours des <strong>douze derniers mois</strong>. Envers un\n<strong>consommateur</strong>, elle s&#039;apprécie dans les limites du code de la consommation : aucune clause des\nprésentes ne l&#039;exclut au-delà de ce que la loi permet.</p>\n<h3>Article 15 — Modification des CGU</h3>\n<p>Les CGU sont versionnées. Une nouvelle version vous est présentée à votre connexion suivante ; le\nservice s&#039;ouvre après votre accord. Si vous la refusez, vous pouvez exporter\nvos données et fermer votre compte. Les versions précédentes restent consultables.</p>\n<h3>Article 16 — Droit applicable et litiges</h3>\n<p>Les CGU sont soumises au droit français. En cas de litige, vous pouvez nous contacter d&#039;abord à\n<a href=\"mailto:david&#64;lintello.ai\">david&#64;lintello.ai</a> . Si vous êtes consommateur, vous pouvez recourir gratuitement au\nmédiateur de la consommation désigné dans les CGV.</p>\n<p>À défaut d&#039;accord :</p>\n<ul>\n<li><strong>consommateur</strong> : vous pouvez saisir, à votre choix, la juridiction du lieu où vous demeuriez\nlors de la souscription ou de la survenance du fait dommageable, ou toute autre juridiction\ncompétente selon la loi ;</li>\n<li><strong>professionnel</strong> : tout litige est porté devant les <strong>juridictions de Toulouse</strong>, y compris en\ncas de référé ou de pluralité de défendeurs.</li>\n</ul>\n<h2 id=\"cgv\">Conditions générales de vente</h2>\n<blockquote>\n<p><strong>PROJET — version de travail du 28 septembre 2026, à faire valider par l&#039;avocat.</strong>\nRédigé depuis la spec <code>docs/specs/billing/cgv.md</code> et ce que le code vend réellement.\n<strong>[À COMPLÉTER]</strong> &#61; une information que seul l&#039;éditeur connaît. <strong>⚖️</strong> &#61; un point à trancher par\nl&#039;avocat. Ces deux marques disparaissent de la version publiée.\n⚠️ Aucun montant n&#039;est recopié ici : la page Tarifs fait foi, pour qu&#039;un changement de prix ne\nrende jamais ces conditions fausses.</p>\n</blockquote>\n<p><strong>Versio</strong></p>','cgu-cgv-app',0,'2026-10-20 08:38:12','2026-10-21 17:59:29',NULL,'full-width',0,NULL,'CGU et CGV de l’application LintellO','Conditions générales d’utilisation et de vente de l’application LintellO. Le texte qui fait foi est publié sur lintello.ai.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(11,'public','Fonctionnalités','','fonctionnalites',1,'2026-10-21 16:31:10','2026-10-21 16:31:10',NULL,'full-width',0,NULL,'Fonctionnalités de LintellO : éditeur de documents IA, chat, recherche','Chat, 18 modes, éditeur de documents IA, recherche web sans pistage, projets : tout ce que LintellO sait faire, avec un moteur IA français.',NULL,0,NULL,NULL,NULL,NULL,0,NULL);
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
(1,'LintellO','Assitant IA 100% Français et souverain','david@lintello.ai','Montsaunes','31260','3 place des Templiers',NULL,NULL,NULL,'LintellO — l\'assistant IA français : documents, chat, recherche','Un assistant IA français hébergé à Strasbourg : un chat qui comprend, un éditeur que l\'IA modifie, une recherche sans pistage.',NULL,NULL,'#2563eb','#1d4ed8','#1e3a8a','\'Poppins\', sans-serif',NULL,'vitrine','ttc','[\"vitrine\",\"blog\",\"faq\",\"marketing\"]',NULL,NULL,NULL,1,3,NULL,5,1,NULL,2,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
INSERT INTO `tag` VALUES
(1,'étudiants','etudiants',NULL,NULL,NULL,NULL,1,NULL),
(2,'maison','maison',NULL,NULL,NULL,NULL,1,NULL),
(3,'pros','pros',NULL,NULL,NULL,NULL,1,NULL),
(4,'chat','chat',NULL,NULL,NULL,NULL,1,NULL),
(5,'documents','documents',NULL,NULL,NULL,NULL,1,NULL),
(6,'recherche','recherche',NULL,NULL,NULL,NULL,1,NULL);
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
INSERT INTO `tag_page` VALUES
(1,5),
(2,6),
(3,7);
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

-- Dump completed on 2026-10-23  4:24:25
