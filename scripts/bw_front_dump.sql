/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bw_front
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
(1,'Créer son site','creer-son-site','#2563eb',NULL,NULL,NULL,0,NULL,NULL),
(2,'Référencement & visibilité','referencement-et-visibilite','#f5a623',NULL,NULL,NULL,0,NULL,NULL),
(3,'Gérer son contenu','gerer-son-contenu','#10b981',NULL,NULL,NULL,0,NULL,NULL),
(4,'Sécurité & tranquillité','securite-et-tranquillite','#6366f1',NULL,NULL,NULL,0,NULL,NULL);
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
('DoctrineMigrations\\Version20260327093858','2026-03-27 10:53:31',3613),
('DoctrineMigrations\\Version20260330175902','2026-03-30 19:59:14',52),
('DoctrineMigrations\\Version20260331051133','2026-03-31 07:12:33',773),
('DoctrineMigrations\\Version20260331120749','2026-03-31 14:08:08',51),
('DoctrineMigrations\\Version20260331134753','2026-03-31 15:48:05',51),
('DoctrineMigrations\\Version20260402035203','2026-04-02 05:52:14',171);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` VALUES
(1,'Je ne suis pas du tout technique, est-ce que je vais m\'en sortir ?','je-ne-suis-pas-du-tout-technique',NULL,'C\'est justement pour vous qu\'on a créé BlogWeb. L\'éditeur est visuel : vous écrivez comme dans un document Word, vous ajoutez vos photos en un clic, vous publiez. Si vous savez envoyer un email, vous savez gérer votre site.',NULL,1,1,NULL),
(2,'Combien de temps faut-il pour avoir mon site en ligne ?','combien-de-temps-pour-site-en-ligne',NULL,'Une demi-journée. On configure tout de notre côté — thème, couleurs, pages, SEO. Vous recevez un site prêt à l\'emploi. Il ne vous reste plus qu\'à ajouter votre contenu quand vous le souhaitez.',NULL,2,1,NULL),
(3,'Pourquoi un abonnement mensuel ? Qu\'est-ce que ça couvre ?','pourquoi-un-abonnement-mensuel',NULL,'L\'abonnement inclut l\'hébergement de votre site, la maintenance technique, les mises à jour de sécurité et le support. Vous n\'avez rien d\'autre à payer, rien à gérer. Votre site tourne, on s\'en occupe.',NULL,3,1,NULL),
(4,'Est-ce que mon site sera bien référencé sur Google ?','est-ce-que-mon-site-sera-bien-reference',NULL,'Le SEO est intégré dès le départ : structure technique optimisée, balises automatiques, sitemap, données structurées. Votre site part avec de bonnes bases. Ensuite, plus vous publiez du contenu de qualité, mieux Google vous positionne — et l\'éditeur est là pour ça.',NULL,4,1,NULL),
(5,'Je n\'ai pas de logo ni de photos professionnelles, c\'est un problème ?','pas-de-logo-ni-de-photos',NULL,'Non. On peut travailler avec des images libres de droits adaptées à votre activité pour démarrer. Et le jour où vous avez vos propres visuels, vous les remplacez vous-même en deux clics.',NULL,5,1,NULL),
(6,'Est-ce que je peux modifier mon site moi-même après la mise en ligne ?','modifier-site-apres-mise-en-ligne',NULL,'C\'est le principe. Vos textes, vos articles, vos photos, vos services — vous gérez tout depuis votre espace d\'administration. Pas besoin de nous appeler pour changer une virgule.',NULL,6,1,NULL),
(7,'Et si j\'ai besoin d\'aide après la mise en ligne ?','besoin-aide-apres-mise-en-ligne',NULL,'On reste disponible. Votre abonnement inclut le support. Une question, un doute, un besoin — vous nous écrivez, on vous répond.',NULL,7,1,NULL),
(8,'Je veux vendre en ligne, c\'est possible ?','vendre-en-ligne',NULL,'Oui, avec l\'offre Complet. Votre boutique est intégrée directement dans votre site avec le paiement sécurisé par Stripe. Pas de plateforme externe, tout est au même endroit.',NULL,8,1,NULL),
(9,'Qu\'est-ce qui vous différencie des autres solutions comme les créateurs de sites en ligne ?','difference-avec-autres-solutions',NULL,'Vous avez un interlocuteur unique qui connaît votre projet. Votre site est construit sur une technologie professionnelle, pas sur un template partagé par des milliers d\'autres sites. Et surtout, vous êtes propriétaire de votre contenu — pas dépendant d\'une plateforme.',NULL,9,1,NULL),
(10,'Je suis freelance, je peux proposer BlogWeb à mes clients ?','freelance-proposer-blogweb',NULL,'Absolument. On a un programme dédié : vous gérez la relation client et le contenu, on gère toute la technique. Consultez notre page Freelances pour en savoir plus.',NULL,10,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES
(3,'Blog Web - Offre Freelance - Un CMS clé en main','david-laignelet-direction-commerciale-externalisee-automatisation-web-99bc59fd-04c0-42bc-acf0-88f47e907e67.jpg',NULL),
(4,'Blog Web - Accueil - Un CMS clé en main','b-w-accueil-web1920-00751565-7eb8-4c04-95e6-5cb0e8677804.jpg',NULL),
(5,'Blog Web - Offres - Un CMS clé en main','david-laignelet-direction-commerciale-externalisee-automatisation-web-2-003683d2-1ca4-4a16-94c1-0b1af616cb5d.jpg',NULL),
(6,'Laignelet David - Blog Web - CMS professionnel clé en main','dl-1-460f0b71-b2a1-4d99-97d2-13e0764e6bb3.jpg',NULL),
(7,'Laignelet David - Blog Web - CMS professionnel clé en main','d-3-ab7e2bf8-05b3-4912-ae5b-dca7416929be.jpg',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES
(1,'Accueil',0,1,'route','header',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL),
(2,'Blog',10,0,'route','header',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL),
(3,'Services',20,0,'route','header',1,'services','app_service_index',NULL,NULL,NULL,NULL,NULL,NULL),
(4,'Catalogue',30,0,'route','header',1,'catalogue','app_product_index',NULL,NULL,NULL,NULL,NULL,NULL),
(5,'Evenements',40,0,'route','header',1,'events','app_event_index',NULL,NULL,NULL,NULL,NULL,NULL),
(6,'Annuaire',50,0,'route','header',1,'annuaire','app_directory',NULL,NULL,NULL,NULL,NULL,NULL),
(7,'Contact',40,0,'route','header',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL),
(8,'Accueil',0,0,'route','footer_nav',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL),
(9,'Blog',10,0,'route','footer_nav',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL),
(10,'Contact',20,0,'route','footer_nav',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL),
(11,'Mentions legales',0,1,'route','footer_legal',1,'mentions-legales','app_legal_page','{\"type\":\"mentions-legales\"}',NULL,NULL,NULL,NULL,NULL),
(12,'Politique de confidentialite',10,1,'route','footer_legal',1,'politique-confidentialite','app_legal_page','{\"type\":\"politique-de-confidentialite\"}',NULL,NULL,NULL,NULL,NULL),
(13,'CGV',20,0,'route','footer_legal',1,'cgv','app_legal_page','{\"type\":\"conditions-generales-de-vente\"}',NULL,NULL,NULL,NULL,NULL),
(14,'CGU',30,0,'route','footer_legal',1,'cgu','app_legal_page','{\"type\":\"conditions-generales-utilisation\"}',NULL,NULL,NULL,NULL,NULL),
(15,'Les offres',10,1,'_self','header',0,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL),
(16,'Freelances',20,1,'_self','header',0,NULL,NULL,NULL,NULL,NULL,NULL,5,NULL),
(17,'À propos',30,1,'_self','header',0,NULL,NULL,NULL,NULL,NULL,NULL,6,NULL),
(18,'Site sur-mesure vs CMS classique',0,1,'_self','footer_nav',0,NULL,NULL,NULL,NULL,NULL,NULL,7,NULL),
(19,'Nos réalisations',10,1,'_self','footer_nav',0,NULL,'app_portfolio_index',NULL,NULL,NULL,NULL,NULL,NULL),
(20,'FAQ',20,1,'_self','footer_nav',0,NULL,'app_faq_index',NULL,NULL,NULL,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES
(1,'public','Mentions légales','<p><em>Dernière mise à jour : {{DATE}}</em></p>\n\n<h2>1. Éditeur du site</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>Forme juridique</strong></td><td>{{FORME_JURIDIQUE}}</td></tr>\n<tr><td><strong>Siège social</strong></td><td>{{ADRESSE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>\n<tr><td><strong>N° TVA</strong></td><td>{{TVA}}</td></tr>\n<tr><td><strong>Capital social</strong></td><td>{{CAPITAL}}</td></tr>\n<tr><td><strong>Directeur de publication</strong></td><td>{{NOM_DIRECTEUR}}</td></tr>\n<tr><td><strong>Contact</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>\n</tbody>\n</table>\n\n<h2>2. Hébergement</h2>\n<table>\n<tbody>\n<tr><td><strong>Hébergeur</strong></td><td>{{NOM_HEBERGEUR}}</td></tr>\n<tr><td><strong>Adresse</strong></td><td>{{ADRESSE_HEBERGEUR}}</td></tr>\n<tr><td><strong>Site web</strong></td><td>{{URL_HEBERGEUR}}</td></tr>\n</tbody>\n</table>\n<p>L&#039;ensemble des données sont hébergées en France, conformément au RGPD.</p>\n\n<h2>3. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p>\n<p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p>\n\n<h2>4. Protection des données</h2>\n<ul>\n<li>Hébergement 100 % France</li>\n<li>Aucun transfert de données hors UE</li>\n<li>Données personnelles jamais revendues</li>\n</ul>\n<p><strong>Contact DPO :</strong> {{EMAIL_DPO}}</p>\n<p>Voir la <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a> pour les détails complets.</p>\n\n<h2>5. Cookies</h2>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Type</th><th>Finalité</th><th>Consentement</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP</td><td>Essentiel</td><td>Authentification</td><td>Non requis</td></tr>\n<tr><td>CSRF</td><td>Essentiel</td><td>Sécurité formulaires</td><td>Non requis</td></tr>\n<tr><td>Google Analytics</td><td>Analytique</td><td>Mesure d&#039;audience</td><td><strong>Requis</strong></td></tr>\n<tr><td>Préférences cookies</td><td>Fonctionnel</td><td>Mémoriser votre choix</td><td>Non requis</td></tr>\n</tbody>\n</table>\n<p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p>\n\n<h2>6. Limitation de responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p>\n<p>L&#039;éditeur décline toute responsabilité en cas d&#039;interruption du site, de survenance de bugs ou d&#039;incompatibilité du site avec certains matériels ou configurations.</p>\n\n<h2>7. Droit applicable et litiges</h2>\n<p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p>\n<p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : {{MEDIATEUR}}.</p>\n\n<h2>8. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>\n</tbody>\n</table>','mentions-legales',1,'2026-03-27 10:55:08','2026-03-27 14:10:52',NULL,'full-width',1,'mentions-legales',NULL,'Mentions légales du site. Éditeur, hébergeur, propriété intellectuelle et contact.',NULL,1,NULL,NULL),
(2,'public','Politique de confidentialité','<p><em>Dernière mise à jour : {{DATE}}</em></p>\n\n<h2>1. Responsable du traitement</h2>\n<table>\n<tbody>\n<tr><td><strong>Entité</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>Représentant</strong></td><td>{{NOM_DIRECTEUR}}</td></tr>\n<tr><td><strong>Siège</strong></td><td>{{ADRESSE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>\n<tr><td><strong>DPO</strong></td><td>{{EMAIL_DPO}}</td></tr>\n</tbody>\n</table>\n\n<h2>2. Données collectées</h2>\n\n<h3>2.1 Compte utilisateur</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, prénom</td><td>Identification</td><td>Durée du compte</td></tr>\n<tr><td>Email</td><td>Identification, notifications</td><td>Durée du compte &#43; 3 ans</td></tr>\n<tr><td>Mot de passe (hashé)</td><td>Authentification</td><td>Durée du compte</td></tr>\n</tbody>\n</table>\n\n<h3>2.2 Formulaire de contact</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, email</td><td>Répondre à la demande</td><td>3 ans</td></tr>\n<tr><td>Message</td><td>Traitement de la demande</td><td>3 ans</td></tr>\n</tbody>\n</table>\n\n<h3>2.3 Commentaires</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, contenu</td><td>Affichage public</td><td>Durée de publication</td></tr>\n</tbody>\n</table>\n\n<h3>2.4 Données techniques</h3>\n<p>Adresse IP (hashée SHA-256), navigateur, pages visitées — conservées 12 mois à des fins de sécurité et de statistiques anonymes.</p>\n\n<h3>2.5 Paiement</h3>\n<p>Les données de paiement ne sont <strong>pas stockées</strong> par ce site. Elles sont gérées par Stripe (certifié PCI-DSS).</p>\n\n<h2>3. Finalités du traitement</h2>\n<ul>\n<li>Gestion des comptes utilisateurs</li>\n<li>Envoi de notifications relatives aux articles et au site</li>\n<li>Traitement des demandes de contact</li>\n<li>Amélioration du site via des statistiques de visite anonymisées</li>\n<li>Gestion des commandes et paiements (si module e-commerce actif)</li>\n</ul>\n\n<h2>4. Base légale</h2>\n<table>\n<thead>\n<tr><th>Traitement</th><th>Base légale (RGPD)</th></tr>\n</thead>\n<tbody>\n<tr><td>Compte utilisateur</td><td>Exécution du contrat (art. 6.1.b)</td></tr>\n<tr><td>Contact</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Cookies analytics</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Sécurité / logs</td><td>Intérêt légitime (art. 6.1.f)</td></tr>\n<tr><td>Facturation</td><td>Obligation légale (art. 6.1.c)</td></tr>\n</tbody>\n</table>\n\n<h2>5. Ce que nous ne faisons PAS</h2>\n<ul>\n<li>Vendre ou louer vos données à des tiers</li>\n<li>Faire de la publicité ciblée</li>\n<li>Faire du profilage marketing</li>\n<li>Transférer vos données hors de l&#039;Union Européenne (hors sous-traitants certifiés)</li>\n</ul>\n\n<h2>6. Cookies</h2>\n\n<h3>Cookies essentiels (sans consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP (PHPSESSID)</td><td>Authentification, panier</td></tr>\n<tr><td>CSRF token</td><td>Sécurité des formulaires</td></tr>\n<tr><td>Préférences cookies</td><td>Mémoriser votre choix</td></tr>\n</tbody>\n</table>\n\n<h3>Cookies analytiques (avec consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th><th>Durée</th></tr>\n</thead>\n<tbody>\n<tr><td>Google Analytics (_ga, _gid)</td><td>Mesure d&#039;audience</td><td>13 mois max</td></tr>\n</tbody>\n</table>\n<p>Les cookies analytiques ne sont déposés <strong>qu&#039;après votre consentement explicite</strong> via le bandeau affiché lors de votre première visite. Vous pouvez retirer votre consentement à tout moment en supprimant vos cookies.</p>\n\n<h2>7. Sous-traitants</h2>\n<table>\n<thead>\n<tr><th>Prestataire</th><th>Pays</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>{{NOM_HEBERGEUR}}</td><td>France</td><td>Hébergement</td></tr>\n<tr><td>Brevo</td><td>France</td><td>Envoi d&#039;emails</td></tr>\n<tr><td>Stripe</td><td>USA*</td><td>Paiement sécurisé</td></tr>\n<tr><td>Google Analytics</td><td>USA*</td><td>Audience (avec consentement)</td></tr>\n</tbody>\n</table>\n<p><em>* Certifiés EU-US Data Privacy Framework</em></p>\n\n<h2>8. Vos droits RGPD</h2>\n<table>\n<thead>\n<tr><th>Droit</th><th>Comment l&#039;exercer</th></tr>\n</thead>\n<tbody>\n<tr><td>Accès</td><td>Espace personnel ou {{EMAIL_DPO}}</td></tr>\n<tr><td>Rectification</td><td>Espace personnel</td></tr>\n<tr><td>Suppression</td><td>Espace personnel ou {{EMAIL_DPO}}</td></tr>\n<tr><td>Portabilité</td><td>{{EMAIL_DPO}}</td></tr>\n<tr><td>Opposition</td><td>{{EMAIL_DPO}}</td></tr>\n<tr><td>Limitation</td><td>{{EMAIL_DPO}}</td></tr>\n</tbody>\n</table>\n<p><strong>Délai de réponse :</strong> 30 jours maximum.</p>\n<p>En cas de difficulté, vous pouvez adresser une réclamation auprès de la <strong>CNIL</strong> : <a href=\"https://www.cnil.fr\" target=\"_blank\" rel=\"noopener\">www.cnil.fr</a> — 3 Place de Fontenoy, 75334 Paris Cedex 07.</p>\n\n<h2>9. Sécurité</h2>\n<table>\n<tbody>\n<tr><td><strong>Transfert</strong></td><td>HTTPS / TLS 1.3</td></tr>\n<tr><td><strong>Mots de passe</strong></td><td>Hashés (bcrypt/argon2)</td></tr>\n<tr><td><strong>IP visiteurs</strong></td><td>Hashées SHA-256 (anonymisées)</td></tr>\n<tr><td><strong>Accès admin</strong></td><td>Protégé par authentification &#43; CSRF</td></tr>\n</tbody>\n</table>\n\n<h2>10. Modifications</h2>\n<p>Cette politique peut être mise à jour. En cas de changement significatif, les utilisateurs inscrits seront informés par email. La date de mise à jour figure en haut de page.</p>\n\n<h2>11. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>DPO</strong></td><td>{{EMAIL_DPO}}</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>\n</tbody>\n</table>','politique-confidentialite',1,'2026-03-27 10:55:08','2026-03-27 14:10:56',NULL,'full-width',1,'politique-confidentialite',NULL,'Politique de confidentialité. Données collectées, cookies, droits RGPD et contact DPO.',NULL,1,NULL,NULL),
(3,'public','Conditions générales d\'utilisation','<p><em>Dernière mise à jour : {{DATE}}</em></p>\n\n<h2>1. Objet</h2>\n<p>Les présentes Conditions Générales d&#039;Utilisation (CGU) régissent l&#039;accès et l&#039;utilisation de ce site internet. En accédant au site, vous acceptez sans réserve les présentes CGU.</p>\n\n<h2>2. Éditeur</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>\n<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>\n<tr><td><strong>Adresse</strong></td><td>{{ADRESSE}}</td></tr>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n</tbody>\n</table>\n\n<h2>3. Accès au service</h2>\n<ul>\n<li>Le site est accessible gratuitement à tout utilisateur disposant d&#039;un accès internet</li>\n<li>Les frais d&#039;accès et d&#039;utilisation du réseau de télécommunication sont à la charge de l&#039;utilisateur</li>\n<li>L&#039;éditeur se réserve le droit de suspendre ou interrompre l&#039;accès pour maintenance</li>\n</ul>\n\n<h2>4. Inscription</h2>\n<p>L&#039;accès à certaines fonctionnalités du site nécessite une inscription. L&#039;utilisateur s&#039;engage à :</p>\n<ul>\n<li>Fournir des informations exactes et complètes</li>\n<li>Mettre à jour ses informations en cas de changement</li>\n<li>Préserver la confidentialité de son mot de passe (12 caractères minimum)</li>\n<li>Notifier immédiatement toute utilisation non autorisée de son compte</li>\n</ul>\n<p>L&#039;éditeur se réserve le droit de supprimer tout compte ne respectant pas les présentes CGU.</p>\n\n<h2>5. Services proposés</h2>\n<p>Le site propose les services suivants :</p>\n<ul>\n<li>Publication et consultation de contenus (articles, pages, services)</li>\n<li>Formulaire de contact</li>\n<li>Inscription aux notifications</li>\n<li>Commentaires sur les articles</li>\n<li>{{SERVICES_SUPPLEMENTAIRES}}</li>\n</ul>\n\n<h2>6. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu du site est protégé par le droit de la propriété intellectuelle :</p>\n<ul>\n<li>Textes, images, vidéos, logos, icônes, sons, logiciels</li>\n<li>Charte graphique et design du site</li>\n<li>Bases de données</li>\n</ul>\n<p>Toute reproduction non autorisée constitue une contrefaçon sanctionnée par les articles L335-2 et suivants du Code de la Propriété Intellectuelle.</p>\n\n<h2>7. Comportement de l&#039;utilisateur</h2>\n<p>L&#039;utilisateur s&#039;engage à ne pas :</p>\n<ul>\n<li>Publier de contenu illicite, diffamatoire, injurieux ou discriminatoire</li>\n<li>Porter atteinte à la vie privée d&#039;autrui</li>\n<li>Tenter d&#039;accéder à des zones non autorisées du site</li>\n<li>Utiliser le site à des fins commerciales non autorisées</li>\n<li>Collecter des données personnelles d&#039;autres utilisateurs</li>\n</ul>\n\n<h2>8. Responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible, mais ne garantit pas :</p>\n<ul>\n<li>L&#039;exactitude, la complétude ou l&#039;actualité des informations publiées</li>\n<li>La disponibilité permanente du site</li>\n<li>L&#039;absence de virus ou de défauts de fonctionnement</li>\n</ul>\n<p>L&#039;éditeur décline toute responsabilité pour les dommages directs ou indirects résultant de l&#039;utilisation du site.</p>\n\n<h2>9. Liens hypertextes</h2>\n<p>Le site peut contenir des liens vers des sites tiers. L&#039;éditeur n&#039;est pas responsable du contenu de ces sites et n&#039;exerce aucun contrôle sur eux.</p>\n\n<h2>10. Données personnelles</h2>\n<p>Le traitement des données personnelles est décrit dans notre <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a>, accessible depuis le pied de page du site.</p>\n\n<h2>11. Modification des CGU</h2>\n<p>L&#039;éditeur se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs inscrits seront informés par email de toute modification substantielle. La date de mise à jour figure en haut de page.</p>\n\n<h2>12. Droit applicable</h2>\n<p>Les présentes CGU sont régies par le droit français. En cas de litige, les tribunaux français seront compétents.</p>\n\n<h2>13. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>\n<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>\n</tbody>\n</table>','cgu',1,'2026-03-27 10:55:21','2026-03-27 14:10:47',NULL,'full-width',1,'cgu',NULL,'Conditions générales d\'utilisation. Accès au service, inscription, propriété intellectuelle et responsabilité.',NULL,1,NULL,NULL),
(4,'public','Les offres','<p>Une offre claire, un prix transparent</p><p>Pas de devis surprise, pas de coûts cachés. Vous choisissez la formule qui correspond à vos besoins, on s&#039;occupe du reste.</p><table class=\"tiptap-table\"><tbody><tr><th><h3>Nos offres</h3></th><th><p style=\"text-align: center\">Vitrine</p></th><th><p style=\"text-align: center\">Blog - Populaire</p></th><th><p style=\"text-align: center\">Complet</p></th></tr><tr><td><p>Pour qui ?</p></td><td><p style=\"text-align: center\">Être présent en ligne avec un site pro</p></td><td><p style=\"text-align: center\">Publier des articles et être trouvé sur Google</p></td><td><p style=\"text-align: center\">Un site complet avec catalogue et vente en ligne</p></td></tr><tr><td><p>Tarif d’installation</p></td><td><p style=\"text-align: center\"><strong>520 € TTC</strong></p><p style=\"text-align: center\">450 € HT</p></td><td><p style=\"text-align: center\"><strong>660 € TTC</strong></p><p style=\"text-align: center\">550 € HT</p></td><td><p style=\"text-align: center\"><strong>1500 € TTC</strong></p><p style=\"text-align: center\">1250 € HT</p></td></tr><tr><td><p>Abonnement</p></td><td><p style=\"text-align: center\"><strong>36 € TTC/mois</strong></p><p style=\"text-align: center\">30 € HT/mois</p></td><td><p style=\"text-align: center\"><strong>42 € TTC/mois</strong></p><p style=\"text-align: center\">35 € HT/mois</p></td><td><p style=\"text-align: center\"><strong>60 € TTC/mois</strong></p><p style=\"text-align: center\">50 € HT/mois</p></td></tr><tr><td><p>Pages personnalisées</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>SEO intégré</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Formulaire de contact sécurisé</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>6 thèmes &#43; personnalisation</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Hébergement &#43; maintenance</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><h3><strong>Les Modules techniques</strong></h3></td><td><p></p></td><td><p></p></td><td><p></p></td></tr><tr><td><p>Module Services</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Module FAQ</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Module Portfolio/Réalisations</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Module Blog — articles, catégories, tags</p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\">✓</p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Module Catalogue</p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Module Evènements</p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>Module Annuaire</p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><p>E-commerce Stripe — paiement sécurisé</p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\"></p></td><td><p style=\"text-align: center\">✓</p></td></tr><tr><td><h3><strong>Options à la carte</strong></h3></td><td><p></p></td><td><p></p></td><td><p></p></td></tr><tr><td><p>Module supplémentaire</p></td><td><p style=\"text-align: center\"><strong>&#43;120 € TTC</strong></p><p style=\"text-align: center\">&#43;100 € HT</p></td><td><p style=\"text-align: center\"><strong>&#43;120 € TT</strong></p><p style=\"text-align: center\">&#43;100 € HT</p></td><td><p></p></td></tr><tr><td><p>Thème </p></td><td><p style=\"text-align: center\"><strong>&#43;420 € TTC</strong></p><p style=\"text-align: center\">&#43;350 € HT</p></td><td><p style=\"text-align: center\"><strong>&#43;420 € TTC</strong></p><p style=\"text-align: center\">&#43;350 € HT</p></td><td><p style=\"text-align: center\"><strong>&#43;420 € TT</strong></p><p style=\"text-align: center\">&#43;350 € HT</p></td></tr><tr><td><p>Réalisation du contenu</p></td><td><p style=\"text-align: center\"><strong>Sur devis</strong></p></td><td><p style=\"text-align: center\"><strong>Sur devis</strong></p></td><td><p style=\"text-align: center\"><strong>Sur devis</strong></p></td></tr></tbody></table><p></p><hr /><hr /><div class=\"block-callout block-callout--info\"><span class=\"block-callout__icon\">ⓘ</span><div class=\"block-callout__content\"><h3>Pas encore prêt ? Préparez votre projet tranquillement</h3><p>Téléchargez notre questionnaire, remplissez-le à votre rythme. Ça nous permettra de vous proposer la formule idéale dès notre premier échange.</p><p><a href=\"#\">Télécharger le questionnaire (PDF)</a></p></div></div><hr /><h2>Un projet web en tête ?</h2><p>Décrivez-nous votre activité, on vous conseille la formule adaptée — sans engagement.</p><p><a href=\"/contact\">Parlons de votre projet →</a></p>','offres',1,'2026-03-27 14:01:09','2026-03-31 07:18:56','{\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Une offre claire, un prix transparent\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pas de devis surprise, pas de co\\u00fbts cach\\u00e9s. Vous choisissez la formule qui correspond \\u00e0 vos besoins, on s\'occupe du reste.\"}]},{\"type\":\"table\",\"content\":[{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Nos offres\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"Vitrine\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"Blog - Populaire\"}]}]},{\"type\":\"tableHeader\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"Complet\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pour qui ?\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u00catre pr\\u00e9sent en ligne avec un site pro\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"Publier des articles et \\u00eatre trouv\\u00e9 sur Google\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"Un site complet avec catalogue et vente en ligne\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Tarif d\\u2019installation\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"520 \\u20ac TTC\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"450 \\u20ac HT\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"660 \\u20ac TTC\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"550 \\u20ac HT\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"1500 \\u20ac TTC\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"1250 \\u20ac HT\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Abonnement\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"36 \\u20ac TTC\\/mois\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"30 \\u20ac HT\\/mois\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"42 \\u20ac TTC\\/mois\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"35 \\u20ac HT\\/mois\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"60 \\u20ac TTC\\/mois\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"50 \\u20ac HT\\/mois\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pages personnalis\\u00e9es\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"SEO int\\u00e9gr\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Formulaire de contact s\\u00e9curis\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"6 th\\u00e8mes + personnalisation\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9bergement + maintenance\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Les Modules techniques\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module Services\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module FAQ\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module Portfolio\\/R\\u00e9alisations\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module Blog \\u2014 articles, cat\\u00e9gories, tags\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module Catalogue\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module Ev\\u00e8nements\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module Annuaire\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"E-commerce Stripe \\u2014 paiement s\\u00e9curis\\u00e9\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"\\u2713\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Options \\u00e0 la carte\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Module suppl\\u00e9mentaire\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"+120 \\u20ac TTC\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"+100 \\u20ac HT\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"+120 \\u20ac TT\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"+100 \\u20ac HT\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Th\\u00e8me \"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"+420 \\u20ac TTC\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"+350 \\u20ac HT\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"+420 \\u20ac TTC\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"+350 \\u20ac HT\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"+420 \\u20ac TT\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"text\":\"+350 \\u20ac HT\"}]}]}]},{\"type\":\"tableRow\",\"content\":[{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9alisation du contenu\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Sur devis\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Sur devis\"}]}]},{\"type\":\"tableCell\",\"attrs\":{\"colspan\":1,\"rowspan\":1,\"colwidth\":null},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":\"center\"},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Sur devis\"}]}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}},{\"type\":\"horizontalRule\"},{\"type\":\"horizontalRule\"},{\"type\":\"callout\",\"attrs\":{\"type\":\"info\"},\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pas encore pr\\u00eat ? Pr\\u00e9parez votre projet tranquillement\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"T\\u00e9l\\u00e9chargez notre questionnaire, remplissez-le \\u00e0 votre rythme. \\u00c7a nous permettra de vous proposer la formule id\\u00e9ale d\\u00e8s notre premier \\u00e9change.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"#\",\"target\":null,\"rel\":\"noopener noreferrer\",\"class\":null}}],\"text\":\"T\\u00e9l\\u00e9charger le questionnaire (PDF)\"}]}]},{\"type\":\"horizontalRule\"},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Un projet web en t\\u00eate ?\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9crivez-nous votre activit\\u00e9, on vous conseille la formule adapt\\u00e9e \\u2014 sans engagement.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/contact\",\"target\":null,\"rel\":\"noopener noreferrer\",\"class\":null}}],\"text\":\"Parlons de votre projet \\u2192\"}]}]}','default',0,NULL,'Nos offres — BlogWeb, site professionnel clé en main','Découvrez nos formules Vitrine, Blog et Complet. Prix transparents, hébergement et maintenance inclus.',NULL,0,NULL,5),
(5,'public','Freelances','<h2>Proposez des sites pros à vos clients — sans toucher au code</h2><p>Vous gérez la relation client, le contenu et le design. On gère l&#039;installation, l&#039;hébergement et la maintenance. Chacun son métier.</p><hr /><h3>Concentrez-vous sur votre valeur ajoutée</h3><p>Brief, direction artistique, contenu, formation client — ce que vous faites le mieux. La technique, c&#039;est notre problème.</p><h3>Générez du récurrent</h3><p>Chaque site déployé vous génère un revenu mensuel. Votre portefeuille clients devient un actif, pas juste une suite de missions.</p><h3>Offrez mieux que les solutions classiques à vos clients</h3><p>Sécurité intégrée, SEO natif, pas de plugin à maintenir. Vos clients sont contents, vous dormez tranquille.</p><hr /><div class=\"block-callout block-callout--info\"><span class=\"block-callout__icon\">ⓘ</span><div class=\"block-callout__content\"><h3>Envie de voir l&#039;envers du décor ?</h3><p>On vous ouvre un accès admin sur une copie de ce site. Testez tout — thèmes, éditeur, modules, SEO. Remis à zéro chaque nuit, amusez-vous.</p><p><a href=\"/contact\">Demander mon accès démo →</a></p></div></div>','freelances',1,'2026-03-27 14:01:09','2026-03-31 07:16:49','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Proposez des sites pros \\u00e0 vos clients \\u2014 sans toucher au code\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Vous g\\u00e9rez la relation client, le contenu et le design. On g\\u00e8re l\'installation, l\'h\\u00e9bergement et la maintenance. Chacun son m\\u00e9tier.\"}]},{\"type\":\"horizontalRule\"},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Concentrez-vous sur votre valeur ajout\\u00e9e\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Brief, direction artistique, contenu, formation client \\u2014 ce que vous faites le mieux. La technique, c\'est notre probl\\u00e8me.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"G\\u00e9n\\u00e9rez du r\\u00e9current\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Chaque site d\\u00e9ploy\\u00e9 vous g\\u00e9n\\u00e8re un revenu mensuel. Votre portefeuille clients devient un actif, pas juste une suite de missions.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Offrez mieux que les solutions classiques \\u00e0 vos clients\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9curit\\u00e9 int\\u00e9gr\\u00e9e, SEO natif, pas de plugin \\u00e0 maintenir. Vos clients sont contents, vous dormez tranquille.\"}]},{\"type\":\"horizontalRule\"},{\"type\":\"callout\",\"attrs\":{\"type\":\"info\"},\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Envie de voir l\'envers du d\\u00e9cor ?\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"On vous ouvre un acc\\u00e8s admin sur une copie de ce site. Testez tout \\u2014 th\\u00e8mes, \\u00e9diteur, modules, SEO. Remis \\u00e0 z\\u00e9ro chaque nuit, amusez-vous.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/contact\",\"target\":null,\"rel\":\"noopener noreferrer\",\"class\":null}}],\"text\":\"Demander mon acc\\u00e8s d\\u00e9mo \\u2192\"}]}]}]}','default',0,NULL,'Programme Freelances — BlogWeb','Proposez des sites professionnels à vos clients sans toucher au code. Vous gérez la relation, on gère la technique.',NULL,0,NULL,3),
(6,'public','À propos','<h2>Pourquoi BlogWeb existe</h2><h3>Le constat</h3><p>Des artisans, des commerçants, des consultants — des gens passionnés par leur métier. Ils savent qu&#039;un site web est indispensable. Mais entre les devis opaques, les solutions trop complexes et la peur de ne pas savoir gérer, beaucoup repoussent. Et ceux qui franchissent le pas se retrouvent souvent avec un site qu&#039;ils ne peuvent pas modifier seuls, un abonnement dont ils ne comprennent pas le contenu, ou une maintenance qui les dépasse.</p><p><strong>Ce n&#039;est pas normal.</strong></p><h3>L&#039;histoire</h3><p>Je m&#039;appelle David Laignelet. Mon parcours, c&#039;est le commerce, la relation client et le web — depuis toujours.</p><p>C&#039;est en travaillant au plus près de ces entrepreneurs que j&#039;ai vu ce qui coince avec le web. Des outils trop complexes, des devis opaques, des sites que le client ne peut pas gérer seul. Des CMS surchargés de plugins, de failles de sécurité, de mises à jour qui cassent tout.</p><p>J&#039;ai construit BlogWeb pour résoudre ce problème. Un CMS professionnel, sécurisé, optimisé pour Google — mais surtout simple. <strong>Le code, c&#039;est mon métier. Le contenu, c&#039;est le vôtre</strong>. Chacun fait ce qu&#039;il sait faire.</p><h2>Les valeurs</h2><p>BlogWeb est né d&#039;une conviction : <strong>la technologie doit servir les gens, pas l&#039;inverse</strong>. Chaque décision technique — la sécurité intégrée, le SEO natif, les thèmes personnalisables sans code — est prise en pensant à la personne qui va utiliser le site, pas à celle qui le construit.</p><p><strong>L&#039;humain d&#039;abord, la technique ensuite. Toujours.</strong></p><hr /><h2>Un projet ? Une question ?</h2><p>Je réponds personnellement à chaque message.</p><p><a href=\"/contact\">Me contacter →</a></p>','a-propos',1,'2026-03-27 14:01:09','2026-04-01 10:06:09','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi BlogWeb existe\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Le constat\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Des artisans, des commer\\u00e7ants, des consultants \\u2014 des gens passionn\\u00e9s par leur m\\u00e9tier. Ils savent qu\'un site web est indispensable. Mais entre les devis opaques, les solutions trop complexes et la peur de ne pas savoir g\\u00e9rer, beaucoup repoussent. Et ceux qui franchissent le pas se retrouvent souvent avec un site qu\'ils ne peuvent pas modifier seuls, un abonnement dont ils ne comprennent pas le contenu, ou une maintenance qui les d\\u00e9passe.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Ce n\'est pas normal.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"L\'histoire\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Je m\'appelle David Laignelet. Mon parcours, c\'est le commerce, la relation client et le web \\u2014 depuis toujours.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"C\'est en travaillant au plus pr\\u00e8s de ces entrepreneurs que j\'ai vu ce qui coince avec le web. Des outils trop complexes, des devis opaques, des sites que le client ne peut pas g\\u00e9rer seul. Des CMS surcharg\\u00e9s de plugins, de failles de s\\u00e9curit\\u00e9, de mises \\u00e0 jour qui cassent tout.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"J\'ai construit BlogWeb pour r\\u00e9soudre ce probl\\u00e8me. Un CMS professionnel, s\\u00e9curis\\u00e9, optimis\\u00e9 pour Google \\u2014 mais surtout simple. \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Le code, c\'est mon m\\u00e9tier. Le contenu, c\'est le v\\u00f4tre\"},{\"type\":\"text\",\"text\":\". Chacun fait ce qu\'il sait faire.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Les valeurs\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"BlogWeb est n\\u00e9 d\'une conviction : \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"la technologie doit servir les gens, pas l\'inverse\"},{\"type\":\"text\",\"text\":\". Chaque d\\u00e9cision technique \\u2014 la s\\u00e9curit\\u00e9 int\\u00e9gr\\u00e9e, le SEO natif, les th\\u00e8mes personnalisables sans code \\u2014 est prise en pensant \\u00e0 la personne qui va utiliser le site, pas \\u00e0 celle qui le construit.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"L\'humain d\'abord, la technique ensuite. Toujours.\"}]},{\"type\":\"horizontalRule\"},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Un projet ? Une question ?\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Je r\\u00e9ponds personnellement \\u00e0 chaque message.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/contact\",\"target\":null,\"rel\":\"noopener noreferrer\",\"class\":null}}],\"text\":\"Me contacter \\u2192\"}]}]}','default',0,NULL,'À propos — BlogWeb, l\'histoire derrière le CMS','BlogWeb est né d\'une conviction : la technologie doit servir les gens, pas l\'inverse.',NULL,0,NULL,7),
(7,'public','Site sur-mesure vs CMS classique','','site-sur-mesure-vs-cms-classique',1,'2026-03-27 14:01:09','2026-03-27 14:01:09','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"level\":1},\"content\":[{\"type\":\"text\",\"text\":\"Comment choisir la bonne solution pour votre site ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Créateur de site en ligne, CMS open source, agence web, freelance… les options ne manquent pas. Et plus vous comparez, plus c\'est confus. Plutôt que de vous dire quoi choisir, voici les questions qui comptent vraiment.\"}]},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"La simplicité au quotidien\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Votre site est en ligne, vous voulez modifier un texte ou ajouter une photo. Est-ce que vous pouvez le faire seul, maintenant, sans appeler quelqu\'un ? Si la réponse est non, vous dépendez d\'un prestataire pour chaque virgule. Et ça, ça coûte du temps et de l\'argent.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avec BlogWeb : un éditeur visuel, intuitif. Vous écrivez, vous publiez. C\'est aussi simple que ça.\",\"marks\":[{\"type\":\"italic\"}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"La sécurité\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Les failles de sécurité, les plugins obsolètes, les sites piratés — ce n\'est pas un scénario catastrophe, c\'est le quotidien de millions de sites. La question n\'est pas « est-ce que ça peut arriver » mais « qui s\'en occupe quand ça arrive ? ». Et surtout : est-ce que votre site est conçu pour l\'éviter ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avec BlogWeb : la sécurité est intégrée à chaque niveau. Anti-spam, protection des données, mises à jour gérées pour vous. Vous n\'avez pas à y penser.\",\"marks\":[{\"type\":\"italic\"}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Le référencement\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avoir un beau site que personne ne trouve, c\'est comme avoir une boutique sans vitrine. Le SEO, ce n\'est pas un bonus, c\'est une nécessité. La question : est-ce que votre solution l\'intègre dès le départ, ou est-ce qu\'il faut ajouter des extensions, configurer des outils, et espérer que tout fonctionne ensemble ?\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avec BlogWeb : sitemap, balises, données structurées, optimisation des images — tout est en place dès la mise en ligne. Votre site part avec une longueur d\'avance.\",\"marks\":[{\"type\":\"italic\"}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"La maintenance\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Un site, ça s\'entretient. Mises à jour du système, des extensions, compatibilités à vérifier, sauvegardes à faire. Certaines solutions vous laissent gérer tout ça seul. D\'autres vous facturent chaque intervention.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avec BlogWeb : l\'hébergement et la maintenance sont inclus dans votre abonnement. On gère, vous travaillez.\",\"marks\":[{\"type\":\"italic\"}]}]},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"L\'autonomie\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Votre contenu vous appartient-il vraiment ? Si demain vous changez d\'avis, pouvez-vous partir avec vos textes, vos images, vos données ? Certaines plateformes rendent la migration difficile — volontairement. Vous n\'êtes pas leur client, vous êtes leur captif.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Avec BlogWeb : votre contenu est le vôtre. Point.\",\"marks\":[{\"type\":\"bold\"},{\"type\":\"italic\"}]}]},{\"type\":\"horizontalRule\"},{\"type\":\"heading\",\"attrs\":{\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"La meilleure façon de choisir, c\'est de voir\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Découvrez nos offres ou parlons directement de votre projet. Pas d\'engagement, pas de jargon — juste une conversation.\"}]},{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Voir les offres →\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/offres\",\"target\":null}}]},{\"type\":\"text\",\"text\":\"  \"},{\"type\":\"text\",\"text\":\"Me contacter →\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/contact\",\"target\":null}}]}]}]}','default',0,NULL,'Site sur-mesure vs CMS classique — Comment choisir ?','Créateur de site, CMS open source ou solution sur-mesure ? Les questions qui comptent pour faire le bon choix.',NULL,0,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_view`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page_view` WRITE;
/*!40000 ALTER TABLE `page_view` DISABLE KEYS */;
INSERT INTO `page_view` VALUES
(1,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/realisation/super-realisation','2026-03-27 14:02:45'),
(2,'/login','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/login','2026-03-27 14:07:54'),
(3,'/article/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-27 14:09:16'),
(4,'/page/freelances','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/article/','2026-03-27 14:09:18'),
(5,'/page/offres','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-27 14:09:19'),
(6,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-27 14:09:25'),
(7,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-27 14:10:10'),
(8,'/page/offres','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-27 14:10:13'),
(9,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-27 14:11:27'),
(10,'/page/offres','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-27 14:11:38'),
(11,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-27 14:11:41'),
(12,'/page/a-propos','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-27 14:12:06'),
(13,'/contact','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-27 14:12:12'),
(14,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-27 14:13:47'),
(15,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-27 14:14:06'),
(16,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-27 14:15:28'),
(17,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-27 14:15:37'),
(18,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-27 14:17:25'),
(19,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-27 14:17:32'),
(20,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-27 14:17:42'),
(21,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-27 14:17:50'),
(22,'/page/offres','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=vitrine','2026-03-27 14:18:01'),
(23,'/page/freelances','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres?_preview_theme=vitrine','2026-03-27 14:18:04'),
(24,'/page/a-propos','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances?_preview_theme=vitrine','2026-03-27 14:18:06'),
(25,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos?_preview_theme=vitrine','2026-03-27 14:18:07'),
(26,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-27 14:18:22'),
(27,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-27 14:18:32'),
(28,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-27 14:18:43'),
(29,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-27 14:18:49'),
(30,'/','464410f3198cf63ab2e6d17c64a8cf5c7bd10439053f17529e3d31190f1ec7ce','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-27 14:19:21'),
(31,'/services','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 09:07:44'),
(32,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin','2026-03-30 09:07:52'),
(33,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 09:07:55'),
(34,'/page/freelances','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 09:08:00'),
(35,'/page/a-propos','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-30 09:08:02'),
(36,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-30 09:08:08'),
(37,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 09:09:06'),
(38,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 09:40:58'),
(39,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 09:40:59'),
(40,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 09:45:37'),
(41,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 09:48:15'),
(42,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 09:51:04'),
(43,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 17:35:38'),
(44,'/page/freelances','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 17:51:31'),
(45,'/page/a-propos','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-30 17:51:47'),
(46,'/contact','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-30 17:51:52'),
(47,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-03-30 17:52:01'),
(48,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 17:52:11'),
(49,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 18:12:46'),
(50,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 18:48:54'),
(51,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 18:51:02'),
(52,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=edit&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController&entityId=4','2026-03-30 20:06:35'),
(53,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=edit&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController&entityId=4','2026-03-30 20:17:23'),
(54,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=edit&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController&entityId=4','2026-03-30 20:17:57'),
(55,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=edit&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController&entityId=4','2026-03-30 20:28:21'),
(56,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-30 20:28:46'),
(57,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 20:28:56'),
(58,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 20:30:22'),
(59,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-30 20:30:27'),
(60,'/page/freelances','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 20:32:05'),
(61,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-30 20:32:06'),
(62,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-30 20:32:18'),
(63,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-30 20:41:28'),
(64,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin/theme-browser','2026-03-30 20:44:10'),
(65,'/page/offres','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/?_preview_theme=moderne','2026-03-30 20:44:18'),
(66,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?routeName=admin_theme_browser','2026-03-30 20:44:45'),
(67,'/','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CThemeImagesCrudController&entityFqcn=App%5CEntity%5CSiteGalleryItem','2026-03-30 20:45:32'),
(68,'/contact','2c0a2732b66361a975f8416b2e45a6dc9892deccf196af6b707b8a48f7e1e498','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-30 20:46:17'),
(69,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-03-31 05:54:02'),
(70,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-03-31 06:14:25'),
(71,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-03-31 06:17:43'),
(72,'/contact','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 06:19:44'),
(73,'/contact','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 06:19:50'),
(74,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-03-31 06:20:24'),
(75,'/services','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 06:20:26'),
(76,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/services','2026-03-31 06:20:39'),
(77,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 06:20:41'),
(78,'/page/a-propos','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 06:20:43'),
(79,'/services','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-31 06:20:45'),
(80,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/services','2026-03-31 06:21:13'),
(81,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 06:21:19'),
(82,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 06:41:45'),
(83,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 06:43:56'),
(84,'/contact','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 06:44:41'),
(85,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 06:47:28'),
(86,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 06:47:51'),
(87,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 06:47:58'),
(88,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 06:52:06'),
(89,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 06:54:49'),
(90,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 06:54:55'),
(91,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 06:56:41'),
(92,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 06:57:39'),
(93,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 07:01:49'),
(94,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 07:16:10'),
(95,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 07:16:59'),
(96,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 07:17:10'),
(97,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 07:17:14'),
(98,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 07:17:20'),
(99,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 07:19:00'),
(100,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 07:19:07'),
(101,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 07:19:16'),
(102,'/page/freelances','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 07:19:18'),
(103,'/page/a-propos','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 07:19:21'),
(104,'/page/a-propos','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-03-31 08:58:04'),
(105,'/user/1','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-31 08:58:07'),
(106,'/user/1/edit','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/user/1','2026-03-31 08:58:14'),
(107,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/user/1/edit','2026-03-31 08:58:30'),
(108,'/categorie/creer-son-site','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 08:58:33'),
(109,'/user/1','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 08:58:41'),
(110,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 08:59:10'),
(111,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 09:16:27'),
(112,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 09:17:05'),
(113,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 09:17:10'),
(114,'/categorie/creer-son-site','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 09:17:14'),
(115,'/categorie/creer-son-site','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 09:38:12'),
(116,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 09:38:23'),
(117,'/categorie/creer-son-site','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 09:38:51'),
(118,'/user/1','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 09:38:57'),
(119,'/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:09:59'),
(120,'/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:10:15'),
(121,'/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:10:28'),
(122,'/article/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:12:48'),
(123,'/article/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:13:02'),
(124,'/article/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:13:13'),
(125,'/article/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:13:32'),
(126,'/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:29:44'),
(127,'/categorie/creer-son-site','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:30:24'),
(128,'/categorie/creer-son-site','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:30:41'),
(129,'/categorie/creer-son-site','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 14:30:53'),
(130,'/categorie/creer-son-site','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',NULL,'2026-03-31 14:33:39'),
(131,'/categorie/creer-son-site','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 14:34:14'),
(132,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/categorie/creer-son-site','2026-03-31 14:34:26'),
(133,'/page/offres','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-03-31 14:34:30'),
(134,'/page/a-propos','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 14:37:18'),
(135,'/','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 15:48:46'),
(136,'/categorie/creer-son-site','06370c5c1dcf2ff775ee808ebebe117538f0397f8ca3f68437a3512c96311d3c','curl/8.17.0',NULL,'2026-03-31 15:48:46'),
(137,'/page/a-propos','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-03-31 15:52:32'),
(138,'/contact','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-31 15:52:44'),
(139,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-31 15:53:23'),
(140,'/','62ba4cba05c0029052bfec614170917dea20c044e93045001bca8c28746f1202','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-03-31 15:54:29'),
(141,'/login','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController','2026-04-01 10:01:48'),
(142,'/page/a-propos','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-04-01 10:02:53'),
(143,'/page/a-propos','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-04-01 10:03:04'),
(144,'/contact','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-04-01 10:03:06'),
(145,'/page/a-propos','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-04-01 10:03:09'),
(146,'/page/a-propos','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/contact','2026-04-01 10:04:00'),
(147,'/','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/a-propos','2026-04-01 10:06:13'),
(148,'/page/offres','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/','2026-04-01 17:33:14'),
(149,'/page/freelances','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/offres','2026-04-01 17:33:23'),
(150,'/page/a-propos','812b573f4de1e303e3ae86937de2eba01dbfdd5abed1070c4c56b8da930cd1ad','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0','http://localhost:8080/page/freelances','2026-04-01 17:33:27'),
(151,'/','93f48267d3a48ba34d80458b4fff9be1540473f10fcc29eafe1b38f6438a9540','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/page/a-propos','2026-04-02 05:22:20'),
(152,'/login','93f48267d3a48ba34d80458b4fff9be1540473f10fcc29eafe1b38f6438a9540','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','http://localhost:8080/admin?crudAction=index&crudControllerFqcn=App%5CController%5CAdmin%5CPageCrudController','2026-04-02 05:47:55'),
(153,'/','93f48267d3a48ba34d80458b4fff9be1540473f10fcc29eafe1b38f6438a9540','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0',NULL,'2026-04-02 12:26:32'),
(154,'/','93f48267d3a48ba34d80458b4fff9be1540473f10fcc29eafe1b38f6438a9540','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0',NULL,'2026-04-02 16:30:33');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES
(1,'Vos clients vous trouvent sur Google','vos-clients-vous-trouvent-sur-google','SEO intégré dès le départ : votre site est indexé, structuré et optimisé pour apparaître là où vos clients cherchent.',NULL,'','fas fa-search',NULL,1,1,NULL,NULL),
(2,'Vous gérez votre contenu en toute autonomie','vous-gerez-votre-contenu-en-toute-autonomie','Un éditeur simple et visuel pour publier vos articles, modifier vos textes et ajouter vos photos — sans appeler personne.',NULL,'','fas fa-edit',NULL,2,1,NULL,NULL),
(3,'Votre site est protégé, vous dormez tranquille','votre-site-est-protege-vous-dormez-tranquille','Sécurité intégrée à chaque niveau : anti-spam, protection des données, mises à jour gérées pour vous.',NULL,'','fas fa-lock',NULL,3,1,NULL,NULL),
(4,'Votre site est prêt en une demi-journée','votre-site-est-pret-en-une-demi-journee','On configure, on personnalise, on met en ligne. Vous vous concentrez sur vos clients, pas sur la technique.',NULL,'','fas fa-bolt',NULL,4,1,NULL,NULL);
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_694309E4F98F144A` (`logo_id`),
  KEY `IDX_694309E4D78119FD` (`favicon_id`),
  KEY `IDX_694309E498BB94C5` (`hero_image_id`),
  KEY `IDX_694309E471BB2404` (`about_image_id`),
  KEY `IDX_694309E47E3C61F9` (`owner_id`),
  KEY `IDX_694309E46EFCB8B8` (`og_image_id`),
  CONSTRAINT `FK_694309E46EFCB8B8` FOREIGN KEY (`og_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E471BB2404` FOREIGN KEY (`about_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E47E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_694309E498BB94C5` FOREIGN KEY (`hero_image_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_694309E4D78119FD` FOREIGN KEY (`favicon_id`) REFERENCES `media` (`id`) ON DELETE SET NULL,
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
(1,'BlogWeb','BlogWeb — CMS professionnel clé en main','david@comwebsolutions.fr','Montsaunès','31260','3 place des Templiers',NULL,NULL,'0622283754','BlogWeb — Votre site professionnel, sécurisé et optimisé Google','Un CMS clé en main pour TPE, artisans et indépendants. Site prêt en une demi-journée, SEO intégré, simple à gérer. Le code c\'est nous, le contenu c\'est vous.',NULL,NULL,'#2563eb','#2d2d2d','#f5a623','\'Poppins\', sans-serif','\'Space Grotesk\', sans-serif','vitrine','ttc','[\"vitrine\",\"blog\",\"services\",\"faq\",\"portfolio\"]',NULL,NULL,NULL,NULL,NULL,4,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES
(1,'site professionnel','site-professionnel'),
(2,'SEO','seo'),
(3,'sécurité web','securite-web'),
(4,'TPE','tpe'),
(5,'artisan','artisan'),
(6,'indépendant','independant'),
(7,'référencement local','referencement-local'),
(8,'contenu web','contenu-web');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(1,'david@comwebsolutions.fr','[\"ROLE_SUPER_ADMIN\"]','$2y$13$Vj4iSSWMSnftrccfiUDcL.Gw3B081KBHIwzRAkUMD6Vvv1fQuMXzS','','',0,NULL,NULL,NULL,NULL,0,NULL);
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

-- Dump completed on 2026-04-02 15:42:01
