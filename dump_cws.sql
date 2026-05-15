/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bw_comwebsolutions
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `categorie` WRITE;
/*!40000 ALTER TABLE `categorie` DISABLE KEYS */;
INSERT INTO `categorie` VALUES
(1,'Stratégie commerciale','strategie-commerciale','#2563EB',NULL,NULL,NULL,0,NULL,NULL),
(2,'Web sans WordPress','web-sans-wordpress','#1E40AF',NULL,NULL,NULL,0,NULL,NULL),
(3,'IA souveraine','ia-souveraine','#F59E0B',NULL,NULL,NULL,0,NULL,NULL),
(4,'Applications métier','applications-metier','#0EA5E9',NULL,NULL,NULL,0,NULL,NULL),
(5,'Vie d\'entrepreneur','vie-d-entrepreneur','#64748B',NULL,NULL,NULL,0,NULL,NULL);
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
('DoctrineMigrations\\Version20260327093858','2026-05-10 07:19:35',3088),
('DoctrineMigrations\\Version20260330175902','2026-05-10 07:19:38',76),
('DoctrineMigrations\\Version20260331051133','2026-05-10 07:19:38',1110),
('DoctrineMigrations\\Version20260331120749','2026-05-10 07:19:39',26),
('DoctrineMigrations\\Version20260331134753','2026-05-10 07:19:39',25),
('DoctrineMigrations\\Version20260402035203','2026-05-10 07:19:39',114),
('DoctrineMigrations\\Version20260403055742','2026-05-10 07:19:40',119),
('DoctrineMigrations\\Version20260403093313','2026-05-10 07:19:40',176),
('DoctrineMigrations\\Version20260408055018','2026-05-10 07:19:40',43),
('DoctrineMigrations\\Version20260409085027','2026-05-10 07:19:40',17),
('DoctrineMigrations\\Version20260416073057','2026-05-10 07:19:40',24),
('DoctrineMigrations\\Version20260429075920','2026-05-10 07:19:40',247),
('DoctrineMigrations\\Version20260504063822','2026-05-10 07:19:40',125),
('DoctrineMigrations\\Version20260508090000','2026-05-10 07:19:40',12),
('DoctrineMigrations\\Version20260510131558','2026-05-10 15:16:21',122);
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` VALUES
(1,'C\'est quoi exactement l\'externalisation commerciale ?','externalisation-commerciale-definition',NULL,'<p>C\'est simple : je prospecte pour vous, en votre nom, comme si j\'étais dans vos locaux. Identification de cibles, prise de contact, qualification, relances, prise de rendez-vous. Vous gardez la main sur la relation client — moi je remplis votre pipe commercial.</p><p>Pas de recrutement, pas de charges sociales, pas de management. Vous achetez du résultat, pas un salarié.</p>',NULL,1,1,NULL),
(2,'En quoi c\'est différent d\'un commercial en CDD ou en intérim ?','difference-externalisation-cdd-interim',NULL,'<p>Un CDD, vous le recrutez, vous le formez, vous le managez, vous payez les charges — et s\'il ne performe pas, vous attendez la fin du contrat. L\'intérim, c\'est pareil avec une agence au milieu qui prend sa marge.</p><p>L\'externalisation, c\'est un professionnel opérationnel dès le premier jour, avec 15 ans de terrain. Pas de période d\'essai, pas de management à assurer, pas de charges patronales. Et si ça ne colle pas, on arrête — pas de préavis de 3 mois.</p>',NULL,2,1,NULL),
(3,'Combien ça coûte par rapport à un recrutement ?','cout-externalisation-vs-recrutement',NULL,'<p>Un commercial salarié, c\'est 40 à 60 k€ brut chargé par an, plus la voiture, le téléphone, les frais, la mutuelle. Sans compter le temps de recrutement et de formation. Et le risque que ça ne marche pas.</p><p>L\'externalisation, c\'est une fraction de ce coût, avec un engagement flexible et des résultats mesurables dès les premières semaines. Le détail dépend de votre besoin — on en parle en 30 minutes.</p>',NULL,3,1,NULL),
(4,'Combien de temps avant les premiers résultats ?','delai-resultats-externalisation',NULL,'<p>Les premiers contacts qualifiés arrivent généralement dans les 2 à 4 semaines. Les premiers rendez-vous dans le mois. La montée en puissance complète prend 2 à 3 mois — le temps de tester les messages, d\'affiner le ciblage, et de construire un rythme de prospection régulier.</p><p>Ce n\'est pas de la magie. C\'est du travail méthodique, de la régularité, et de l\'ajustement permanent.</p>',NULL,4,1,NULL),
(5,'Les prospects savent que c\'est externalisé ?','transparence-externalisation-prospects',NULL,'<p>Non. Je prospecte en votre nom, avec votre identité, votre adresse email, votre numéro. Pour le prospect, c\'est votre entreprise qui le contacte. Quand le rendez-vous est pris, c\'est vous qui reprenez la main sur la relation commerciale.</p><p>C\'est votre marque, votre image, votre pipe. Moi je suis le moteur — pas la carrosserie.</p>',NULL,5,1,NULL),
(6,'Quelle différence entre externalisation commerciale et direction commerciale externalisée ?','difference-externalisation-direction-commerciale',NULL,'<p>L\'externalisation commerciale, c\'est de l\'exécution : je prospecte pour vous. La direction commerciale externalisée, c\'est de la stratégie + du pilotage : je définis votre plan d\'action commercial, je structure vos process de vente, je mets en place les outils, et je pilote l\'activité.</p><p>C\'est la solution pour les dirigeants qui ont besoin d\'un directeur commercial mais pas le budget pour un poste à temps plein. Vous bénéficiez de l\'expérience d\'un profil senior quelques jours par mois, sans les charges d\'un cadre à 80 k€.</p>',NULL,6,1,NULL),
(7,'J\'ai déjà des commerciaux mais pas de stratégie commerciale, vous pouvez m\'aider ?','strategie-commerciale-equipe-existante',NULL,'<p>C\'est même le cas le plus fréquent. Vous avez des commerciaux terrain qui font du bon travail, mais personne pour structurer : ciblage, argumentaires, process de relance, suivi des KPIs, outils CRM. Chacun fait à sa sauce et vous n\'avez aucune visibilité sur le pipe.</p><p>Je mets en place la stratégie, les outils et les process. Vos commerciaux gardent leur autonomie terrain, mais avec un cadre qui multiplie leur efficacité.</p>',NULL,7,1,NULL),
(8,'Pourquoi pas WordPress comme tout le monde ?','pourquoi-pas-wordpress',NULL,'<p>WordPress représente 40 % du web. C\'est aussi la cible n°1 des hackers, le champion des mises à jour qui cassent tout, et le roi des sites lents bourrés de plugins. Chaque mois, des milliers de sites WordPress sont piratés ou tombent en panne après une mise à jour.</p><p>Je développe sur un CMS maison, BlogWeb, construit sur Symfony — le framework utilisé par BlaBlaCar ou Spotify. Résultat : un site rapide, sécurisé, sans plugin tiers, que je maintiens moi-même. Pas de mauvaise surprise au prochain update.</p>',NULL,8,1,NULL),
(9,'Combien coûte un site avec vous ?','cout-site-web',NULL,'<p>Un site vitrine professionnel avec BlogWeb démarre autour de 2 000 à 4 000 €. Un site avec des fonctionnalités métier (formulaires avancés, espace client, catalogue) se situe entre 4 000 et 8 000 €. Les applications sur mesure, c\'est au cas par cas.</p><p>La vraie différence : pas de frais cachés, pas de licence annuelle, pas de plugin payant à renouveler. Et surtout, un site pensé pour convertir — pas juste pour être joli.</p>',NULL,9,1,NULL),
(10,'Je suis une TPE avec un petit budget, c\'est pour moi ?','tpe-petit-budget',NULL,'<p>C\'est justement pour ça que j\'existe. Les grosses agences ne sont pas rentables pour une TPE — et une TPE n\'est pas rentable pour elles. Résultat : vous êtes mal servi ou vous payez trop cher pour ce que vous obtenez.</p><p>Mon modèle est conçu pour les TPE/PME : un seul interlocuteur, pas de structure à financer, des prestations modulables. On commence par ce qui a le plus d\'impact, et on avance à votre rythme.</p>',NULL,10,1,NULL),
(11,'Comment ça se passe concrètement pour démarrer ?','demarrer-collaboration',NULL,'<p>Vous réservez un créneau de 30 minutes. On se parle, je vous pose des questions sur votre activité, votre marché, ce qui bloque. À la fin de l\'appel, je vous dis clairement si je peux aider et ce que je recommande.</p><p>Si on avance, je vous envoie une proposition claire en quelques jours : périmètre, planning, prix. Pas de devis de 15 pages, pas de jargon. Un document que vous comprenez en 5 minutes.</p>',NULL,11,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES
(1,'Photo Mickaël Lamy','placeholder-testimonial-1.jpg',NULL),
(2,'Photo Yannick Dougnac','placeholder-testimonial-2.jpg',NULL),
(3,'Photo Camille Dassieu','placeholder-testimonial-3.jpg',NULL),
(4,'Logo Com Web Solutions','comweb-fac13648-4cf3-44ea-bb24-f456a9b368ae.png','comweb-fac13648-4cf3-44ea-bb24-f456a9b368ae.webp'),
(5,'Photo Hero - Com Web Solutions','mg-4733-1e88d5df-27a5-4b97-86bb-3a59345d99e4.jpg','mg-4733-1e88d5df-27a5-4b97-86bb-3a59345d99e4.webp'),
(6,'Direction commerciale externalisée','com-web-solutions-direction-commerciale-externalisee-1f6df690-d9e7-4407-b0de-525702ac95d1.png','com-web-solutions-direction-commerciale-externalisee-1f6df690-d9e7-4407-b0de-525702ac95d1.webp'),
(7,'App sur mesure','com-web-solutions-applications-web-sur-mesure-3ad3df40-4936-4d1b-bd18-bf474df29f7d.png','com-web-solutions-applications-web-sur-mesure-3ad3df40-4936-4d1b-bd18-bf474df29f7d.webp'),
(8,'Blog Web','com-web-solutions-blog-web-cms-alternative-wordpress-1cc767cb-7d2c-45fe-ad4b-18a1445c7a44.png','com-web-solutions-blog-web-cms-alternative-wordpress-1cc767cb-7d2c-45fe-ad4b-18a1445c7a44.webp'),
(9,'Com Web Solution - Accompagnement complet','com-web-solutions-accompagnement-commercial-et-web-tpe-pme-3f58b043-a978-416f-b838-2c6a4f7cd677.png','com-web-solutions-accompagnement-commercial-et-web-tpe-pme-3f58b043-a978-416f-b838-2c6a4f7cd677.webp'),
(10,'Externalisation BtoB','com-web-solutions-externalisation-commerciale-bb-84f13f8a-3933-449a-b513-b6df5417d143.png','com-web-solutions-externalisation-commerciale-bb-84f13f8a-3933-449a-b513-b6df5417d143.webp'),
(11,'Appel d\'Offre','com-web-solutions-externalisation-d-appels-d-offres-7a306968-f530-4e17-af2d-91f7f9212d15.png','com-web-solutions-externalisation-d-appels-d-offres-7a306968-f530-4e17-af2d-91f7f9212d15.webp'),
(12,'LintellO','com-web-solutions-lintello-d3bdb1c8-e32d-4cfc-9d2f-36df0973efc4.png','com-web-solutions-lintello-d3bdb1c8-e32d-4cfc-9d2f-36df0973efc4.webp');
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES
(1,'Accueil',0,1,'route','header',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'Blog',4,1,'route','header',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,'Services',3,0,'route','header',1,'services','app_service_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'Catalogue',5,0,'route','header',1,'catalogue','app_product_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,'Evenements',6,0,'route','header',1,'events','app_event_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,'Annuaire',7,0,'route','header',1,'annuaire','app_directory',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,'Contact',9,1,'route','header',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,'Accueil',0,0,'route','footer_nav',1,'home','app_home',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,'Blog',2,0,'route','footer_nav',1,'blog','app_article_show_all',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,'Contact',3,1,'route','footer_nav',1,'contact','app_contact',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(11,'Mentions legales',0,1,'route','footer_legal',1,'mentions-legales','app_legal_page','{\"type\":\"mentions-legales\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(12,'Politique de confidentialite',10,1,'route','footer_legal',1,'politique-confidentialite','app_legal_page','{\"type\":\"politique-de-confidentialite\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(13,'CGV',20,0,'route','footer_legal',1,'cgv','app_legal_page','{\"type\":\"conditions-generales-de-vente\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(14,'CGU',30,1,'route','footer_legal',1,'cgu','app_legal_page','{\"type\":\"conditions-generales-utilisation\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(16,'À propos',8,1,'page','header',0,NULL,NULL,NULL,NULL,NULL,NULL,4,NULL,NULL),
(17,'Le Commerce',1,1,'url','header',0,NULL,NULL,NULL,'#',NULL,NULL,NULL,NULL,NULL),
(18,'Le Web',2,1,'url','header',0,NULL,NULL,NULL,'#',NULL,NULL,NULL,NULL,NULL),
(21,'Externalisation commerciale B2B',1,1,'service','header',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,2),
(22,'Direction Commerciale Externalisée',0,1,'service','header',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,1),
(23,'Externalisation appels d\'offres',2,1,'service','header',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,3),
(24,'BlogWeb',0,1,'service','header',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,18,4),
(25,'Applications sur mesure',1,1,'service','header',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,18,6),
(26,'LintellO',2,1,'service','header',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,18,5),
(27,'FAQ',1,1,'route','footer_nav',0,NULL,'app_faq_index',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
(1,'public','Mentions légales','<p><em>Dernière mise à jour : 10 mai 2026</em></p>\n\n<h2>1. Éditeur du site</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>EI - LAIGNELET David - Com Web Solutions</td></tr>\n<tr><td><strong>Forme juridique</strong></td><td>Entreprise Individuelle (EI)</td></tr>\n<tr><td><strong>Siège social</strong></td><td>3 place des Templiers — 31260 Montsaunès</td></tr>\n<tr><td><strong>SIRET</strong></td><td>498 614 825 00046</td></tr>\n<tr><td><strong>N° TVA</strong></td><td>FR 18498614825</td></tr>\n<tr><td><strong>Capital social</strong></td><td>Non applicable (EI)</td></tr>\n<tr><td><strong>Directeur de publication</strong></td><td>LAIGNELET David</td></tr>\n<tr><td><strong>Contact</strong></td><td>david@comwebsolutions.fr</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>06 22 28 37 54</td></tr>\n</tbody>\n</table>\n\n<h2>2. Hébergement</h2>\n<table>\n<tbody>\n<tr><td><strong>Hébergeur</strong></td><td>OVH SAS</td></tr>\n<tr><td><strong>Adresse</strong></td><td>2 rue Kellermann, 59100 Roubaix, France</td></tr>\n<tr><td><strong>Site web</strong></td><td>https://www.ovh.com</td></tr>\n</tbody>\n</table>\n<p>L&#039;ensemble des données sont hébergées en France, conformément au RGPD.</p>\n\n<h2>3. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p>\n<p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p>\n\n<h2>4. Protection des données</h2>\n<ul>\n<li>Hébergement 100 % France</li>\n<li>Aucun transfert de données hors UE</li>\n<li>Données personnelles jamais revendues</li>\n</ul>\n<p><strong>Contact DPO :</strong> david@comwebsolutions.fr</p>\n<p>Voir la <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a> pour les détails complets.</p>\n\n<h2>5. Cookies</h2>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Type</th><th>Finalité</th><th>Consentement</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP</td><td>Essentiel</td><td>Authentification</td><td>Non requis</td></tr>\n<tr><td>CSRF</td><td>Essentiel</td><td>Sécurité formulaires</td><td>Non requis</td></tr>\n<tr><td>Google Analytics</td><td>Analytique</td><td>Mesure d&#039;audience</td><td><strong>Requis</strong></td></tr>\n<tr><td>Préférences cookies</td><td>Fonctionnel</td><td>Mémoriser votre choix</td><td>Non requis</td></tr>\n</tbody>\n</table>\n<p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p>\n\n<h2>6. Limitation de responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p>\n<p>L&#039;éditeur décline toute responsabilité en cas d&#039;interruption du site, de survenance de bugs ou d&#039;incompatibilité du site avec certains matériels ou configurations.</p>\n\n<h2>7. Droit applicable et litiges</h2>\n<p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p>\n<p><strong>Médiation consommation :</strong> Conformément à l&#039;article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : Non applicable.</p>\n\n<h2>8. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>david@comwebsolutions.fr</td></tr>\n<tr><td><strong>Courrier</strong></td><td>EI - LAIGNELET David - Com Web Solutions — 3 place des Templiers — 31260 Montsaunès</td></tr>\n<tr><td><strong>Téléphone</strong></td><td>06 22 28 37 54</td></tr>\n</tbody>\n</table>','mentions-legales',1,'2026-05-10 07:32:36',NULL,NULL,'full-width',1,'mentions-legales',NULL,'Mentions légales du site. Éditeur, hébergeur, propriété intellectuelle et contact.',NULL,1,NULL,NULL),
(2,'public','Politique de confidentialité','<p><em>Dernière mise à jour : 10 mai 2026</em></p>\n\n<h2>1. Responsable du traitement</h2>\n<table>\n<tbody>\n<tr><td><strong>Entité</strong></td><td>EI - LAIGNELET David - Com Web Solutions</td></tr>\n<tr><td><strong>Représentant</strong></td><td>LAIGNELET David</td></tr>\n<tr><td><strong>Siège</strong></td><td>3 place des Templiers — 31260 Montsaunès</td></tr>\n<tr><td><strong>SIRET</strong></td><td>498 614 825 00046</td></tr>\n<tr><td><strong>DPO</strong></td><td>david@comwebsolutions.fr</td></tr>\n</tbody>\n</table>\n\n<h2>2. Données collectées</h2>\n\n<h3>2.1 Compte utilisateur</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, prénom</td><td>Identification</td><td>Durée du compte</td></tr>\n<tr><td>Email</td><td>Identification, notifications</td><td>Durée du compte &#43; 3 ans</td></tr>\n<tr><td>Mot de passe (hashé)</td><td>Authentification</td><td>Durée du compte</td></tr>\n</tbody>\n</table>\n\n<h3>2.2 Formulaire de contact</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, email</td><td>Répondre à la demande</td><td>3 ans</td></tr>\n<tr><td>Message</td><td>Traitement de la demande</td><td>3 ans</td></tr>\n</tbody>\n</table>\n\n<h3>2.3 Commentaires</h3>\n<table>\n<thead>\n<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>\n</thead>\n<tbody>\n<tr><td>Nom, contenu</td><td>Affichage public</td><td>Durée de publication</td></tr>\n</tbody>\n</table>\n\n<h3>2.4 Données techniques</h3>\n<p>Adresse IP (hashée SHA-256), navigateur, pages visitées — conservées 12 mois à des fins de sécurité et de statistiques anonymes.</p>\n\n<h3>2.5 Paiement</h3>\n<p>Les données de paiement ne sont <strong>pas stockées</strong> par ce site. Elles sont gérées par Stripe (certifié PCI-DSS).</p>\n\n<h2>3. Finalités du traitement</h2>\n<ul>\n<li>Gestion des comptes utilisateurs</li>\n<li>Envoi de notifications relatives aux articles et au site</li>\n<li>Traitement des demandes de contact</li>\n<li>Amélioration du site via des statistiques de visite anonymisées</li>\n<li>Gestion des commandes et paiements (si module e-commerce actif)</li>\n</ul>\n\n<h2>4. Base légale</h2>\n<table>\n<thead>\n<tr><th>Traitement</th><th>Base légale (RGPD)</th></tr>\n</thead>\n<tbody>\n<tr><td>Compte utilisateur</td><td>Exécution du contrat (art. 6.1.b)</td></tr>\n<tr><td>Contact</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Cookies analytics</td><td>Consentement (art. 6.1.a)</td></tr>\n<tr><td>Sécurité / logs</td><td>Intérêt légitime (art. 6.1.f)</td></tr>\n<tr><td>Facturation</td><td>Obligation légale (art. 6.1.c)</td></tr>\n</tbody>\n</table>\n\n<h2>5. Ce que nous ne faisons PAS</h2>\n<ul>\n<li>Vendre ou louer vos données à des tiers</li>\n<li>Faire de la publicité ciblée</li>\n<li>Faire du profilage marketing</li>\n<li>Transférer vos données hors de l&#039;Union Européenne (hors sous-traitants certifiés)</li>\n</ul>\n\n<h2>6. Cookies</h2>\n\n<h3>Cookies essentiels (sans consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>Session PHP (PHPSESSID)</td><td>Authentification, panier</td></tr>\n<tr><td>CSRF token</td><td>Sécurité des formulaires</td></tr>\n<tr><td>Préférences cookies</td><td>Mémoriser votre choix</td></tr>\n</tbody>\n</table>\n\n<h3>Cookies analytiques (avec consentement)</h3>\n<table>\n<thead>\n<tr><th>Cookie</th><th>Finalité</th><th>Durée</th></tr>\n</thead>\n<tbody>\n<tr><td>Google Analytics (_ga, _gid)</td><td>Mesure d&#039;audience</td><td>13 mois max</td></tr>\n</tbody>\n</table>\n<p>Les cookies analytiques ne sont déposés <strong>qu&#039;après votre consentement explicite</strong> via le bandeau affiché lors de votre première visite. Vous pouvez retirer votre consentement à tout moment en supprimant vos cookies.</p>\n\n<h2>7. Sous-traitants</h2>\n<table>\n<thead>\n<tr><th>Prestataire</th><th>Pays</th><th>Finalité</th></tr>\n</thead>\n<tbody>\n<tr><td>OVH SAS</td><td>France</td><td>Hébergement</td></tr>\n<tr><td>Brevo</td><td>France</td><td>Envoi d&#039;emails</td></tr>\n<tr><td>Stripe</td><td>USA*</td><td>Paiement sécurisé</td></tr>\n<tr><td>Google Analytics</td><td>USA*</td><td>Audience (avec consentement)</td></tr>\n</tbody>\n</table>\n<p><em>* Certifiés EU-US Data Privacy Framework</em></p>\n\n<h2>8. Vos droits RGPD</h2>\n<table>\n<thead>\n<tr><th>Droit</th><th>Comment l&#039;exercer</th></tr>\n</thead>\n<tbody>\n<tr><td>Accès</td><td>Espace personnel ou david@comwebsolutions.fr</td></tr>\n<tr><td>Rectification</td><td>Espace personnel</td></tr>\n<tr><td>Suppression</td><td>Espace personnel ou david@comwebsolutions.fr</td></tr>\n<tr><td>Portabilité</td><td>david@comwebsolutions.fr</td></tr>\n<tr><td>Opposition</td><td>david@comwebsolutions.fr</td></tr>\n<tr><td>Limitation</td><td>david@comwebsolutions.fr</td></tr>\n</tbody>\n</table>\n<p><strong>Délai de réponse :</strong> 30 jours maximum.</p>\n<p>En cas de difficulté, vous pouvez adresser une réclamation auprès de la <strong>CNIL</strong> : <a href=\"https://www.cnil.fr\" target=\"_blank\" rel=\"noopener\">www.cnil.fr</a> — 3 Place de Fontenoy, 75334 Paris Cedex 07.</p>\n\n<h2>9. Sécurité</h2>\n<table>\n<tbody>\n<tr><td><strong>Transfert</strong></td><td>HTTPS / TLS 1.3</td></tr>\n<tr><td><strong>Mots de passe</strong></td><td>Hashés (bcrypt/argon2)</td></tr>\n<tr><td><strong>IP visiteurs</strong></td><td>Hashées SHA-256 (anonymisées)</td></tr>\n<tr><td><strong>Accès admin</strong></td><td>Protégé par authentification &#43; CSRF</td></tr>\n</tbody>\n</table>\n\n<h2>10. Modifications</h2>\n<p>Cette politique peut être mise à jour. En cas de changement significatif, les utilisateurs inscrits seront informés par email. La date de mise à jour figure en haut de page.</p>\n\n<h2>11. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>DPO</strong></td><td>david@comwebsolutions.fr</td></tr>\n<tr><td><strong>Courrier</strong></td><td>EI - LAIGNELET David - Com Web Solutions — 3 place des Templiers — 31260 Montsaunès</td></tr>\n</tbody>\n</table>','politique-confidentialite',1,'2026-05-10 07:32:36',NULL,NULL,'full-width',1,'politique-confidentialite',NULL,'Politique de confidentialité. Données collectées, cookies, droits RGPD et contact DPO.',NULL,1,NULL,NULL),
(3,'public','Conditions générales d\'utilisation','<p><em>Dernière mise à jour : 10 mai 2026</em></p>\n\n<h2>1. Objet</h2>\n<p>Les présentes Conditions Générales d&#039;Utilisation (CGU) régissent l&#039;accès et l&#039;utilisation de ce site internet. En accédant au site, vous acceptez sans réserve les présentes CGU.</p>\n\n<h2>2. Éditeur</h2>\n<table>\n<tbody>\n<tr><td><strong>Raison sociale</strong></td><td>EI - LAIGNELET David - Com Web Solutions</td></tr>\n<tr><td><strong>SIRET</strong></td><td>498 614 825 00046</td></tr>\n<tr><td><strong>Adresse</strong></td><td>3 place des Templiers — 31260 Montsaunès</td></tr>\n<tr><td><strong>Email</strong></td><td>david@comwebsolutions.fr</td></tr>\n</tbody>\n</table>\n\n<h2>3. Accès au service</h2>\n<ul>\n<li>Le site est accessible gratuitement à tout utilisateur disposant d&#039;un accès internet</li>\n<li>Les frais d&#039;accès et d&#039;utilisation du réseau de télécommunication sont à la charge de l&#039;utilisateur</li>\n<li>L&#039;éditeur se réserve le droit de suspendre ou interrompre l&#039;accès pour maintenance</li>\n</ul>\n\n<h2>4. Inscription</h2>\n<p>L&#039;accès à certaines fonctionnalités du site nécessite une inscription. L&#039;utilisateur s&#039;engage à :</p>\n<ul>\n<li>Fournir des informations exactes et complètes</li>\n<li>Mettre à jour ses informations en cas de changement</li>\n<li>Préserver la confidentialité de son mot de passe (12 caractères minimum)</li>\n<li>Notifier immédiatement toute utilisation non autorisée de son compte</li>\n</ul>\n<p>L&#039;éditeur se réserve le droit de supprimer tout compte ne respectant pas les présentes CGU.</p>\n\n<h2>5. Services proposés</h2>\n<p>Le site propose les services suivants :</p>\n<ul>\n<li>Publication et consultation de contenus (articles, pages, services)</li>\n<li>Formulaire de contact</li>\n<li>Inscription aux notifications</li>\n<li>Commentaires sur les articles</li>\n<li>{{SERVICES_SUPPLEMENTAIRES}}</li>\n</ul>\n\n<h2>6. Propriété intellectuelle</h2>\n<p>L&#039;ensemble du contenu du site est protégé par le droit de la propriété intellectuelle :</p>\n<ul>\n<li>Textes, images, vidéos, logos, icônes, sons, logiciels</li>\n<li>Charte graphique et design du site</li>\n<li>Bases de données</li>\n</ul>\n<p>Toute reproduction non autorisée constitue une contrefaçon sanctionnée par les articles L335-2 et suivants du Code de la Propriété Intellectuelle.</p>\n\n<h2>7. Comportement de l&#039;utilisateur</h2>\n<p>L&#039;utilisateur s&#039;engage à ne pas :</p>\n<ul>\n<li>Publier de contenu illicite, diffamatoire, injurieux ou discriminatoire</li>\n<li>Porter atteinte à la vie privée d&#039;autrui</li>\n<li>Tenter d&#039;accéder à des zones non autorisées du site</li>\n<li>Utiliser le site à des fins commerciales non autorisées</li>\n<li>Collecter des données personnelles d&#039;autres utilisateurs</li>\n</ul>\n\n<h2>8. Responsabilité</h2>\n<p>L&#039;éditeur s&#039;efforce de fournir des informations aussi précises que possible, mais ne garantit pas :</p>\n<ul>\n<li>L&#039;exactitude, la complétude ou l&#039;actualité des informations publiées</li>\n<li>La disponibilité permanente du site</li>\n<li>L&#039;absence de virus ou de défauts de fonctionnement</li>\n</ul>\n<p>L&#039;éditeur décline toute responsabilité pour les dommages directs ou indirects résultant de l&#039;utilisation du site.</p>\n\n<h2>9. Liens hypertextes</h2>\n<p>Le site peut contenir des liens vers des sites tiers. L&#039;éditeur n&#039;est pas responsable du contenu de ces sites et n&#039;exerce aucun contrôle sur eux.</p>\n\n<h2>10. Données personnelles</h2>\n<p>Le traitement des données personnelles est décrit dans notre <a href=\"/politique-de-confidentialite\">Politique de confidentialité</a>, accessible depuis le pied de page du site.</p>\n\n<h2>11. Modification des CGU</h2>\n<p>L&#039;éditeur se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs inscrits seront informés par email de toute modification substantielle. La date de mise à jour figure en haut de page.</p>\n\n<h2>12. Droit applicable</h2>\n<p>Les présentes CGU sont régies par le droit français. En cas de litige, les tribunaux français seront compétents.</p>\n\n<h2>13. Contact</h2>\n<table>\n<tbody>\n<tr><td><strong>Email</strong></td><td>david@comwebsolutions.fr</td></tr>\n<tr><td><strong>Courrier</strong></td><td>EI - LAIGNELET David - Com Web Solutions — 3 place des Templiers — 31260 Montsaunès</td></tr>\n</tbody>\n</table>','cgu',1,'2026-05-10 07:32:44',NULL,NULL,'full-width',1,'cgu',NULL,'Conditions générales d\'utilisation. Accès au service, inscription, propriété intellectuelle et responsabilité.',NULL,1,NULL,NULL),
(4,'public','À propos','<h2>15 ans de commerce, 10 ans de code</h2>\n\n<p>Je m&#039;appelle David Laignelet. J&#039;ai commencé par vendre. Du B2B, du B2C, du dur. Des produits, des services, des concepts. Pendant 15 ans, j&#039;ai fait du terrain — prospection, négociation, closing, direction commerciale. J&#039;ai aussi été du mauvais côté : celui où on se fait avoir par des consultants qui n&#039;ont jamais vendu de leur vie.</p>\n\n<p>C&#039;est précisément cette expérience qui m&#039;a poussé à créer Com Web Solutions. Pour proposer l&#039;inverse : un interlocuteur unique qui comprend le business <strong>et</strong> la technique. Quelqu&#039;un qui a vendu avant de coder, et qui code pour aider à vendre.</p>\n\n<h2>Du commerce au code</h2>\n\n<p>Il y a 10 ans, j&#039;ai appris à développer. Pas dans une école, sur le terrain — comme pour le commerce. Symfony, PHP, JavaScript, bases de données. Aujourd&#039;hui je conçois des sites web, des applications métier et des outils d&#039;intelligence artificielle.</p>\n\n<p>En parallèle, j&#039;enseigne les techniques commerciales. Cette double casquette — vendre et construire — c&#039;est ce qui fait la différence pour mes clients.</p>\n\n<h2>Ce que je fais aujourd&#039;hui</h2>\n\n<p>J&#039;accompagne des dirigeants de TPE/PME sur deux fronts :</p>\n\n<ul>\n<li><strong>Le commerce</strong> — Direction commerciale externalisée, prospection B2B, réponse aux appels d&#039;offres. Pour ceux qui n&#039;ont pas de directeur commercial en interne.</li>\n<li><strong>Le web et la tech</strong> — Sites BlogWeb (alternative française à WordPress), LintellO (IA confidentielle hébergée en France), applications sur mesure (référence : Kayre).</li>\n</ul>\n\n<p>Un seul interlocuteur, du premier appel à la mise en ligne. Pas de jargon, pas de slides PowerPoint, pas de chargé de compte.</p>\n\n<h2>Basé dans le Comminges, disponible partout</h2>\n\n<p>Mon bureau est à Montsaunès, dans les Pyrénées. Mais peu importe où vous êtes — Toulouse, Paris, Lille, ailleurs. On bosse en visio, en présentiel, comme ça vous arrange. Ce qui compte, c&#039;est le résultat.</p>\n\n<h2>Ma philosophie</h2>\n\n<p>Je ne fais pas de marketing-speak. Je ne dis pas « synergie », « écosystème » ou « transformation digitale ». Je parle comme je vends : direct, concret, terrain.</p>\n\n<p>Quand je peux aider, je le dis. Quand je ne peux pas, je le dis aussi. C&#039;est aussi simple que ça.</p>\n\n<div>\n<h3 style=\"margin-bottom: 0.5rem;\">Un échange de 30 minutes pour faire le point ?</h3>\n<p style=\"color: var(--text-muted, #6B7280);\">Pas d&#039;engagement, pas de présentation commerciale. On parle de votre boîte.</p>\n<a href=\"https://calendar.app.google/Fbg8eFHGt97zVENT7\" target=\"_blank\" rel=\"noopener\" class=\"btn btn-primary btn-lg\">Réserver un créneau</a>\n</div>','a-propos',1,'2026-05-10 05:54:01','2026-05-10 08:02:24',NULL,'default',0,NULL,'À propos — David Laignelet | Com Web Solutions','15 ans de commerce, 10 ans de code. Un seul interlocuteur pour votre développement commercial et web. Basé dans le Comminges, disponible partout.',NULL,0,NULL,5),
(5,'public','Pourquoi un seul interlocuteur pour le commerce et le web ?','<p><em>Vous êtes dirigeant de TPE ou PME. Vous gérez tout. Et quand il s\'agit du commercial ou du web, vous faites avec les moyens du bord — ou vous déléguez à des gens qui ne comprennent pas votre réalité.</em></p>\n\n<hr>\n\n<h2>Vous n\'avez pas les moyens d\'une agence web ET d\'un directeur commercial</h2>\n\n<p>Recruter un directeur commercial, c\'est 60 à 80 k€ par an. Mandater une agence web, c\'est 5 à 15 k€ le site, puis un forfait maintenance, puis le SEO en option, puis le freelance pour les campagnes. Et entre les deux, personne ne se parle.</p>\n\n<p>Résultat : vous avez un site qui ne génère aucun lead, un commercial (quand vous en avez un) qui prospecte à froid sans support digital, et une facture globale qui ne produit aucun retour mesurable.</p>\n\n<p><strong>C\'est le quotidien de 80 % des TPE/PME B2B que je rencontre.</strong></p>\n\n<hr>\n\n<h2>Votre agence web ne sait pas ce qu\'est un cycle de vente</h2>\n\n<p>Elle parle responsive, UX, charte graphique. Elle livre un site \"joli\". Mais elle ne vous a jamais demandé : combien coûte un prospect ? Quel est votre taux de transformation ? À quel moment du parcours vous perdez des opportunités ?</p>\n\n<p>Parce qu\'elle n\'a jamais vendu. Elle n\'a jamais décroché un téléphone pour qualifier un lead. Elle n\'a jamais répondu à un appel d\'offres à 3h du matin.</p>\n\n<p>Moi, je l\'ai fait pendant 15 ans avant d\'écrire ma première ligne de code. Et ça change tout dans la façon de construire un site : on ne pense pas \"maquette Figma\", on pense parcours de conversion.</p>\n\n<hr>\n\n<h2>Vous avez déjà été déçu par un prestataire</h2>\n\n<p>L\'agence qui disparaît après la livraison. Le freelance qui ne répond plus. Le consultant qui facture des slides que personne ne lit. Le prestataire qui sous-traite à quelqu\'un que vous n\'avez jamais rencontré.</p>\n\n<p>Quand vous travaillez avec moi, il n\'y a pas de chargé de compte, pas de chef de projet intermédiaire, pas de sous-traitance. Du premier appel à la mise en ligne — et après — c\'est la même personne. Si quelque chose ne va pas, vous savez exactement à qui parler.</p>\n\n<hr>\n\n<h2>Le vrai problème : personne ne fait le lien entre votre commerce et votre web</h2>\n\n<p>Vous pouvez avoir le meilleur site du monde et zéro prospect. Vous pouvez avoir un excellent commercial et un site qui le dessert. Ce qui manque dans la plupart des TPE/PME, ce n\'est ni l\'un ni l\'autre — c\'est quelqu\'un qui comprend les deux et qui les fait travailler ensemble.</p>\n\n<p>Quand c\'est la même personne qui gère votre prospection et qui code votre site :</p>\n\n<ul>\n<li>Les séquences de prospection renvoient vers des pages qui convertissent</li>\n<li>Le site est pensé pour aider le commercial, pas pour le portfolio de l\'agence</li>\n<li>Le CRM, les formulaires, les relances — tout est connecté sans trois prestataires</li>\n<li>Chaque euro investi a un objectif commercial mesurable</li>\n</ul>\n\n<hr>\n\n<h2>Concrètement, comment ça se passe ?</h2>\n\n<p><strong>1. On se parle 30 minutes.</strong> Pas de présentation commerciale. Je vous pose des questions sur votre boîte, votre marché, ce qui bloque. Je vous dis honnêtement si je peux aider — ou non.</p>\n\n<p><strong>2. Je vous propose un plan d\'action.</strong> Pas 40 pages de recommandations. Un document clair : voici ce qu\'on fait, dans quel ordre, pour quel résultat attendu, à quel prix.</p>\n\n<p><strong>3. On avance ensemble.</strong> Pas de tunnel de 6 mois sans nouvelles. Vous voyez ce qui se construit, vous validez au fur et à mesure, vous gardez la main.</p>\n\n<hr>\n\n<h2>Ce n\'est pas pour tout le monde</h2>\n\n<p>Je travaille avec des dirigeants de TPE/PME qui :</p>\n\n<ul>\n<li>Font eux-mêmes le commercial — et n\'en peuvent plus</li>\n<li>Ont un site web qui ne leur rapporte rien</li>\n<li>Veulent un interlocuteur unique, pas un organigramme de prestataires</li>\n<li>Cherchent du concret, pas du jargon</li>\n</ul>\n\n<p>Si vous cherchez une grosse agence avec des process certifiés et des comités de pilotage, ce n\'est pas ici. Si vous cherchez quelqu\'un qui comprend votre réalité de dirigeant et qui sait à la fois vendre et construire les outils pour vendre — on devrait se parler.</p>\n\n<hr>\n\n<div style=\"margin-top: 2rem; padding: 2rem; background: var(--surface, #F9FAFB); border-radius: 0.625rem; text-align: center;\">\n<h3 style=\"margin-bottom: 0.5rem;\">30 minutes pour faire le point</h3>\n<p style=\"color: var(--text-muted, #6B7280);\">Pas d\'engagement, pas de présentation PowerPoint. On parle de votre boîte et je vous dis ce que je ferais — ou pas.</p>\n<a href=\"https://calendar.app.google/Fbg8eFHGt97zVENT7\" target=\"_blank\" rel=\"noopener\" class=\"btn btn-primary btn-lg\" style=\"margin-top: 1rem; color: #fff !important;\">Réserver un créneau</a>\n</div>','pourquoi-un-seul-interlocuteur',1,'2026-05-10 06:22:08',NULL,NULL,'default',0,NULL,'Pourquoi un seul interlocuteur pour le commerce et le web ?','Votre agence web ne comprend pas votre business. Votre commercial n\'a pas de support digital. Un seul interlocuteur pour les deux change tout.',NULL,0,NULL,NULL),
(6,'public','Vous n\'avez personne pour prospecter — et ça vous coûte cher','<p><em>Vous êtes dirigeant de TPE/PME. Vous faites tout — la production, la gestion, le commercial. Sauf que le commercial, c\'est celui qui saute en premier quand le quotidien déborde.</em></p>\n\n<hr>\n\n<h2>Le problème n\'est pas que vous ne savez pas vendre</h2>\n\n<p>Vous avez monté votre boîte. Vous avez trouvé vos premiers clients. Vous savez vendre — vous l\'avez prouvé. Le problème, c\'est que vous ne pouvez pas tout faire. La prospection demande de la régularité, de la méthode, et du temps. Trois choses que vous n\'avez plus.</p>\n\n<p>Résultat : vous vivez sur votre carnet d\'adresses. Le bouche-à-oreille fonctionne, mais il ne suffit plus. Et quand un gros client part, c\'est la panique.</p>\n\n<hr>\n\n<h2>Embaucher un commercial ? Pas si simple.</h2>\n\n<p>Un bon commercial coûte entre 40 000 et 60 000 € par an, charges comprises. Il faut le recruter (3 à 6 mois), le former à votre offre (encore 3 mois), espérer qu\'il reste. En TPE, ce n\'est souvent pas viable.</p>\n\n<p>L\'alternative : externaliser. Pas à une plateforme, pas à un call center, mais à quelqu\'un qui comprend votre métier, votre offre, et qui a 15 ans de terrain dans les pattes.</p>\n\n<hr>\n\n<h2>Ce que je fais concrètement</h2>\n\n<h3>Direction commerciale externalisée</h3>\n<p>Je prends en charge votre stratégie commerciale : diagnostic, structuration de la prospection, mise en place des outils, formation de votre équipe si vous en avez une, pilotage des résultats. Vous avez un directeur commercial — sans le salaire fixe.</p>\n\n<h3>Prospection B2B</h3>\n<p>L\'offre 20/80 : je gère votre prospection de A à Z. Ciblage, séquences multicanales (email, LinkedIn, téléphone), qualification des leads, prise de RDV. Vous recevez des rendez-vous qualifiés, vous restez focus sur votre métier.</p>\n\n<h3>Appels d\'offres</h3>\n<p>Détection des marchés pertinents, analyse des cahiers des charges, rédaction et dépôt de vos réponses. Pour ne plus passer à côté de marchés publics et privés qui sont à votre portée.</p>\n\n<hr>\n\n<h2>Pour qui ?</h2>\n\n<ul>\n<li>Dirigeants de TPE/PME qui font le commercial eux-mêmes et qui saturent</li>\n<li>Entreprises B2B avec une bonne offre mais pas de pipeline structuré</li>\n<li>Boîtes qui ont essayé de recruter un commercial et qui se sont plantées</li>\n<li>Entreprises qui répondent aux appels d\'offres au dernier moment — ou pas du tout</li>\n</ul>\n\n<hr>\n\n<h2>Ce que ça ne sera pas</h2>\n\n<p>Pas de slides PowerPoint. Pas de \"stratégie de marque\" ou de \"positionnement sur le marché\". Pas de reporting de 40 pages que personne ne lit. Du concret, du terrain, des résultats mesurables. Si au bout de 3 mois ça ne bouge pas, on se le dit.</p>\n\n<hr>\n\n<div style=\"margin-top: 2rem; padding: 2rem; background: var(--surface, #F9FAFB); border-radius: 0.625rem; text-align: center;\">\n<h3 style=\"margin-bottom: 0.5rem;\">On fait le point sur votre développement commercial ?</h3>\n<p style=\"color: var(--text-muted, #6B7280);\">30 minutes pour comprendre où vous en êtes et si je peux aider. Sans engagement.</p>\n<a href=\"https://calendar.app.google/Fbg8eFHGt97zVENT7\" target=\"_blank\" rel=\"noopener\" class=\"btn btn-primary btn-lg\" style=\"margin-top: 1rem; color: #fff !important;\">Réserver un créneau</a>\n</div>','developpement-commercial',1,'2026-05-10 06:31:39',NULL,NULL,'default',0,NULL,'Développement commercial TPE/PME — Com Web Solutions','Prospection B2B, direction commerciale externalisée, appels d\'offres. 15 ans de terrain au service de votre développement commercial.',NULL,0,NULL,NULL),
(7,'public','Votre site est en ligne — mais est-ce qu\'il travaille pour vous ?','<p><em>Vous avez un site. Il est \"joli\". Mais quand vous comptez les contacts reçus depuis un an… c\'est le vide. Le problème n\'est pas le site. C\'est ce qu\'on en a fait.</em></p>\n\n<hr>\n\n<h2>Un site web n\'est pas une brochure en ligne</h2>\n\n<p>La plupart des sites de TPE/PME sont des vitrines mortes. Mis en ligne il y a 3 ans, jamais mis à jour, mal référencés, parfois même pas en HTTPS. Ils existent parce qu\'\"il en faut un\" — pas parce qu\'ils servent à quelque chose.</p>\n\n<p>Un site qui travaille pour vous, c\'est un site qui apparaît sur Google quand vos prospects cherchent ce que vous vendez. Qui explique clairement ce que vous faites. Qui donne envie de vous contacter. Et que vous pouvez modifier vous-même en 5 minutes.</p>\n\n<hr>\n\n<h2>WordPress, le problème qu\'on ne vous dit pas</h2>\n\n<p>80% des sites de TPE tournent sur WordPress. Avec 5, 10, parfois 20 plugins. Chaque plugin est une porte d\'entrée potentielle pour un pirate. Chaque mise à jour peut tout casser. Et quand votre prestataire disparaît, vous êtes coincé avec un site que vous ne comprenez pas.</p>\n\n<p>Je ne construis pas sur WordPress. Je construis sur BlogWeb — un CMS que j\'ai développé moi-même, en Symfony, hébergé en France. Pas de plugins, pas de failles connues, pas de dépendance à un écosystème tiers. Vous avez un site rapide, sécurisé, et que je maintiens personnellement.</p>\n\n<hr>\n\n<h2>Ce qu\'un bon site fait pour votre business</h2>\n\n<ul>\n<li><strong>Il vous rend visible</strong> — SEO intégré, temps de chargement optimisé, structure pensée pour Google</li>\n<li><strong>Il rassure vos prospects</strong> — design professionnel, témoignages, contenu qui montre que vous connaissez votre métier</li>\n<li><strong>Il génère des contacts</strong> — formulaires, CTA clairs, parcours de conversion pensé par quelqu\'un qui vend</li>\n<li><strong>Il vous appartient</strong> — hébergé en France, données chez vous, pas de lock-in technologique</li>\n</ul>\n\n<hr>\n\n<h2>Site en ligne en une demi-journée</h2>\n\n<p>Ce n\'est pas un slogan. C\'est la réalité de BlogWeb. Vous me donnez vos textes, vos photos, vos couleurs — et en 4 heures votre site est en ligne, fonctionnel, référencé, sécurisé. Pas 3 mois de maquettes, de réunions et de devis à 5 chiffres.</p>\n\n<p>Après la mise en ligne, je reste votre interlocuteur. Pas un numéro de ticket, pas un chatbot — moi, directement. Maintenance, mises à jour, évolutions : tout passe par un seul canal.</p>\n\n<hr>\n\n<h2>Et si votre site pouvait aussi vendre ?</h2>\n\n<p>Quand celui qui construit votre site est aussi celui qui gère votre prospection, les choses s\'alignent. Vos pages sont pensées pour convertir, pas pour décorer. Vos séquences de prospection renvoient vers du contenu qui prépare le terrain. Votre site devient un outil commercial — pas un centre de coûts.</p>\n\n<hr>\n\n<div style=\"margin-top: 2rem; padding: 2rem; background: var(--surface, #F9FAFB); border-radius: 0.625rem; text-align: center;\">\n<h3 style=\"margin-bottom: 0.5rem;\">On regarde ensemble ce que votre site pourrait faire ?</h3>\n<p style=\"color: var(--text-muted, #6B7280);\">Audit gratuit de votre site actuel en 30 minutes. Je vous dis ce qui marche, ce qui ne marche pas, et ce qu\'on peut améliorer.</p>\n<a href=\"https://calendar.app.google/Fbg8eFHGt97zVENT7\" target=\"_blank\" rel=\"noopener\" class=\"btn btn-primary btn-lg\" style=\"margin-top: 1rem; color: #fff !important;\">Réserver un créneau</a>\n</div>','votre-site-web',1,'2026-05-10 06:31:39',NULL,NULL,'default',0,NULL,'Votre site web ne vous rapporte rien ? — Com Web Solutions','Site vitrine, blog ou e-commerce sans WordPress. Hébergé en France, sécurisé, en ligne en une demi-journée. Un seul interlocuteur.',NULL,0,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_view`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `page_view` WRITE;
/*!40000 ALTER TABLE `page_view` DISABLE KEYS */;
INSERT INTO `page_view` VALUES
(1,'/','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 07:41:26',0),
(2,'/','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0',NULL,'2026-05-10 07:47:28',0),
(3,'/login','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0',NULL,'2026-05-10 07:47:47',0),
(4,'/page/a-propos','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 07:54:17',0),
(5,'/','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 07:55:38',0),
(6,'/page/a-propos','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 08:05:58',0),
(7,'/page/a-propos','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 08:07:34',0),
(8,'/','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 08:22:29',0),
(9,'/page/pourquoi-un-seul-interlocuteur','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 08:27:47',0),
(10,'/','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 08:32:31',0),
(11,'/','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-10 08:37:29',0),
(12,'/','ed9e264c7f6fd840cbcd3f8b998bff9132021037c7f0dee010217d96f4d64036','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0',NULL,'2026-05-10 15:26:47',0),
(13,'/','3a3a5e8e9dd4b8e54a8bc7732b62cfa6e7fd8b563dc4a6801b1788ff62193d19','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-11 05:45:44',0),
(14,'/','3a3a5e8e9dd4b8e54a8bc7732b62cfa6e7fd8b563dc4a6801b1788ff62193d19','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-11 05:48:53',0),
(15,'/service/externalisation-commerciale-b2b','3a3a5e8e9dd4b8e54a8bc7732b62cfa6e7fd8b563dc4a6801b1788ff62193d19','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36',NULL,'2026-05-11 15:56:48',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES
(1,'Direction Commerciale Externalisée','direction-commerciale-externalisee','Votre bras droit commercial : diagnostic stratégique, structuration de la prospection, formation de votre équipe, pilotage des résultats. Pour les dirigeants qui n\'ont pas de directeur commercial en interne.','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Votre directeur commercial, sans le co\\u00fbt d\'un CDI\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Recruter un directeur commercial co\\u00fbte entre 60 000 et 90 000 \\u20ac par an, sans compter les charges, le v\\u00e9hicule et les outils. Avec la Direction Commerciale Externalis\\u00e9e, vous b\\u00e9n\\u00e9ficiez d\'un accompagnement strat\\u00e9gique complet pour \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"1 650 \\u20ac\\/mois\"},{\"type\":\"text\",\"text\":\", sans engagement longue dur\\u00e9e.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cette offre s\'adresse aux TPE et PME qui ont besoin de structurer leur d\\u00e9veloppement commercial sans mobiliser un poste \\u00e0 temps plein.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les 5 piliers de l\'accompagnement\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"1. Strat\\u00e9gie commerciale\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Diagnostic de votre positionnement, d\\u00e9finition des cibles prioritaires, construction de l\'offre et du discours commercial. On part de votre r\\u00e9alit\\u00e9 terrain pour b\\u00e2tir un plan d\'action concret.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"2. Cycle de vente\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mise en place du processus complet : prospection multicanale (t\\u00e9l\\u00e9phone, email, LinkedIn), qualification des leads, relances structur\\u00e9es, closing. Chaque \\u00e9tape est outill\\u00e9e et mesurable.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"3. Pilotage et reporting\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Tableaux de bord CRM, suivi des KPI (taux de transformation, panier moyen, cycle de vente), point hebdomadaire avec le dirigeant. Vous gardez la visibilit\\u00e9 totale sur l\'activit\\u00e9 commerciale.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"4. Relation client\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Fid\\u00e9lisation, upsell, gestion des comptes cl\\u00e9s. Le d\\u00e9veloppement commercial ne s\'arr\\u00eate pas \\u00e0 la signature : on structure aussi la r\\u00e9tention et la croissance du portefeuille existant.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"5. Ressources et outils\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"CRM configur\\u00e9, scripts d\'appel, s\\u00e9quences email, bases de donn\\u00e9es B2B, supports de pr\\u00e9sentation. Tout est fourni et op\\u00e9rationnel d\\u00e8s le d\\u00e9marrage.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Ce qui est inclus\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Prospection t\\u00e9l\\u00e9phonique et email int\\u00e9gr\\u00e9e\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9ponse aux appels d\'offres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Point strat\\u00e9gique hebdomadaire\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Acc\\u00e8s CRM avec reporting automatique\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Base de donn\\u00e9es B2B qualifi\\u00e9e\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Formation de vos \\u00e9quipes si besoin\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pour qui ?\"}]},{\"type\":\"callout\",\"attrs\":{\"type\":\"info\"},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Dirigeants de TPE\\/PME qui veulent acc\\u00e9l\\u00e9rer leur croissance commerciale sans recruter, ou qui ont besoin d\'un regard ext\\u00e9rieur pour structurer une d\\u00e9marche qui fonctionne. Particuli\\u00e8rement adapt\\u00e9 aux entreprises en phase de d\\u00e9veloppement ou de repositionnement.\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"\\u00c0 partir de 1 650 \\u20ac\\/mois \\u2014 Sans engagement\"}]}]}]}','<h2>Votre directeur commercial, sans le coût d&#039;un CDI</h2><p>Recruter un directeur commercial coûte entre 60 000 et 90 000 € par an, sans compter les charges, le véhicule et les outils. Avec la Direction Commerciale Externalisée, vous bénéficiez d&#039;un accompagnement stratégique complet pour <strong>1 650 €/mois</strong>, sans engagement longue durée.</p><p>Cette offre s&#039;adresse aux TPE et PME qui ont besoin de structurer leur développement commercial sans mobiliser un poste à temps plein.</p><h3>Les 5 piliers de l&#039;accompagnement</h3><h4>1. Stratégie commerciale</h4><p>Diagnostic de votre positionnement, définition des cibles prioritaires, construction de l&#039;offre et du discours commercial. On part de votre réalité terrain pour bâtir un plan d&#039;action concret.</p><h4>2. Cycle de vente</h4><p>Mise en place du processus complet : prospection multicanale (téléphone, email, LinkedIn), qualification des leads, relances structurées, closing. Chaque étape est outillée et mesurable.</p><h4>3. Pilotage et reporting</h4><p>Tableaux de bord CRM, suivi des KPI (taux de transformation, panier moyen, cycle de vente), point hebdomadaire avec le dirigeant. Vous gardez la visibilité totale sur l&#039;activité commerciale.</p><h4>4. Relation client</h4><p>Fidélisation, upsell, gestion des comptes clés. Le développement commercial ne s&#039;arrête pas à la signature : on structure aussi la rétention et la croissance du portefeuille existant.</p><h4>5. Ressources et outils</h4><p>CRM configuré, scripts d&#039;appel, séquences email, bases de données B2B, supports de présentation. Tout est fourni et opérationnel dès le démarrage.</p><h3>Ce qui est inclus</h3><ul><li><p>Prospection téléphonique et email intégrée</p></li><li><p>Réponse aux appels d&#039;offres</p></li><li><p>Point stratégique hebdomadaire</p></li><li><p>Accès CRM avec reporting automatique</p></li><li><p>Base de données B2B qualifiée</p></li><li><p>Formation de vos équipes si besoin</p></li></ul><h3>Pour qui ?</h3><div class=\"block-callout block-callout--info\"><span class=\"block-callout__icon\">ⓘ</span><div class=\"block-callout__content\"><p>Dirigeants de TPE/PME qui veulent accélérer leur croissance commerciale sans recruter, ou qui ont besoin d&#039;un regard extérieur pour structurer une démarche qui fonctionne. Particulièrement adapté aux entreprises en phase de développement ou de repositionnement.<br /><strong>À partir de 1 650 €/mois — Sans engagement</strong></p></div></div>','laptop',NULL,1,1,6,NULL),
(2,'Externalisation commerciale B2B','externalisation-commerciale-b2b','L\'offre 20/80 : prise en charge de votre prospection B2B de A à Z. Ciblage, séquences multicanales, phoning. Vous restez focus sur votre métier.','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Votre prospection B2B cl\\u00e9 en main\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Prospecter prend du temps, demande des outils et une m\\u00e9thode rigoureuse. La plupart des dirigeants de TPE\\/PME n\'ont ni le temps ni les ressources pour maintenir une prospection r\\u00e9guli\\u00e8re. R\\u00e9sultat : le pipe commercial se vide entre deux contrats.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"L\'Externalisation Commerciale B2B prend en charge l\'int\\u00e9gralit\\u00e9 de votre prospection pour \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"950 \\u20ac\\/mois\"},{\"type\":\"text\",\"text\":\", sans engagement.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Ce que nous faisons pour vous\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Prospection t\\u00e9l\\u00e9phonique intensive\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"1 000 appels garantis par mois\"},{\"type\":\"text\",\"text\":\" vers vos cibles. Chaque appel suit un script valid\\u00e9 ensemble, adapt\\u00e9 \\u00e0 votre offre et votre march\\u00e9. L\'objectif : d\\u00e9crocher des rendez-vous qualifi\\u00e9s que vous transformez.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Campagnes email s\\u00e9quenc\\u00e9es\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9quences multicanales personnalis\\u00e9es : emails de prise de contact, relances, contenus \\u00e0 valeur ajout\\u00e9e. Chaque campagne est cibl\\u00e9e sur des segments pr\\u00e9cis de votre march\\u00e9.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Base de donn\\u00e9es B2B fournie\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pas besoin d\'acheter des fichiers. Nous constituons et qualifions votre base de prospects \\u00e0 partir de sources professionnelles v\\u00e9rifi\\u00e9es, segment\\u00e9e par secteur, taille d\'entreprise et zone g\\u00e9ographique.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Reporting CRM automatique\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Chaque action est trac\\u00e9e dans le CRM : appels pass\\u00e9s, emails envoy\\u00e9s, r\\u00e9ponses obtenues, rendez-vous d\\u00e9croch\\u00e9s. Vous recevez un reporting clair et r\\u00e9gulier sans rien avoir \\u00e0 faire.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Le principe 20\\/80\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Nous prenons en charge les 80 % du travail de prospection (ciblage, appels, relances, qualification) pour que vous vous concentriez sur les 20 % \\u00e0 forte valeur : le rendez-vous client et le closing. Votre temps est investi l\\u00e0 o\\u00f9 il rapporte.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9sultats concrets\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"1 000 appels sortants par mois minimum\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Rendez-vous qualifi\\u00e9s livr\\u00e9s dans votre agenda\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pipe commercial aliment\\u00e9 en continu\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Visibilit\\u00e9 totale via le CRM partag\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Aucun recrutement, aucune charge salariale\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Pour qui ?\"}]},{\"type\":\"callout\",\"attrs\":{\"type\":\"success\"},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"TPE et PME en B2B qui veulent maintenir une prospection r\\u00e9guli\\u00e8re sans embaucher de commercial. Id\\u00e9al pour les entreprises de services, ESN, bureaux d\'\\u00e9tudes, prestataires industriels ou toute structure dont le d\\u00e9veloppement repose sur la conqu\\u00eate de nouveaux comptes.\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"950 \\u20ac\\/mois \\u2014 Sans engagement \\u2014 R\\u00e9sultats d\\u00e8s le premier mois\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null}}]}]}','<h2>Votre prospection B2B clé en main</h2><p>Prospecter prend du temps, demande des outils et une méthode rigoureuse. La plupart des dirigeants de TPE/PME n&#039;ont ni le temps ni les ressources pour maintenir une prospection régulière. Résultat : le pipe commercial se vide entre deux contrats.</p><p>L&#039;Externalisation Commerciale B2B prend en charge l&#039;intégralité de votre prospection pour <strong>950 €/mois</strong>, sans engagement.</p><h3>Ce que nous faisons pour vous</h3><h4>Prospection téléphonique intensive</h4><p><strong>1 000 appels garantis par mois</strong> vers vos cibles. Chaque appel suit un script validé ensemble, adapté à votre offre et votre marché. L&#039;objectif : décrocher des rendez-vous qualifiés que vous transformez.</p><h4>Campagnes email séquencées</h4><p>Séquences multicanales personnalisées : emails de prise de contact, relances, contenus à valeur ajoutée. Chaque campagne est ciblée sur des segments précis de votre marché.</p><h4>Base de données B2B fournie</h4><p>Pas besoin d&#039;acheter des fichiers. Nous constituons et qualifions votre base de prospects à partir de sources professionnelles vérifiées, segmentée par secteur, taille d&#039;entreprise et zone géographique.</p><h4>Reporting CRM automatique</h4><p>Chaque action est tracée dans le CRM : appels passés, emails envoyés, réponses obtenues, rendez-vous décrochés. Vous recevez un reporting clair et régulier sans rien avoir à faire.</p><h3>Le principe 20/80</h3><p>Nous prenons en charge les 80 % du travail de prospection (ciblage, appels, relances, qualification) pour que vous vous concentriez sur les 20 % à forte valeur : le rendez-vous client et le closing. Votre temps est investi là où il rapporte.</p><h3>Résultats concrets</h3><ul><li><p>1 000 appels sortants par mois minimum</p></li><li><p>Rendez-vous qualifiés livrés dans votre agenda</p></li><li><p>Pipe commercial alimenté en continu</p></li><li><p>Visibilité totale via le CRM partagé</p></li><li><p>Aucun recrutement, aucune charge salariale</p></li></ul><h2>Pour qui ?</h2><div class=\"block-callout block-callout--success\"><span class=\"block-callout__icon\">✔</span><div class=\"block-callout__content\"><p>TPE et PME en B2B qui veulent maintenir une prospection régulière sans embaucher de commercial. Idéal pour les entreprises de services, ESN, bureaux d&#039;études, prestataires industriels ou toute structure dont le développement repose sur la conquête de nouveaux comptes.<br /><strong>950 €/mois — Sans engagement — Résultats dès le premier mois</strong></p><p></p></div></div>','briefcase',NULL,2,1,10,NULL),
(3,'Externalisation appels d\'offres','externalisation-appels-d-offres','Détection, analyse, rédaction et dépôt de vos réponses aux appels d\'offres publics et privés. Pour ne plus passer à côté de marchés à votre portée.','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Ne passez plus \\u00e0 c\\u00f4t\\u00e9 des march\\u00e9s publics\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les appels d\'offres repr\\u00e9sentent un levier de croissance consid\\u00e9rable pour les TPE\\/PME, mais la complexit\\u00e9 administrative d\\u00e9courage la plupart des dirigeants. Veille quotidienne, analyse des cahiers des charges, r\\u00e9daction des m\\u00e9moires techniques, constitution des dossiers administratifs : c\'est un m\\u00e9tier \\u00e0 part enti\\u00e8re.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Nous prenons en charge l\'int\\u00e9gralit\\u00e9 du processus pour \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"375 \\u20ac\\/mois + 150 \\u20ac par dossier d\\u00e9pos\\u00e9\"},{\"type\":\"text\",\"text\":\".\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Notre processus en 4 \\u00e9tapes\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"1. Veille automatis\\u00e9e\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Surveillance quotidienne des plateformes de march\\u00e9s publics et priv\\u00e9s (BOAMP, JOUE, plateformes de d\\u00e9mat\\u00e9rialisation). Les opportunit\\u00e9s correspondant \\u00e0 votre activit\\u00e9 sont identifi\\u00e9es automatiquement.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"2. Pr\\u00e9s\\u00e9lection intelligente\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Chaque appel d\'offres d\\u00e9tect\\u00e9 est analys\\u00e9 : crit\\u00e8res d\'\\u00e9ligibilit\\u00e9, montant estim\\u00e9, chances de succ\\u00e8s, ad\\u00e9quation avec vos r\\u00e9f\\u00e9rences. Vous ne recevez que les march\\u00e9s pertinents, avec une recommandation argument\\u00e9e.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"3. R\\u00e9daction compl\\u00e8te\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"M\\u00e9moire technique, note m\\u00e9thodologique, r\\u00e9f\\u00e9rences, moyens humains et mat\\u00e9riels : nous r\\u00e9digeons l\'int\\u00e9gralit\\u00e9 du dossier de r\\u00e9ponse. Vous relisez, validez, et nous d\\u00e9posons.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"4. D\\u00e9p\\u00f4t et suivi\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Constitution du dossier administratif (DC1, DC2, attestations), d\\u00e9p\\u00f4t sur la plateforme dans les d\\u00e9lais, suivi de la notification. Tout est g\\u00e9r\\u00e9 de A \\u00e0 Z.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi externaliser vos AO ?\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Un dossier de r\\u00e9ponse prend en moyenne 2 \\u00e0 5 jours de travail\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"80 % des TPE\\/PME \\u00e9ligibles ne r\\u00e9pondent jamais par manque de temps\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les march\\u00e9s publics offrent une visibilit\\u00e9 et une r\\u00e9currence que le priv\\u00e9 n\'apporte pas\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Le taux de r\\u00e9ussite augmente significativement avec un dossier professionnel et structur\\u00e9\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Ce qui est inclus dans l\'abonnement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Veille quotidienne sur toutes les plateformes\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pr\\u00e9s\\u00e9lection et recommandation des march\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Alerte par email pour chaque opportunit\\u00e9 identifi\\u00e9e\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conseil sur la strat\\u00e9gie de r\\u00e9ponse\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pour qui ?\"}]},{\"type\":\"callout\",\"attrs\":{\"type\":\"success\"},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"TPE, PME, artisans et prestataires de services qui souhaitent acc\\u00e9der aux march\\u00e9s publics sans mobiliser de ressources internes. Particuli\\u00e8rement adapt\\u00e9 aux entreprises du BTP, services aux collectivit\\u00e9s, informatique, formation et conseil.\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"375 \\u20ac\\/mois + 150 \\u20ac\\/dossier \\u2014 Sans engagement\"}]}]}]}','<h2>Ne passez plus à côté des marchés publics</h2><p>Les appels d&#039;offres représentent un levier de croissance considérable pour les TPE/PME, mais la complexité administrative décourage la plupart des dirigeants. Veille quotidienne, analyse des cahiers des charges, rédaction des mémoires techniques, constitution des dossiers administratifs : c&#039;est un métier à part entière.</p><p>Nous prenons en charge l&#039;intégralité du processus pour <strong>375 €/mois &#43; 150 € par dossier déposé</strong>.</p><h3>Notre processus en 4 étapes</h3><h4>1. Veille automatisée</h4><p>Surveillance quotidienne des plateformes de marchés publics et privés (BOAMP, JOUE, plateformes de dématérialisation). Les opportunités correspondant à votre activité sont identifiées automatiquement.</p><h4>2. Présélection intelligente</h4><p>Chaque appel d&#039;offres détecté est analysé : critères d&#039;éligibilité, montant estimé, chances de succès, adéquation avec vos références. Vous ne recevez que les marchés pertinents, avec une recommandation argumentée.</p><h4>3. Rédaction complète</h4><p>Mémoire technique, note méthodologique, références, moyens humains et matériels : nous rédigeons l&#039;intégralité du dossier de réponse. Vous relisez, validez, et nous déposons.</p><h4>4. Dépôt et suivi</h4><p>Constitution du dossier administratif (DC1, DC2, attestations), dépôt sur la plateforme dans les délais, suivi de la notification. Tout est géré de A à Z.</p><h3>Pourquoi externaliser vos AO ?</h3><ul><li><p>Un dossier de réponse prend en moyenne 2 à 5 jours de travail</p></li><li><p>80 % des TPE/PME éligibles ne répondent jamais par manque de temps</p></li><li><p>Les marchés publics offrent une visibilité et une récurrence que le privé n&#039;apporte pas</p></li><li><p>Le taux de réussite augmente significativement avec un dossier professionnel et structuré</p></li></ul><h3>Ce qui est inclus dans l&#039;abonnement</h3><ul><li><p>Veille quotidienne sur toutes les plateformes</p></li><li><p>Présélection et recommandation des marchés</p></li><li><p>Alerte par email pour chaque opportunité identifiée</p></li><li><p>Conseil sur la stratégie de réponse</p></li></ul><h3>Pour qui ?</h3><div class=\"block-callout block-callout--success\"><span class=\"block-callout__icon\">✔</span><div class=\"block-callout__content\"><p>TPE, PME, artisans et prestataires de services qui souhaitent accéder aux marchés publics sans mobiliser de ressources internes. Particulièrement adapté aux entreprises du BTP, services aux collectivités, informatique, formation et conseil.<br /><strong>375 €/mois &#43; 150 €/dossier — Sans engagement</strong></p></div></div>','pencil-square',NULL,3,1,11,NULL),
(4,'BlogWeb','blogweb','CMS clé en main, alternative française à WordPress. Site vitrine, blog ou e-commerce, sécurisé, hébergé en France, sans plugins à maintenir. Site en ligne en une demi-journée.','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Votre site professionnel, livr\\u00e9 en une demi-journ\\u00e9e\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Vous \\u00eates artisan, commer\\u00e7ant, ind\\u00e9pendant ou dirigeant de TPE ? Vous avez besoin d\'un site qui fonctionne, pas d\'un projet web qui s\'\\u00e9ternise. BlogWeb est notre CMS fran\\u00e7ais, con\\u00e7u pour livrer un site professionnel pr\\u00eat pour Google en une demi-journ\\u00e9e.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pas de WordPress, pas de plugins \\u00e0 empiler, pas de mises \\u00e0 jour instables. \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Une plateforme ferm\\u00e9e, s\\u00e9curis\\u00e9e, maintenue par nos soins.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Ce que vous obtenez\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Un site complet, pas une coquille vide\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Pages vitrine, blog, catalogue produits ou e-commerce : tout est int\\u00e9gr\\u00e9 nativement. \\u00c9diteur visuel intuitif, gestion des menus en glisser-d\\u00e9poser, formulaire de contact, galeries photos. Vous g\\u00e9rez votre contenu comme dans un traitement de texte.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"SEO int\\u00e9gr\\u00e9 d\\u00e8s le d\\u00e9part\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Meta tags, sitemap XML, donn\\u00e9es structur\\u00e9es, URLs propres : tout est en place d\\u00e8s la livraison. Votre site est indexable par Google imm\\u00e9diatement, sans plugin suppl\\u00e9mentaire ni configuration technique.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9berg\\u00e9 en France, s\\u00e9curis\\u00e9, RGPD\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Serveurs OVH en France, sauvegardes automatiques quotidiennes, certificat SSL inclus. Aucune faille li\\u00e9e \\u00e0 des extensions tierces puisqu\'il n\'y en a pas. Conformit\\u00e9 RGPD native.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"6 th\\u00e8mes professionnels inclus\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Designs pr\\u00e9-configur\\u00e9s adapt\\u00e9s \\u00e0 chaque m\\u00e9tier. Personnalisation des couleurs, polices et logo sans toucher au code. Votre identit\\u00e9 visuelle est respect\\u00e9e d\\u00e8s le d\\u00e9marrage.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les offres\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"https:\\/\\/blogweb.comwebsolutions.fr\\/page\\/offres\",\"target\":\"_blank\",\"rel\":\"noopener noreferrer\",\"class\":null}}],\"text\":\"\\u2192 D\\u00e9couvrir les offres\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Ce qui est inclus dans chaque abonnement\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9bergement France avec sauvegardes quotidiennes\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Maintenance et mises \\u00e0 jour de s\\u00e9curit\\u00e9\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Support par un interlocuteur unique\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Formation initiale de 30 minutes + guide \\u00e9crit\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Certificat SSL et conformit\\u00e9 RGPD\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pourquoi pas WordPress ?\"}]},{\"type\":\"callout\",\"attrs\":{\"type\":\"info\"},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"WordPress repr\\u00e9sente 40 % des sites web, mais aussi la majorit\\u00e9 des sites pirat\\u00e9s. Les plugins tiers cr\\u00e9ent des failles, les mises \\u00e0 jour cassent des fonctionnalit\\u00e9s, et la maintenance devient un poste de d\\u00e9pense permanent. BlogWeb \\u00e9limine ces probl\\u00e8mes en proposant une plateforme ferm\\u00e9e, o\\u00f9 chaque fonctionnalit\\u00e9 est d\\u00e9velopp\\u00e9e et maintenue par notre \\u00e9quipe.\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"https:\\/\\/blogweb.comwebsolutions.fr\",\"target\":\"_blank\",\"rel\":\"noopener noreferrer\",\"class\":null}},{\"type\":\"bold\"}],\"text\":\"\\u2192 D\\u00e9couvrir Blog Web\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/contact\",\"target\":\"_blank\",\"rel\":\"noopener noreferrer\",\"class\":null}},{\"type\":\"bold\"}],\"text\":\"\\u2192 Nous Contacter\"}]}]}]}','<h2>Votre site professionnel, livré en une demi-journée</h2><p>Vous êtes artisan, commerçant, indépendant ou dirigeant de TPE ? Vous avez besoin d&#039;un site qui fonctionne, pas d&#039;un projet web qui s&#039;éternise. BlogWeb est notre CMS français, conçu pour livrer un site professionnel prêt pour Google en une demi-journée.</p><p>Pas de WordPress, pas de plugins à empiler, pas de mises à jour instables. <strong>Une plateforme fermée, sécurisée, maintenue par nos soins.</strong></p><h3>Ce que vous obtenez</h3><h4>Un site complet, pas une coquille vide</h4><p>Pages vitrine, blog, catalogue produits ou e-commerce : tout est intégré nativement. Éditeur visuel intuitif, gestion des menus en glisser-déposer, formulaire de contact, galeries photos. Vous gérez votre contenu comme dans un traitement de texte.</p><h4>SEO intégré dès le départ</h4><p>Meta tags, sitemap XML, données structurées, URLs propres : tout est en place dès la livraison. Votre site est indexable par Google immédiatement, sans plugin supplémentaire ni configuration technique.</p><h4>Hébergé en France, sécurisé, RGPD</h4><p>Serveurs OVH en France, sauvegardes automatiques quotidiennes, certificat SSL inclus. Aucune faille liée à des extensions tierces puisqu&#039;il n&#039;y en a pas. Conformité RGPD native.</p><h4>6 thèmes professionnels inclus</h4><p>Designs pré-configurés adaptés à chaque métier. Personnalisation des couleurs, polices et logo sans toucher au code. Votre identité visuelle est respectée dès le démarrage.</p><h3>Les offres</h3><h4><a href=\"https://blogweb.comwebsolutions.fr/page/offres\" target=\"_blank\" rel=\"noopener noreferrer\">→ Découvrir les offres</a></h4><h3>Ce qui est inclus dans chaque abonnement</h3><ul><li><p>Hébergement France avec sauvegardes quotidiennes</p></li><li><p>Maintenance et mises à jour de sécurité</p></li><li><p>Support par un interlocuteur unique</p></li><li><p>Formation initiale de 30 minutes &#43; guide écrit</p></li><li><p>Certificat SSL et conformité RGPD</p></li></ul><h3>Pourquoi pas WordPress ?</h3><div class=\"block-callout block-callout--info\"><span class=\"block-callout__icon\">ⓘ</span><div class=\"block-callout__content\"><p>WordPress représente 40 % des sites web, mais aussi la majorité des sites piratés. Les plugins tiers créent des failles, les mises à jour cassent des fonctionnalités, et la maintenance devient un poste de dépense permanent. BlogWeb élimine ces problèmes en proposant une plateforme fermée, où chaque fonctionnalité est développée et maintenue par notre équipe.<br /><strong><a href=\"https://blogweb.comwebsolutions.fr\" target=\"_blank\" rel=\"noopener noreferrer\">→ Découvrir Blog Web</a></strong><br /><strong><a href=\"/contact\" target=\"_blank\" rel=\"noopener noreferrer\">→ Nous Contacter</a></strong></p></div></div>','globe',NULL,4,1,8,NULL),
(5,'LintellO','lintello','L\'IA française et confidentielle. Hébergée en France, chiffrée, jamais utilisée pour entraîner les modèles. Pour les pros, étudiants et particuliers qui refusent de confier leurs données à ChatGPT.','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"L\'IA fran\\u00e7aise qui respecte vos donn\\u00e9es\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"L\'intelligence artificielle est devenue un outil du quotidien, mais la plupart des solutions am\\u00e9ricaines exploitent vos donn\\u00e9es pour entra\\u00eener leurs mod\\u00e8les. LintellO est notre alternative fran\\u00e7aise : \"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"h\\u00e9berg\\u00e9e en France, chiffr\\u00e9e AES-256, conforme RGPD\"},{\"type\":\"text\",\"text\":\", vos conversations ne sont jamais utilis\\u00e9es pour l\'entra\\u00eenement.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pour les professionnels\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Consultants, dirigeants, professions r\\u00e9glement\\u00e9es, agences : LintellO vous donne acc\\u00e8s \\u00e0 4 mod\\u00e8les d\'IA fran\\u00e7ais et 17 modes intelligents adapt\\u00e9s \\u00e0 vos usages m\\u00e9tier.\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"R\\u00e9daction : emails, rapports, synth\\u00e8ses, propositions commerciales\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Analyse : documents PDF, tableaux, contrats, appels d\'offres\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Code : assistance d\\u00e9veloppement avec Codestral\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cr\\u00e9atif : brainstorming, contenus marketing, scripts\"}]}]}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Recherche web int\\u00e9gr\\u00e9e avec sources v\\u00e9rifi\\u00e9es : LintellO ne fabrique pas d\'informations, il les cite.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pour les \\u00e9tudiants\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"4 modes \\u00e9ducation d\\u00e9di\\u00e9s : r\\u00e9visions adaptatives par niveau et fili\\u00e8re, aide \\u00e0 la dissertation, compr\\u00e9hension de concepts complexes, recherche documentaire. Un assistant qui aide \\u00e0 apprendre, pas qui fait le travail \\u00e0 votre place.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"S\\u00e9curit\\u00e9 et confidentialit\\u00e9\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9bergement OVH Strasbourg, France\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Chiffrement AES-256 de bout en bout\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Donn\\u00e9es jamais utilis\\u00e9es pour entra\\u00eener les mod\\u00e8les\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Z\\u00e9ro revente de donn\\u00e9es \\u00e0 des tiers\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Suppression de vos donn\\u00e9es sous 24h sur demande\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Conformit\\u00e9 RGPD compl\\u00e8te\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Les offres\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"https:\\/\\/www.lintello.fr\\/tarifs\\/\",\"target\":\"_blank\",\"rel\":\"noopener noreferrer\",\"class\":null}}],\"text\":\"\\u2192 D\\u00e9couvrir les offres\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pour qui ?\"}]},{\"type\":\"callout\",\"attrs\":{\"type\":\"success\"},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Toute personne ou entreprise qui utilise l\'IA au quotidien et qui ne veut pas que ses donn\\u00e9es servent \\u00e0 entra\\u00eener des mod\\u00e8les am\\u00e9ricains. Particuli\\u00e8rement adapt\\u00e9 aux professions soumises au secret professionnel (avocats, comptables, consultants) et aux entreprises manipulant des donn\\u00e9es sensibles.\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"https:\\/\\/www.lintello.fr\",\"target\":\"_blank\",\"rel\":\"noopener noreferrer\",\"class\":null}},{\"type\":\"bold\"}],\"text\":\"\\u2192 D\\u00e9couvrir LintellO\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"link\",\"attrs\":{\"href\":\"\\/contact\",\"target\":\"_blank\",\"rel\":\"noopener noreferrer\",\"class\":null}},{\"type\":\"bold\"}],\"text\":\"\\u2192 Nous Contacter\"}]}]}]}','<h2>L&#039;IA française qui respecte vos données</h2><p>L&#039;intelligence artificielle est devenue un outil du quotidien, mais la plupart des solutions américaines exploitent vos données pour entraîner leurs modèles. LintellO est notre alternative française : <strong>hébergée en France, chiffrée AES-256, conforme RGPD</strong>, vos conversations ne sont jamais utilisées pour l&#039;entraînement.</p><h3>Pour les professionnels</h3><p>Consultants, dirigeants, professions réglementées, agences : LintellO vous donne accès à 4 modèles d&#039;IA français et 17 modes intelligents adaptés à vos usages métier.</p><ul><li><p>Rédaction : emails, rapports, synthèses, propositions commerciales</p></li><li><p>Analyse : documents PDF, tableaux, contrats, appels d&#039;offres</p></li><li><p>Code : assistance développement avec Codestral</p></li><li><p>Créatif : brainstorming, contenus marketing, scripts</p></li></ul><p>Recherche web intégrée avec sources vérifiées : LintellO ne fabrique pas d&#039;informations, il les cite.</p><h3>Pour les étudiants</h3><p>4 modes éducation dédiés : révisions adaptatives par niveau et filière, aide à la dissertation, compréhension de concepts complexes, recherche documentaire. Un assistant qui aide à apprendre, pas qui fait le travail à votre place.</p><h3>Sécurité et confidentialité</h3><ul><li><p>Hébergement OVH Strasbourg, France</p></li><li><p>Chiffrement AES-256 de bout en bout</p></li><li><p>Données jamais utilisées pour entraîner les modèles</p></li><li><p>Zéro revente de données à des tiers</p></li><li><p>Suppression de vos données sous 24h sur demande</p></li><li><p>Conformité RGPD complète</p></li></ul><h3>Les offres</h3><h4><a href=\"https://www.lintello.fr/tarifs/\" target=\"_blank\" rel=\"noopener noreferrer\">→ Découvrir les offres</a></h4><h3>Pour qui ?</h3><div class=\"block-callout block-callout--success\"><span class=\"block-callout__icon\">✔</span><div class=\"block-callout__content\"><p>Toute personne ou entreprise qui utilise l&#039;IA au quotidien et qui ne veut pas que ses données servent à entraîner des modèles américains. Particulièrement adapté aux professions soumises au secret professionnel (avocats, comptables, consultants) et aux entreprises manipulant des données sensibles.<br /><strong><a href=\"https://www.lintello.fr\" target=\"_blank\" rel=\"noopener noreferrer\">→ Découvrir LintellO</a></strong><br /><strong><a href=\"/contact\" target=\"_blank\" rel=\"noopener noreferrer\">→ Nous Contacter</a></strong></p></div></div>','cup-hot',NULL,5,1,12,NULL),
(6,'Applications sur mesure','applications-sur-mesure','Développement custom pour besoins spécifiques : CRM métier, plateformes de gestion, outils internes. Référence : Kayre (application pour pro des services).','{\"type\":\"doc\",\"content\":[{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":2},\"content\":[{\"type\":\"text\",\"text\":\"Des outils num\\u00e9riques taill\\u00e9s pour votre m\\u00e9tier\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Les logiciels standards ne couvrent jamais 100 % de vos besoins. Entre les tableurs Excel qui s\'empilent, les outils SaaS qui ne communiquent pas entre eux et les processus manuels qui font perdre du temps, il y a une alternative : le d\\u00e9veloppement sur mesure.\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Nous concevons des applications m\\u00e9tier qui s\'adaptent \\u00e0 votre fonctionnement, pas l\'inverse.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Ce que nous d\\u00e9veloppons\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"CRM et gestion commerciale\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Outils de suivi clients, pipeline commercial, relances automatis\\u00e9es, tableaux de bord. Con\\u00e7us pour votre cycle de vente sp\\u00e9cifique, pas pour un cas g\\u00e9n\\u00e9rique.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Plateformes de gestion interne\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Gestion de projets, suivi de production, planification des ressources, workflows m\\u00e9tier. Chaque fonctionnalit\\u00e9 r\\u00e9pond \\u00e0 un besoin identifi\\u00e9 dans votre organisation.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Automatisation et IA\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Automatisation des t\\u00e2ches r\\u00e9p\\u00e9titives, g\\u00e9n\\u00e9ration de documents, reporting automatique, int\\u00e9gration d\'IA pour l\'analyse de donn\\u00e9es ou la r\\u00e9daction. Le temps gagn\\u00e9 se mesure en heures par semaine.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Plateformes web complexes\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Marketplaces, intranets, portails clients, syst\\u00e8mes de r\\u00e9servation. Des applications web compl\\u00e8tes avec gestion des droits, API et int\\u00e9grations tierces.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Notre stack technique\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Symfony (PHP) pour le backend et les APIs\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Architecture solide, maintenable et \\u00e9volutive\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"H\\u00e9bergement France (OVH) avec sauvegardes\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Int\\u00e9grations : API tierces, CRM, outils comptables, IA\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Nos r\\u00e9f\\u00e9rences\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"Kayre\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Plateforme de gestion compl\\u00e8te d\\u00e9velopp\\u00e9e sur mesure : Suivit de formation, e-learning, abonnement, rapports de donn\\u00e9es. Un outil unique qui remplace syst\\u00e8mes & logiciels.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"BlogWeb\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Notre propre CMS, d\\u00e9velopp\\u00e9 en interne sous Symfony. Preuve concr\\u00e8te de notre capacit\\u00e9 \\u00e0 concevoir, d\\u00e9velopper et maintenir un produit logiciel complet.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":4},\"content\":[{\"type\":\"text\",\"text\":\"LintellO\"}]},{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Plateforme d\'intelligence artificielle avec gestion d\'abonnements, API multi-mod\\u00e8les, chiffrement de bout en bout. Application complexe en production avec des utilisateurs r\\u00e9els.\"}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Comment \\u00e7a se passe\"}]},{\"type\":\"bulletList\",\"content\":[{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Cadrage : on comprend votre m\\u00e9tier, vos process, vos irritants\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Maquettage : prototypes visuels pour valider avant de coder\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"D\\u00e9veloppement it\\u00e9ratif : livraisons r\\u00e9guli\\u00e8res, retours int\\u00e9gr\\u00e9s\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Mise en production : d\\u00e9ploiement, formation, documentation\"}]}]},{\"type\":\"listItem\",\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"Maintenance : support continu, \\u00e9volutions au fil de vos besoins\"}]}]}]},{\"type\":\"heading\",\"attrs\":{\"textAlign\":null,\"level\":3},\"content\":[{\"type\":\"text\",\"text\":\"Pour qui ?\"}]},{\"type\":\"callout\",\"attrs\":{\"type\":\"info\"},\"content\":[{\"type\":\"paragraph\",\"attrs\":{\"textAlign\":null},\"content\":[{\"type\":\"text\",\"text\":\"TPE et PME dont les outils standards ne suffisent plus. Dirigeants qui perdent du temps avec des process manuels ou des logiciels inadapt\\u00e9s. Entreprises qui veulent un avantage comp\\u00e9titif gr\\u00e2ce \\u00e0 des outils taill\\u00e9s pour leur m\\u00e9tier.\"},{\"type\":\"hardBreak\"},{\"type\":\"text\",\"marks\":[{\"type\":\"bold\"}],\"text\":\"Devis sur mesure \\u2014 Symfony \\u2014 H\\u00e9berg\\u00e9 en France\"}]}]}]}','<h2>Des outils numériques taillés pour votre métier</h2><p>Les logiciels standards ne couvrent jamais 100 % de vos besoins. Entre les tableurs Excel qui s&#039;empilent, les outils SaaS qui ne communiquent pas entre eux et les processus manuels qui font perdre du temps, il y a une alternative : le développement sur mesure.</p><p>Nous concevons des applications métier qui s&#039;adaptent à votre fonctionnement, pas l&#039;inverse.</p><h3>Ce que nous développons</h3><h4>CRM et gestion commerciale</h4><p>Outils de suivi clients, pipeline commercial, relances automatisées, tableaux de bord. Conçus pour votre cycle de vente spécifique, pas pour un cas générique.</p><h4>Plateformes de gestion interne</h4><p>Gestion de projets, suivi de production, planification des ressources, workflows métier. Chaque fonctionnalité répond à un besoin identifié dans votre organisation.</p><h4>Automatisation et IA</h4><p>Automatisation des tâches répétitives, génération de documents, reporting automatique, intégration d&#039;IA pour l&#039;analyse de données ou la rédaction. Le temps gagné se mesure en heures par semaine.</p><h4>Plateformes web complexes</h4><p>Marketplaces, intranets, portails clients, systèmes de réservation. Des applications web complètes avec gestion des droits, API et intégrations tierces.</p><h3>Notre stack technique</h3><ul><li><p>Symfony (PHP) pour le backend et les APIs</p></li><li><p>Architecture solide, maintenable et évolutive</p></li><li><p>Hébergement France (OVH) avec sauvegardes</p></li><li><p>Intégrations : API tierces, CRM, outils comptables, IA</p></li></ul><h3>Nos références</h3><h4>Kayre</h4><p>Plateforme de gestion complète développée sur mesure : Suivit de formation, e-learning, abonnement, rapports de données. Un outil unique qui remplace systèmes &amp; logiciels.</p><h4>BlogWeb</h4><p>Notre propre CMS, développé en interne sous Symfony. Preuve concrète de notre capacité à concevoir, développer et maintenir un produit logiciel complet.</p><h4>LintellO</h4><p>Plateforme d&#039;intelligence artificielle avec gestion d&#039;abonnements, API multi-modèles, chiffrement de bout en bout. Application complexe en production avec des utilisateurs réels.</p><h3>Comment ça se passe</h3><ul><li><p>Cadrage : on comprend votre métier, vos process, vos irritants</p></li><li><p>Maquettage : prototypes visuels pour valider avant de coder</p></li><li><p>Développement itératif : livraisons régulières, retours intégrés</p></li><li><p>Mise en production : déploiement, formation, documentation</p></li><li><p>Maintenance : support continu, évolutions au fil de vos besoins</p></li></ul><h3>Pour qui ?</h3><div class=\"block-callout block-callout--info\"><span class=\"block-callout__icon\">ⓘ</span><div class=\"block-callout__content\"><p>TPE et PME dont les outils standards ne suffisent plus. Dirigeants qui perdent du temps avec des process manuels ou des logiciels inadaptés. Entreprises qui veulent un avantage compétitif grâce à des outils taillés pour leur métier.<br /><strong>Devis sur mesure — Symfony — Hébergé en France</strong></p></div></div>','gear',NULL,6,1,7,NULL);
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
(1,'Com Web Solutions','Le commerce qui vend, le web qui convertit','david@comwebsolutions.fr','Montsaunès','31260','3 place des Templiers',NULL,NULL,'0622283754','Com Web Solutions — Le commerce qui vend, le web qui convertit','Agence indépendante : prospection B2B, sites web sans WordPress, applications sur mesure. 15 ans à vendre, 10 ans à coder. RDV gratuit en ligne.',NULL,NULL,'#0A6BFF','#F5A623','#2D2D2D','\'Poppins\', sans-serif','\'Inter\', sans-serif','vitrine','ttc','[\"vitrine\",\"blog\",\"services\",\"faq\",\"portfolio\"]',NULL,NULL,NULL,4,NULL,5,NULL,NULL,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_gallery_item`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `site_gallery_item` WRITE;
/*!40000 ALTER TABLE `site_gallery_item` DISABLE KEYS */;
INSERT INTO `site_gallery_item` VALUES
(1,'testimonial',1,'Mickaël Lamy','L\'informatique était un milieu étranger où il est plus facile de se faire avoir qu\'être écouté. David a su refonder un climat de confiance. Voilà quelqu\'un qui se met à votre portée, qui comprend vite et travaille bien. Je suis très satisfait de son travail.',1,1),
(2,'testimonial',2,'Yannick Dougnac — Kayre','David est une personne bien organisée et efficace. Il a mis en place deux logiciels dans notre entreprise (Notion et Vertuoza). Rapide dans l\'exécution, tout en maintenant une bonne qualité. Sa large connaissance dans son domaine lui permet de s\'adapter facilement aux nouvelles demandes.',1,2),
(3,'testimonial',3,'Camille Dassieu — Courtage Assurances Pyrénées','J\'ai contacté David pour voir si je pouvais m\'améliorer en organisation et en gain de temps : pari réussi. Après un bilan de mes besoins, David est à l\'écoute et s\'adapte aux particularités du métier. Grâce à ses conseils, je comprends l\'importance de son service. Je le recommande +++.',1,3);
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
  `tag_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_389B783989D9B62` (`slug`),
  KEY `IDX_389B783C865A29C` (`tag_group_id`),
  CONSTRAINT `FK_389B783C865A29C` FOREIGN KEY (`tag_group_id`) REFERENCES `tag_group` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES
(1,'prospection B2B','prospection-b2b',NULL),
(2,'direction commerciale externalisée','direction-commerciale-externalisee',NULL),
(3,'appels d\'offres','appels-d-offres',NULL),
(4,'BlogWeb','blogweb',NULL),
(5,'WordPress','wordpress',NULL),
(6,'Symfony','symfony',NULL),
(7,'RGPD','rgpd',NULL),
(8,'souveraineté numérique','souverainete-numerique',NULL),
(9,'LintellO','lintello',NULL),
(10,'application métier','application-metier',NULL),
(11,'Kayre','kayre',NULL),
(12,'Comminges','comminges',NULL),
(13,'Occitanie','occitanie',NULL),
(14,'TPE','tpe',NULL),
(15,'PME','pme',NULL),
(16,'freelance','freelance',NULL);
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
(1,'david@comwebsolutions.fr','[\"ROLE_SUPER_ADMIN\"]','$2y$13$4/W0eUNaM0tNgmZwlk4aNuaYMi8dZufiEZoz4aqFFkD3Po/Prtv22','','',0,NULL,NULL,NULL,NULL,0,NULL);
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

-- Dump completed on 2026-05-13  5:37:30
