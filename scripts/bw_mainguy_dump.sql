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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_23A0E66989D9B62` (`slug`),
  KEY `IDX_23A0E66E2532148` (`featured_media_id`),
  KEY `idx_article_published` (`published`),
  CONSTRAINT `FK_23A0E66E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES
(1,'Super article','<p>Super article</p>','2026-08-26 14:47:52','2026-08-27 16:13:15','2026-08-27 16:11:00','super-artcile',1,NULL,0,'public','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Super article\"}]}]}','Super article','C\'est vraiment un très très bon article !','Article, bon',0,NULL,10,NULL);
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `article_categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `article_categorie` WRITE;
/*!40000 ALTER TABLE `article_categorie` DISABLE KEYS */;
INSERT INTO `article_categorie` VALUES
(1,1);
/*!40000 ALTER TABLE `article_categorie` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `comment`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `contact_message`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `contact_message` WRITE;
/*!40000 ALTER TABLE `contact_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_message` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
('DoctrineMigrations\\Version20260616040528','2026-08-25 08:37:47',29);
/*!40000 ALTER TABLE `doctrine_migration_versions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES
(5,'Logo BM blanc transparent','logo-bm-blanc.png','logo-bm-blanc.webp',187,131),
(6,'Logo BM anthracite transparent','logo-bm-anthracite.png','logo-bm-anthracite.webp',187,131),
(8,'Affiche video hero - Saint-Martory','hero-bm-affiche.webp',NULL,1600,900),
(9,'Office - signature d acte','office-etude.webp',NULL,1400,935),
(10,'Expertise - droit immobilier','expertise-immobilier.webp',NULL,900,675),
(11,'Expertise - droit de la famille','expertise-famille.webp',NULL,900,675),
(12,'Expertise - formalites','expertise-formalites.webp',NULL,900,675),
(13,'Expertise - droit des affaires','expertise-affaires.webp',NULL,900,675),
(14,'Expertise - droit public','expertise-public.webp',NULL,900,675);
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES
(1,'Accueil',0,1,'route','header',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'Actualités',40,1,'route','header',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,'Expertises',10,1,'route','header',1,'services','app_service_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'Catalogue',30,0,'route','header',1,'catalogue','app_product_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,'Événements',40,0,'route','header',1,'events','app_event_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,'Annuaire',50,0,'route','header',1,'annuaire','app_directory',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,'Contact',60,1,'route','header',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,'Accueil',0,1,'route','footer_nav',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,'Actualités',40,1,'route','footer_nav',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,'Contact',20,1,'route','footer_nav',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(11,'Mentions légales',0,1,'route','footer_legal',1,'mentions-legales','app_legal_page','{\"type\":\"mentions-legales\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(12,'Politique de confidentialité',10,1,'route','footer_legal',1,'politique-confidentialite','app_legal_page','{\"type\":\"politique-de-confidentialite\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(13,'CGV',20,0,'route','footer_legal',1,'cgv','app_legal_page','{\"type\":\"conditions-generales-de-vente\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(14,'CGU',30,0,'route','footer_legal',1,'cgu','app_legal_page','{\"type\":\"conditions-generales-utilisation\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(15,'Tarifs',20,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL,NULL),
(16,'Tarifs',15,1,'page','footer_nav',0,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL,NULL);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `messenger_messages`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `messenger_messages` WRITE;
/*!40000 ALTER TABLE `messenger_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messenger_messages` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `order`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `page`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES
(1,'public','Mentions légales','<p><em>Dernière mise à jour : 25 août 2026</em></p>\n\n<h2>1. Éditeur du site</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>Forme juridique</strong></td><td>SELARL à associé unique</td></tr>\n<tr><td><strong>Siège social</strong></td><td>379 rue des Villas, 31360 Saint-Martory</td></tr>\n<tr><td><strong>SIRET</strong></td><td>948 742 523 00012</td></tr>\n<tr><td><strong>N° TVA</strong></td><td>{{TVA}}</td></tr>\n<tr><td><strong>Capital social</strong></td><td>{{CAPITAL}}</td></tr>\n<tr><td><strong>Directeur de publication</strong></td><td>Maître Bruno Mainguy</td></tr>\n<tr><td><strong>Contact</strong></td><td>bruno.mainguy&#64;31061.notaires.fr</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>05 61 90 20 40</td></tr>\n</tbody>\n</table>\n\n<h2>2. Hébergement</h2>\n<table>\n<tbody>\n<tr><td><strong>Hébergeur</strong></td><td>OVH SAS</td></tr>\n<tr><td><strong>Adresse</strong></td><td>2 rue Kellermann, 59100 Roubaix, France</td></tr>\n<tr><td><strong>Site web</strong></td><td>https://www.ovhcloud.com/fr/</td></tr>\n</tbody>\n</table>\n<p>L&#039;ensemble des données sont hébergées en France, conformément au RGPD.</p>\n\n<h2>3. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p>\n<p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p>\n\n<h2>4. Protection des données</h2>\n<ul>\n<li>Hébergement 100 % France</li>\n<li>Aucun transfert de données hors UE</li>\n<li>Données personnelles jamais revendues</li>\n</ul>\n<p><strong>Contact DPO :</strong> bruno.mainguy&#64;31061.notaires.fr</p>\n<p>Voir la <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a> pour les détails complets.</p>\n\n<h2>5. Cookies</h2>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Type</th><th>Finalité</th><th>Consentement</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP</td><td>Essentiel</td><td>Authentification</td><td>Non requis</td></tr>\n<tr><td>CSRF</td><td>Essentiel</td><td>Sécurité formulaires</td><td>Non requis</td></tr>\n<tr><td>_bw_sid</td><td>Mesure d&#039;audience</td><td>Session de visite anonyme (30 min)</td><td>Non requis (exempt CNIL)</td></tr>\n<tr><td>Google Analytics</td><td>Analytique tiers</td><td>Mesure d&#039;audience</td><td><strong>Requis</strong></td></tr>\n<tr><td>Préférences cookies</td><td>Fonctionnel</td><td>Mémoriser votre choix</td><td>Non requis</td></tr>\n</tbody>\n</table>\n<p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p>\n\n<h2>6. Limitation de responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p>\n<p>L&#039;éditeur décline toute responsabilité en cas d&#039;interruption du site, de survenance de bugs ou d&#039;incompatibilité du site avec certains matériels ou configurations.</p>\n\n<h2>7. Droit applicable et litiges</h2>\n<p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p>\n<p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : {{MEDIATEUR}}.</p>\n\n<h2>8. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>bruno.mainguy&#64;31061.notaires.fr</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — 379 rue des Villas, 31360 Saint-Martory</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>05 61 90 20 40</td></tr>\n</tbody>\n</table>','mentions-legales',1,'2026-08-25 08:38:40','2026-08-28 14:39:33',NULL,'full-width',1,'mentions-legales',NULL,'Mentions légales du site. Éditeur, hébergeur, propriété intellectuelle et contact.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(2,'public','Politique de confidentialité','<p><em>Dernière mise à jour : 25 août 2026</em></p><h2>1. Responsable du traitement</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>Entité</strong></p></td><td><p>{{RAISON_SOCIALE}}</p></td></tr><tr><td><p><strong>Représentant</strong></p></td><td><p>Maître Bruno Mainguy</p></td></tr><tr><td><p><strong>Siège</strong></p></td><td><p>379 rue des Villas, 31360 Saint-Martory</p></td></tr><tr><td><p><strong>SIRET</strong></p></td><td><p>948 742 523 00012</p></td></tr><tr><td><p><strong>DPO</strong></p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr></tbody></table><h2>2. Données collectées</h2><h3>2.1 Formulaire de contact</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Donnée</p></th><th><p>Finalité</p></th><th><p>Conservation</p></th></tr><tr><td><p>Nom, email</p></td><td><p>Répondre à la demande</p></td><td><p>3 ans</p></td></tr><tr><td><p>Message</p></td><td><p>Traitement de la demande</p></td><td><p>3 ans</p></td></tr></tbody></table><h3>2.2 Commentaires</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Donnée</p></th><th><p>Finalité</p></th><th><p>Conservation</p></th></tr><tr><td><p>Nom, contenu</p></td><td><p>Affichage public</p></td><td><p>Durée de publication</p></td></tr></tbody></table><h3>2.3 Mesure d&#039;audience interne</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Donnée</p></th><th><p>Finalité</p></th><th><p>Conservation</p></th></tr><tr><td><p>IP hashée (SHA-256 &#43; sel journalier)</p></td><td><p>Statistiques pseudonymisées, sécurité</p></td><td><p>13 mois</p></td></tr><tr><td><p>Pages visitées, parcours, durée, scroll</p></td><td><p>Amélioration du site</p></td><td><p>13 mois</p></td></tr><tr><td><p>Source d&#039;arrivée (referer, paramètres UTM)</p></td><td><p>Mesure d&#039;acquisition</p></td><td><p>13 mois</p></td></tr><tr><td><p>Type d&#039;appareil (desktop, mobile, tablette)</p></td><td><p>Statistique technique</p></td><td><p>13 mois</p></td></tr></tbody></table><p>Ces données sont <strong>pseudonymisées</strong> : l’adresse IP est remplacée par une empreinte SHA-256 salée quotidiennement, et aucun nom ne leur est associé. L&#039;adresse IP n&#039;est jamais stockée en clair. Aucune donnée n&#039;est partagée avec des tiers. Ce traitement est exempt de consentement conformément aux recommandations de la CNIL relatives aux outils de mesure d&#039;audience (délibération n°2020-091).</p><h2>3. Finalités du traitement</h2><ul><li><p>Gestion des comptes utilisateurs</p></li><li><p>Envoi de notifications relatives aux articles et au site</p></li><li><p>Traitement des demandes de contact</p></li><li><p>Amélioration du site via des statistiques de visite pseudonymisées</p></li></ul><h2>4. Base légale</h2><table class=\"tiptap-table\"><tbody><tr><th><p>Traitement</p></th><th><p>Base légale (RGPD)</p></th></tr><tr><td><p>Compte utilisateur</p></td><td><p>Exécution du contrat (art. 6.1.b)</p></td></tr><tr><td><p>Contact</p></td><td><p>Consentement (art. 6.1.a)</p></td></tr><tr><td><p>Mesure d’audience interne (pseudonymisée)</p></td><td><p>Intérêt légitime (art. 6.1.f) — exempt de consentement CNIL</p></td></tr><tr><td><p>Sécurité / logs</p></td><td><p>Intérêt légitime (art. 6.1.f)</p></td></tr></tbody></table><h2>5. Ce que nous ne faisons PAS</h2><ul><li><p>Vendre ou louer vos données à des tiers</p></li><li><p>Faire de la publicité ciblée</p></li><li><p>Faire du profilage marketing</p></li><li><p>Transférer vos données hors de l&#039;Union Européenne (hors sous-traitants certifiés)</p></li></ul><h2>6. Cookies</h2><h3>Cookies essentiels et de mesure exemptés (sans consentement)</h3><table class=\"tiptap-table\"><tbody><tr><th><p>Cookie</p></th><th><p>Finalité</p></th><th><p>Durée</p></th></tr><tr><td><p>Session PHP (PHPSESSID)</p></td><td><p>Authentification</p></td><td><p>Session</p></td></tr><tr><td><p>CSRF token</p></td><td><p>Sécurité des formulaires</p></td><td><p>Session</p></td></tr><tr><td><p>Préférences cookies</p></td><td><p>Mémoriser votre choix</p></td><td><p>13 mois</p></td></tr><tr><td><p>_bw_sid</p></td><td><p>Mesure d’audience (session de visite)</p></td><td><p>30 minutes</p></td></tr></tbody></table><p>Le cookie <strong>_bw_sid</strong> est un cookie first-party de mesure d&#039;audience. Il n’est pas partagé avec des tiers et expire après 30 minutes d&#039;inactivité. Conformément aux recommandations de la CNIL, ce type de cookie est <strong>exempt de consentement</strong>.</p><h2>7. Sous-traitants</h2><table class=\"tiptap-table\"><tbody><tr><th><p>Prestataire</p></th><th><p>Pays</p></th><th><p>Finalité</p></th></tr><tr><td><p>OVH SAS</p></td><td><p>France</p></td><td><p>Hébergement</p></td></tr><tr><td><p>Brevo</p></td><td><p>France</p></td><td><p>Envoi d&#039;emails</p></td></tr></tbody></table><h2>8. Vos droits RGPD</h2><table class=\"tiptap-table\"><tbody><tr><th><p>Droit</p></th><th><p>Comment l&#039;exercer</p></th></tr><tr><td><p>Accès</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Rectification</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Suppression</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Portabilité</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Opposition</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p>Limitation</p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr></tbody></table><p><strong>Délai de réponse :</strong> 30 jours maximum.</p><p>En cas de difficulté, vous pouvez adresser une réclamation auprès de la <strong>CNIL</strong> : <a href=\"https://www.cnil.fr\" target=\"_blank\" rel=\"noopener noreferrer\">www.cnil.fr</a> — 3 Place de Fontenoy, 75334 Paris Cedex 07.</p><h2>9. Sécurité</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>Transfert</strong></p></td><td><p>HTTPS / TLS 1.3</p></td></tr><tr><td><p><strong>Mots de passe</strong></p></td><td><p>Hashés (bcrypt/argon2)</p></td></tr><tr><td><p><strong>IP visiteurs</strong></p></td><td><p>Hashées SHA-256 (pseudonymisées)</p></td></tr><tr><td><p><strong>Accès admin</strong></p></td><td><p>Protégé par authentification &#43; CSRF</p></td></tr></tbody></table><h2>10. Modifications</h2><p>Cette politique peut être mise à jour. En cas de changement significatif, les utilisateurs inscrits seront informés par email. La date de mise à jour figure en haut de page.</p><h2>11. Contact</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>DPO</strong></p></td><td><p>bruno.mainguy&#64;31061.notaires.fr</p></td></tr><tr><td><p><strong>Courrier</strong></p></td><td><p>{{RAISON_SOCIALE}} — 379 rue des Villas, 31360 Saint-Martory</p></td></tr></tbody></table>','politique-confidentialite',1,'2026-08-25 08:38:40','2026-08-28 14:40:49','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"italic\"}],\"text\":\"Derni\\u00e8re mise \\u00e0 jour : 25 ao\\u00fbt 2026\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"1. Responsable du traitement\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Entit\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"{{RAISON_SOCIALE}}\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Repr\\u00e9sentant\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Ma\\u00eetre Bruno Mainguy\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Si\\u00e8ge\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"379 rue des Villas, 31360 Saint-Martory\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"SIRET\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"948 742 523 00012\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"DPO\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"2. Donn\\u00e9es collect\\u00e9es\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"2.1 Formulaire de contact\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9e\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conservation\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Nom, email\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9pondre \\u00e0 la demande\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"3 ans\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Message\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Traitement de la demande\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"3 ans\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"2.2 Commentaires\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9e\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conservation\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Nom, contenu\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Affichage public\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Dur\\u00e9e de publication\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"2.3 Mesure d\'audience interne\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9e\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conservation\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"IP hash\\u00e9e (SHA-256 + sel journalier)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Statistiques pseudonymis\\u00e9es, s\\u00e9curit\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pages visit\\u00e9es, parcours, dur\\u00e9e, scroll\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Am\\u00e9lioration du site\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Source d\'arriv\\u00e9e (referer, param\\u00e8tres UTM)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mesure d\'acquisition\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Type d\'appareil (desktop, mobile, tablette)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Statistique technique\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Ces donn\\u00e9es sont \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"pseudonymis\\u00e9es\"},{\"type\":\"text\",\"text\":\" : l\\u2019adresse IP est remplac\\u00e9e par une empreinte SHA-256 sal\\u00e9e quotidiennement, et aucun nom ne leur est associ\\u00e9. L\'adresse IP n\'est jamais stock\\u00e9e en clair. Aucune donn\\u00e9e n\'est partag\\u00e9e avec des tiers. Ce traitement est exempt de consentement conform\\u00e9ment aux recommandations de la CNIL relatives aux outils de mesure d\'audience (d\\u00e9lib\\u00e9ration n\\u00b02020-091).\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"3. Finalit\\u00e9s du traitement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Gestion des comptes utilisateurs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Envoi de notifications relatives aux articles et au site\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Traitement des demandes de contact\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Am\\u00e9lioration du site via des statistiques de visite pseudonymis\\u00e9es\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"4. Base l\\u00e9gale\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Traitement\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Base l\\u00e9gale (RGPD)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Compte utilisateur\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Ex\\u00e9cution du contrat (art. 6.1.b)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Contact\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Consentement (art. 6.1.a)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mesure d\\u2019audience interne (pseudonymis\\u00e9e)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Int\\u00e9r\\u00eat l\\u00e9gitime (art. 6.1.f) \\u2014 exempt de consentement CNIL\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9curit\\u00e9 \\/ logs\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Int\\u00e9r\\u00eat l\\u00e9gitime (art. 6.1.f)\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"5. Ce que nous ne faisons PAS\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Vendre ou louer vos donn\\u00e9es \\u00e0 des tiers\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Faire de la publicit\\u00e9 cibl\\u00e9e\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Faire du profilage marketing\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Transf\\u00e9rer vos donn\\u00e9es hors de l\'Union Europ\\u00e9enne (hors sous-traitants certifi\\u00e9s)\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"6. Cookies\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Cookies essentiels et de mesure exempt\\u00e9s (sans consentement)\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cookie\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Dur\\u00e9e\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Session PHP (PHPSESSID)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Authentification\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Session\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"CSRF token\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9curit\\u00e9 des formulaires\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Session\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pr\\u00e9f\\u00e9rences cookies\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"M\\u00e9moriser votre choix\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"13 mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"_bw_sid\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mesure d\\u2019audience (session de visite)\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"30 minutes\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Le cookie \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"_bw_sid\"},{\"type\":\"text\",\"text\":\" est un cookie first-party de mesure d\'audience. Il n\\u2019est pas partag\\u00e9 avec des tiers et expire apr\\u00e8s 30 minutes d\'inactivit\\u00e9. Conform\\u00e9ment aux recommandations de la CNIL, ce type de cookie est \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"exempt de consentement\"},{\"type\":\"text\",\"text\":\".\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"7. Sous-traitants\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Prestataire\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pays\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"OVH SAS\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"France\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9bergement\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Brevo\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"France\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Envoi d\'emails\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"8. Vos droits RGPD\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Droit\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Comment l\'exercer\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Acc\\u00e8s\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Rectification\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Suppression\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Portabilit\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Opposition\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Limitation\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"D\\u00e9lai de r\\u00e9ponse :\"},{\"type\":\"text\",\"text\":\" 30 jours maximum.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"En cas de difficult\\u00e9, vous pouvez adresser une r\\u00e9clamation aupr\\u00e8s de la \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"CNIL\"},{\"type\":\"text\",\"text\":\" : \"},{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"https:\\/\\/www.cnil.fr\",\"target\":\"_blank\",\"rel\":\"noopener\",\"class\":null}}],\"text\":\"www.cnil.fr\"},{\"type\":\"text\",\"text\":\" \\u2014 3 Place de Fontenoy, 75334 Paris Cedex 07.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"9. S\\u00e9curit\\u00e9\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Transfert\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"HTTPS \\/ TLS 1.3\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Mots de passe\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Hash\\u00e9s (bcrypt\\/argon2)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"IP visiteurs\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Hash\\u00e9es SHA-256 (pseudonymis\\u00e9es)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Acc\\u00e8s admin\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Prot\\u00e9g\\u00e9 par authentification + CSRF\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"10. Modifications\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cette politique peut \\u00eatre mise \\u00e0 jour. En cas de changement significatif, les utilisateurs inscrits seront inform\\u00e9s par email. La date de mise \\u00e0 jour figure en haut de page.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"11. Contact\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"DPO\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"bruno.mainguy@31061.notaires.fr\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Courrier\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"{{RAISON_SOCIALE}} \\u2014 379 rue des Villas, 31360 Saint-Martory\"}]}]}]}]}]}','full-width',1,'politique-confidentialite',NULL,'Politique de confidentialité. Données collectées, cookies, droits RGPD et contact DPO.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(3,'public','Conditions générales d\'utilisation','<p><em>Dernière mise à jour : 25 août 2026</em></p>\n\n<h2>1. Objet</h2>\n<p>Les présentes Conditions Générales d&#039;Utilisation (CGU) régissent l&#039;accès et l&#039;utilisation de ce site internet. En accédant au site, vous acceptez sans réserve les présentes CGU.</p>\n\n<h2>2. Éditeur</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>948 742 523 00012</td></tr>\n<tr><td><strong>Adresse</strong></td><td>379 rue des Villas, 31360 Saint-Martory</td></tr>\n<tr><td><strong>Email</strong></td><td>bruno.mainguy@31061.notaires.fr</td></tr>\n</tbody>\n</table>\n\n<h2>3. Accès au service</h2>\n<ul>\n<li>Le site est accessible gratuitement à tout utilisateur disposant d&#039;un accès internet</li>\n<li>Les frais d&#039;accès et d&#039;utilisation du réseau de télécommunication sont à la charge de l&#039;utilisateur</li>\n<li>L&#039;éditeur se réserve le droit de suspendre ou interrompre l&#039;accès pour maintenance</li>\n</ul>\n\n<h2>4. Inscription</h2>\n<p>L&#039;accès à certaines fonctionnalités du site nécessite une inscription. L&#039;utilisateur s&#039;engage à :</p>\n<ul>\n<li>Fournir des informations exactes et complètes</li>\n<li>Mettre à jour ses informations en cas de changement</li>\n<li>Préserver la confidentialité de son mot de passe (12 caractères minimum)</li>\n<li>Notifier immédiatement toute utilisation non autorisée de son compte</li>\n</ul>\n<p>L&#039;éditeur se réserve le droit de supprimer tout compte ne respectant pas les présentes CGU.</p>\n\n<h2>5. Services proposés</h2>\n<p>Le site propose les services suivants :</p>\n<ul>\n<li>Publication et consultation de contenus (articles, pages, services)</li>\n<li>Formulaire de contact</li>\n<li>Inscription aux notifications</li>\n<li>Commentaires sur les articles</li>\n\n</ul>\n\n<h2>6. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu du site est protégé par le droit de la propriété intellectuelle :</p>\n<ul>\n<li>Textes, images, vidéos, logos, icônes, sons, logiciels</li>\n<li>Charte graphique et design du site</li>\n<li>Bases de données</li>\n</ul>\n<p>Toute reproduction non autorisée constitue une contrefaçon sanctionnée par les articles L335-2 et suivants du Code de la Propriété Intellectuelle.</p>\n\n<h2>7. Comportement de l&#039;utilisateur</h2>\n<p>L&#039;utilisateur s&#039;engage à ne pas :</p>\n<ul>\n<li>Publier de contenu illicite, diffamatoire, injurieux ou discriminatoire</li>\n<li>Porter atteinte à la vie privée d&#039;autrui</li>\n<li>Tenter d&#039;accéder à des zones non autorisées du site</li>\n<li>Utiliser le site à des fins commerciales non autorisées</li>\n<li>Collecter des données personnelles d&#039;autres utilisateurs</li>\n</ul>\n\n<h2>8. Responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible, mais ne garantit pas :</p>\n<ul>\n<li>L&#039;exactitude, la complétude ou l&#039;actualité des informations publiées</li>\n<li>La disponibilité permanente du site</li>\n<li>L&#039;absence de virus ou de défauts de fonctionnement</li>\n</ul>\n<p>L&#039;éditeur décline toute responsabilité pour les dommages directs ou indirects résultant de l&#039;utilisation du site.</p>\n\n<h2>9. Liens hypertextes</h2>\n<p>Le site peut contenir des liens vers des sites tiers. L&#039;éditeur n&#039;est pas responsable du contenu de ces sites et n&#039;exerce aucun contrôle sur eux.</p>\n\n<h2>10. Données personnelles</h2>\n<p>Le traitement des données personnelles est décrit dans notre <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a>, accessible depuis le pied de page du site.</p>\n\n<h2>11. Modification des CGU</h2>\n<p>L&#039;éditeur se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs inscrits seront informés par email de toute modification substantielle. La date de mise à jour figure en haut de page.</p>\n\n<h2>12. Droit applicable</h2>\n<p>Les présentes CGU sont régies par le droit français. En cas de litige, les tribunaux français seront compétents.</p>\n\n<h2>13. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>bruno.mainguy@31061.notaires.fr</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — 379 rue des Villas, 31360 Saint-Martory</td></tr>\n</tbody>\n</table>','cgu',0,'2026-08-25 08:38:50','2026-08-25 10:04:04',NULL,'full-width',1,'cgu',NULL,'Conditions générales d\'utilisation. Accès au service, inscription, propriété intellectuelle et responsabilité.',NULL,1,NULL,NULL,NULL,NULL,1,NULL),
(4,'public','Tarifs','<p class=\"lead\">La somme que l’on verse au notaire, que l’on nomme communément et improprement « frais de notaire », comprend en réalité les taxes reversées au Trésor Public, les déboursés, et la rémunération au titre du service notarial.</p>\n\n<p>Parce que le notaire remplit une fonction d’intérêt public, la rémunération au titre du service notarial est strictement réglementée et fait l’objet d’un tarif.</p>\n\n<h2>Composition des frais de notaire</h2>\n\n<div class=\"bw-fees\">\n  <div class=\"bw-fee\">\n    <span class=\"bw-fee__share\">8<span class=\"bw-fee__unit\">/10</span></span>\n    <h3 class=\"bw-fee__title\">Taxes et impôts</h3>\n    <p class=\"bw-fee__text\">Les sommes que le notaire est tenu de percevoir et de reverser à l’État et aux collectivités locales pour le compte de son client. Elles varient suivant la nature de l’acte et du bien.</p>\n  </div>\n  <div class=\"bw-fee\">\n    <span class=\"bw-fee__share\">1<span class=\"bw-fee__unit\">/10</span></span>\n    <h3 class=\"bw-fee__title\">Déboursés</h3>\n    <p class=\"bw-fee__text\">Les sommes avancées par l’étude pour le compte de son client afin de réunir les pièces et documents nécessaires à l’établissement de l’acte.</p>\n  </div>\n  <div class=\"bw-fee\">\n    <span class=\"bw-fee__share\">1<span class=\"bw-fee__unit\">/10</span></span>\n    <h3 class=\"bw-fee__title\">Service notarial</h3>\n    <p class=\"bw-fee__text\">La rémunération du service rendu, qui couvre les charges de l’office, les collaborateurs et les notaires.</p>\n  </div>\n</div>\n\n<h2>Un tarif fixé par décret</h2>\n<p>Ce tarif, fixé par le décret du 8 mars 1978, a été modifié à quatre reprises : par les décrets du 16 mai 2006, du 21 mars 2007, du 17 février 2011, et enfin par le décret et l’arrêté du 26 février 2016.</p>\n\n<p>Le tarif comprend donc :</p>\n<ul>\n  <li><strong>des émoluments proportionnels et fixes</strong>, fixés par décret et arrêté, pour tous les actes et formalités pour lesquels les pouvoirs publics l’ont décidé : ventes, donations, successions, prêts…</li>\n  <li><strong>des honoraires</strong> pour tous les actes dont le décret prévoit que la rémunération est librement convenue entre le notaire et son client : baux commerciaux, actes de sociétés, négociations immobilières, consultations détachables…</li>\n</ul>\n\n<h2>Le conseil est gratuit</h2>\n<p>Nous avons à cœur de fournir un accompagnement de qualité et d’établir une relation de confiance avec nos clients. N’hésitez pas à nous exposer votre projet : nous vous communiquerons une estimation des frais correspondant à votre situation.</p>','tarifs',1,'2026-08-25 08:22:58','2026-08-26 14:56:35','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les \\u00ab frais de notaire \\u00bb sont l\\u2019un des sujets qui inqui\\u00e8tent le plus au moment d\\u2019un achat. Dans les faits, ils ne correspondent que tr\\u00e8s marginalement \\u00e0 la r\\u00e9mun\\u00e9ration de l\\u2019office : l\\u2019essentiel est revers\\u00e9 \\u00e0 l\\u2019\\u00c9tat et aux collectivit\\u00e9s.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Ce que recouvrent r\\u00e9ellement les frais\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Sur l\\u2019ensemble des sommes vers\\u00e9es \\u00e0 l\\u2019\\u00e9tude lors d\\u2019une acquisition immobili\\u00e8re, la r\\u00e9partition est, en ordre de grandeur, la suivante.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"8\\/10\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Taxes et imp\\u00f4ts\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les droits de mutation, revers\\u00e9s \\u00e0 l\\u2019\\u00c9tat, au d\\u00e9partement et \\u00e0 la commune. Le notaire les collecte pour leur compte : ils ne lui reviennent pas.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"1\\/10\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9bours\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les sommes avanc\\u00e9es par l\\u2019\\u00e9tude pour votre compte : documents d\\u2019urbanisme, actes d\\u2019\\u00e9tat civil, g\\u00e9om\\u00e8tre, formalit\\u00e9s de publicit\\u00e9 fonci\\u00e8re.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"1\\/10\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"\\u00c9moluments\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"La r\\u00e9mun\\u00e9ration du notaire \\u00e0 proprement parler, fix\\u00e9e par un tarif r\\u00e9glement\\u00e9 et identique dans toute la France.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Des \\u00e9muluments fix\\u00e9s par les pouvoirs publics\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Le tarif des notaires est r\\u00e9glement\\u00e9 : il s\\u2019applique de la m\\u00eame fa\\u00e7on dans toutes les \\u00e9tudes de France. Le notaire ne fixe donc pas librement sa r\\u00e9mun\\u00e9ration, et vous ne paierez pas davantage ici qu\\u2019ailleurs pour un m\\u00eame acte.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Certaines prestations de conseil rel\\u00e8vent en revanche d\\u2019honoraires libres. Leur montant vous est alors annonc\\u00e9 et convenu avec vous avant toute intervention.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Deux notaires, aucun surco\\u00fbt\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Lorsque l\\u2019acqu\\u00e9reur et le vendeur souhaitent chacun \\u00eatre accompagn\\u00e9s par leur propre notaire, les deux \\u00e9tudes se partagent les \\u00e9moluments pr\\u00e9vus pour l\\u2019op\\u00e9ration. Faire appel \\u00e0 un second notaire n\\u2019entra\\u00eene donc \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"aucun frais suppl\\u00e9mentaire\"},{\"type\":\"text\",\"text\":\" pour vous.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Une estimation avant de vous engager\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Chaque dossier a ses particularit\\u00e9s. Le plus s\\u00fbr reste de nous exposer votre projet : nous vous communiquons une estimation des frais correspondant \\u00e0 votre situation, avant que vous ne preniez d\\u2019engagement.\"}]}]}','full-width',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,1,NULL),
(5,'public','Expertises','<p>Notre raison d’être est de vous permettre d’anticiper tous les événements de votre vie en toute sérénité.</p>\n\n<p>Située à Saint-Martory, l’Étude vous reçoit au 379 rue des Villas. L’office BM NOTAIRE a conscience que ses clients évoluent dans un environnement toujours plus complexe et mouvant. Il est garant de la sécurité juridique et apporte son expertise dans l’élaboration des contrats qui lui sont confiés.</p>\n\n<h2>Notre philosophie</h2>\n<p>L’accompagnement avec humanité, rendre le droit accessible au plus grand nombre, l’écoute attentive, la réactivité, la satisfaction, l’empathie : ce sont les qualités qui traduisent notre philosophie et qui sont au cœur des préoccupations de l’office.</p>\n<p>L’Étude s’appuie sur une équipe soudée et fidèle, partageant des convictions fortes : la considération, l’écoute et la confiance mutuelle sont essentielles à la réussite de vos objectifs personnels et patrimoniaux.</p>\n\n<h2>Un office moderne</h2>\n<p>L’Office Notarial de Saint-Martory met à disposition ses nouvelles technologies : signature des actes sur support électronique, visioconférence, procuration à distance.</p>\n\n<h2>Transparence</h2>\n<p>Le conseil est gratuit. Nous avons à cœur de fournir un accompagnement de qualité et d’établir une relation de confiance avec nos clients.</p>\n\n<h2>Éco-responsable</h2>\n<p>Soucieux de l’environnement, nous mettons tout en œuvre pour limiter les impressions et privilégier une gestion dématérialisée des actes notariés.</p>\n\n<h2>Réactivité</h2>\n<p>L’ensemble de nos collaborateurs s’engagent à vous répondre dans les meilleurs délais.</p>\n\n<h2>Nos domaines d’intervention</h2>\n<p>L’étude accompagne les particuliers comme les professionnels et les collectivités.</p>','expertises-introduction',1,'2026-08-25 08:37:21','2026-08-28 15:00:19',NULL,'full-width',1,'services_intro',NULL,NULL,NULL,0,NULL,9,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `page` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=289 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_view`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page_view` WRITE;
/*!40000 ALTER TABLE `page_view` DISABLE KEYS */;
INSERT INTO `page_view` VALUES
(1,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 08:39:15',0,NULL,1,NULL,NULL,1),
(2,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 08:39:16',0,NULL,1,NULL,NULL,2),
(3,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 08:39:56',0,NULL,1,NULL,0,3),
(4,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-25 08:44:12',0,NULL,1,157,55,4),
(5,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 08:47:52',0,NULL,1,NULL,NULL,5),
(6,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 08:47:52',0,NULL,1,NULL,NULL,6),
(7,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 08:47:52',0,NULL,1,NULL,NULL,7),
(8,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 08:47:58',0,'/',2,NULL,21,3),
(9,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 08:48:57',0,'/',3,NULL,21,3),
(10,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 08:49:39',0,'/',4,NULL,41,3),
(11,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36','http://localhost:8080/contact','2026-08-25 08:50:11',0,'/contact',5,NULL,16,3),
(12,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-25 08:55:52',0,'/',2,700,100,4),
(13,'/article/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 08:56:07',0,'/',3,15,100,4),
(14,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/article/','2026-08-25 08:56:09',0,'/article/',4,2,100,4),
(15,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 08:56:11',0,'/services',5,200,100,4),
(16,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 08:58:01',0,NULL,1,NULL,NULL,8),
(17,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 08:58:12',0,'/',6,NULL,21,3),
(18,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 08:58:56',0,'/',7,NULL,21,3),
(19,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:02:30',0,NULL,1,NULL,NULL,9),
(20,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:02:40',0,'/',8,NULL,20,3),
(21,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:11:11',0,'/',6,900,100,4),
(22,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:11:22',0,'/',7,11,100,4),
(23,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:11:23',0,'/services',8,17,100,4),
(24,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:19:24',0,NULL,1,NULL,NULL,10),
(25,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:19:24',0,NULL,1,NULL,NULL,11),
(26,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 09:19:32',0,'/',9,NULL,16,3),
(27,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:21:02',0,'/',9,579,73,4),
(28,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:21:18',0,'/',10,45,100,4),
(29,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:22:07',0,'/',11,49,100,4),
(30,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/contact','2026-08-25 09:22:11',0,'/contact',12,5,100,4),
(31,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:22:13',0,'/services',13,31,100,4),
(32,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:22:57',0,'/',14,307,100,4),
(33,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:24:51',0,NULL,1,NULL,NULL,12),
(34,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:24:56',0,'/',10,NULL,0,3),
(35,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:26:20',0,'/',11,NULL,18,3),
(36,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:27:26',0,'/contact',15,313,100,4),
(37,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:27:41',0,'/',16,15,34,4),
(38,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:27:42',0,'/',17,243,100,4),
(39,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:32:05',0,NULL,1,NULL,NULL,13),
(40,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:32:13',0,NULL,1,NULL,NULL,14),
(41,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:32:24',0,'/',12,NULL,18,3),
(42,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:33:11',0,'/',18,351,100,4),
(43,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:36:19',0,NULL,1,NULL,NULL,15),
(44,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:36:33',0,'/',13,NULL,18,3),
(45,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:37:15',0,'/',14,NULL,19,3),
(46,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:38:09',0,NULL,1,NULL,NULL,16),
(47,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:38:09',0,NULL,1,NULL,NULL,17),
(48,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:38:18',0,'/',15,NULL,18,3),
(49,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:39:12',0,'/',19,165,55,4),
(50,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-25 09:42:08',0,'/',20,451,100,4),
(51,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:44:42',0,'/',16,NULL,18,3),
(52,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:46:50',0,'/',21,392,100,4),
(53,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:50:23',0,'/',17,NULL,18,3),
(54,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:50:53',0,NULL,1,NULL,NULL,18),
(55,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:50:53',0,NULL,1,NULL,NULL,19),
(56,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 09:52:05',0,NULL,1,NULL,NULL,20),
(57,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:52:16',0,'/',18,NULL,18,3),
(58,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:53:36',0,'/',22,106,100,4),
(59,'/article/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:55:27',0,'/',23,201,100,4),
(60,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:55:30',0,'/',19,NULL,18,3),
(61,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36','http://localhost:8080/','2026-08-25 09:56:31',0,'/',20,NULL,17,3),
(62,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:56:58',0,'/article/',24,202,100,4),
(63,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:56:58',0,'/',25,NULL,40,4),
(64,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-25 09:57:02',0,'/',26,4,40,4),
(65,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:57:02',0,'/',27,75,100,4),
(66,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:58:05',0,'/',21,NULL,18,3),
(67,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:58:25',0,'/',28,61,100,4),
(68,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 09:59:17',0,'/',22,NULL,18,3),
(69,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:59:29',0,'/',29,15,100,4),
(70,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 09:59:58',0,'/',30,15,100,4),
(71,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 10:00:22',0,'/',23,NULL,18,3),
(72,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/contact','2026-08-25 10:00:28',0,'/contact',31,46,100,4),
(73,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/contact','2026-08-25 10:01:24',0,'/',32,107,34,4),
(74,'/login','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-25 10:03:23',0,'/',33,13,95,4),
(75,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:23:37',0,NULL,1,NULL,NULL,21),
(76,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:23:38',0,NULL,1,NULL,NULL,22),
(77,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:23:38',0,NULL,1,NULL,NULL,23),
(78,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:24:17',0,NULL,1,NULL,NULL,24),
(79,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:25:31',0,NULL,1,NULL,NULL,25),
(80,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:25:31',0,NULL,1,NULL,NULL,26),
(81,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:25:31',0,NULL,1,NULL,NULL,27),
(82,'/service/vente-immobiliere','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:25:32',0,NULL,1,NULL,NULL,28),
(83,'/service/conseil-patrimonial','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:25:32',0,NULL,1,NULL,NULL,29),
(84,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:25:32',0,NULL,1,NULL,NULL,30),
(85,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:25:32',0,NULL,1,NULL,NULL,31),
(86,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 10:25:40',0,'/',24,NULL,38,3),
(87,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/page/tarifs','2026-08-25 10:26:18',0,'/page/tarifs',25,NULL,38,3),
(88,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 10:26:28',0,'/page/tarifs',26,NULL,16,3),
(89,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:35:27',0,NULL,1,NULL,NULL,32),
(90,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:35:27',0,NULL,1,NULL,NULL,33),
(91,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:37:27',0,NULL,1,NULL,NULL,34),
(92,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:37:35',0,NULL,1,NULL,NULL,35),
(93,'/page/expertises-introduction','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:37:36',0,NULL,1,NULL,NULL,36),
(94,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:37:36',0,NULL,1,NULL,NULL,37),
(95,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:37:36',0,NULL,1,NULL,NULL,38),
(96,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:38:52',0,NULL,1,NULL,NULL,39),
(97,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:38:52',0,NULL,1,NULL,NULL,40),
(98,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 10:38:57',0,'/',27,NULL,38,3),
(99,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:40:57',0,NULL,1,NULL,NULL,41),
(100,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/services','2026-08-25 10:41:17',0,'/services',28,NULL,79,3),
(101,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:41:35',0,NULL,1,NULL,NULL,42),
(102,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:41:35',0,NULL,1,NULL,NULL,43),
(103,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:41:35',0,NULL,1,NULL,NULL,44),
(104,'/service/vente-immobiliere','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:41:35',0,NULL,1,NULL,NULL,45),
(105,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:41:35',0,NULL,1,NULL,NULL,46),
(106,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:44:58',0,NULL,1,NULL,NULL,47),
(107,'/page/mentions-legales','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:44:58',0,NULL,1,NULL,NULL,48),
(108,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:45:17',0,NULL,1,NULL,NULL,49),
(109,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:45:17',0,NULL,1,NULL,NULL,50),
(110,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:45:18',0,NULL,1,NULL,NULL,51),
(111,'/article/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:45:39',0,NULL,1,NULL,NULL,52),
(112,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:45:39',0,NULL,1,NULL,NULL,53),
(113,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:45:40',0,NULL,1,NULL,NULL,54),
(114,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 10:45:40',0,NULL,1,NULL,NULL,55),
(115,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 11:23:50',0,NULL,1,NULL,NULL,56),
(116,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 11:24:42',0,NULL,1,NULL,NULL,57),
(117,'/page/tarifs','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/services','2026-08-25 11:25:08',0,'/services',2,NULL,41,57),
(118,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 11:25:13',0,'/page/tarifs',3,NULL,18,57),
(119,'/services','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 11:25:35',0,'/',4,NULL,35,57),
(120,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 11:27:08',0,'/services',5,NULL,43,57),
(121,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:28:28',0,'/contact',6,NULL,42,57),
(122,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:29:03',0,'/contact',7,NULL,42,57),
(123,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:31:30',0,'/contact',8,NULL,43,57),
(124,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:37:25',0,'/contact',9,NULL,66,57),
(125,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:40:31',0,'/contact',10,NULL,92,57),
(126,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:43:47',0,'/contact',11,NULL,100,57),
(127,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:44:36',0,'/contact',12,NULL,100,57),
(128,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:46:50',0,'/contact',13,NULL,100,57),
(129,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:48:34',0,'/contact',14,NULL,100,57),
(130,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 11:51:54',0,'/contact',15,NULL,100,57),
(131,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 11:57:40',0,NULL,1,NULL,NULL,58),
(132,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 11:57:47',0,'/contact',16,NULL,43,57),
(133,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 12:03:22',0,NULL,1,NULL,NULL,59),
(134,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 12:03:36',0,NULL,1,NULL,NULL,60),
(135,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 12:03:46',0,NULL,1,NULL,NULL,61),
(136,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/contact','2026-08-25 12:03:56',0,'/contact',17,NULL,43,57),
(137,'/contact','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',NULL,'2026-08-25 14:06:04',0,NULL,1,NULL,NULL,62),
(138,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-25 14:26:57',0,NULL,1,NULL,54,63),
(139,'/service/conseil-patrimonial','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-25 14:27:05',0,'/',2,8,97,63),
(140,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/service/conseil-patrimonial','2026-08-25 14:27:11',0,'/service/conseil-patrimonial',3,1625,100,63),
(141,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',NULL,'2026-08-25 14:27:47',0,NULL,1,NULL,16,64),
(142,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX','http://localhost:8080/','2026-08-25 14:29:05',0,'/',2,NULL,NULL,64),
(143,'/','727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/service/conseil-patrimonial','2026-08-25 14:54:31',0,'/',4,524,100,63),
(144,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',NULL,'2026-08-26 14:14:54',0,NULL,1,NULL,NULL,65),
(145,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',NULL,'2026-08-26 14:14:54',0,NULL,1,NULL,NULL,66),
(146,'/services','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',NULL,'2026-08-26 14:14:54',0,NULL,1,NULL,NULL,67),
(147,'/page/tarifs','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',NULL,'2026-08-26 14:14:55',0,NULL,1,NULL,NULL,68),
(148,'/contact','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',NULL,'2026-08-26 14:14:55',0,NULL,1,NULL,NULL,69),
(149,'/article/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',NULL,'2026-08-26 14:14:55',0,NULL,1,NULL,NULL,70),
(150,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-26 14:20:10',0,NULL,1,1168,18,71),
(151,'/recherche','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-26 14:39:47',0,'/',2,3,94,71),
(152,'/services','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/recherche?q=expertise','2026-08-26 14:39:59',0,'/recherche',3,12,94,71),
(153,'/service/vente-immobiliere','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-26 14:40:14',0,'/services',4,15,100,71),
(154,'/services','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/service/vente-immobiliere','2026-08-26 14:40:26',0,'/service/vente-immobiliere',5,11,100,71),
(155,'/service/prets-et-garanties','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-26 14:40:31',0,'/services',6,5,100,71),
(156,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/service/prets-et-garanties','2026-08-26 14:40:37',0,'/service/prets-et-garanties',7,6,100,71),
(157,'/services','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-26 14:40:39',0,'/',8,16,93,71),
(158,'/page/tarifs','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/services','2026-08-26 14:41:03',0,'/services',9,24,100,71),
(159,'/article/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/page/tarifs','2026-08-26 14:41:12',0,'/page/tarifs',10,9,100,71),
(160,'/contact','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/article/','2026-08-26 14:41:23',0,'/article/',11,11,94,71),
(161,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/contact','2026-08-26 14:41:33',0,'/contact',12,10,94,71),
(162,'/contact','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-26 14:41:40',0,'/',13,7,49,71),
(163,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/contact','2026-08-26 14:41:43',0,'/contact',14,60,100,71),
(164,'/mentions-legales','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/','2026-08-26 14:42:49',0,'/',15,65,100,71),
(165,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/mentions-legales','2026-08-26 14:43:03',0,'/mentions-legales',16,15,100,71),
(166,'/login','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-26 14:43:20',0,'/',17,16,100,71),
(167,'/login','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/login','2026-08-26 14:43:25',0,'/login',18,6,92,71),
(168,'/login','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/login','2026-08-26 14:43:35',0,'/login',19,122,85,71),
(169,'/article/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/mentions-legales','2026-08-26 14:51:48',0,NULL,1,4,93,72),
(170,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController','2026-08-26 14:51:54',0,'/article/',2,108,100,72),
(171,'/','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-26 14:53:45',0,'/',3,NULL,18,72),
(172,'/login','a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-26 14:53:50',0,'/',4,180,100,72),
(173,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 13:57:37',0,NULL,1,NULL,NULL,73),
(174,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 13:57:37',0,NULL,1,NULL,NULL,74),
(175,'/page/tarifs','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 13:57:37',0,NULL,1,NULL,NULL,75),
(176,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 13:57:38',0,NULL,1,NULL,NULL,76),
(177,'/service/droit-public','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 13:57:38',0,NULL,1,NULL,NULL,77),
(178,'/contact','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 13:57:38',0,NULL,1,NULL,NULL,78),
(179,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 13:58:09',0,NULL,1,NULL,0,79),
(180,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX','http://localhost:8080/','2026-08-27 14:15:39',0,'/',2,NULL,15,79),
(181,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:19:03',0,NULL,1,NULL,NULL,80),
(182,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:21:52',0,NULL,1,NULL,NULL,81),
(183,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:21:53',0,NULL,1,NULL,NULL,82),
(184,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:22:54',0,NULL,1,NULL,NULL,83),
(185,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:22:54',0,NULL,1,NULL,NULL,84),
(186,'/page/tarifs','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:22:54',0,NULL,1,NULL,NULL,85),
(187,'/contact','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:22:54',0,NULL,1,NULL,NULL,86),
(188,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:22:54',0,NULL,1,NULL,NULL,87),
(189,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:27:17',0,NULL,1,NULL,NULL,88),
(190,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 14:27:27',0,'/',3,NULL,19,79),
(191,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:28:16',0,NULL,1,NULL,NULL,89),
(192,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX','http://localhost:8080/services','2026-08-27 14:28:50',0,'/services',4,NULL,18,79),
(193,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX','http://localhost:8080/services','2026-08-27 14:38:22',0,'/services',5,NULL,21,79),
(194,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX','http://localhost:8080/services','2026-08-27 14:45:55',0,'/services',6,NULL,21,79),
(195,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:46:31',0,NULL,1,NULL,NULL,90),
(196,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:46:31',0,NULL,1,NULL,NULL,91),
(197,'/page/tarifs','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:46:31',0,NULL,1,NULL,NULL,92),
(198,'/contact','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:46:31',0,NULL,1,NULL,NULL,93),
(199,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 14:46:31',0,NULL,1,NULL,NULL,94),
(200,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:07:28',0,NULL,1,NULL,NULL,95),
(201,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:07:29',0,NULL,1,NULL,NULL,96),
(202,'/service/droit-public','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:07:29',0,NULL,1,NULL,NULL,97),
(203,'/page/tarifs','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:07:29',0,NULL,1,NULL,NULL,98),
(204,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:07:29',0,NULL,1,NULL,NULL,99),
(205,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 15:07:37',0,'/services',7,NULL,59,79),
(206,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:08:57',0,NULL,1,NULL,NULL,100),
(207,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:09',0,NULL,1,NULL,NULL,101),
(208,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:09',0,NULL,1,NULL,NULL,102),
(209,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:09',0,NULL,1,NULL,NULL,103),
(210,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:09',0,NULL,1,NULL,NULL,104),
(211,'/service/droit-famille-patrimonial','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:10',0,NULL,1,NULL,NULL,105),
(212,'/page/tarifs','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:10',0,NULL,1,NULL,NULL,106),
(213,'/contact','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:10',0,NULL,1,NULL,NULL,107),
(214,'/article/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:10',0,NULL,1,NULL,NULL,108),
(215,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:10:24',0,NULL,1,NULL,NULL,109),
(216,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX','http://localhost:8080/service/droit-immobilier','2026-08-27 15:12:42',0,'/service/droit-immobilier',8,NULL,45,79),
(217,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 15:13:51',0,'/service/droit-immobilier',9,NULL,21,79),
(218,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 15:15:51',0,'/services',10,NULL,45,79),
(219,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36',NULL,'2026-08-27 15:20:12',0,'/service/droit-immobilier',11,NULL,32,79),
(220,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:50:06',0,NULL,1,NULL,NULL,110),
(221,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 15:50:11',0,NULL,1,NULL,NULL,111),
(222,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 15:50:20',0,NULL,1,NULL,22,112),
(223,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 15:51:16',0,'/services',2,NULL,21,112),
(224,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 16:06:57',0,'/services',3,NULL,21,112),
(225,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 16:07:41',0,'/services',4,NULL,21,112),
(226,'/services','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 16:08:03',0,'/services',5,NULL,21,112),
(227,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 16:08:03',0,'/services',6,NULL,47,112),
(228,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36',NULL,'2026-08-27 16:08:15',0,'/service/droit-immobilier',7,NULL,33,112),
(229,'/service/droit-immobilier','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',NULL,'2026-08-27 16:12:48',0,'/service/droit-immobilier',8,NULL,56,112),
(230,'/page/politique-confidentialite','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 16:45:56',0,NULL,1,NULL,NULL,113),
(231,'/page/mentions-legales','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 16:45:56',0,NULL,1,NULL,NULL,114),
(232,'/page/politique-confidentialite','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 16:45:56',0,NULL,1,NULL,NULL,115),
(233,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 16:46:04',0,NULL,1,NULL,NULL,116),
(234,'/','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 17:05:01',0,NULL,1,NULL,NULL,117),
(235,'/page/politique-confidentialite','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 17:21:10',0,NULL,1,NULL,NULL,118),
(236,'/page/politique-confidentialite','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 17:21:10',0,NULL,1,NULL,NULL,119),
(237,'/page/politique-confidentialite','6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',NULL,'2026-08-27 17:21:17',0,NULL,1,NULL,NULL,120),
(238,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-28 14:27:56',0,NULL,1,2,13,121),
(239,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-28 14:28:03',0,'/',2,NULL,90,121),
(240,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/login','2026-08-28 14:28:08',0,'/login',3,600,96,121),
(241,'/reset-password','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/login','2026-08-28 14:38:13',0,'/login',4,605,97,121),
(242,'/reset-password/check-email','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/reset-password','2026-08-28 14:38:19',0,'/reset-password',5,3,97,121),
(243,'/reset-password/reset','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-28 14:38:37',0,'/reset-password/check-email',6,15,94,121),
(244,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/reset-password/reset','2026-08-28 14:39:01',0,'/reset-password/reset',7,3,94,121),
(245,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:41:02',0,NULL,1,NULL,NULL,122),
(246,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:41:09',0,NULL,1,NULL,NULL,123),
(247,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController','2026-08-28 14:41:18',0,'/login',8,86,89,121),
(248,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:41:26',0,NULL,1,NULL,NULL,124),
(249,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:41:26',0,NULL,1,NULL,NULL,125),
(250,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:41:37',0,NULL,1,NULL,NULL,126),
(251,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0','http://localhost:8080/reset-password/check-email','2026-08-28 14:42:46',0,'/',9,100,89,121),
(252,'/login','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',NULL,'2026-08-28 14:44:33',0,'/',10,1043,90,121),
(253,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:37',0,NULL,1,NULL,NULL,127),
(254,'/services','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:37',0,NULL,1,NULL,NULL,128),
(255,'/contact','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:38',0,NULL,1,NULL,NULL,129),
(256,'/article/super-artcile','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:38',0,NULL,1,NULL,NULL,130),
(257,'/page/tarifs','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,131),
(258,'/service/droit-des-affaires','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,132),
(259,'/service/droit-famille-patrimonial','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,133),
(260,'/service/droit-immobilier','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,134),
(261,'/service/droit-public','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,135),
(262,'/service/formalites','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,136),
(263,'/page/mentions-legales','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,137),
(264,'/page/politique-confidentialite','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:39',0,NULL,1,NULL,NULL,138),
(265,'/page/tarifs','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:40',0,NULL,1,NULL,NULL,139),
(266,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:50',0,NULL,1,NULL,NULL,140),
(267,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:51',0,NULL,1,NULL,NULL,141),
(268,'/article/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:54:58',0,NULL,1,NULL,NULL,142),
(269,'/contact','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:55:17',0,NULL,1,NULL,NULL,143),
(270,'/contact','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:55:18',0,NULL,1,NULL,NULL,144),
(271,'/contact','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:55:27',0,NULL,1,NULL,NULL,145),
(272,'/contact','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 14:55:40',0,NULL,1,NULL,NULL,146),
(273,'/contact','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:03:55',0,NULL,1,NULL,NULL,147),
(274,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:03:55',0,NULL,1,NULL,NULL,148),
(275,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:03:56',0,NULL,1,NULL,NULL,149),
(276,'/page/expertises-introduction','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:13:56',0,NULL,1,NULL,NULL,150),
(277,'/mentions-legales','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:14:08',0,NULL,1,NULL,NULL,151),
(278,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:14:21',0,NULL,1,NULL,NULL,152),
(279,'/politique-de-confidentialite','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:14:36',0,NULL,1,NULL,NULL,153),
(280,'/page/expertises-introduction','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:15:04',0,NULL,1,NULL,NULL,154),
(281,'/page/expertises-introduction','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:15:04',0,NULL,1,NULL,NULL,155),
(282,'/services','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:15:04',0,NULL,1,NULL,NULL,156),
(283,'/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:18:19',0,NULL,1,NULL,NULL,157),
(284,'/services','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:18:19',0,NULL,1,NULL,NULL,158),
(285,'/contact','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:18:19',0,NULL,1,NULL,NULL,159),
(286,'/page/tarifs','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:18:20',0,NULL,1,NULL,NULL,160),
(287,'/article/','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:18:20',0,NULL,1,NULL,NULL,161),
(288,'/page/expertises-introduction','79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',NULL,'2026-08-28 15:18:21',0,NULL,1,NULL,NULL,162);
/*!40000 ALTER TABLE `page_view` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `reset_password_request`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `reset_password_request` WRITE;
/*!40000 ALTER TABLE `reset_password_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `reset_password_request` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_E19D9AD2989D9B62` (`slug`),
  KEY `IDX_E19D9AD23DA5256D` (`image_id`),
  KEY `IDX_E19D9AD2670E5B73` (`linked_page_id`),
  KEY `idx_service_active` (`is_active`),
  CONSTRAINT `FK_E19D9AD23DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_E19D9AD2670E5B73` FOREIGN KEY (`linked_page_id`) REFERENCES `page` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES
(1,'Droit immobilier','droit-immobilier','Vous expliquer la procédure dans le cadre d’un premier achat, vous rassurer sur le bien avec une analyse approfondie du dossier, ou vous conseiller sur les aspects techniques et fiscaux si vous êtes investisseur.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"L’étude accompagne chacun dans la réalisation de son projet immobilier, en toute sécurité et efficacité.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Nos interventions\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Vente immobilière : terrains à bâtir, parcelles agricoles, copropriété, maison, immeuble entier\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avant-contrats : promesse unilatérale d’achat, promesse unilatérale de vente, promesse synallagmatique de vente\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Acte final de vente\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Prises de garanties : hypothèque, cautionnement, hypothèque légale spéciale de prêteur de deniers\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Baux d’habitation, bail rural, bail emphytéotique, bail à construction\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Mise en copropriété, refonte, scission de copropriété\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Création de servitudes\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Vente en l’état futur d’achèvement\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Création de lotissements\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Location-accession\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Substitution SAFER\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Échange\"}]}]}','<p>L’étude accompagne chacun dans la réalisation de son projet immobilier, en toute sécurité et efficacité.</p><h3>Nos interventions</h3><ul><li>Vente immobilière : terrains à bâtir, parcelles agricoles, copropriété, maison, immeuble entier</li><li>Avant-contrats : promesse unilatérale d’achat, promesse unilatérale de vente, promesse synallagmatique de vente</li><li>Acte final de vente</li><li>Prises de garanties : hypothèque, cautionnement, hypothèque légale spéciale de prêteur de deniers</li><li>Baux d’habitation, bail rural, bail emphytéotique, bail à construction</li><li>Mise en copropriété, refonte, scission de copropriété</li><li>Création de servitudes</li><li>Vente en l’état futur d’achèvement</li><li>Création de lotissements</li><li>Location-accession</li><li>Substitution SAFER</li><li>Échange</li></ul>',NULL,NULL,10,1,10,NULL,NULL,NULL,NULL,0,NULL),
(2,'Droit de la famille et patrimonial','droit-famille-patrimonial','Au-delà de la rédaction de contrats, notre mission de conseil est essentielle pour vous accompagner dans les moments importants et réaliser le meilleur choix possible, tant sur le plan personnel que fiscal.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Appréhender vos contraintes pour vous permettre de décider en connaissance de cause, sur le plan personnel comme fiscal.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Nos interventions\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Donation simple, donation-partage, démembrement\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Succession, partage amiable, partage judiciaire\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Convention de quasi-usufruit\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Changement de régime matrimonial, contrat de mariage\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Licitation\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Testament\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"PACS, divorce, adoption, PMA\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Mandat de protection future, mandat à effet posthume\"}]}]}','<p>Appréhender vos contraintes pour vous permettre de décider en connaissance de cause, sur le plan personnel comme fiscal.</p><h3>Nos interventions</h3><ul><li>Donation simple, donation-partage, démembrement</li><li>Succession, partage amiable, partage judiciaire</li><li>Convention de quasi-usufruit</li><li>Changement de régime matrimonial, contrat de mariage</li><li>Licitation</li><li>Testament</li><li>PACS, divorce, adoption, PMA</li><li>Mandat de protection future, mandat à effet posthume</li></ul>',NULL,NULL,20,1,11,NULL,NULL,NULL,NULL,0,NULL),
(3,'Formalités','formalites','La prise en charge des démarches et des formalités qui accompagnent vos actes, jusqu’à leur aboutissement.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"L’étude prend en charge les formalités liées à vos dossiers et en assure le suivi jusqu’à leur terme.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Nos interventions\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Formalités de successions\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Formalités commerciales\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Autorisations d’urbanisme\"}]}]}','<p>L’étude prend en charge les formalités liées à vos dossiers et en assure le suivi jusqu’à leur terme.</p><h3>Nos interventions</h3><ul><li>Formalités de successions</li><li>Formalités commerciales</li><li>Autorisations d’urbanisme</li></ul>',NULL,NULL,30,1,12,NULL,NULL,NULL,NULL,0,NULL),
(4,'Droit des affaires','droit-des-affaires','Notre expertise au service des professionnels nous permet de vous proposer des solutions juridiques et fiscales au plus près de vos besoins et de vos intérêts.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"De la constitution de votre société à sa transmission, l’étude vous accompagne à chaque étape de la vie de votre entreprise.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Nos interventions\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Statuts, mise en activité\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cession de fonds : commerce, artisanal, agricole\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Cession d’entreprise (titres sociaux)\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Bail commercial\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Pacte Dutreil\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Transmission universelle de patrimoine\"}]}]}','<p>De la constitution de votre société à sa transmission, l’étude vous accompagne à chaque étape de la vie de votre entreprise.</p><h3>Nos interventions</h3><ul><li>Statuts, mise en activité</li><li>Cession de fonds : commerce, artisanal, agricole</li><li>Cession d’entreprise (titres sociaux)</li><li>Bail commercial</li><li>Pacte Dutreil</li><li>Transmission universelle de patrimoine</li></ul>',NULL,NULL,40,1,13,NULL,NULL,NULL,NULL,0,NULL),
(5,'Droit public','droit-public','L’accompagnement des collectivités et des établissements publics dans leurs opérations patrimoniales.','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"L’étude intervient auprès des acteurs publics du territoire pour sécuriser leurs opérations.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Nos interventions\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Fusion d’établissements publics de coopération intercommunale\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ventes et acquisitions par les collectivités\"}]}]}','<p>L’étude intervient auprès des acteurs publics du territoire pour sécuriser leurs opérations.</p><h3>Nos interventions</h3><ul><li>Fusion d’établissements publics de coopération intercommunale</li><li>Ventes et acquisitions par les collectivités</li></ul>',NULL,NULL,50,1,14,NULL,NULL,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `site`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `site` WRITE;
/*!40000 ALTER TABLE `site` DISABLE KEYS */;
INSERT INTO `site` VALUES
(1,'Maître Bruno Mainguy, notaire à Saint-Martory','Office notarial — Saint-Martory','bruno.mainguy@31061.notaires.fr','Saint-Martory','31360','379 Rue des Villas',NULL,'documents/medias/carte-maitre-bruno-mainguy-notaire-a-saint-martory.webp','0561902040','Maître Bruno Mainguy — Notaire à Saint-Martory','Office notarial BM NOTAIRE à Saint-Martory (31) : immobilier, famille, patrimoine, entreprise. Anticiper les événements de votre vie en toute sérénité.',NULL,NULL,'#273133','#6B7576','#273133','\'Inter\', sans-serif','\'Vidaloka\', serif','corporate','ttc','[\"vitrine\",\"blog\",\"services\",\"faq\",\"marketing\"]',NULL,NULL,NULL,6,NULL,8,9,NULL,NULL,5,NULL,'ProfessionalService',NULL,'Lu-Ve 09:00-12:00\nLu-Ve 14:00-18:00',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `site` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `stat_conversion`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `stat_conversion` WRITE;
/*!40000 ALTER TABLE `stat_conversion` DISABLE KEYS */;
/*!40000 ALTER TABLE `stat_conversion` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stat_session`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `stat_session` WRITE;
/*!40000 ALTER TABLE `stat_session` DISABLE KEYS */;
INSERT INTO `stat_session` VALUES
(1,'1c74b264797bf31058864739b0766150b548e4d61568e5c79556646279aeef56','2026-08-25 08:39:15','2026-08-25 08:39:15','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(2,'7ec3780fe276652ad81aae79df08a472ca9e5ae131a09aafff2b0afa7fe627a3','2026-08-25 08:39:16','2026-08-25 08:39:16','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(3,'0d87e553829532b35f89e9f8a870699f5e5f47ce667e70ed1258fe3a67a58c06','2026-08-25 08:39:56','2026-08-25 10:41:17','direct',NULL,NULL,NULL,'/','/services',28,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',0,'desktop'),
(4,'044b6312a49250b877548f822c98a8ea8da74f10e299d506ec247ffdc9444a95','2026-08-25 08:44:12','2026-08-25 10:03:36','direct',NULL,NULL,NULL,'/','/login',33,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',0,'desktop'),
(5,'ac563732b076f9317f71c2006331b875c659db5d1b7886824f6f26feac51729d','2026-08-25 08:47:52','2026-08-25 08:47:52','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(6,'01784ba2797bda98db35c636abd30b6397c074a17c04de71e23d0d8449a27361','2026-08-25 08:47:52','2026-08-25 08:47:52','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(7,'4cda7d7754d44f71a81789e8e96716cba1712caeb4c6155a6bc5546dd4131ef2','2026-08-25 08:47:52','2026-08-25 08:47:52','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(8,'56f3049371a4dd137489549dfedfd2f7df680973e6c8fbd196df691eab6841be','2026-08-25 08:58:01','2026-08-25 08:58:01','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(9,'0b2a517d03e3043ec9213b59f5bdcb915c30a5ceedc486b16b42038f4b000802','2026-08-25 09:02:30','2026-08-25 09:02:30','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(10,'06f44165f413f3290a7ac5cf1ce0a7fc5c49fa3558dd37931448c5018d76ae5e','2026-08-25 09:19:23','2026-08-25 09:19:23','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(11,'1427e2787f18f0bf098239477d8e99855b8112d62c5f2f51be456895e83edb41','2026-08-25 09:19:24','2026-08-25 09:19:24','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(12,'3df8ae861f2a25b0ccf8e7a6fd619aca4b124688a681deed1498e25c50d5d287','2026-08-25 09:24:51','2026-08-25 09:24:51','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(13,'8fb137a5798edffb8ca5b261b53d41b7b03b776c79c4b96d61a66a5a032853a3','2026-08-25 09:32:05','2026-08-25 09:32:05','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(14,'a910e7977f31080bdfd394ebd03c30dd6e0fbae89f59b34d09e4607f423cadd4','2026-08-25 09:32:13','2026-08-25 09:32:13','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(15,'6179077bf0c8565f2912bc24c1aa7790c44fcdd34f56a9af9992901b6524ed97','2026-08-25 09:36:19','2026-08-25 09:36:19','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(16,'faeed51ec6b7574ad18b1a7ecdac57688d721d574fe0289b36bec1710c924fb8','2026-08-25 09:38:09','2026-08-25 09:38:09','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(17,'78eea49346b26666ac6859814a3fa022b13626e8065b320a7f2b091d51447d10','2026-08-25 09:38:09','2026-08-25 09:38:09','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(18,'3dd4832a67042bc4145bbed0959067ee453eb65ebd598a91ec4bf4ca63265d1f','2026-08-25 09:50:53','2026-08-25 09:50:53','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(19,'3cd5e6fc1f2d490839d0748f28bce7a08a2143b720be99dd746a85a748d1cec9','2026-08-25 09:50:53','2026-08-25 09:50:53','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(20,'193491a4a86982f7d1537ebe08f884b83ab00c47e9c0cbbaaeffcf9da6d78c20','2026-08-25 09:52:05','2026-08-25 09:52:05','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(21,'c5806458fd1e424836ce0a872e919f7582fc4f0b39c588c67c9a88f51d377bc1','2026-08-25 10:23:37','2026-08-25 10:23:37','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(22,'72ab3f1204f20dad5da78ab338877a0f54b4be31cbd8b5a54d3628c27daa347a','2026-08-25 10:23:38','2026-08-25 10:23:38','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(23,'aea208577ce0daaafe9d2847bbd7f5d82d07c9c0b2aaa7d23e4ce1b4409fe299','2026-08-25 10:23:38','2026-08-25 10:23:38','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(24,'30055bb2480637f79d82a63a5084dfeff16de881427c039b9d97f5b75bafc15c','2026-08-25 10:24:17','2026-08-25 10:24:17','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(25,'ffb124140c1cfd6c0d91a20fff0048af1e8f1cbabe993bc077d3d84b2e1e75e9','2026-08-25 10:25:31','2026-08-25 10:25:31','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(26,'1640833cb4244ef4bcde4e328b82340295a1939f123e921e51ada291dffb6a60','2026-08-25 10:25:31','2026-08-25 10:25:31','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(27,'8f4176a5baa85365b93f074fde0fd7638caa494203353c4322006bba65e789d7','2026-08-25 10:25:31','2026-08-25 10:25:31','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(28,'bf6224c5e14075396c59df33391030ec030c5bd74e735a54bbb66a4d6e1b6895','2026-08-25 10:25:32','2026-08-25 10:25:32','direct',NULL,NULL,NULL,'/service/vente-immobiliere','/service/vente-immobiliere',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(29,'09b486edd1e25fc8f95b746f9781e0385b0ef9a32a3af4e3777b26ce091ce956','2026-08-25 10:25:32','2026-08-25 10:25:32','direct',NULL,NULL,NULL,'/service/conseil-patrimonial','/service/conseil-patrimonial',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(30,'64718b94e16556ce3331d395a6a53c2f1d3edd2c4c1c1235408475b74dac660f','2026-08-25 10:25:32','2026-08-25 10:25:32','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(31,'b2cfc439ea634a4d3053b1c7a9ce30bfd18eddb5b1c6d1b9feb06ef67bdcaae5','2026-08-25 10:25:32','2026-08-25 10:25:32','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(32,'08a5d2ef12c35d126c6fa29290ad67b9d476a476611b1daca76ba914a50e4819','2026-08-25 10:35:27','2026-08-25 10:35:27','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(33,'1174c74073da7dbee03608dba61362ac164e69e66dbee6b98203fe322f21ee43','2026-08-25 10:35:27','2026-08-25 10:35:27','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(34,'80989f84a1b0b50e31cd6b170e14f37b6b196c269439ccd6834721137c3f199f','2026-08-25 10:37:27','2026-08-25 10:37:27','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(35,'c842cc0cd8306b1f937d68daed60758e0bd268a3c43e58a59100faab43500b18','2026-08-25 10:37:35','2026-08-25 10:37:35','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(36,'a42bd340ded9f6b8c809430c2b66830832df8b0a3eeee9d9da1f4786a9d928b3','2026-08-25 10:37:36','2026-08-25 10:37:36','direct',NULL,NULL,NULL,'/page/expertises-introduction','/page/expertises-introduction',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(37,'dcbb0b1b05201c256a938ce90ddad7111c20a4d8e19aeb12095cae75306dc9a0','2026-08-25 10:37:36','2026-08-25 10:37:36','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(38,'2c18f19c975cc5db995b34dd0d26275ece548b9248f01ad9e9559c1fca68f768','2026-08-25 10:37:36','2026-08-25 10:37:36','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(39,'a7871d6ea44f7efff52fbe520d6cd8b536ec9ec8173d0fc1c818a063a48a819f','2026-08-25 10:38:52','2026-08-25 10:38:52','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(40,'e8324a35cffef6e5e23fbc0110fd2d83726e38da15ceb90153398ed79afbcee3','2026-08-25 10:38:52','2026-08-25 10:38:52','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(41,'ce77678d4473cdebfe07a1d67bb5598ff53c11f01156837be40c7ea105f5ee69','2026-08-25 10:40:57','2026-08-25 10:40:57','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(42,'4cc777684c3ef66ebbc0b7565ab6fd97ebbaff089281352c809ea1518975b7a3','2026-08-25 10:41:35','2026-08-25 10:41:35','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(43,'939c78c1f7276ef5c5ad33d5c9b100e02ab069c9effdceae94747ce8c9468b0c','2026-08-25 10:41:35','2026-08-25 10:41:35','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(44,'d4351da4661534819cd974f6a8160992b23332318643e01d7214465d4f906d2e','2026-08-25 10:41:35','2026-08-25 10:41:35','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(45,'4639e0194b3afeb6b91308d77b371d64cd3282732022162f976f7d09dabbe99c','2026-08-25 10:41:35','2026-08-25 10:41:35','direct',NULL,NULL,NULL,'/service/vente-immobiliere','/service/vente-immobiliere',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(46,'ebd48a6d9716ede9965680c0e4784e7e61995356db357aa36715cd3f8acc01c0','2026-08-25 10:41:35','2026-08-25 10:41:35','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(47,'d5c55f4f7ecd4b8d5145b4ff1b9ab7cbc23226de587e0e552cdda4975954bfd4','2026-08-25 10:44:58','2026-08-25 10:44:58','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(48,'3387adbe51a679de7f2727f3a4b80488a65aa4f88fe3e09d7df859ad061454ce','2026-08-25 10:44:58','2026-08-25 10:44:58','direct',NULL,NULL,NULL,'/page/mentions-legales','/page/mentions-legales',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(49,'cebf08660d5e014e075ebfd9b52dea79b01bfd4db7a8ec1107423b08ff60973e','2026-08-25 10:45:17','2026-08-25 10:45:17','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(50,'fb7881a9c8bda50a018d1dd7c342cf80868cb328c7349d7ef1bcc9720332041c','2026-08-25 10:45:17','2026-08-25 10:45:17','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(51,'c1950b1d89f67c186241de349893adaec9ded8f82e014d047c815e9eec707224','2026-08-25 10:45:18','2026-08-25 10:45:18','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(52,'24b87a4546685d2a5da71bc290a71e4e14ef15e43eb8769e731bc8eb32d2df58','2026-08-25 10:45:39','2026-08-25 10:45:39','direct',NULL,NULL,NULL,'/article/','/article/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(53,'d9015170ea1c920488c61ab6ec8a2cd7f30082e10f00e6ffc16f2449d5eff042','2026-08-25 10:45:39','2026-08-25 10:45:39','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(54,'6c4165546120839fa1325e500fc532b215dbb955b31c71f4ce988ef366488d5f','2026-08-25 10:45:40','2026-08-25 10:45:40','direct',NULL,NULL,NULL,'/','/',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(55,'48e56e2c0968bad4548b2057695da274cd650ef1fd252c4a3517b1b1f84ecca6','2026-08-25 10:45:40','2026-08-25 10:45:40','direct',NULL,NULL,NULL,'/services','/services',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(56,'4a0f6398ab4f30f06aa15bd9263b17f847b897cfd74a545fb24bbbdd3a3dbf01','2026-08-25 11:23:50','2026-08-25 11:23:50','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(57,'2280f7cc164f24913245e66fac217ba212e4440b70f29701059a6b417676150a','2026-08-25 11:24:42','2026-08-25 12:03:56','direct',NULL,NULL,NULL,'/services','/contact',17,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',0,'desktop'),
(58,'2a58e74ffd2494ef499807a095bcdcbf5585f040a58e1d67900ff538949d17b8','2026-08-25 11:57:40','2026-08-25 11:57:40','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(59,'9b2e14dd18d95504d08163e4049fadf0324a1b55bd3ecf149ab2f89b50ee1b59','2026-08-25 12:03:22','2026-08-25 12:03:22','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(60,'7446befb497e914f4348162fafb5b863636a443c38b49a851d70905ec1cb6e18','2026-08-25 12:03:36','2026-08-25 12:03:36','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(61,'27854d5eb1cd0091ab65b3beddc47ad75c8fe9eacb20eda221044bf801d13704','2026-08-25 12:03:46','2026-08-25 12:03:46','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(62,'596ec5b89bc9ebbe67ff2e40deff1a32fe1c2ee20b668e362460e6c02c6c4665','2026-08-25 14:06:04','2026-08-25 14:06:04','direct',NULL,NULL,NULL,'/contact','/contact',1,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','curl/8.11.0',0,'desktop'),
(63,'25d5f90a723cadff1333d340c5a2d8d57826b2727f883e6cf47b760ad58523bb','2026-08-25 14:26:57','2026-08-25 15:03:16','direct',NULL,NULL,NULL,'/','/',4,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',0,'desktop'),
(64,'12b5340630e039213e5b8166c0610099886673ca0cd1096e69495af691fc9de9','2026-08-25 14:27:47','2026-08-25 14:29:05','direct',NULL,NULL,NULL,'/','/',2,'727ea457bd819d9635be30790840af69bd27c89dcbc283cfdcff848cff864f1f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.34493.1 Chrome/148.0.7778.280 Electron/42.9.2 Safari/537.36 MSIX',0,'desktop'),
(65,'2af15e3152453df568541d9c4dbc44567cb2908602cee3bf6531d0220db13330','2026-08-26 14:14:54','2026-08-26 14:14:54','direct',NULL,NULL,NULL,'/','/',1,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',0,'desktop'),
(66,'2123422b17386625b9f43c285c30094d61ffda6c2aa2352cb2b7c69c50ef893c','2026-08-26 14:14:54','2026-08-26 14:14:54','direct',NULL,NULL,NULL,'/','/',1,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',0,'desktop'),
(67,'b7e25de27d0243df10cbc663cad93042f13518d9a4239db4c6587937acb44031','2026-08-26 14:14:54','2026-08-26 14:14:54','direct',NULL,NULL,NULL,'/services','/services',1,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',0,'desktop'),
(68,'b9fe1a59409787fd7ffa7befbb9165aa43af0b98d456a074299dc99a5e466cdb','2026-08-26 14:14:55','2026-08-26 14:14:55','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',0,'desktop'),
(69,'1a3df5b569319da478c5dd2d666fd533948e982719d8b715b89c2b201c2ab688','2026-08-26 14:14:55','2026-08-26 14:14:55','direct',NULL,NULL,NULL,'/contact','/contact',1,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',0,'desktop'),
(70,'d9165f65ee34a6de8c7010c6e26e80a0c9dde14e589b9fab215de8caecdc5e3c','2026-08-26 14:14:55','2026-08-26 14:14:55','direct',NULL,NULL,NULL,'/article/','/article/',1,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','curl/8.11.0',0,'desktop'),
(71,'9861692faf736088e21c4efb1b2a05deaa2f91a35173202eb021b846b3421c32','2026-08-26 14:20:10','2026-08-26 14:45:37','direct',NULL,NULL,NULL,'/','/login',19,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',0,'desktop'),
(72,'2c5b50dc9c60066858c8fd13ee1cfce926895b7696b8930f4f7afa35bc7426e0','2026-08-26 14:51:48','2026-08-26 14:54:54','referral','http://localhost:8080/mentions-legales',NULL,NULL,'/article/','/login',4,'a126c207e339219bc0e3fedd652bb384baaa52264182023d5f86c6e9ff086de1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',0,'desktop'),
(73,'05cee17154bd2c1a7d64fb8b5f65ad313d3263254b7688fafdefb840687089b7','2026-08-27 13:57:37','2026-08-27 13:57:37','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(74,'e72eacf6b76d2ceeca70f957624ae65fdad94ac731b826bc3e1fb91dd07cfcfd','2026-08-27 13:57:37','2026-08-27 13:57:37','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(75,'4d946a82780e05720eb915a5b9b79a5854b0cb6fbb887f7b03e21f9108e99675','2026-08-27 13:57:37','2026-08-27 13:57:37','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(76,'8af11e41eb066f1a7bb9704f2311bfbb4e550b70627cb40fd55172598f1b222f','2026-08-27 13:57:38','2026-08-27 13:57:38','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(77,'3a69c5a7495b99393b17968576450747d9b188177886232adfa6d1902e031c32','2026-08-27 13:57:38','2026-08-27 13:57:38','direct',NULL,NULL,NULL,'/service/droit-public','/service/droit-public',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(78,'d426a8360905e8a48c8317444a72559cf8eafca0491960f912b1efcbd46e2542','2026-08-27 13:57:38','2026-08-27 13:57:38','direct',NULL,NULL,NULL,'/contact','/contact',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(79,'6d45e1941dd4a133cf0c48a94d4351f6afcf6971bb6d7e63f3f89775fb25614e','2026-08-27 13:58:09','2026-08-27 15:20:12','direct',NULL,NULL,NULL,'/','/service/droit-immobilier',11,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',0,'desktop'),
(80,'7db1ebb94dd2c8d72581104785f4e9f852b44215cfe84f2b2ba56f06edff3f41','2026-08-27 14:19:03','2026-08-27 14:19:03','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(81,'742e0230cd0638680f18e2c006ed0a40dcf2b60b51ba2b96b6b10e3de2cf5a55','2026-08-27 14:21:52','2026-08-27 14:21:52','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(82,'60ec104a9e6c38bcc0fce85c42f40c33da663ebd59e774a1bcd699dffb6ebeb1','2026-08-27 14:21:53','2026-08-27 14:21:53','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(83,'866760d67ce0e831cf03307f014f0a851c5fd0342d5ba55b87ff8bfb439d16b8','2026-08-27 14:22:54','2026-08-27 14:22:54','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(84,'24321017829f8a4922e8e3495becccb157d31a00c7d84a8c19fb067e76032c70','2026-08-27 14:22:54','2026-08-27 14:22:54','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(85,'f3a3e69bf56b31e4de9bc4ea422e4f7580362e9eb5895d603fa949790ab6706b','2026-08-27 14:22:54','2026-08-27 14:22:54','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(86,'1f4a6d358073f61ffbfc80fe6cc182d0a21d038b2d70a5cd4b3d9871150d25ca','2026-08-27 14:22:54','2026-08-27 14:22:54','direct',NULL,NULL,NULL,'/contact','/contact',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(87,'8d839fdcc20d253c5171ee793470f1cd1a4726ecdb4cadfd6573a42f5b9c5034','2026-08-27 14:22:54','2026-08-27 14:22:54','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(88,'ed0ee3bafb66e6778a1e1b10fd1b32cecaf2d9b9e7770d414bfc53e2584c495d','2026-08-27 14:27:17','2026-08-27 14:27:17','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(89,'698ecd34b0d53ed3b28f039969025d35bf88e67784496f685294aa5c1d9a7f95','2026-08-27 14:28:16','2026-08-27 14:28:16','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(90,'d480ce1520c861ac6c768da0df00f21db1a8e5da5a7f67079ae769a6bb7c5058','2026-08-27 14:46:31','2026-08-27 14:46:31','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(91,'b5f3ca53e7502972132b0465da88f8da83f8ecb0a8877f0ce57981c552110367','2026-08-27 14:46:31','2026-08-27 14:46:31','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(92,'194671303f08ffb3354f322d656a3c4f14cbe620b671723e483224c268eadce8','2026-08-27 14:46:31','2026-08-27 14:46:31','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(93,'df63673c70cd67e5f2af450cc6320cf5b3183841398e01757c4679fa94c24e83','2026-08-27 14:46:31','2026-08-27 14:46:31','direct',NULL,NULL,NULL,'/contact','/contact',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(94,'37268f4ca4a55e9cd537ad5579206225b13b954f82f744bd2b3fa58dd1d9bf9f','2026-08-27 14:46:31','2026-08-27 14:46:31','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(95,'db27fa02804e8bcd9f5cb49d3e9198dab1cbf16dd9bffdad6dc46f7f42cc2716','2026-08-27 15:07:28','2026-08-27 15:07:28','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(96,'08e6d5cca469077eb73360019fa5f57004a2eb9573da0efed8029679f352e061','2026-08-27 15:07:29','2026-08-27 15:07:29','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(97,'8567d4c89c595efc2eb1031b4f903bda0b46a9eaace5ff9205f0123f7b17c9aa','2026-08-27 15:07:29','2026-08-27 15:07:29','direct',NULL,NULL,NULL,'/service/droit-public','/service/droit-public',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(98,'5595564e487018fc3d310f5a0bc1e0cde8a95c940a83a0b064e7eda14365e777','2026-08-27 15:07:29','2026-08-27 15:07:29','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(99,'90063dca0dfa2b28429e590aaf31114ba1d91328012a07ca73b0ffed6811b408','2026-08-27 15:07:29','2026-08-27 15:07:29','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(100,'18a0ec61c64840342086feb5296e2afb8d4bebda2e846daa3e8eb09fa57b17a9','2026-08-27 15:08:57','2026-08-27 15:08:57','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(101,'8b6a09ab62b203d05b37fe356387fd47cdc86917662e15c7164d34548214fcd0','2026-08-27 15:10:09','2026-08-27 15:10:09','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(102,'7bb4dbf9bd2baf8e0666dd63362a715b22e90af56239efa1318202c138be0899','2026-08-27 15:10:09','2026-08-27 15:10:09','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(103,'586a86fc39a0fdd88a6a2604598eaad7fa1a228db114e6dfd6d53ef5343558ec','2026-08-27 15:10:09','2026-08-27 15:10:09','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(104,'cf69c049bdf4812a3a867e41134fd71a27e6d5071b44e0be95cc3ce79fbdb1a3','2026-08-27 15:10:09','2026-08-27 15:10:09','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(105,'d65547dd0ef3cbef4e9d15ef63e321e4420f99b29db989386d55a008c949215f','2026-08-27 15:10:10','2026-08-27 15:10:10','direct',NULL,NULL,NULL,'/service/droit-famille-patrimonial','/service/droit-famille-patrimonial',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(106,'3c795b71e2c8a39648026044aec00b60c02cc5a0c3aa996fa4c66598036767d8','2026-08-27 15:10:10','2026-08-27 15:10:10','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(107,'8f31fab8e0dc419164f1546fe3e45558732a2ad339f6b2532adb54c45ed10b7c','2026-08-27 15:10:10','2026-08-27 15:10:10','direct',NULL,NULL,NULL,'/contact','/contact',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(108,'d9d537c6b7591da0ff7591966fa01e45ceb4358c5e6e51e5670a34002453c052','2026-08-27 15:10:10','2026-08-27 15:10:10','direct',NULL,NULL,NULL,'/article/','/article/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(109,'781d5e0359bb9bd4d2a1655705c1cf6f55cd411aca1224421aae793998aacb41','2026-08-27 15:10:24','2026-08-27 15:10:24','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(110,'99cf689eabfaabad37b1c18e0320b8a72612f371c838b40a3deffb2c7e8b2ec1','2026-08-27 15:50:06','2026-08-27 15:50:06','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(111,'a19fd10c2f35fd391f1c368e0ecc6065e091c15dc2476d7eeb378f500ed9c1c1','2026-08-27 15:50:11','2026-08-27 15:50:11','direct',NULL,NULL,NULL,'/services','/services',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(112,'a02f839fcc065b80533349ea753ab4ec5488d456ee36867dad9416020eb70793','2026-08-27 15:50:20','2026-08-27 16:12:48','direct',NULL,NULL,NULL,'/services','/service/droit-immobilier',8,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Claude/1.37937.3 Chrome/148.0.7778.280 Safari/537.36 MSIX',0,'desktop'),
(113,'3c6d202ecc8f5c8c84ae679620acec8e1a5d7e21b3c5334f32bcd5ab5e73a2ec','2026-08-27 16:45:56','2026-08-27 16:45:56','direct',NULL,NULL,NULL,'/page/politique-confidentialite','/page/politique-confidentialite',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(114,'1813205d2f14d93e82c7da0880d120be321e4d670dc80793adbde025df866a0c','2026-08-27 16:45:56','2026-08-27 16:45:56','direct',NULL,NULL,NULL,'/page/mentions-legales','/page/mentions-legales',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(115,'0290e89a55b5aaa24a4273759c2c14aaafd02dab98924d71b50f29bd04591f7a','2026-08-27 16:45:56','2026-08-27 16:45:56','direct',NULL,NULL,NULL,'/page/politique-confidentialite','/page/politique-confidentialite',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(116,'de201b5fbd39c7f04c3e64a7a04a05019322feb6fd95c836393252852c71e5f2','2026-08-27 16:46:04','2026-08-27 16:46:04','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(117,'3a0207716c3fe5ea836e08b39c75a1bcd65d936cdbda0f5e83cacbdac80e470c','2026-08-27 17:05:01','2026-08-27 17:05:01','direct',NULL,NULL,NULL,'/','/',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(118,'11ca478440ea42056899d2c87b684173cde55606386731cd0495b908f7fa2011','2026-08-27 17:21:10','2026-08-27 17:21:10','direct',NULL,NULL,NULL,'/page/politique-confidentialite','/page/politique-confidentialite',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(119,'2d9a4d574a3e697ed853e2125dac1caf3ff7bda4143815c70cf0da3264ac83b8','2026-08-27 17:21:10','2026-08-27 17:21:10','direct',NULL,NULL,NULL,'/page/politique-confidentialite','/page/politique-confidentialite',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(120,'988561e873269b63bd57f62df93dd9e1fa0c1601ed0ce22e9ae7f2d0e8a57f0a','2026-08-27 17:21:17','2026-08-27 17:21:17','direct',NULL,NULL,NULL,'/page/politique-confidentialite','/page/politique-confidentialite',1,'6b79e9300ba2efcdfca988f752fd228c7a6e40d120fc4fc63375ab905f10ca6f','curl/8.11.0',0,'desktop'),
(121,'ad5f053752f2189bda3b05858b18a041d3360cdb5e1836d2677f12675239c5a7','2026-08-28 14:27:56','2026-08-28 14:45:19','direct',NULL,NULL,NULL,'/','/login',10,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0',0,'desktop'),
(122,'4038e7461498df31a1e9259529461e08331d2dc50ecfc1092fc3ab01686fd1eb','2026-08-28 14:41:01','2026-08-28 14:41:01','direct',NULL,NULL,NULL,'/login','/login',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(123,'82ea893ed45f40f20d93d9a65075372fc1d1238f4e545f88b68cc0decd78d2fc','2026-08-28 14:41:09','2026-08-28 14:41:09','direct',NULL,NULL,NULL,'/login','/login',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(124,'ed4cd2e3e7912ffd9791db0068d4f6054268ad191564970851ce4c74cc534551','2026-08-28 14:41:26','2026-08-28 14:41:26','direct',NULL,NULL,NULL,'/login','/login',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(125,'57bbf109f5d7c6efe8a9a8176ee1fa49a16b8ec6930c617535a4b38c1fee6355','2026-08-28 14:41:26','2026-08-28 14:41:26','direct',NULL,NULL,NULL,'/login','/login',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(126,'42ecf5634edb2685873a2d88a4e71aaf4faab20b2218aa6e60986cc783cb4ec7','2026-08-28 14:41:37','2026-08-28 14:41:37','direct',NULL,NULL,NULL,'/login','/login',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(127,'3c9fcc338277863a5343f009f3411faa2f7d60fac7af1912e9153da737458d0c','2026-08-28 14:54:37','2026-08-28 14:54:37','direct',NULL,NULL,NULL,'/','/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(128,'6170b367a7e3ef213ee0177ff290567f59ca3ef36b0425c25a99f7d19b9b89c1','2026-08-28 14:54:37','2026-08-28 14:54:37','direct',NULL,NULL,NULL,'/services','/services',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(129,'65c9ae11641177df5f820bb73c42d55433dbe3e291a89c95d0a00daa8bb67278','2026-08-28 14:54:38','2026-08-28 14:54:38','direct',NULL,NULL,NULL,'/contact','/contact',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(130,'8da5359ba173edf956cf8b02faa1b7f8813552073aa959ae6b2277eb3d65d17e','2026-08-28 14:54:38','2026-08-28 14:54:38','direct',NULL,NULL,NULL,'/article/super-artcile','/article/super-artcile',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(131,'8b765e3c0e3a3f10e457c22699e7628a7e9b5d06403b8b7594f4a5a1d13954aa','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(132,'d16ec05d18681476a19173b96e27c6b5437b24e8faece7219428360084af6db4','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/service/droit-des-affaires','/service/droit-des-affaires',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(133,'53103bca43eeef65305254704a637ee30d22d7fb4c08bbd97782ae79d719e29e','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/service/droit-famille-patrimonial','/service/droit-famille-patrimonial',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(134,'d34a74510c541949fc63ef294159f888930dbb59cf3ffe8185c6f991f1237716','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/service/droit-immobilier','/service/droit-immobilier',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(135,'a845b86fa1f8375db658df4975c6f5750ff8acc471e42f8e3f6784e743954962','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/service/droit-public','/service/droit-public',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(136,'f2b27315ecb40d239f0aed9ae6415560a78f02a0a817e973172350b716c04d36','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/service/formalites','/service/formalites',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(137,'6427d07756fd9eccaa0f96fc2669b958cf162cc85c8b4243b64d9dc0bfe8d6d4','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/page/mentions-legales','/page/mentions-legales',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(138,'64aea1c199f979e39165ea45b176fa1913a3ec37970229ee573cc0f11dc265f4','2026-08-28 14:54:39','2026-08-28 14:54:39','direct',NULL,NULL,NULL,'/page/politique-confidentialite','/page/politique-confidentialite',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(139,'b8dce91f1274c0b3d9b27daabf6bcb5e2552d433ba6986e308cfca8ce49ed417','2026-08-28 14:54:40','2026-08-28 14:54:40','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(140,'6cb03ea8de076abb550273cadb90c651245bad7345b0ae726b93b88e30f6d564','2026-08-28 14:54:50','2026-08-28 14:54:50','direct',NULL,NULL,NULL,'/','/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(141,'1e09991774f0d357e56f7372c2f15e5b7148d99c38a1e3ce89c9d0d2314e4a3c','2026-08-28 14:54:51','2026-08-28 14:54:51','direct',NULL,NULL,NULL,'/','/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(142,'a005d48ff4ba30de25092d760fa5d3b67bc62e7e50cae259652b740d7976a7a4','2026-08-28 14:54:58','2026-08-28 14:54:58','direct',NULL,NULL,NULL,'/article/','/article/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(143,'cff4539bc3a63d25d89371a96fb4c4d72eb726165ab74402f4636355e304f4b0','2026-08-28 14:55:17','2026-08-28 14:55:17','direct',NULL,NULL,NULL,'/contact','/contact',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(144,'6687bf637a4847ffe22bae381b93ba4378675c84487e1ab3d209647cbec0265f','2026-08-28 14:55:18','2026-08-28 14:55:18','direct',NULL,NULL,NULL,'/contact','/contact',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(145,'d537884f706dd451ce071f34704d643187dfa3350e82faef0a720e1a2cba756e','2026-08-28 14:55:27','2026-08-28 14:55:27','direct',NULL,NULL,NULL,'/contact','/contact',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(146,'a00bd0bb03ede65b202839b31047ea67580cc316d11d49be98dec18e5dbad41c','2026-08-28 14:55:40','2026-08-28 14:55:40','direct',NULL,NULL,NULL,'/contact','/contact',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(147,'a6034fffd1c36951a733f5d343fcc24119e689384e6b456970a6ddd39586f03a','2026-08-28 15:03:55','2026-08-28 15:03:55','direct',NULL,NULL,NULL,'/contact','/contact',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(148,'aaf87bf490afa470c11abaed4df56beccc0676bd6f9ca357fda7c886f0413a78','2026-08-28 15:03:55','2026-08-28 15:03:55','direct',NULL,NULL,NULL,'/','/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(149,'fc4cf63100d3f0fef641a4ca85b7ddcaa687da5d9b3401a01cc0f12bf1b9021f','2026-08-28 15:03:56','2026-08-28 15:03:56','direct',NULL,NULL,NULL,'/','/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(150,'13814f4f822e0c55605d347246a99787e1aaaaea735088d36648578a28b0cbec','2026-08-28 15:13:56','2026-08-28 15:13:56','direct',NULL,NULL,NULL,'/page/expertises-introduction','/page/expertises-introduction',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(151,'29db845f16b974fb58236a88e8c1244187547e9f4e1739dce4468b4b2172a55e','2026-08-28 15:14:08','2026-08-28 15:14:08','direct',NULL,NULL,NULL,'/mentions-legales','/mentions-legales',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(152,'31cb5e47d892d97547a460041f307f1e8a8ebd334eac01ea7b26242a3e9391d8','2026-08-28 15:14:21','2026-08-28 15:14:21','direct',NULL,NULL,NULL,'/','/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(153,'5e5067ecb9434b77f368d34774237465434c80d935f33a5176eaeca017a5d8cb','2026-08-28 15:14:36','2026-08-28 15:14:36','direct',NULL,NULL,NULL,'/politique-de-confidentialite','/politique-de-confidentialite',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(154,'e9d55f465e8d408fe5cbfa4de8bbaeb64cccc857521d2d1e4f174be25ffb5e40','2026-08-28 15:15:04','2026-08-28 15:15:04','direct',NULL,NULL,NULL,'/page/expertises-introduction','/page/expertises-introduction',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(155,'23e943f0e4a858c0d90eb048cd17cb0957253329e51545710123da99aec3ca31','2026-08-28 15:15:04','2026-08-28 15:15:04','direct',NULL,NULL,NULL,'/page/expertises-introduction','/page/expertises-introduction',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(156,'f55e9d83fdbd5d7bb3c4e35483a05916f9a5c390b2ddbc9539b523e1b5020209','2026-08-28 15:15:04','2026-08-28 15:15:04','direct',NULL,NULL,NULL,'/services','/services',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(157,'4d08d738b55d4be17eff5b6dd84bf80df28d43dc6e4711397b6efae547bf8a46','2026-08-28 15:18:19','2026-08-28 15:18:19','direct',NULL,NULL,NULL,'/','/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(158,'d31c814ff5c1c7edc3f7e6b4662ba564e6c0ff19acc40f34a0142c78292281f2','2026-08-28 15:18:19','2026-08-28 15:18:19','direct',NULL,NULL,NULL,'/services','/services',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(159,'4d06aa9c26f497ea1f13233f8628806ea386ce4fbf5c7b1d4e9fd6d165728336','2026-08-28 15:18:19','2026-08-28 15:18:19','direct',NULL,NULL,NULL,'/contact','/contact',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(160,'4baa9e3840a042aa44f762da8d0e2251c7142f43c4f4de2f05c0853f55a631d2','2026-08-28 15:18:20','2026-08-28 15:18:20','direct',NULL,NULL,NULL,'/page/tarifs','/page/tarifs',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(161,'1fe845618589e98cd72a6d019f501a1ca1d561a1b28460d1de03e2731c6a75b5','2026-08-28 15:18:20','2026-08-28 15:18:20','direct',NULL,NULL,NULL,'/article/','/article/',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop'),
(162,'02343b8803205876adb9d4e109e7fd64217c97582af6cab2de833d54c866abe6','2026-08-28 15:18:21','2026-08-28 15:18:21','direct',NULL,NULL,NULL,'/page/expertises-introduction','/page/expertises-introduction',1,'79088805363567d7db79e2fe172a57188ce76537175c8645da19b65ece873e9c','curl/8.11.0',0,'desktop');
/*!40000 ALTER TABLE `stat_session` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
-- Dumping data for table `subscriber`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `subscriber` WRITE;
/*!40000 ALTER TABLE `subscriber` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriber` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
  `no_index` tinyint(1) NOT NULL DEFAULT 1,
  `canonical_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_389B783989D9B62` (`slug`),
  KEY `IDX_389B783C865A29C` (`tag_group_id`),
  CONSTRAINT `FK_389B783C865A29C` FOREIGN KEY (`tag_group_id`) REFERENCES `tag_group` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Dumping data for table `tag_page`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag_page` WRITE;
/*!40000 ALTER TABLE `tag_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_page` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`),
  KEY `IDX_8D93D64986383B10` (`avatar_id`),
  CONSTRAINT `FK_8D93D64986383B10` FOREIGN KEY (`avatar_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(1,'david@comwebsolutions.fr','[\"ROLE_SUPER_ADMIN\"]','$2y$13$2JjbUxVCIBuTZEo5dth7k.AHozOGGLqbLeY150qqOVnN8VfS3ed4m','','',1,NULL,NULL,NULL,NULL,0,NULL,0),
(2,'soumya.bouchaila@hotmail.fr','[\"ROLE_ADMIN\"]','$2y$13$XTIKGxA6oCOEWAg0Yi5uQ.0Rh810FMnQeqKZIfLeku12SG8xMOpSu','Bouchaila','Soumya',1,NULL,NULL,NULL,NULL,0,NULL,0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-08-28 13:40:05
