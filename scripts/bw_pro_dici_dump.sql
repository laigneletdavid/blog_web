/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bw_pro_dici
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `categorie` WRITE;
/*!40000 ALTER TABLE `categorie` DISABLE KEYS */;
INSERT INTO `categorie` VALUES
(1,'Portraits de pros','portraits-de-pros','#E2725B',NULL,NULL,NULL,0,NULL,NULL),
(2,'Conseils pratiques','conseils-pratiques','#41521F',NULL,NULL,NULL,0,NULL,NULL),
(3,'Vie du secteur','vie-du-secteur','#2C2C2C',NULL,NULL,NULL,0,NULL,NULL),
(4,'Coups de cœur','coups-de-coeur','#E2725B',NULL,NULL,NULL,0,NULL,NULL);
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
-- Dumping data for table `doctrine_migration_versions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `doctrine_migration_versions` WRITE;
/*!40000 ALTER TABLE `doctrine_migration_versions` DISABLE KEYS */;
INSERT INTO `doctrine_migration_versions` VALUES
('DoctrineMigrations\\Version20260327093858','2026-04-14 09:21:16',2581),
('DoctrineMigrations\\Version20260330175902','2026-04-14 09:21:18',54),
('DoctrineMigrations\\Version20260331051133','2026-04-14 09:21:18',856),
('DoctrineMigrations\\Version20260331120749','2026-04-14 09:21:19',34),
('DoctrineMigrations\\Version20260331134753','2026-04-14 09:21:19',21),
('DoctrineMigrations\\Version20260402035203','2026-04-14 09:21:19',233),
('DoctrineMigrations\\Version20260403055742','2026-04-14 09:21:19',87),
('DoctrineMigrations\\Version20260403093313','2026-04-14 09:21:19',120),
('DoctrineMigrations\\Version20260408055018','2026-04-14 09:21:20',33),
('DoctrineMigrations\\Version20260409085027','2026-04-14 09:21:20',17);
/*!40000 ALTER TABLE `doctrine_migration_versions` ENABLE KEYS */;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES
(1,'Logo Pro d\'Ici','logo-complet-lesprodici-0d68f447-c35b-438b-875f-b1608077270e.png','logo-complet-lesprodici-0d68f447-c35b-438b-875f-b1608077270e.webp'),
(2,'Pro D\'ici - Groupe','cercle-des-pro-0625-27102bc6-9baa-4fea-b06a-f79273fba3dd.jpg','cercle-des-pro-0625-27102bc6-9baa-4fea-b06a-f79273fba3dd.webp'),
(3,'Pro d\'Ici - Mondonvile','place-gros-horloge-mondonville-56d0d8c1-077b-4572-9014-e7326b36d615.png','place-gros-horloge-mondonville-56d0d8c1-077b-4572-9014-e7326b36d615.webp');
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_menu_location_system_key` (`location`,`system_key`),
  KEY `IDX_7D053A937294869C` (`article_id`),
  KEY `IDX_7D053A93BCF5E72D` (`categorie_id`),
  KEY `IDX_7D053A93C4663E4` (`page_id`),
  KEY `IDX_7D053A93727ACA70` (`parent_id`),
  KEY `idx_menu_is_visible` (`is_visible`),
  KEY `idx_menu_location` (`location`),
  CONSTRAINT `FK_7D053A93727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `menu` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_7D053A937294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `FK_7D053A93BCF5E72D` FOREIGN KEY (`categorie_id`) REFERENCES `categorie` (`id`),
  CONSTRAINT `FK_7D053A93C4663E4` FOREIGN KEY (`page_id`) REFERENCES `page` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES
(1,'Accueil',0,1,'route','header',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL),
(2,'Blog',10,1,'route','header',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL),
(3,'Services',20,0,'route','header',1,'services','app_service_index',NULL,NULL,NULL,NULL,NULL,NULL),
(4,'Catalogue',30,0,'route','header',1,'catalogue','app_product_index',NULL,NULL,NULL,NULL,NULL,NULL),
(5,'Evenements',40,0,'route','header',1,'events','app_event_index',NULL,NULL,NULL,NULL,NULL,NULL),
(6,'Annuaire',50,1,'route','header',1,'annuaire','app_directory',NULL,NULL,NULL,NULL,NULL,NULL),
(7,'Contact',60,1,'route','header',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL),
(8,'Accueil',0,1,'route','footer_nav',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL),
(9,'Blog',10,1,'route','footer_nav',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL),
(10,'Contact',20,1,'route','footer_nav',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL),
(11,'Mentions legales',0,1,'route','footer_legal',1,'mentions-legales','app_legal_page','{\"type\":\"mentions-legales\"}',NULL,NULL,NULL,NULL,NULL),
(12,'Politique de confidentialite',10,1,'route','footer_legal',1,'politique-confidentialite','app_legal_page','{\"type\":\"politique-de-confidentialite\"}',NULL,NULL,NULL,NULL,NULL),
(13,'CGV',20,0,'route','footer_legal',1,'cgv','app_legal_page','{\"type\":\"conditions-generales-de-vente\"}',NULL,NULL,NULL,NULL,NULL),
(14,'CGU',30,0,'route','footer_legal',1,'cgu','app_legal_page','{\"type\":\"conditions-generales-utilisation\"}',NULL,NULL,NULL,NULL,NULL);
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_140AB620989D9B62` (`slug`),
  UNIQUE KEY `UNIQ_140AB62047280172` (`system_key`),
  KEY `IDX_140AB620E2532148` (`featured_media_id`),
  CONSTRAINT `FK_140AB620E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES
(1,'public','Mentions légales','<p><em>Dernière mise à jour : 14 avril 2026</em></p><h2>1. Éditeur du site</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>Raison sociale</strong></p></td><td><p>AlexMB</p></td></tr><tr><td><p><strong>Forme juridique</strong></p></td><td><p>Auto-entreprise (Entreprise Individuelle)</p></td></tr><tr><td><p><strong>Siège social</strong></p></td><td><p>25 bis chemin de la Croix d&#039;Alliez, 31700 Mondonville</p></td></tr><tr><td><p><strong>SIRET</strong></p></td><td><p>791 423 924 000 20</p></td></tr><tr><td><p><strong>N° TVA</strong></p></td><td><p>Non assujetti (franchise en base de TVA, article 293 B du CGI)</p></td></tr><tr><td><p><strong>Capital social</strong></p></td><td><p>Non applicable</p></td></tr><tr><td><p><strong>Directeur de publication</strong></p></td><td><p>Alexandra Michalski Beaudouin</p></td></tr><tr><td><p><strong>Contact</strong></p></td><td><p>contactalexmb&#64;gmail.com</p></td></tr><tr><td><p><strong>Téléphone</strong></p></td><td><p>06 73 73 42 92</p></td></tr></tbody></table><h2>2. Hébergement</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>Hébergeur</strong></p></td><td><p>OVH </p></td></tr><tr><td><p>Adresse</p></td><td><p>2, rue Kellermann, 59100 Roubaix2 - rue Kellermann, 59100 Roubaix</p></td></tr><tr><td><p><strong>Site web</strong></p></td><td><p>[à compléter]</p></td></tr></tbody></table><p>L&#039;ensemble des données sont hébergées en France, conformément au RGPD.</p><h2>3. Propriété intellectuelle</h2><p>L&#039;ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p><p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p><h2>4. Protection des données</h2><ul><li><p>Hébergement 100 % France</p></li><li><p>Aucun transfert de données hors UE</p></li><li><p>Données personnelles jamais revendues</p></li></ul><p><strong>Contact DPO :</strong> contactalexmb&#64;gmail.com</p><p>Voir la <a href=\"/politique-de-confidentialite\" target=\"_blank\" rel=\"noopener noreferrer\">Politique de confidentialité</a> pour les détails complets.</p><h2>5. Cookies</h2><table class=\"tiptap-table\"><tbody><tr><th><p>Cookie</p></th><th><p>Type</p></th><th><p>Finalité</p></th><th><p>Consentement</p></th></tr><tr><td><p>Session PHP</p></td><td><p>Essentiel</p></td><td><p>Authentification</p></td><td><p>Non requis</p></td></tr><tr><td><p>CSRF</p></td><td><p>Essentiel</p></td><td><p>Sécurité formulaires</p></td><td><p>Non requis</p></td></tr><tr><td><p>Google Analytics</p></td><td><p>Analytique</p></td><td><p>Mesure d&#039;audience</p></td><td><p><strong>Requis</strong></p></td></tr><tr><td><p>Préférences cookies</p></td><td><p>Fonctionnel</p></td><td><p>Mémoriser votre choix</p></td><td><p>Non requis</p></td></tr></tbody></table><p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p><h2>6. Limitation de responsabilité</h2><p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p><p>L&#039;éditeur décline toute responsabilité en cas d&#039;interruption du site, de survenance de bugs ou d&#039;incompatibilité du site avec certains matériels ou configurations.</p><h2>7. Droit applicable et litiges</h2><p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p><p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : Non applicable (activité non soumise à médiation de la consommation).</p><h2>8. Contact</h2><table class=\"tiptap-table\"><tbody><tr><td><p><strong>Email</strong></p></td><td><p>contactalexmb&#64;gmail.com</p></td></tr><tr><td><p><strong>Courrier</strong></p></td><td><p>AlexMB — 25 bis chemin de la Croix d&#039;Alliez, 31700 Mondonville</p></td></tr><tr><td><p><strong>Téléphone</strong></p></td><td><p>[à compléter]</p></td></tr></tbody></table>','mentions-legales',1,'2026-04-14 09:24:35','2026-04-14 10:32:23','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"italic\"}],\"text\":\"Derni\\u00e8re mise \\u00e0 jour : 14 avril 2026\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"1. \\u00c9diteur du site\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Raison sociale\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"AlexMB\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Forme juridique\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Auto-entreprise (Entreprise Individuelle)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Si\\u00e8ge social\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"25 bis chemin de la Croix d\'Alliez, 31700 Mondonville\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"SIRET\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"791 423 924 000 20\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"N\\u00b0 TVA\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Non assujetti (franchise en base de TVA, article 293 B du CGI)\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Capital social\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Non applicable\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Directeur de publication\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Alexandra Michalski Beaudouin\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Contact\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"contactalexmb@gmail.com\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"T\\u00e9l\\u00e9phone\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"06 73 73 42 92\"}]}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"2. H\\u00e9bergement\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"H\\u00e9bergeur\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"OVH \"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Adresse\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"2, rue Kellermann, 59100 Roubaix2 - rue Kellermann, 59100 Roubaix\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Site web\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"[\\u00e0 compl\\u00e9ter]\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"L\'ensemble des donn\\u00e9es sont h\\u00e9berg\\u00e9es en France, conform\\u00e9ment au RGPD.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"3. Propri\\u00e9t\\u00e9 intellectuelle\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"L\'ensemble du contenu de ce site (textes, images, vid\\u00e9os, logos, ic\\u00f4nes, sons, logiciels, etc.) est prot\\u00e9g\\u00e9 par les lois fran\\u00e7aises et internationales relatives \\u00e0 la propri\\u00e9t\\u00e9 intellectuelle.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Toute reproduction, repr\\u00e9sentation, modification, publication ou d\\u00e9naturation, totale ou partielle, du site ou de son contenu, par quelque proc\\u00e9d\\u00e9 que ce soit, est interdite sans autorisation pr\\u00e9alable \\u00e9crite (articles L.335-2 et suivants du Code de la propri\\u00e9t\\u00e9 intellectuelle).\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"4. Protection des donn\\u00e9es\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9bergement 100 % France\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Aucun transfert de donn\\u00e9es hors UE\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9es personnelles jamais revendues\"}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Contact DPO :\"},{\"type\":\"text\",\"text\":\" contactalexmb@gmail.com\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Voir la \"},{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/politique-de-confidentialite\",\"target\":\"_blank\",\"rel\":\"noopener noreferrer\",\"class\":null}}],\"text\":\"Politique de confidentialit\\u00e9\"},{\"type\":\"text\",\"text\":\" pour les d\\u00e9tails complets.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"5. Cookies\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cookie\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Type\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Finalit\\u00e9\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Consentement\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Session PHP\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Essentiel\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Authentification\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Non requis\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"CSRF\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Essentiel\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9curit\\u00e9 formulaires\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Non requis\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Google Analytics\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Analytique\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mesure d\'audience\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Requis\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pr\\u00e9f\\u00e9rences cookies\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Fonctionnel\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"M\\u00e9moriser votre choix\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Non requis\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Vous pouvez g\\u00e9rer vos pr\\u00e9f\\u00e9rences via le bandeau de cookies affich\\u00e9 lors de votre premi\\u00e8re visite.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"6. Limitation de responsabilit\\u00e9\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"L\'\\u00e9diteur s\'efforce de fournir des informations aussi pr\\u00e9cises que possible. Toutefois, il ne pourra \\u00eatre tenu responsable des omissions, inexactitudes ou carences dans la mise \\u00e0 jour de ces informations.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"L\'\\u00e9diteur d\\u00e9cline toute responsabilit\\u00e9 en cas d\'interruption du site, de survenance de bugs ou d\'incompatibilit\\u00e9 du site avec certains mat\\u00e9riels ou configurations.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"7. Droit applicable et litiges\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les pr\\u00e9sentes mentions l\\u00e9gales sont r\\u00e9gies par le droit fran\\u00e7ais. En cas de litige, une solution amiable sera recherch\\u00e9e avant toute action judiciaire. Les tribunaux fran\\u00e7ais seront seuls comp\\u00e9tents.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"M\\u00e9diation consommation :\"},{\"type\":\"text\",\"text\":\" Conform\\u00e9ment \\u00e0 l\'article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement \\u00e0 un m\\u00e9diateur de la consommation. M\\u00e9diateur : Non applicable (activit\\u00e9 non soumise \\u00e0 m\\u00e9diation de la consommation).\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"8. Contact\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Email\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"contactalexmb@gmail.com\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Courrier\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"AlexMB \\u2014 25 bis chemin de la Croix d\'Alliez, 31700 Mondonville\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"T\\u00e9l\\u00e9phone\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"[\\u00e0 compl\\u00e9ter]\"}]}]}]}]}]}','full-width',1,'mentions-legales',NULL,'Mentions légales du site. Éditeur, hébergeur, propriété intellectuelle et contact.',NULL,1,NULL,NULL),
(2,'public','Politique de confidentialité','<p><em>Dernière mise à jour : 14 avril 2026</em></p>\n\n<h2>1. Responsable du traitement</h2>\n<table>\n<tbody>\n<tr><td><strong>Entité</strong></td><td>AlexMB</td></tr>\n<tr><td><strong>Représentant</strong></td><td>Alexandra Michalski Beaudouin</td></tr>\n<tr><td><strong>Siège</strong></td><td>25 bis chemin de la Croix d&#039;Alliez, 31700 Mondonville</td></tr>\n<tr><td><strong>SIRET</strong></td><td>791 423 924 000 20</td></tr>\n<tr><td><strong>DPO</strong></td><td>contactalexmb&#64;gmail.com</td></tr>\n</tbody>\n</table>\n\n<h2>2. Données collectées</h2>\n\n<h3>2.1 Compte utilisateur</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, prénom</td><td>Identification</td><td>Durée du compte</td></tr>\n<tr><td>Email</td><td>Identification, notifications</td><td>Durée du compte &#43; 3 ans</td></tr>\n<tr><td>Mot de passe (hashé)</td><td>Authentification</td><td>Durée du compte</td></tr>\n</tbody>\n</table>\n\n<h3>2.2 Formulaire de contact</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, email</td><td>Répondre à la demande</td><td>3 ans</td></tr>\n<tr><td>Message</td><td>Traitement de la demande</td><td>3 ans</td></tr>\n</tbody>\n</table>\n\n<h3>2.3 Commentaires</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, contenu</td><td>Affichage public</td><td>Durée de publication</td></tr>\n</tbody>\n</table>\n\n<h3>2.4 Données techniques</h3>\n<p>Adresse IP (hashée SHA-256), navigateur, pages visitées — conservées 12 mois à des fins de sécurité et de statistiques anonymes.</p>\n\n<h3>2.5 Paiement</h3>\n<p>Les données de paiement ne sont <strong>pas stockées</strong> par ce site. Elles sont gérées par Stripe (certifié PCI-DSS).</p>\n\n<h2>3. Finalités du traitement</h2>\n<ul>\n<li>Gestion des comptes utilisateurs</li>\n<li>Envoi de notifications relatives aux articles et au site</li>\n<li>Traitement des demandes de contact</li>\n<li>Amélioration du site via des statistiques de visite anonymisées</li>\n<li>Gestion des commandes et paiements (si module e-commerce actif)</li>\n</ul>\n\n<h2>4. Base légale</h2>\n<table>\n<thead>\n<tr><th>Traitement</th><th>Base légale (RGPD)</th></tr>\n</thead>\n<tbody>\n<tr><td>Compte utilisateur</td><td>Exécution du contrat (art. 6.1.b)</td></tr>\n<tr><td>Contact</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Cookies analytics</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Sécurité / logs</td><td>Intérêt légitime (art. 6.1.f)</td></tr>\n<tr><td>Facturation</td><td>Obligation légale (art. 6.1.c)</td></tr>\n</tbody>\n</table>\n\n<h2>5. Ce que nous ne faisons PAS</h2>\n<ul>\n<li>Vendre ou louer vos données à des tiers</li>\n<li>Faire de la publicité ciblée</li>\n<li>Faire du profilage marketing</li>\n<li>Transférer vos données hors de l&#039;Union Européenne (hors sous-traitants certifiés)</li>\n</ul>\n\n<h2>6. Cookies</h2>\n\n<h3>Cookies essentiels (sans consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP (PHPSESSID)</td><td>Authentification, panier</td></tr>\n<tr><td>CSRF token</td><td>Sécurité des formulaires</td></tr>\n<tr><td>Préférences cookies</td><td>Mémoriser votre choix</td></tr>\n</tbody>\n</table>\n\n<h3>Cookies analytiques (avec consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th><th>Durée</th></tr>\n</thead>\n<tbody>\n<tr><td>Google Analytics (_ga, _gid)</td><td>Mesure d&#039;audience</td><td>13 mois max</td></tr>\n</tbody>\n</table>\n<p>Les cookies analytiques ne sont déposés <strong>qu&#039;après votre consentement explicite</strong> via le bandeau affiché lors de votre première visite. Vous pouvez retirer votre consentement à tout moment en supprimant vos cookies.</p>\n\n<h2>7. Sous-traitants</h2>\n<table>\n<thead>\n<tr><th>Prestataire</th><th>Pays</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>[à compléter]</td><td>France</td><td>Hébergement</td></tr>\n<tr><td>Brevo</td><td>France</td><td>Envoi d&#039;emails</td></tr>\n<tr><td>Stripe</td><td>USA*</td><td>Paiement sécurisé</td></tr>\n<tr><td>Google Analytics</td><td>USA*</td><td>Audience (avec consentement)</td></tr>\n</tbody>\n</table>\n<p><em>* Certifiés EU-US Data Privacy Framework</em></p>\n\n<h2>8. Vos droits RGPD</h2>\n<table>\n<thead>\n<tr><th>Droit</th><th>Comment l&#039;exercer</th></tr>\n</thead>\n<tbody>\n<tr><td>Accès</td><td>Espace personnel ou contactalexmb&#64;gmail.com</td></tr>\n<tr><td>Rectification</td><td>Espace personnel</td></tr>\n<tr><td>Suppression</td><td>Espace personnel ou contactalexmb&#64;gmail.com</td></tr>\n<tr><td>Portabilité</td><td>contactalexmb&#64;gmail.com</td></tr>\n<tr><td>Opposition</td><td>contactalexmb&#64;gmail.com</td></tr>\n<tr><td>Limitation</td><td>contactalexmb&#64;gmail.com</td></tr>\n</tbody>\n</table>\n<p><strong>Délai de réponse :</strong> 30 jours maximum.</p>\n<p>En cas de difficulté, vous pouvez adresser une réclamation auprès de la <strong>CNIL</strong> : <a href=\"https://www.cnil.fr\" target=\"_blank\" rel=\"noopener\">www.cnil.fr</a> — 3 Place de Fontenoy, 75334 Paris Cedex 07.</p>\n\n<h2>9. Sécurité</h2>\n<table>\n<tbody>\n<tr><td><strong>Transfert</strong></td><td>HTTPS / TLS 1.3</td></tr>\n<tr><td><strong>Mots de passe</strong></td><td>Hashés (bcrypt/argon2)</td></tr>\n<tr><td><strong>IP visiteurs</strong></td><td>Hashées SHA-256 (anonymisées)</td></tr>\n<tr><td><strong>Accès admin</strong></td><td>Protégé par authentification &#43; CSRF</td></tr>\n</tbody>\n</table>\n\n<h2>10. Modifications</h2>\n<p>Cette politique peut être mise à jour. En cas de changement significatif, les utilisateurs inscrits seront informés par email. La date de mise à jour figure en haut de page.</p>\n\n<h2>11. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>DPO</strong></td><td>contactalexmb&#64;gmail.com</td></tr>\n<tr><td><strong>Courrier</strong></td><td>AlexMB — 25 bis chemin de la Croix d&#039;Alliez, 31700 Mondonville</td></tr>\n</tbody>\n</table>','politique-confidentialite',1,'2026-04-14 09:24:35','2026-04-14 10:32:19',NULL,'full-width',1,'politique-confidentialite',NULL,'Politique de confidentialité. Données collectées, cookies, droits RGPD et contact DPO.',NULL,1,NULL,NULL);
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
  PRIMARY KEY (`id`),
  KEY `idx_pageview_created_at` (`created_at`),
  KEY `idx_pageview_url` (`url`),
  KEY `idx_pageview_is_bot` (`is_bot`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_view`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page_view` WRITE;
/*!40000 ALTER TABLE `page_view` DISABLE KEYS */;
INSERT INTO `page_view` VALUES
(1,'/','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0',NULL,'2026-04-14 09:35:28',0),
(2,'/login','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0',NULL,'2026-04-14 09:35:39',0),
(3,'/login','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/login','2026-04-14 09:35:51',0),
(4,'/login','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/login','2026-04-14 09:36:03',0),
(5,'/login','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/login','2026-04-14 09:36:42',0),
(6,'/login','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/login','2026-04-14 09:38:37',0),
(7,'/login','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/login','2026-04-14 09:38:47',0),
(8,'/login','efe74856c1ecd19253e8027f8d5b64cc193f5f1906efb186e1645379edf0ca95','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/login','2026-04-14 09:40:27',0);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_E19D9AD2989D9B62` (`slug`),
  KEY `IDX_E19D9AD23DA5256D` (`image_id`),
  KEY `IDX_E19D9AD2670E5B73` (`linked_page_id`),
  KEY `idx_service_active` (`is_active`),
  CONSTRAINT `FK_E19D9AD23DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_E19D9AD2670E5B73` FOREIGN KEY (`linked_page_id`) REFERENCES `page` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_694309E4F98F144A` (`logo_id`),
  KEY `IDX_694309E4D78119FD` (`favicon_id`),
  KEY `IDX_694309E498BB94C5` (`hero_image_id`),
  KEY `IDX_694309E471BB2404` (`about_image_id`),
  KEY `IDX_694309E47E3C61F9` (`owner_id`),
  KEY `IDX_694309E46EFCB8B8` (`og_image_id`),
  KEY `IDX_694309E4E3225E88` (`logo_dark_id`),
  CONSTRAINT `FK_694309E46EFCB8B8` FOREIGN KEY (`og_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E471BB2404` FOREIGN KEY (`about_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E47E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_694309E498BB94C5` FOREIGN KEY (`hero_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
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
(1,'Les Pros d\'Ici','Les Pros d\'Ici','contactalexmb@gmail.com','Mondonville','31700','25 bis chemin de la Croix d\'Alliez',NULL,NULL,NULL,'Les Pros d\'Ici — Pro de confiance Nord-Ouest toulousain','De Tournefeuille a Grenade, decouvrez les artisans, commercants et experts du coin, selectionnes pour leur savoir-faire.',NULL,NULL,'#e2725b','#41521f','#f9f7f2',NULL,NULL,'artisan','ttc','[\"vitrine\",\"blog\",\"directory\"]',NULL,NULL,NULL,1,NULL,3,1,NULL,NULL,NULL);
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_389B783989D9B62` (`slug`)
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`),
  KEY `IDX_8D93D64986383B10` (`avatar_id`),
  CONSTRAINT `FK_8D93D64986383B10` FOREIGN KEY (`avatar_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(1,'contactalexmb@gmail.com','[\"ROLE_SUPER_ADMIN\"]','$2y$13$uwtYMIYvMZcInjpDSvEWJOIM5ne91ae1HkI8k/rNQoMFDDXouj6w6','','',0,NULL,NULL,NULL,NULL,0,NULL),
(3,'david@comwebsolutions.fr','[\"ROLE_SUPER_ADMIN\"]','$2y$13$YOWCVyhMGFpOt529T8OjjeaH3F5fba.KsSlPvFXXIcozc5w3fgrFS','Laignelet','David',1,NULL,NULL,NULL,NULL,0,NULL);
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

-- Dump completed on 2026-04-14  8:46:22
