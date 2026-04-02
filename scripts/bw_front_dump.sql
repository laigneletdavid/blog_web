/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: blog_web
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
  `featured_media_id` int(11) DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `draft_blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`draft_blocks`)),
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(4) NOT NULL DEFAULT 0,
  `visibility` varchar(20) NOT NULL DEFAULT 'public',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_23A0E66989D9B62` (`slug`),
  KEY `IDX_23A0E66E2532148` (`featured_media_id`),
  KEY `idx_article_published` (`published`),
  CONSTRAINT `FK_23A0E66E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES
(1,'Article test','<p>Ceci est un article test sur mon super chien !<br /></p><figure><img src=\"/documents/medias/profil-look-a9d2403c-d8c0-47ff-a82d-c10d5ba7586d.jpg\" alt=\"Look\" loading=\"lazy\" /></figure><p>Et blabla bla</p>','2026-03-10 06:25:44','2026-03-17 14:00:02','2026-03-10 06:30:00','article-test',1,'Mon super chien',NULL,'{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ceci est un article test sur mon super chien !\"},{\"type\":\"hardBreak\"}]},{\"type\":\"image\",\"attrs\":{\"src\":\"\\/documents\\/medias\\/profil-look-a9d2403c-d8c0-47ff-a82d-c10d5ba7586d.jpg\",\"alt\":\"Look\",\"title\":null}},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Et blabla bla\"}]}]}',NULL,NULL,NULL,NULL,0,NULL,0,'public'),
(2,'Test TOC','<h2>Titre 2</h2><p>Ceci est un chapitre.</p><h3>Titre 3</h3><p>chap</p><h3>Titre 32</h3><p>chamljsnx&amp;aocn</p><p></p><h2>Titre 22</h2><p>ldbouazbce</p>','2026-03-17 17:22:10','2026-03-18 05:12:24','2026-03-17 17:22:00','test-toc',1,NULL,NULL,'{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Titre 2\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ceci est un chapitre.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Titre 3\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"chap\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Titre 32\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"chamljsnx&aocn\"}]},{\"type\":\"paragraph\"},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Titre 22\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"ldbouazbce\"}]}]}',NULL,NULL,NULL,NULL,0,NULL,1,'public');
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
(1,1),
(2,1);
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
  `featured_media_id` int(11) DEFAULT NULL,
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_497DD634989D9B62` (`slug`),
  KEY `IDX_497DD634E2532148` (`featured_media_id`),
  CONSTRAINT `FK_497DD634E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `categorie` WRITE;
/*!40000 ALTER TABLE `categorie` DISABLE KEYS */;
INSERT INTO `categorie` VALUES
(1,'Catégorie Test','categorie-test','#008000',NULL,NULL,NULL,NULL,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES
(1,'test de commentaire','2026-03-18 05:14:14',2,1);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
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
('DoctrineMigrations\\Version20260327093858',NULL,NULL);
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
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `image_id` int(11) DEFAULT NULL,
  `linked_product_id` int(11) DEFAULT NULL,
  `notified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_3BAE0AA7989D9B62` (`slug`),
  KEY `IDX_3BAE0AA73DA5256D` (`image_id`),
  KEY `idx_event_active` (`is_active`),
  KEY `idx_event_date_start` (`date_start`),
  KEY `idx_event_featured` (`is_featured`),
  KEY `IDX_3BAE0AA7D240BD1D` (`linked_product_id`),
  CONSTRAINT `FK_3BAE0AA73DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`),
  CONSTRAINT `FK_3BAE0AA7D240BD1D` FOREIGN KEY (`linked_product_id`) REFERENCES `product` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `event` WRITE;
/*!40000 ALTER TABLE `event` DISABLE KEYS */;
INSERT INTO `event` VALUES
(1,'Tous à la pêche','tous-a-la-peche','Venez tous à la pêche','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Tous \\u00e0 la p\\u00eache \\u00e0 la truite \"}]}]}','<p>Tous à la pêche à la truite </p>','2026-03-28 08:00:00','2026-03-28 18:00:00','Montsaunes',1,1,NULL,NULL,NULL,0,NULL,1,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` VALUES
(1,'Est-ce que je peux créer des évennements ?','est-ce-que-je-peux-creer-des-evennements','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Oui tu peux !\"}]}]}','<p>Oui tu peux !</p>','bi-calendar-event',0,1,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq_category`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `faq_category` WRITE;
/*!40000 ALTER TABLE `faq_category` DISABLE KEYS */;
INSERT INTO `faq_category` VALUES
(1,'Fonctionnalités','fonctionnalites',0,1);
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
(1,'Look','profil-look-a9d2403c-d8c0-47ff-a82d-c10d5ba7586d.jpg',NULL),
(2,'profil-david-8468f1e2-8807-4819-b967-4de6049e9fe4','profil-david-8468f1e2-8807-4819-b967-4de6049e9fe4.jpg',NULL),
(3,'profil david','profil david-69bf89f568152.jpg',NULL);
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
  `article_id` int(11) DEFAULT NULL,
  `categorie_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `location` varchar(20) NOT NULL DEFAULT 'header',
  `is_system` tinyint(4) NOT NULL DEFAULT 0,
  `system_key` varchar(50) DEFAULT NULL,
  `route` varchar(100) DEFAULT NULL,
  `route_params` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`route_params`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_menu_location_system_key` (`location`,`system_key`),
  KEY `IDX_7D053A937294869C` (`article_id`),
  KEY `IDX_7D053A93BCF5E72D` (`categorie_id`),
  KEY `IDX_7D053A93C4663E4` (`page_id`),
  KEY `idx_menu_is_visible` (`is_visible`),
  KEY `IDX_7D053A93727ACA70` (`parent_id`),
  KEY `idx_menu_location` (`location`),
  CONSTRAINT `FK_7D053A93727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `menu` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_7D053A937294869C` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`),
  CONSTRAINT `FK_7D053A93BCF5E72D` FOREIGN KEY (`categorie_id`) REFERENCES `categorie` (`id`),
  CONSTRAINT `FK_7D053A93C4663E4` FOREIGN KEY (`page_id`) REFERENCES `page` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES
(1,'A propos',3,1,'Page',NULL,NULL,1,NULL,NULL,'header',0,NULL,NULL,NULL),
(3,'Accueil',0,1,'route',NULL,NULL,NULL,NULL,NULL,'header',1,'home','app_home',NULL),
(4,'Blog',2,1,'route',NULL,NULL,NULL,NULL,NULL,'header',1,'blog','app_article_show_all',NULL),
(5,'Services',0,1,'route',NULL,NULL,NULL,19,NULL,'header',1,'services','app_service_index',NULL),
(6,'Catalogue',1,1,'route',NULL,NULL,NULL,19,NULL,'header',1,'catalogue','app_product_index',NULL),
(7,'Evenements',2,1,'route',NULL,NULL,NULL,19,NULL,'header',1,'events','app_event_index',NULL),
(8,'Annuaire',4,1,'route',NULL,NULL,NULL,NULL,NULL,'header',1,'annuaire','app_directory',NULL),
(9,'Contact',5,0,'route',NULL,NULL,NULL,NULL,NULL,'header',1,'contact','app_contact',NULL),
(10,'Accueil',1,0,'route',NULL,NULL,NULL,NULL,NULL,'footer_nav',1,'home','app_home',NULL),
(11,'Blog',4,1,'route',NULL,NULL,NULL,NULL,NULL,'footer_nav',1,'blog','app_article_show_all',NULL),
(12,'Contact',7,1,'route',NULL,NULL,NULL,NULL,NULL,'footer_nav',1,'contact','app_contact',NULL),
(13,'Mentions legales',0,1,'route',NULL,NULL,NULL,NULL,NULL,'footer_legal',1,'mentions-legales','app_legal_page','{\"type\":\"mentions-legales\"}'),
(14,'Politique de confidentialite',1,1,'route',NULL,NULL,NULL,NULL,NULL,'footer_legal',1,'politique-confidentialite','app_legal_page','{\"type\":\"politique-de-confidentialite\"}'),
(15,'CGV',0,1,'route',NULL,NULL,NULL,17,NULL,'footer_legal',1,'cgv','app_legal_page','{\"type\":\"conditions-generales-de-vente\"}'),
(16,'CGU',1,1,'route',NULL,NULL,NULL,17,NULL,'footer_legal',1,'cgu','app_legal_page','{\"type\":\"conditions-generales-utilisation\"}'),
(17,'Test menu',2,1,'url',NULL,NULL,NULL,NULL,'#','footer_legal',0,NULL,NULL,NULL),
(18,'Catégorie Test',8,1,'categorie',NULL,1,NULL,NULL,NULL,'footer_nav',0,NULL,NULL,NULL),
(19,'Services',1,1,'url',NULL,NULL,NULL,NULL,'#','header',0,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messenger_messages`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `messenger_messages` WRITE;
/*!40000 ALTER TABLE `messenger_messages` DISABLE KEYS */;
INSERT INTO `messenger_messages` VALUES
(1,'O:36:\\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\\":2:{s:44:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\\";a:1:{s:46:\\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\\";a:1:{i:0;O:46:\\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\\":1:{s:55:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\\";s:21:\\\"messenger.bus.default\\\";}}}s:45:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\\";O:51:\\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\\":2:{s:60:\\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\\";O:28:\\\"Symfony\\\\Component\\\\Mime\\\\Email\\\":6:{i:0;N;i:1;N;i:2;s:1804:\\\"<!DOCTYPE html>\n<html>\n<head><meta charset=\\\"UTF-8\\\"></head>\n<body style=\\\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333;\\\">\n    <h1 style=\\\"color: #2563EB; font-size: 24px;\\\">Confirmation de commande</h1>\n\n    <p>Bonjour Jean,</p>\n    <p>Merci pour votre commande ! Voici le recapitulatif :</p>\n\n    <table style=\\\"width: 100%; border-collapse: collapse; margin: 20px 0;\\\">\n        <tr style=\\\"background: #f8f9fa;\\\">\n            <th style=\\\"text-align: left; padding: 10px; border-bottom: 2px solid #dee2e6;\\\">Produit</th>\n            <th style=\\\"text-align: center; padding: 10px; border-bottom: 2px solid #dee2e6;\\\">Qte</th>\n            <th style=\\\"text-align: right; padding: 10px; border-bottom: 2px solid #dee2e6;\\\">Montant</th>\n        </tr>\n                <tr>\n            <td style=\\\"padding: 10px; border-bottom: 1px solid #dee2e6;\\\">\n                Sortie journée pêche en montagne\n                            </td>\n            <td style=\\\"text-align: center; padding: 10px; border-bottom: 1px solid #dee2e6;\\\">2</td>\n            <td style=\\\"text-align: right; padding: 10px; border-bottom: 1px solid #dee2e6;\\\">300,00 &euro;</td>\n        </tr>\n            </table>\n\n    <p style=\\\"text-align: right; font-size: 18px; font-weight: bold;\\\">\n        Total : 300,00 &euro; TTC\n    </p>\n\n    <p><strong>Reference :</strong> BW-20260323-1C1B2</p>\n    <p><strong>Paiement :</strong> Virement / cheque / especes</p>\n\n        <p style=\\\"background: #fff3cd; padding: 15px; border-radius: 8px;\\\">\n        Votre commande est en attente de paiement. Nous vous contacterons pour convenir du mode de reglement.\n    </p>\n    \n    <hr style=\\\"margin: 30px 0; border: none; border-top: 1px solid #dee2e6;\\\">\n    <p style=\\\"color: #6c757d; font-size: 12px;\\\">Mon blog</p>\n</body>\n</html>\n\\\";i:3;s:5:\\\"utf-8\\\";i:4;a:0:{}i:5;a:2:{i:0;O:37:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\\":2:{s:46:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\\";a:3:{s:2:\\\"to\\\";a:1:{i:0;O:47:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:2:\\\"To\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:58:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\\";a:1:{i:0;O:30:\\\"Symfony\\\\Component\\\\Mime\\\\Address\\\":2:{s:39:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\\";s:20:\\\"jean.dupont@test.com\\\";s:36:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\\";s:0:\\\"\\\";}}}}s:7:\\\"subject\\\";a:1:{i:0;O:48:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:7:\\\"Subject\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:55:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\\";s:53:\\\"Confirmation de commande BW-20260323-1C1B2 - Mon blog\\\";}}s:4:\\\"from\\\";a:1:{i:0;O:47:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:4:\\\"From\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:58:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\\";a:1:{i:0;O:30:\\\"Symfony\\\\Component\\\\Mime\\\\Address\\\":2:{s:39:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\\";s:25:\\\"laignelet.david@gmail.com\\\";s:36:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\\";s:0:\\\"\\\";}}}}}s:49:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\\";i:76;}i:1;N;}}s:61:\\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\\";N;}}','[]','default','2026-03-23 13:15:17','2026-03-23 13:15:17',NULL),
(2,'O:36:\\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\\":2:{s:44:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\\";a:1:{s:46:\\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\\";a:1:{i:0;O:46:\\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\\":1:{s:55:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\\";s:21:\\\"messenger.bus.default\\\";}}}s:45:\\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\\";O:51:\\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\\":2:{s:60:\\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\\";O:28:\\\"Symfony\\\\Component\\\\Mime\\\\Email\\\":6:{i:0;N;i:1;N;i:2;s:1504:\\\"<!DOCTYPE html>\n<html>\n<head><meta charset=\\\"UTF-8\\\"></head>\n<body style=\\\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333;\\\">\n    <h1 style=\\\"color: #2563EB; font-size: 24px;\\\">Nouvelle commande BW-20260323-1C1B2</h1>\n\n    <p><strong>Client :</strong> Jean Dupont</p>\n    <p><strong>Email :</strong> jean.dupont@test.com</p>\n        \n    <p><strong>Paiement :</strong> Virement / cheque / especes</p>\n    <p><strong>Statut :</strong> En attente</p>\n\n    <table style=\\\"width: 100%; border-collapse: collapse; margin: 20px 0;\\\">\n        <tr style=\\\"background: #f8f9fa;\\\">\n            <th style=\\\"text-align: left; padding: 8px;\\\">Produit</th>\n            <th style=\\\"text-align: center; padding: 8px;\\\">Qte</th>\n            <th style=\\\"text-align: right; padding: 8px;\\\">Montant</th>\n        </tr>\n                <tr>\n            <td style=\\\"padding: 8px; border-bottom: 1px solid #dee2e6;\\\">\n                Sortie journée pêche en montagne            </td>\n            <td style=\\\"text-align: center; padding: 8px; border-bottom: 1px solid #dee2e6;\\\">2</td>\n            <td style=\\\"text-align: right; padding: 8px; border-bottom: 1px solid #dee2e6;\\\">300,00 &euro;</td>\n        </tr>\n            </table>\n\n    <p style=\\\"font-size: 18px; font-weight: bold; text-align: right;\\\">\n        Total : 300,00 &euro; TTC\n    </p>\n\n    <hr style=\\\"margin: 20px 0;\\\">\n    <p style=\\\"color: #6c757d; font-size: 12px;\\\">Commande passee le 23/03/2026 pm 14:15 sur Mon blog.</p>\n</body>\n</html>\n\\\";i:3;s:5:\\\"utf-8\\\";i:4;a:0:{}i:5;a:2:{i:0;O:37:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\\":2:{s:46:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\\";a:2:{s:2:\\\"to\\\";a:1:{i:0;O:47:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:2:\\\"To\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:58:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\\";a:1:{i:0;O:30:\\\"Symfony\\\\Component\\\\Mime\\\\Address\\\":2:{s:39:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\\";s:25:\\\"laignelet.david@gmail.com\\\";s:36:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\\";s:0:\\\"\\\";}}}}s:7:\\\"subject\\\";a:1:{i:0;O:48:\\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\\":5:{s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\\";s:7:\\\"Subject\\\";s:56:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\\";i:76;s:50:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\\";N;s:53:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\\";s:5:\\\"utf-8\\\";s:55:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\\";s:35:\\\"Nouvelle commande BW-20260323-1C1B2\\\";}}}s:49:\\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\\";i:76;}i:1;N;}}s:61:\\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\\";N;}}','[]','default','2026-03-23 13:15:17','2026-03-23 13:15:17',NULL);
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
  `customer_last_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_F5299398AEA34913` (`reference`),
  KEY `idx_order_status` (`status`),
  KEY `idx_order_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES
(1,'BW-20260323-1C1B2','Jean','jean.dupont@test.com',NULL,NULL,'[{\"productId\":2,\"title\":\"Sortie journ\\u00e9e p\\u00eache en montagne\",\"variant\":null,\"qty\":2,\"unitPriceHT\":125.0,\"vatRate\":20.0,\"lineTotalTTC\":300.0}]',250.00,50.00,300.00,'manual',NULL,'pending','2026-03-23 14:15:17',NULL,'Dupont');
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
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `slug` varchar(255) NOT NULL,
  `published` tinyint(4) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `featured_media_id` int(11) DEFAULT NULL,
  `blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`blocks`)),
  `draft_blocks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`draft_blocks`)),
  `template` varchar(30) NOT NULL DEFAULT 'default',
  `seo_title` varchar(70) DEFAULT NULL,
  `seo_description` varchar(160) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `no_index` tinyint(4) NOT NULL DEFAULT 0,
  `canonical_url` varchar(255) DEFAULT NULL,
  `visibility` varchar(20) NOT NULL DEFAULT 'public',
  `is_system` tinyint(4) NOT NULL DEFAULT 0,
  `system_key` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_140AB620989D9B62` (`slug`),
  UNIQUE KEY `UNIQ_140AB62047280172` (`system_key`),
  KEY `IDX_140AB620E2532148` (`featured_media_id`),
  CONSTRAINT `FK_140AB620E2532148` FOREIGN KEY (`featured_media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES
(1,'A propos','<p></p><p>Test de contenu TipTap avec media.<br /></p><figure><img src=\"/documents/medias/profil-look-a9d2403c-d8c0-47ff-a82d-c10d5ba7586d.jpg\" alt=\"Look\" loading=\"lazy\" /></figure>','a-propos',1,'2026-03-10 06:20:39','2026-03-11 07:03:25',NULL,'{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\"},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Test de contenu TipTap avec media.\"},{\"type\":\"hardBreak\"}]},{\"type\":\"image\",\"attrs\":{\"src\":\"\\/documents\\/medias\\/profil-look-a9d2403c-d8c0-47ff-a82d-c10d5ba7586d.jpg\",\"alt\":\"Look\",\"title\":null}}]}',NULL,'default',NULL,NULL,NULL,0,NULL,'public',0,NULL),
(2,'Test 2','<p>oefbnvufe</p><h2>fbve</h2><figure><img src=\"/documents/medias/profil-look-a9d2403c-d8c0-47ff-a82d-c10d5ba7586d.jpg\" alt=\"Look\" loading=\"lazy\" /></figure>','test-2',1,'2026-03-18 15:07:38','2026-03-18 15:07:43',NULL,'{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"oefbnvufe\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"fbve\"}]},{\"type\":\"image\",\"attrs\":{\"src\":\"\\/documents\\/medias\\/profil-look-a9d2403c-d8c0-47ff-a82d-c10d5ba7586d.jpg\",\"alt\":\"Look\",\"title\":null}}]}',NULL,'default',NULL,NULL,NULL,0,NULL,'public',0,NULL),
(3,'Mentions légales','<p><em>Dernière mise à jour : {{DATE}}</em></p>\n\n<h2>1. Éditeur du site</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>Forme juridique</strong></td><td>{{FORME_JURIDIQUE}}</td></tr>\n<tr><td><strong>Siège social</strong></td><td>{{ADRESSE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>\n<tr><td><strong>N° TVA</strong></td><td>{{TVA}}</td></tr>\n<tr><td><strong>Capital social</strong></td><td>{{CAPITAL}}</td></tr>\n<tr><td><strong>Directeur de publication</strong></td><td>{{NOM_DIRECTEUR}}</td></tr>\n<tr><td><strong>Contact</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>\n</tbody>\n</table>\n\n<h2>2. Hébergement</h2>\n<table>\n<tbody>\n<tr><td><strong>Hébergeur</strong></td><td>{{NOM_HEBERGEUR}}</td></tr>\n<tr><td><strong>Adresse</strong></td><td>{{ADRESSE_HEBERGEUR}}</td></tr>\n<tr><td><strong>Site web</strong></td><td>{{URL_HEBERGEUR}}</td></tr>\n</tbody>\n</table>\n<p>L&#039;ensemble des données sont hébergées en France, conformément au RGPD.</p>\n\n<h2>3. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p>\n<p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p>\n\n<h2>4. Protection des données</h2>\n<ul>\n<li>Hébergement 100 % France</li>\n<li>Aucun transfert de données hors UE</li>\n<li>Données personnelles jamais revendues</li>\n</ul>\n<p><strong>Contact DPO :</strong> {{EMAIL_DPO}}</p>\n<p>Voir la <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a> pour les détails complets.</p>\n\n<h2>5. Cookies</h2>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Type</th><th>Finalité</th><th>Consentement</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP</td><td>Essentiel</td><td>Authentification</td><td>Non requis</td></tr>\n<tr><td>CSRF</td><td>Essentiel</td><td>Sécurité formulaires</td><td>Non requis</td></tr>\n<tr><td>Google Analytics</td><td>Analytique</td><td>Mesure d&#039;audience</td><td><strong>Requis</strong></td></tr>\n<tr><td>Préférences cookies</td><td>Fonctionnel</td><td>Mémoriser votre choix</td><td>Non requis</td></tr>\n</tbody>\n</table>\n<p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p>\n\n<h2>6. Limitation de responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p>\n<p>L&#039;éditeur décline toute responsabilité en cas d&#039;interruption du site, de survenance de bugs ou d&#039;incompatibilité du site avec certains matériels ou configurations.</p>\n\n<h2>7. Droit applicable et litiges</h2>\n<p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p>\n<p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : {{MEDIATEUR}}.</p>\n\n<h2>8. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>\n</tbody>\n</table>','mentions-legales',1,'2026-03-23 18:55:55','2026-03-23 20:13:21',NULL,NULL,NULL,'full-width',NULL,NULL,NULL,1,NULL,'public',1,'mentions-legales'),
(4,'Politique de confidentialité','<p><em>Dernière mise à jour : {{DATE}}</em></p>\n\n<h2>1. Responsable du traitement</h2>\n<table>\n<tbody>\n<tr><td><strong>Entité</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>Représentant</strong></td><td>{{NOM_DIRECTEUR}}</td></tr>\n<tr><td><strong>Siège</strong></td><td>{{ADRESSE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>\n<tr><td><strong>DPO</strong></td><td>{{EMAIL_DPO}}</td></tr>\n</tbody>\n</table>\n\n<h2>2. Données collectées</h2>\n\n<h3>2.1 Compte utilisateur</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, prénom</td><td>Identification</td><td>Durée du compte</td></tr>\n<tr><td>Email</td><td>Identification, notifications</td><td>Durée du compte &#43; 3 ans</td></tr>\n<tr><td>Mot de passe (hashé)</td><td>Authentification</td><td>Durée du compte</td></tr>\n</tbody>\n</table>\n\n<h3>2.2 Formulaire de contact</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, email</td><td>Répondre à la demande</td><td>3 ans</td></tr>\n<tr><td>Message</td><td>Traitement de la demande</td><td>3 ans</td></tr>\n</tbody>\n</table>\n\n<h3>2.3 Commentaires</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, contenu</td><td>Affichage public</td><td>Durée de publication</td></tr>\n</tbody>\n</table>\n\n<h3>2.4 Données techniques</h3>\n<p>Adresse IP (hashée SHA-256), navigateur, pages visitées — conservées 12 mois à des fins de sécurité et de statistiques anonymes.</p>\n\n<h3>2.5 Paiement</h3>\n<p>Les données de paiement ne sont <strong>pas stockées</strong> par ce site. Elles sont gérées par Stripe (certifié PCI-DSS).</p>\n\n<h2>3. Finalités du traitement</h2>\n<ul>\n<li>Gestion des comptes utilisateurs</li>\n<li>Envoi de notifications relatives aux articles et au site</li>\n<li>Traitement des demandes de contact</li>\n<li>Amélioration du site via des statistiques de visite anonymisées</li>\n<li>Gestion des commandes et paiements (si module e-commerce actif)</li>\n</ul>\n\n<h2>4. Base légale</h2>\n<table>\n<thead>\n<tr><th>Traitement</th><th>Base légale (RGPD)</th></tr>\n</thead>\n<tbody>\n<tr><td>Compte utilisateur</td><td>Exécution du contrat (art. 6.1.b)</td></tr>\n<tr><td>Contact</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Cookies analytics</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Sécurité / logs</td><td>Intérêt légitime (art. 6.1.f)</td></tr>\n<tr><td>Facturation</td><td>Obligation légale (art. 6.1.c)</td></tr>\n</tbody>\n</table>\n\n<h2>5. Ce que nous ne faisons PAS</h2>\n<ul>\n<li>Vendre ou louer vos données à des tiers</li>\n<li>Faire de la publicité ciblée</li>\n<li>Faire du profilage marketing</li>\n<li>Transférer vos données hors de l&#039;Union Européenne (hors sous-traitants certifiés)</li>\n</ul>\n\n<h2>6. Cookies</h2>\n\n<h3>Cookies essentiels (sans consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP (PHPSESSID)</td><td>Authentification, panier</td></tr>\n<tr><td>CSRF token</td><td>Sécurité des formulaires</td></tr>\n<tr><td>Préférences cookies</td><td>Mémoriser votre choix</td></tr>\n</tbody>\n</table>\n\n<h3>Cookies analytiques (avec consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th><th>Durée</th></tr>\n</thead>\n<tbody>\n<tr><td>Google Analytics (_ga, _gid)</td><td>Mesure d&#039;audience</td><td>13 mois max</td></tr>\n</tbody>\n</table>\n<p>Les cookies analytiques ne sont déposés <strong>qu&#039;après votre consentement explicite</strong> via le bandeau affiché lors de votre première visite. Vous pouvez retirer votre consentement à tout moment en supprimant vos cookies.</p>\n\n<h2>7. Sous-traitants</h2>\n<table>\n<thead>\n<tr><th>Prestataire</th><th>Pays</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>{{NOM_HEBERGEUR}}</td><td>France</td><td>Hébergement</td></tr>\n<tr><td>Brevo</td><td>France</td><td>Envoi d&#039;emails</td></tr>\n<tr><td>Stripe</td><td>USA*</td><td>Paiement sécurisé</td></tr>\n<tr><td>Google Analytics</td><td>USA*</td><td>Audience (avec consentement)</td></tr>\n</tbody>\n</table>\n<p><em>* Certifiés EU-US Data Privacy Framework</em></p>\n\n<h2>8. Vos droits RGPD</h2>\n<table>\n<thead>\n<tr><th>Droit</th><th>Comment l&#039;exercer</th></tr>\n</thead>\n<tbody>\n<tr><td>Accès</td><td>Espace personnel ou {{EMAIL_DPO}}</td></tr>\n<tr><td>Rectification</td><td>Espace personnel</td></tr>\n<tr><td>Suppression</td><td>Espace personnel ou {{EMAIL_DPO}}</td></tr>\n<tr><td>Portabilité</td><td>{{EMAIL_DPO}}</td></tr>\n<tr><td>Opposition</td><td>{{EMAIL_DPO}}</td></tr>\n<tr><td>Limitation</td><td>{{EMAIL_DPO}}</td></tr>\n</tbody>\n</table>\n<p><strong>Délai de réponse :</strong> 30 jours maximum.</p>\n<p>En cas de difficulté, vous pouvez adresser une réclamation auprès de la <strong>CNIL</strong> : <a href=\"https://www.cnil.fr\" target=\"_blank\" rel=\"noopener\">www.cnil.fr</a> — 3 Place de Fontenoy, 75334 Paris Cedex 07.</p>\n\n<h2>9. Sécurité</h2>\n<table>\n<tbody>\n<tr><td><strong>Transfert</strong></td><td>HTTPS / TLS 1.3</td></tr>\n<tr><td><strong>Mots de passe</strong></td><td>Hashés (bcrypt/argon2)</td></tr>\n<tr><td><strong>IP visiteurs</strong></td><td>Hashées SHA-256 (anonymisées)</td></tr>\n<tr><td><strong>Accès admin</strong></td><td>Protégé par authentification &#43; CSRF</td></tr>\n</tbody>\n</table>\n\n<h2>10. Modifications</h2>\n<p>Cette politique peut être mise à jour. En cas de changement significatif, les utilisateurs inscrits seront informés par email. La date de mise à jour figure en haut de page.</p>\n\n<h2>11. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>DPO</strong></td><td>{{EMAIL_DPO}}</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>\n</tbody>\n</table>','politique-confidentialite',1,'2026-03-23 18:55:55','2026-03-23 20:13:21',NULL,NULL,NULL,'full-width',NULL,NULL,NULL,1,NULL,'public',1,'politique-confidentialite'),
(5,'Conditions générales de vente','<p><em>Dernière mise à jour : {{DATE}}</em></p>\n\n<h2>1. Objet</h2>\n<p>Les présentes Conditions Générales de Vente (CGV) régissent les ventes de produits et/ou services effectuées via ce site internet. Toute commande implique l&#039;acceptation sans réserve des présentes CGV.</p>\n\n<h2>2. Vendeur</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>\n<tr><td><strong>Adresse</strong></td><td>{{ADRESSE}}</td></tr>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n</tbody>\n</table>\n\n<h2>3. Prix</h2>\n<ul>\n<li>Les prix sont indiqués en euros {{TTC_OU_HT}}</li>\n<li>Les tarifs sont ceux en vigueur au moment de la validation de la commande</li>\n<li>Le vendeur se réserve le droit de modifier ses prix à tout moment</li>\n<li>Les frais de livraison sont indiqués avant validation de la commande</li>\n</ul>\n\n<h2>4. Commande</h2>\n<p>Le processus de commande comprend les étapes suivantes :</p>\n<ol>\n<li>Sélection des produits et ajout au panier</li>\n<li>Vérification du panier</li>\n<li>Identification (connexion ou création de compte)</li>\n<li>Choix du mode de livraison</li>\n<li>Validation et paiement sécurisé</li>\n</ol>\n<p>Un email de confirmation est envoyé après chaque commande.</p>\n\n<h2>5. Paiement</h2>\n<ul>\n<li>Le paiement est exigible immédiatement à la commande</li>\n<li>Moyens acceptés : carte bancaire via <strong>Stripe</strong> (certifié PCI-DSS)</li>\n<li>Les données de paiement ne sont pas stockées par le site</li>\n<li>Les transactions sont sécurisées par chiffrement SSL/TLS</li>\n</ul>\n\n<h2>6. Livraison</h2>\n<table>\n<thead>\n<tr><th>Élément</th><th>Détail</th></tr>\n</thead>\n<tbody>\n<tr><td><strong>Zones de livraison</strong></td><td>{{ZONES_LIVRAISON}}</td></tr>\n<tr><td><strong>Délais</strong></td><td>{{DELAIS_LIVRAISON}}</td></tr>\n<tr><td><strong>Frais</strong></td><td>{{FRAIS_LIVRAISON}}</td></tr>\n<tr><td><strong>Transporteur</strong></td><td>{{TRANSPORTEUR}}</td></tr>\n</tbody>\n</table>\n<p>En cas de retard de livraison, le client sera informé dans les meilleurs délais.</p>\n\n<h2>7. Droit de rétractation</h2>\n<p>Conformément à l&#039;article L221-18 du Code de la consommation, le consommateur dispose d&#039;un délai de <strong>14 jours</strong> à compter de la réception du produit pour exercer son droit de rétractation, sans avoir à justifier de motifs ni à payer de pénalités.</p>\n<ul>\n<li>Notifier par email à {{EMAIL_CONTACT}} ou par courrier</li>\n<li>Retourner le produit dans son état d&#039;origine sous 14 jours</li>\n<li>Remboursement sous 14 jours après réception du retour</li>\n</ul>\n<p><strong>Exceptions :</strong> produits personnalisés, périssables, descellés (hygiène), contenus numériques téléchargés.</p>\n\n<h2>8. Garanties</h2>\n<p>Les produits bénéficient de :</p>\n<ul>\n<li><strong>Garantie légale de conformité</strong> (articles L217-4 et suivants du Code de la consommation) — 2 ans à compter de la livraison</li>\n<li><strong>Garantie des vices cachés</strong> (articles 1641 et suivants du Code civil) — 2 ans à compter de la découverte du vice</li>\n</ul>\n\n<h2>9. Responsabilité</h2>\n<p>Le vendeur ne saurait être tenu responsable de l&#039;inexécution du contrat en cas de force majeure, de perturbation ou de grève totale ou partielle des services postaux et moyens de transport et/ou communications.</p>\n\n<h2>10. Réclamations et litiges</h2>\n<p>En cas de litige, une solution amiable sera recherchée avant toute action judiciaire.</p>\n<p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur. Médiateur : {{MEDIATEUR}}.</p>\n<p><strong>Droit applicable :</strong> droit français. Tribunaux français compétents.</p>\n\n<h2>11. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>\n</tbody>\n</table>','cgv',1,'2026-03-23 18:55:55','2026-03-23 20:13:21',NULL,NULL,NULL,'full-width',NULL,NULL,NULL,1,NULL,'public',1,'cgv'),
(6,'Conditions générales d\'utilisation','<p><em>Dernière mise à jour : {{DATE}}</em></p>\n\n<h2>1. Objet</h2>\n<p>Les présentes Conditions Générales d&#039;Utilisation (CGU) régissent l&#039;accès et l&#039;utilisation de ce site internet. En accédant au site, vous acceptez sans réserve les présentes CGU.</p>\n\n<h2>2. Éditeur</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>\n<tr><td><strong>Adresse</strong></td><td>{{ADRESSE}}</td></tr>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n</tbody>\n</table>\n\n<h2>3. Accès au service</h2>\n<ul>\n<li>Le site est accessible gratuitement à tout utilisateur disposant d&#039;un accès internet</li>\n<li>Les frais d&#039;accès et d&#039;utilisation du réseau de télécommunication sont à la charge de l&#039;utilisateur</li>\n<li>L&#039;éditeur se réserve le droit de suspendre ou interrompre l&#039;accès pour maintenance</li>\n</ul>\n\n<h2>4. Inscription</h2>\n<p>L&#039;accès à certaines fonctionnalités du site nécessite une inscription. L&#039;utilisateur s&#039;engage à :</p>\n<ul>\n<li>Fournir des informations exactes et complètes</li>\n<li>Mettre à jour ses informations en cas de changement</li>\n<li>Préserver la confidentialité de son mot de passe (12 caractères minimum)</li>\n<li>Notifier immédiatement toute utilisation non autorisée de son compte</li>\n</ul>\n<p>L&#039;éditeur se réserve le droit de supprimer tout compte ne respectant pas les présentes CGU.</p>\n\n<h2>5. Services proposés</h2>\n<p>Le site propose les services suivants :</p>\n<ul>\n<li>Publication et consultation de contenus (articles, pages, services)</li>\n<li>Formulaire de contact</li>\n<li>Inscription aux notifications</li>\n<li>Commentaires sur les articles</li>\n<li>{{SERVICES_SUPPLEMENTAIRES}}</li>\n</ul>\n\n<h2>6. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu du site est protégé par le droit de la propriété intellectuelle :</p>\n<ul>\n<li>Textes, images, vidéos, logos, icônes, sons, logiciels</li>\n<li>Charte graphique et design du site</li>\n<li>Bases de données</li>\n</ul>\n<p>Toute reproduction non autorisée constitue une contrefaçon sanctionnée par les articles L335-2 et suivants du Code de la Propriété Intellectuelle.</p>\n\n<h2>7. Comportement de l&#039;utilisateur</h2>\n<p>L&#039;utilisateur s&#039;engage à ne pas :</p>\n<ul>\n<li>Publier de contenu illicite, diffamatoire, injurieux ou discriminatoire</li>\n<li>Porter atteinte à la vie privée d&#039;autrui</li>\n<li>Tenter d&#039;accéder à des zones non autorisées du site</li>\n<li>Utiliser le site à des fins commerciales non autorisées</li>\n<li>Collecter des données personnelles d&#039;autres utilisateurs</li>\n</ul>\n\n<h2>8. Responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible, mais ne garantit pas :</p>\n<ul>\n<li>L&#039;exactitude, la complétude ou l&#039;actualité des informations publiées</li>\n<li>La disponibilité permanente du site</li>\n<li>L&#039;absence de virus ou de défauts de fonctionnement</li>\n</ul>\n<p>L&#039;éditeur décline toute responsabilité pour les dommages directs ou indirects résultant de l&#039;utilisation du site.</p>\n\n<h2>9. Liens hypertextes</h2>\n<p>Le site peut contenir des liens vers des sites tiers. L&#039;éditeur n&#039;est pas responsable du contenu de ces sites et n&#039;exerce aucun contrôle sur eux.</p>\n\n<h2>10. Données personnelles</h2>\n<p>Le traitement des données personnelles est décrit dans notre <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a>, accessible depuis le pied de page du site.</p>\n\n<h2>11. Modification des CGU</h2>\n<p>L&#039;éditeur se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs inscrits seront informés par email de toute modification substantielle. La date de mise à jour figure en haut de page.</p>\n\n<h2>12. Droit applicable</h2>\n<p>Les présentes CGU sont régies par le droit français. En cas de litige, les tribunaux français seront compétents.</p>\n\n<h2>13. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>\n</tbody>\n</table>','cgu',1,'2026-03-23 18:55:55','2026-03-23 20:13:21',NULL,NULL,NULL,'full-width',NULL,NULL,NULL,1,NULL,'public',1,'cgu');
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
  PRIMARY KEY (`id`),
  KEY `idx_pageview_created_at` (`created_at`),
  KEY `idx_pageview_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=407 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_view`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page_view` WRITE;
/*!40000 ALTER TABLE `page_view` DISABLE KEYS */;
INSERT INTO `page_view` VALUES
(1,'/','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-03-11 07:02:01'),
(2,'/','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController','2026-03-11 07:03:27'),
(3,'/page/a-propos','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-11 07:05:56'),
(4,'/','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CMenuCrudController','2026-03-11 07:08:12'),
(5,'/','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CMenuCrudController','2026-03-11 07:08:14'),
(6,'/','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CMenuCrudController','2026-03-11 07:08:53'),
(7,'/','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CMenuCrudController','2026-03-11 07:08:56'),
(8,'/','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CMenuCrudController','2026-03-11 07:09:05'),
(9,'/categorie/categorie-test','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-11 07:09:07'),
(10,'/article/article-test','b78211b6c06d07246822b810f2fae7e52cbc85b1f2482a81488a5e79b47d1b0f','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/categorie-test','2026-03-11 07:09:10'),
(11,'/','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-13 09:20:34'),
(12,'/','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-13 09:45:34'),
(13,'/categorie/categorie-test','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-13 09:46:34'),
(14,'/article/article-test','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/categorie-test','2026-03-13 09:46:39'),
(15,'/page/a-propos','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/article-test','2026-03-13 09:46:43'),
(16,'/article/article-test','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-13 09:47:10'),
(17,'/login','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/article-test','2026-03-13 09:51:26'),
(18,'/','011a304df7bdb4e29838ddb68023461278abf4e27a6d11effd822d069466472c','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/login','2026-03-13 09:51:30'),
(19,'/login','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=edit&crudControllerFqcn=App%5CController%5CAdmin%5CArticleCrudController&entityId=1','2026-03-16 09:21:06'),
(20,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 09:21:39'),
(21,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 09:22:00'),
(22,'/categorie/categorie-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-16 09:22:09'),
(23,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 09:22:22'),
(24,'/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:16:30'),
(25,'/contact','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:16:59'),
(26,'/article/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:23:17'),
(27,'/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:23:41'),
(28,'/contact','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:23:43'),
(29,'/article/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:23:44'),
(30,'/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:47:48'),
(31,'/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:47:49'),
(32,'/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:47:50'),
(33,'/article/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:47:51'),
(34,'/article/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:47:53'),
(35,'/contact','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:47:54'),
(36,'/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:48:01'),
(37,'/','72eefc6f2fcf5398f6a6a05d1fabeafbb7bcf2cda1146e79267ffd56a8b984d3','curl/8.17.0',NULL,'2026-03-16 16:48:09'),
(38,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:51:14'),
(39,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:52:22'),
(40,'/categorie/categorie-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=corporate','2026-03-16 16:52:36'),
(41,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:52:54'),
(42,'/page/a-propos','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=moderne','2026-03-16 16:53:03'),
(43,'/categorie/categorie-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos?_preview_theme=moderne','2026-03-16 16:53:05'),
(44,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:53:14'),
(45,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:53:31'),
(46,'/page/a-propos','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=corporate','2026-03-16 16:53:40'),
(47,'/article/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos?_preview_theme=corporate','2026-03-16 16:53:46'),
(48,'/categorie/categorie-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=corporate','2026-03-16 16:53:50'),
(49,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/categorie-test?_preview_theme=corporate','2026-03-16 16:53:54'),
(50,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:55:03'),
(51,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:55:27'),
(52,'/page/a-propos','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=corporate','2026-03-16 16:55:40'),
(53,'/categorie/categorie-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos?_preview_theme=corporate','2026-03-16 16:55:42'),
(54,'/article/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/categorie-test?_preview_theme=corporate','2026-03-16 16:55:43'),
(55,'/categorie/categorie-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=corporate','2026-03-16 16:55:46'),
(56,'/article/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/categorie-test?_preview_theme=corporate','2026-03-16 16:55:48'),
(57,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=corporate','2026-03-16 16:56:52'),
(58,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:57:21'),
(59,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 16:57:42'),
(60,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:10'),
(61,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:10'),
(62,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:11'),
(63,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:11'),
(64,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:11'),
(65,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:11'),
(66,'/contact','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:18'),
(67,'/contact','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:18'),
(68,'/article/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 17:16:18'),
(69,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 17:16:51'),
(70,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 17:17:06'),
(71,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 17:17:13'),
(72,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 17:17:21'),
(73,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 17:17:33'),
(74,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 17:17:40'),
(75,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-16 17:18:00'),
(76,'/contact','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-16 17:18:02'),
(77,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-03-16 17:18:07'),
(78,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 17:18:22'),
(79,'/contact','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=corporate','2026-03-16 17:18:30'),
(80,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 17:53:25'),
(81,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:08:02'),
(82,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:11:02'),
(83,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-16 18:11:11'),
(84,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:14:44'),
(85,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-16 18:14:55'),
(86,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:19:16'),
(87,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-16 18:19:42'),
(88,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:23:51'),
(89,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:25:09'),
(90,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:25:34'),
(91,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 18:25:42'),
(92,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:18'),
(93,'/contact','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:18'),
(94,'/article/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:18'),
(95,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:26'),
(96,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:26'),
(97,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:26'),
(98,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:26'),
(99,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:27'),
(100,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 18:41:27'),
(101,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 20:22:05'),
(102,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-16 20:25:56'),
(103,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CUserCrudController','2026-03-16 20:33:48'),
(104,'/article/article-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-16 20:33:55'),
(105,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','curl/8.11.0',NULL,'2026-03-16 21:10:31'),
(106,'/article/article-test','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-16 21:11:49'),
(107,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin','2026-03-16 21:12:04'),
(108,'/login','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-16 21:12:12'),
(109,'/','fcd589fd2350eb3d6df975b146ba1ccb5be3acfe66676199045bac6a2eff2315','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin','2026-03-16 21:12:20'),
(110,'/','698c83c619ca7b9a4846d523c646fea95c2eec480407e805372e01cf006f1e15','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin','2026-03-17 06:13:33'),
(111,'/','698c83c619ca7b9a4846d523c646fea95c2eec480407e805372e01cf006f1e15','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin','2026-03-17 07:07:28'),
(112,'/login','698c83c619ca7b9a4846d523c646fea95c2eec480407e805372e01cf006f1e15','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-17 07:07:35'),
(113,'/article/article-test','4f1e8aa8f6e9030270640b6c538c3d31814ab5446d765a990e01ca7f9ce27acf','curl/8.17.0',NULL,'2026-03-17 17:32:24'),
(114,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CArticleCrudController','2026-03-18 05:12:30'),
(115,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-18 05:12:31'),
(116,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-18 05:12:34'),
(117,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/test-toc','2026-03-18 05:12:57'),
(118,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-18 05:13:00'),
(119,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-18 05:13:02'),
(120,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-18 05:13:06'),
(121,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CUserCrudController','2026-03-18 05:13:26'),
(122,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-18 05:13:28'),
(123,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-18 05:13:29'),
(124,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-18 05:13:53'),
(125,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-18 05:13:56'),
(126,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-18 05:14:00'),
(127,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/test-toc','2026-03-18 05:14:14'),
(128,'/article/article-test','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/test-toc','2026-03-18 05:14:26'),
(129,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/article-test','2026-03-18 05:14:53'),
(130,'/article/article-test','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-18 05:14:57'),
(131,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/article-test','2026-03-18 05:15:00'),
(132,'/page/a-propos','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-18 05:15:01'),
(133,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:15:29'),
(134,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=moderne','2026-03-18 05:15:32'),
(135,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=moderne','2026-03-18 05:15:36'),
(136,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/test-toc?_preview_theme=moderne','2026-03-18 05:16:31'),
(137,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=moderne','2026-03-18 05:16:34'),
(138,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:46:48'),
(139,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-18 05:46:56'),
(140,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-18 05:47:03'),
(141,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:47:21'),
(142,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=artisan','2026-03-18 05:47:23'),
(143,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:48:00'),
(144,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=artisan','2026-03-18 05:48:02'),
(145,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=artisan','2026-03-18 05:48:08'),
(146,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:48:17'),
(147,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=corporate','2026-03-18 05:48:18'),
(148,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:48:36'),
(149,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=default','2026-03-18 05:48:38'),
(150,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=default','2026-03-18 05:48:44'),
(151,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:48:58'),
(152,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=moderne','2026-03-18 05:49:08'),
(153,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=moderne','2026-03-18 05:49:10'),
(154,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/test-toc?_preview_theme=moderne','2026-03-18 05:49:40'),
(155,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=moderne','2026-03-18 05:51:22'),
(156,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:51:53'),
(157,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=vitrine','2026-03-18 05:51:56'),
(158,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=vitrine','2026-03-18 05:52:02'),
(159,'/page/a-propos','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?categorie=categorie-test&_preview_theme=vitrine','2026-03-18 05:52:10'),
(160,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:52:47'),
(161,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=starter','2026-03-18 05:52:49'),
(162,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=starter','2026-03-18 05:52:51'),
(163,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/test-toc?_preview_theme=starter','2026-03-18 05:52:54'),
(164,'/page/a-propos','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=starter','2026-03-18 05:53:31'),
(165,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:54:23'),
(166,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:55:33'),
(167,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:55:44'),
(168,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=corporate','2026-03-18 05:55:59'),
(169,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:56:49'),
(170,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=artisan','2026-03-18 05:56:50'),
(171,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:57:02'),
(172,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=default','2026-03-18 05:57:04'),
(173,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:57:14'),
(174,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=moderne','2026-03-18 05:57:16'),
(175,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:57:34'),
(176,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=starter','2026-03-18 05:57:36'),
(177,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=starter','2026-03-18 05:57:42'),
(178,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?categorie=categorie-test&_preview_theme=starter','2026-03-18 05:57:44'),
(179,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-18 05:57:47'),
(180,'/article/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=vitrine','2026-03-18 05:57:49'),
(181,'/article/test-toc','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/?_preview_theme=vitrine','2026-03-18 05:57:57'),
(182,'/','1f25c75e079dee0f92048812a2d86834763db1a77386d47ee2ace273ee8a4770','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_menu_manager','2026-03-18 15:08:02'),
(183,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:47:11'),
(184,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:50:30'),
(185,'/article/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:50:42'),
(186,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/article/','2026-03-20 13:51:25'),
(187,'/page/a-propos','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:52:55'),
(188,'/contact','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:55:18'),
(189,'/contact','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:55:33'),
(190,'/recherche','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:55:47'),
(191,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:56:08'),
(192,'/article/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:56:27'),
(193,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 13:56:41'),
(194,'/login','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:06:50'),
(195,'/login','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/login','2026-03-20 14:07:25'),
(196,'/login','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/login','2026-03-20 14:08:24'),
(197,'/login','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/login','2026-03-20 14:08:50'),
(198,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/login','2026-03-20 14:09:05'),
(199,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:09:44'),
(200,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:12:18'),
(201,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:12:48'),
(202,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:13:25'),
(203,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:14:42'),
(204,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:15:17'),
(205,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:19:06'),
(206,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:20:35'),
(207,'/article/test-toc','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:21:38'),
(208,'/article/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:22:13'),
(209,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 14:22:41'),
(210,'/login','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController','2026-03-20 16:10:19'),
(211,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:32:24'),
(212,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:33:12'),
(213,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:33:23'),
(214,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:33:37'),
(215,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:33:50'),
(216,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:34:05'),
(217,'/article/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:34:42'),
(218,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:36:24'),
(219,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:36:39'),
(220,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:37:04'),
(221,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:39:06'),
(222,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:39:29'),
(223,'/article/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:40:08'),
(224,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/article/?_preview_theme=artisan','2026-03-20 16:41:28'),
(225,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 16:42:20'),
(226,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 18:03:57'),
(227,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-20 18:04:25'),
(228,'/','4db5c058159aedc8f7ed8614fbaf2184b143c48e2ac8a6347ec1ad17c2a9c3a6','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/login','2026-03-20 18:21:17'),
(229,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/login','2026-03-21 06:59:33'),
(230,'/login','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-21 06:59:37'),
(231,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CEventCrudController','2026-03-21 07:01:11'),
(232,'/article/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-21 07:01:22'),
(233,'/article/test-toc','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-21 07:02:13'),
(234,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-21 07:04:39'),
(235,'/evenement/tous-a-la-peche','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-21 07:04:48'),
(236,'/article/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-21 07:08:20'),
(237,'/article/article-test','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-21 07:08:24'),
(238,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/article-test','2026-03-21 07:10:38'),
(239,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/article-test','2026-03-21 07:10:40'),
(240,'/evenement/tous-a-la-peche','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-21 07:26:56'),
(241,'/evenement/tous-a-la-peche','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-21 07:31:08'),
(242,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 07:56:17'),
(243,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:29:43'),
(244,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:35:15'),
(245,'/catalogue/sortie-peche-en-mer-journee-complete','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/catalogue','2026-03-21 18:35:42'),
(246,'/catalogue/sortie-peche-en-mer-journee-complete','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:36:56'),
(247,'/catalogue/sortie-peche-en-mer-journee-complete','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:38:13'),
(248,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:38:29'),
(249,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:43:00'),
(250,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:43:18'),
(251,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:43:36'),
(252,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:43:46'),
(253,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:43:56'),
(254,'/catalogue','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:44:12'),
(255,'/catalogue/sortie-peche-en-mer-journee-complete','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:44:30'),
(256,'/catalogue/sortie-peche-en-mer-journee-complete','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:44:41'),
(257,'/catalogue/sortie-peche-en-mer-journee-complete','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:44:52'),
(258,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:45:11'),
(259,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:46:47'),
(260,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:48:10'),
(261,'/','ed183cc36d7fb1efe0fab2adf3fa0a90946729febdc4d5b36587a21103eb46e9','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-21 18:48:29'),
(262,'/','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=edit&crudControllerFqcn=App%5CController%5CAdmin%5CProductCrudController&entityId=1','2026-03-22 06:50:57'),
(263,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-22 06:51:05'),
(264,'/catalogue/sortie-peche-en-mer-journee-complete','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-22 06:51:09'),
(265,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-22 06:51:25'),
(266,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-22 06:51:41'),
(267,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:03:25'),
(268,'/catalogue/sortie-peche-en-mer-journee-complete','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/catalogue','2026-03-22 07:04:04'),
(269,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:05:01'),
(270,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-22 07:05:10'),
(271,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/catalogue?_preview_theme=corporate','2026-03-22 07:05:12'),
(272,'/catalogue/sortie-peche-en-mer-journee-complete','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-22 07:05:23'),
(273,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-peche-en-mer-journee-complete','2026-03-22 07:05:29'),
(274,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:05:30'),
(275,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:06:15'),
(276,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:06:29'),
(277,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:06:44'),
(278,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-peche-en-mer-journee-complete','2026-03-22 07:19:42'),
(279,'/catalogue/sortie-journee-peche-en-montagne','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-22 07:19:44'),
(280,'/catalogue/sortie-journee-peche-en-montagne','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-22 07:24:13'),
(281,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-journee-peche-en-montagne','2026-03-22 07:24:17'),
(282,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:27:07'),
(283,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:28:27'),
(284,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:30:42'),
(285,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-22 07:34:39'),
(286,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-journee-peche-en-montagne','2026-03-22 07:42:13'),
(287,'/catalogue/sortie-journee-peche-en-montagne','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-22 07:42:16'),
(288,'/contact','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-journee-peche-en-montagne','2026-03-22 07:42:21'),
(289,'/catalogue/categorie/peche-en-eau-douce','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-22 07:42:28'),
(290,'/catalogue/categorie/peche-en-mer','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/categorie/peche-en-eau-douce','2026-03-22 07:42:29'),
(291,'/catalogue','99e0ee9a47d91bafd2601b97989989a3deb64bbb1e739dc1b8aedbc40889d615','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/categorie/peche-en-mer','2026-03-22 07:42:34'),
(292,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 05:38:15'),
(293,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 05:38:44'),
(294,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 05:41:11'),
(295,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 05:41:28'),
(296,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 05:41:44'),
(297,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 05:42:00'),
(298,'/catalogue/sortie-journee-peche-en-montagne','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 14:02:22'),
(299,'/catalogue/sortie-journee-peche-en-montagne','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 14:05:29'),
(300,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 14:06:20'),
(301,'/','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-23 14:06:30'),
(302,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-23 14:06:33'),
(303,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/panier','2026-03-23 14:06:35'),
(304,'/catalogue/sortie-peche-en-mer-journee-complete','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-23 14:06:37'),
(305,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-peche-en-mer-journee-complete','2026-03-23 14:06:39'),
(306,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/panier','2026-03-23 14:07:11'),
(307,'/catalogue/sortie-journee-peche-en-montagne','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-23 14:07:12'),
(308,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-journee-peche-en-montagne','2026-03-23 14:07:14'),
(309,'/catalogue/sortie-journee-peche-en-montagne','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 14:11:46'),
(310,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue/sortie-journee-peche-en-montagne','2026-03-23 14:11:50'),
(311,'/commander','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/panier','2026-03-23 14:11:54'),
(312,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/catalogue/sortie-journee-peche-en-montagne','2026-03-23 14:12:03'),
(313,'/commander','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/panier','2026-03-23 14:12:29'),
(314,'/commande/confirmation/BW-20260323-1C1B2','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/commander','2026-03-23 14:15:17'),
(315,'/catalogue/sortie-journee-peche-en-montagne','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:07:21'),
(316,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:07:55'),
(317,'/catalogue/sortie-journee-peche-en-montagne','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:08:11'),
(318,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:08:42'),
(319,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:08:59'),
(320,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:09:15'),
(321,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:09:31'),
(322,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:09:44'),
(323,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 15:09:59'),
(324,'/mentions-legales','84b4bee9c4e4f76c3fccfe35ac99e1310bdd9559eeba645251b337497ec687bf','curl/8.17.0',NULL,'2026-03-23 19:56:31'),
(325,'/','84b4bee9c4e4f76c3fccfe35ac99e1310bdd9559eeba645251b337497ec687bf','curl/8.17.0',NULL,'2026-03-23 19:56:36'),
(326,'/','84b4bee9c4e4f76c3fccfe35ac99e1310bdd9559eeba645251b337497ec687bf','curl/8.17.0',NULL,'2026-03-23 19:56:41'),
(327,'/','84b4bee9c4e4f76c3fccfe35ac99e1310bdd9559eeba645251b337497ec687bf','curl/8.17.0',NULL,'2026-03-23 19:56:46'),
(328,'/','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-23 19:59:12'),
(329,'/mentions-legales','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/','2026-03-23 19:59:59'),
(330,'/','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_menu_manager','2026-03-23 20:04:55'),
(331,'/','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_menu_manager','2026-03-23 20:06:04'),
(332,'/commander','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/panier','2026-03-23 20:06:14'),
(333,'/catalogue','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/commander','2026-03-23 20:06:18'),
(334,'/article/','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/catalogue','2026-03-23 20:07:41'),
(335,'/evenements','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-23 20:07:45'),
(336,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/evenements','2026-03-23 20:07:47'),
(337,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/panier','2026-03-23 20:07:51'),
(338,'/panier','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/panier','2026-03-23 20:07:52'),
(339,'/mentions-legales','79b67789f84cf9f42c2a491c5e0c1962df76a91958d577480f0fee709fdf3379','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/panier','2026-03-23 20:10:35'),
(340,'/login','8138e7973d59958592bb3b6d51b91648b9d1e83cc31e8303f6ad154a52fa4880','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin','2026-03-25 05:38:13'),
(341,'/','8138e7973d59958592bb3b6d51b91648b9d1e83cc31e8303f6ad154a52fa4880','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_menu_manager','2026-03-25 05:44:10'),
(342,'/contact','8138e7973d59958592bb3b6d51b91648b9d1e83cc31e8303f6ad154a52fa4880','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-25 09:13:04'),
(343,'/','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CFaqCrudController','2026-03-26 07:51:46'),
(344,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-26 07:52:14'),
(345,'/','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/faq','2026-03-26 07:52:45'),
(346,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 07:54:41'),
(347,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-26 07:54:55'),
(348,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/faq','2026-03-26 07:55:29'),
(349,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-26 08:04:28'),
(350,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 08:04:59'),
(351,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 09:29:40'),
(352,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 10:23:08'),
(353,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 10:23:32'),
(354,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 10:24:22'),
(355,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 10:24:40'),
(356,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 10:25:48'),
(357,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 10:26:08'),
(358,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 10:26:26'),
(359,'/faq','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-26 10:37:04'),
(360,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-26 10:37:34'),
(361,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisations','2026-03-26 10:37:36'),
(362,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisations','2026-03-26 10:38:01'),
(363,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-26 10:38:06'),
(364,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 10:41:05'),
(365,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 10:41:05'),
(366,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-26 10:54:34'),
(367,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisations','2026-03-26 10:54:36'),
(368,'/realisations','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-26 17:06:21'),
(369,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 17:06:23'),
(370,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 17:06:28'),
(371,'/page/a-propos','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisation/super-realisation','2026-03-26 17:07:32'),
(372,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 17:08:44'),
(373,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 17:09:15'),
(374,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisations','2026-03-26 17:09:21'),
(375,'/login','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CMediaCrudController','2026-03-26 17:10:54'),
(376,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisations','2026-03-26 17:11:11'),
(377,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 17:11:28'),
(378,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/realisations','2026-03-26 17:11:54'),
(379,'/realisation/super-realisation','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisations','2026-03-26 17:29:31'),
(380,'/','d5288e1376ee70b2123185007f269d102f17bd419a42e8d92dfe481c92ef49ed','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisation/super-realisation','2026-03-26 17:29:35'),
(381,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-27 14:48:37'),
(382,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-27 14:48:38'),
(383,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-27 14:48:41'),
(384,'/login','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-27 14:48:50'),
(385,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-27 14:49:07'),
(386,'/','0d627048bf894bf53b46cb4261f245161dfb926567a9a2045473fe78080683c3','curl/8.17.0',NULL,'2026-03-30 07:45:03'),
(387,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-30 07:46:35'),
(388,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-30 07:47:19'),
(389,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/','2026-03-30 07:47:34'),
(390,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/','2026-03-30 07:47:37'),
(391,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/','2026-03-30 07:47:38'),
(392,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/','2026-03-30 07:47:56'),
(393,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-30 07:48:54'),
(394,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 07:48:56'),
(395,'/','0d627048bf894bf53b46cb4261f245161dfb926567a9a2045473fe78080683c3','curl/8.17.0',NULL,'2026-03-30 08:05:18'),
(396,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-30 08:05:25'),
(397,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 08:05:46'),
(398,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 08:32:44'),
(399,'/article/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 08:32:45'),
(400,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-30 08:32:50'),
(401,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','http://localhost:8080/','2026-03-30 08:35:46'),
(402,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-30 08:36:16'),
(403,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-30 08:36:29'),
(404,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-30 09:03:25'),
(405,'/login','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0',NULL,'2026-03-30 09:05:18'),
(406,'/login','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/login','2026-03-30 09:05:23');
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
  CONSTRAINT `FK_2F2A62E43DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_item`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `portfolio_item` WRITE;
/*!40000 ALTER TABLE `portfolio_item` DISABLE KEYS */;
INSERT INTO `portfolio_item` VALUES
(1,'Super réalisation','super-realisation','Vraiment chouette','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}},{\"type\":\"columns\",\"content\":[{\"type\":\"column\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"Super travail\"}]}]},{\"type\":\"column\",\"content\":[{\"type\":\"image\",\"attrs\":{\"src\":\"\\/documents\\/medias\\/profil-david-8468f1e2-8807-4819-b967-4de6049e9fe4.jpg\",\"alt\":\"profil-david-8468f1e2-8807-4819-b967-4de6049e9fe4\",\"title\":null}}]}]}]}','<p style=\"text-align: center\"></p><div class=\"block-columns\"><div class=\"block-column\"><p style=\"text-align: center\">Super travail</p></div><div class=\"block-column\"><figure><img src=\"/documents/medias/profil-david-8468f1e2-8807-4819-b967-4de6049e9fe4.jpg\" alt=\"profil-david-8468f1e2-8807-4819-b967-4de6049e9fe4\" loading=\"lazy\" /></figure></div></div>','SDC','2026-03-23','https://www.strategiedigitaleconseil.fr',NULL,0,1,1,NULL,NULL,NULL,0,NULL,NULL,3);
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
INSERT INTO `portfolio_item_tag` VALUES
(1,1);
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
  CONSTRAINT `FK_D34A04AD3DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES
(1,'Sortie peche en mer - Journee complete','sortie-peche-en-mer-journee-complete','Embarquez pour une journee de peche au large. Materiel fourni, guide professionnel. Debutants et confirmes bienvenus.',NULL,'',120.00,NULL,20.00,'available',NULL,NULL,1,1,0,NULL,NULL,NULL,0,NULL,1,NULL),
(2,'Sortie journée pêche en montagne','sortie-journee-peche-en-montagne','Super journée de pe^che à la truite',NULL,'',125.00,NULL,20.00,'available',NULL,NULL,1,0,0,NULL,NULL,NULL,0,NULL,2,NULL);
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
  CONSTRAINT `FK_CDFC73563DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_category`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product_category` WRITE;
/*!40000 ALTER TABLE `product_category` DISABLE KEYS */;
INSERT INTO `product_category` VALUES
(1,'Pêche en mer','peche-en-mer','Sorite et organisations de pêche en mer',2,1,NULL),
(2,'Pêche en eau douce','peche-en-eau-douce','Sortie et organisation de pêche en eau douce',1,1,NULL);
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
  CONSTRAINT `FK_64617F03EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_image`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `product_image` WRITE;
/*!40000 ALTER TABLE `product_image` DISABLE KEYS */;
INSERT INTO `product_image` VALUES
(2,0,2,3);
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
  CONSTRAINT `FK_E19D9AD23DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media` (`id`),
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
  `logo_id` int(11) DEFAULT NULL,
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
  `favicon_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `hero_image_id` int(11) DEFAULT NULL,
  `about_image_id` int(11) DEFAULT NULL,
  `enabled_modules` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '["vitrine"]' CHECK (json_valid(`enabled_modules`)),
  `catalog_price_display` varchar(3) NOT NULL DEFAULT 'ttc',
  `stripe_public_key` varchar(255) DEFAULT NULL,
  `stripe_secret_key` varchar(255) DEFAULT NULL,
  `stripe_webhook_secret` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_694309E4F98F144A` (`logo_id`),
  KEY `IDX_694309E4D78119FD` (`favicon_id`),
  KEY `IDX_694309E47E3C61F9` (`owner_id`),
  KEY `IDX_694309E498BB94C5` (`hero_image_id`),
  KEY `IDX_694309E471BB2404` (`about_image_id`),
  CONSTRAINT `FK_694309E471BB2404` FOREIGN KEY (`about_image_id`) REFERENCES `media` (`id`),
  CONSTRAINT `FK_694309E47E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_694309E498BB94C5` FOREIGN KEY (`hero_image_id`) REFERENCES `media` (`id`),
  CONSTRAINT `FK_694309E4D78119FD` FOREIGN KEY (`favicon_id`) REFERENCES `media` (`id`),
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
(1,'Mon blog','Mon blog','laignelet.david@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'vitrine',NULL,NULL,NULL,NULL,'[\"vitrine\",\"services\",\"blog\",\"events\",\"private_pages\",\"directory\",\"catalogue\",\"ecommerce\",\"faq\",\"portfolio\"]','ttc',NULL,NULL,NULL);
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
  CONSTRAINT `FK_478E9021EA9FDD75` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`),
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES
(1,'Test de tag','test-de-tag');
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
  `subscribe_news` tinyint(1) DEFAULT NULL,
  `subscribe_articles` tinyint(1) DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `bio` longtext DEFAULT NULL,
  `avatar_id` int(11) DEFAULT NULL,
  `subscribe_events` tinyint(4) NOT NULL DEFAULT 0,
  `company` varchar(255) DEFAULT NULL,
  `job_title` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `is_directory_visible` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`),
  KEY `IDX_8D93D64986383B10` (`avatar_id`),
  CONSTRAINT `FK_8D93D64986383B10` FOREIGN KEY (`avatar_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(1,'laignelet.david@gmail.com','[\"ROLE_SUPER_ADMIN\"]','$2y$13$KjmsekwJqiAkdFgOfpYEcu4fjbg0jpcX9kyzTxuMZHvC/TjI4xHZm','Laignelet','David',NULL,NULL,0,NULL,NULL,0,NULL,NULL,NULL,0);
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

-- Dump completed on 2026-04-02 15:15:50
