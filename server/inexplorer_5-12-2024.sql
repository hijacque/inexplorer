-- MySQL dump 10.13  Distrib 8.3.0, for macos14.2 (arm64)
--
-- Host: localhost    Database: inexplorer
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-04-20 06:14:27.956112'),(2,'auth','0001_initial','2024-04-20 06:14:28.052893'),(3,'admin','0001_initial','2024-04-20 06:14:28.076902'),(4,'admin','0002_logentry_remove_auto_add','2024-04-20 06:14:28.079857'),(5,'admin','0003_logentry_add_action_flag_choices','2024-04-20 06:14:28.083319'),(6,'contenttypes','0002_remove_content_type_name','2024-04-20 06:14:28.100239'),(7,'auth','0002_alter_permission_name_max_length','2024-04-20 06:14:28.111995'),(8,'auth','0003_alter_user_email_max_length','2024-04-20 06:14:28.122732'),(9,'auth','0004_alter_user_username_opts','2024-04-20 06:14:28.126935'),(10,'auth','0005_alter_user_last_login_null','2024-04-20 06:14:28.140987'),(11,'auth','0006_require_contenttypes_0002','2024-04-20 06:14:28.141642'),(12,'auth','0007_alter_validators_add_error_messages','2024-04-20 06:14:28.144285'),(13,'auth','0008_alter_user_username_max_length','2024-04-20 06:14:28.157139'),(14,'auth','0009_alter_user_last_name_max_length','2024-04-20 06:14:28.170275'),(15,'auth','0010_alter_group_name_max_length','2024-04-20 06:14:28.176739'),(16,'auth','0011_update_proxy_permissions','2024-04-20 06:14:28.179716'),(17,'auth','0012_alter_user_first_name_max_length','2024-04-20 06:14:28.192538'),(18,'sessions','0001_initial','2024-04-20 06:14:28.198197');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `element`
--

DROP TABLE IF EXISTS `element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `element` (
  `id` varchar(12) NOT NULL,
  `map_id` int NOT NULL,
  `type` smallint NOT NULL,
  `tags` longtext,
  PRIMARY KEY (`id`),
  KEY `map_id` (`map_id`),
  CONSTRAINT `element_ibfk_1` FOREIGN KEY (`map_id`) REFERENCES `map` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `element`
--

LOCK TABLES `element` WRITE;
/*!40000 ALTER TABLE `element` DISABLE KEYS */;
INSERT INTO `element` VALUES ('N1',1,1,NULL),('N10',2,1,NULL),('N100',3,1,NULL),('N101',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W30\"}'),('N102',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W30\"}'),('N103',3,1,NULL),('N104',3,1,NULL),('N105',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W31\"}'),('N106',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W31\"}'),('N107',3,1,NULL),('N108',3,1,NULL),('N109',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W32\"}'),('N11',2,1,NULL),('N110',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W32\"}'),('N111',3,1,NULL),('N112',3,1,NULL),('N113',3,1,NULL),('N114',3,1,NULL),('N115',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W33\"}'),('N116',3,1,NULL),('N117',3,1,NULL),('N118',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W34\"}'),('N119',3,1,NULL),('N12',2,1,NULL),('N120',3,1,NULL),('N121',3,1,NULL),('N122',3,1,NULL),('N123',3,1,'{\"path\":\"stairs\",\"stairs:link\":\"N34,N180\"}'),('N124',3,1,'{\"path\":\"stairs\",\"stairs:link\":\"N37,N189\"}'),('N125',4,1,NULL),('N126',4,1,NULL),('N127',4,1,NULL),('N128',4,1,NULL),('N129',4,1,NULL),('N13',2,1,NULL),('N130',4,1,NULL),('N131',4,1,NULL),('N132',4,1,NULL),('N133',4,1,NULL),('N134',4,1,NULL),('N135',4,1,NULL),('N136',4,1,NULL),('N137',4,1,NULL),('N138',4,1,NULL),('N139',4,1,NULL),('N14',2,1,NULL),('N140',4,1,NULL),('N141',4,1,NULL),('N142',4,1,NULL),('N143',4,1,NULL),('N144',4,1,NULL),('N145',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W67\"}'),('N146',4,1,NULL),('N147',4,1,NULL),('N148',4,1,NULL),('N149',4,1,NULL),('N15',2,1,NULL),('N150',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W55\"}'),('N151',4,1,NULL),('N152',4,1,NULL),('N153',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W55\"}'),('N154',4,1,NULL),('N155',4,1,NULL),('N156',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W56\"}'),('N157',4,1,NULL),('N158',4,1,NULL),('N159',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W57\"}'),('N16',2,1,NULL),('N160',4,1,NULL),('N161',4,1,NULL),('N162',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W58\"}'),('N163',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W58\"}'),('N164',4,1,NULL),('N165',4,1,NULL),('N166',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W59\"}'),('N167',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W59\"}'),('N168',4,1,NULL),('N169',4,1,NULL),('N17',2,1,NULL),('N170',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W60\"}'),('N171',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W60\"}'),('N172',4,1,NULL),('N173',4,1,NULL),('N174',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W61\"}'),('N175',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W61\"}'),('N176',4,1,NULL),('N177',4,1,NULL),('N178',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W62\"}'),('N179',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W62\"}'),('N18',2,1,NULL),('N180',4,1,'{\"path\":\"stairs\",\"stairs:link\":\"N123\"}'),('N181',4,1,NULL),('N182',4,1,NULL),('N183',4,1,NULL),('N184',4,1,NULL),('N185',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W64\"}'),('N186',4,1,NULL),('N187',4,1,NULL),('N188',4,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W65\"}'),('N189',4,1,'{\"path\":\"stairs\",\"stairs:link\":\"N124,N199\"}'),('N19',2,1,NULL),('N190',4,1,NULL),('N191',4,1,NULL),('N192',4,1,NULL),('N193',4,1,NULL),('N194',5,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W84\"}'),('N195',5,1,NULL),('N196',5,1,NULL),('N197',5,1,NULL),('N198',5,1,NULL),('N199',5,1,'{\"path\":\"stairs\",\"stairs:link\":\"N189,N218\"}'),('N2',1,1,NULL),('N20',2,1,NULL),('N200',5,1,NULL),('N201',5,1,NULL),('N202',5,1,NULL),('N203',5,1,NULL),('N204',5,1,NULL),('N205',5,1,NULL),('N206',5,1,NULL),('N207',5,1,NULL),('N208',5,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W85\"}'),('N209',5,1,NULL),('N21',2,1,NULL),('N210',5,1,NULL),('N211',5,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W86\"}'),('N212',5,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W86\"}'),('N213',6,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W91\"}'),('N214',6,1,NULL),('N215',6,1,NULL),('N216',6,1,NULL),('N217',6,1,NULL),('N218',6,1,'{\"path\":\"stairs\",\"stairs:link\":\"N199\"}'),('N219',6,1,NULL),('N22',2,1,NULL),('N220',6,1,NULL),('N221',6,1,NULL),('N222',6,1,NULL),('N223',6,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W91\"}'),('N224',6,1,NULL),('N225',6,1,NULL),('N226',6,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W92\"}'),('N227',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W1\"}'),('N228',1,1,NULL),('N229',1,1,NULL),('N23',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W15\"}'),('N230',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W95\",\"entrance:of_map\":\"7\"}'),('N231',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W95\",\"entrance:of_map\":\"7\",\"entrance:link\":\"N301\"}'),('N232',1,1,NULL),('N233',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W95\",\"entrance:of_map\":\"7\"}'),('N234',1,1,NULL),('N235',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W95\",\"entrance:of_map\":\"7\",\"entrance:link\":\"N266\"}'),('N236',1,1,NULL),('N237',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W95\",\"entrance:of_map\":\"7\"}'),('N238',1,1,NULL),('N239',1,1,NULL),('N24',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W16\"}'),('N240',1,1,NULL),('N241',1,1,NULL),('N242',1,1,NULL),('N243',1,1,NULL),('N244',1,1,NULL),('N245',1,1,NULL),('N246',1,1,NULL),('N247',1,1,NULL),('N248',1,1,NULL),('N249',1,1,NULL),('N25',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W17\"}'),('N250',7,1,'{\"path\":\"entrance\"}'),('N251',7,1,NULL),('N252',7,1,NULL),('N253',7,1,NULL),('N254',7,1,NULL),('N255',7,1,NULL),('N256',7,1,NULL),('N257',7,1,NULL),('N258',7,1,NULL),('N259',7,1,NULL),('N26',2,1,'{\"path\":\"entrance\",\"entrance:link\":\"N7\"}'),('N260',7,1,NULL),('N261',7,1,NULL),('N262',7,1,NULL),('N263',7,1,NULL),('N264',7,1,NULL),('N265',7,1,NULL),('N266',7,1,'{\"path\":\"entrance\",\"entrance:link\":\"N235\"}'),('N267',7,1,NULL),('N268',7,1,NULL),('N269',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W101\"}'),('N27',2,1,NULL),('N270',7,1,NULL),('N271',7,1,NULL),('N272',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W102\"}'),('N273',7,1,NULL),('N274',7,1,NULL),('N275',7,1,NULL),('N276',7,1,NULL),('N277',7,1,NULL),('N278',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W103\"}'),('N279',7,1,NULL),('N28',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W18\"}'),('N280',7,1,NULL),('N281',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W104\"}'),('N282',7,1,NULL),('N283',7,1,NULL),('N284',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W105\"}'),('N285',7,1,NULL),('N286',7,1,NULL),('N287',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W106\"}'),('N288',7,1,NULL),('N289',7,1,NULL),('N29',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W19\"}'),('N290',7,1,NULL),('N291',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W107\"}'),('N292',7,1,NULL),('N293',7,1,NULL),('N294',7,1,NULL),('N295',7,1,NULL),('N296',7,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W108\"}'),('N297',7,1,NULL),('N298',7,1,NULL),('N299',7,1,'{\"path\":\"entrance\",\"entrance:link\":\"N9\"}'),('N3',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W1\",\"entrance:of_map\":2,\"entrance:link\":\"N32\"}'),('N30',2,1,NULL),('N300',7,1,'{\"amenity\":\"atm\",\"name\":\"Landbank ATM\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('N301',7,1,'{\"path\":\"entrance\",\"entrance:link\":\"N231\"}'),('N302',7,1,NULL),('N303',7,1,NULL),('N304',7,1,NULL),('N305',7,1,'{\"path\":\"stairs\",\"stairs:link\":\"N379\"}'),('N306',7,1,'{\"path\":\"stairs\",\"stairs:link\":\"N380\"}'),('N307',7,1,'{\"path\":\"entrance\",\"entrance:link\":\"N233\"}'),('N308',7,1,'{\"path\":\"entrance\",\"entrance:link\":\"N237\"}'),('N309',7,1,'{\"path\":\"entrance\",\"entrance:link\":\"N331\"}'),('N31',2,1,NULL),('N310',7,1,NULL),('N311',7,1,NULL),('N312',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W126\"}'),('N313',8,1,NULL),('N314',8,1,NULL),('N315',8,1,NULL),('N316',8,1,NULL),('N317',8,1,NULL),('N318',8,1,NULL),('N319',8,1,NULL),('N32',2,1,'{\"path\":\"entrance\",\"entrance:link\":\"N3\"}'),('N320',8,1,NULL),('N321',8,1,NULL),('N322',8,1,NULL),('N323',8,1,NULL),('N324',8,1,NULL),('N325',8,1,NULL),('N326',8,1,NULL),('N327',8,1,NULL),('N328',8,1,NULL),('N329',8,1,NULL),('N33',2,1,'{\"path\":\"entrance\",\"entrance:link\":\"N6\"}'),('N330',8,1,NULL),('N331',8,1,'{\"path\":\"entrance\",\"entrance:link\":\"N309\"}'),('N332',8,1,NULL),('N333',8,1,NULL),('N334',8,1,NULL),('N335',8,1,NULL),('N336',8,1,NULL),('N337',8,1,NULL),('N338',8,1,NULL),('N339',8,1,NULL),('N34',2,1,'{\"path\":\"stairs\",\"stairs:link\":\"N123\"}'),('N340',8,1,NULL),('N341',8,1,NULL),('N342',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W127\"}'),('N343',8,1,NULL),('N344',8,1,NULL),('N345',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W128\"}'),('N346',8,1,NULL),('N347',8,1,NULL),('N348',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W129\"}'),('N349',8,1,NULL),('N35',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W23\"}'),('N350',8,1,NULL),('N351',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W130\"}'),('N352',8,1,NULL),('N353',8,1,NULL),('N354',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W131\"}'),('N355',8,1,NULL),('N356',8,1,NULL),('N357',8,1,NULL),('N358',8,1,NULL),('N359',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W132\"}'),('N36',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W23\"}'),('N360',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W132\"}'),('N361',8,1,NULL),('N362',8,1,NULL),('N363',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W133\"}'),('N364',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W133\"}'),('N365',8,1,NULL),('N366',8,1,NULL),('N367',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W134\"}'),('N368',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W134\"}'),('N369',8,1,NULL),('N37',2,1,'{\"path\":\"stairs\",\"stairs:link\":\"N124\"}'),('N370',8,1,NULL),('N371',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W135\"}'),('N372',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W135\"}'),('N373',8,1,NULL),('N374',8,1,NULL),('N375',8,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W136\"}'),('N376',8,1,NULL),('N377',8,1,NULL),('N378',8,1,NULL),('N379',8,1,'{\"path\":\"stairs\",\"stairs:link\":\"N305\"}'),('N38',2,1,NULL),('N380',8,1,'{\"path\":\"stairs\",\"stairs:link\":\"N306\"}'),('N381',1,1,NULL),('N382',1,1,NULL),('N383',1,1,NULL),('N384',1,1,NULL),('N385',1,1,NULL),('N386',1,1,NULL),('N387',1,1,NULL),('N388',1,1,'{\"path\":\"entrance\"}'),('N389',1,1,NULL),('N39',2,1,NULL),('N390',1,1,NULL),('N391',1,1,'{\"path\":\"entrance\"}'),('N392',1,1,NULL),('N393',1,1,NULL),('N394',1,1,NULL),('N395',1,1,NULL),('N396',1,1,'{\"path\":\"entrance\"}'),('N397',1,1,NULL),('N398',1,1,'{\"path\":\"entrance\"}'),('N399',1,1,NULL),('N4',1,1,NULL),('N40',2,1,NULL),('N400',1,1,NULL),('N401',1,1,'{\"path\":\"entrance\"}'),('N402',1,1,NULL),('N403',1,1,NULL),('N404',1,1,NULL),('N405',1,1,NULL),('N406',1,1,NULL),('N407',1,1,NULL),('N408',1,1,NULL),('N409',1,1,NULL),('N41',2,1,NULL),('N410',1,1,'{\"path\":\"entrance\"}'),('N411',1,1,NULL),('N412',1,1,NULL),('N413',1,1,'{\"path\":\"entrance\"}'),('N414',1,1,NULL),('N42',2,1,NULL),('N423',11,1,NULL),('N424',11,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W156\"}'),('N425',11,1,NULL),('N426',11,1,NULL),('N427',11,1,NULL),('N428',11,1,NULL),('N429',11,1,NULL),('N43',2,1,NULL),('N430',11,1,'{\"path\":\"stairs\",\"stairs:link\":\"N431\"}'),('N431',12,1,'{\"path\":\"stairs\",\"stairs:link\":\"N430,N74\"}'),('N432',12,1,NULL),('N433',12,1,NULL),('N434',12,1,NULL),('N435',12,1,NULL),('N436',12,1,NULL),('N437',12,1,NULL),('N438',12,1,NULL),('N439',12,1,'{\"path\":\"stairs\",\"stairs:link\":\"N485\"}'),('N44',2,1,NULL),('N440',12,1,NULL),('N441',12,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W160\"}'),('N442',12,1,NULL),('N443',12,1,NULL),('N444',12,1,NULL),('N445',12,1,NULL),('N446',12,1,NULL),('N447',12,1,NULL),('N448',12,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W161\"}'),('N449',12,1,NULL),('N45',2,1,NULL),('N450',12,1,NULL),('N451',12,1,NULL),('N452',12,1,NULL),('N453',12,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W162\"}'),('N454',12,1,NULL),('N455',12,1,NULL),('N456',12,1,NULL),('N457',12,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W163\"}'),('N458',12,1,NULL),('N459',12,1,NULL),('N46',2,1,NULL),('N460',12,1,NULL),('N461',12,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W164\"}'),('N462',12,1,NULL),('N463',12,1,NULL),('N464',12,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W165\"}'),('N465',12,1,NULL),('N466',12,1,NULL),('N467',12,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W166\"}'),('N468',12,1,NULL),('N469',12,1,NULL),('N47',2,1,NULL),('N470',12,1,NULL),('N471',12,1,NULL),('N472',12,1,NULL),('N473',12,1,'{\"path\":\"stairs\",\"stairs:link\":\"N494\"}'),('N474',13,1,'{\"path\":\"stairs\",\"stairs:link\":\"N431\"}'),('N475',13,1,NULL),('N476',13,1,NULL),('N477',13,1,NULL),('N478',13,1,NULL),('N479',13,1,NULL),('N48',2,1,NULL),('N480',13,1,NULL),('N481',13,1,NULL),('N482',13,1,NULL),('N483',13,1,NULL),('N484',13,1,NULL),('N485',13,1,'{\"path\":\"stairs\",\"stairs:link\":\"N439\"}'),('N486',13,1,NULL),('N487',13,1,NULL),('N488',13,1,NULL),('N489',13,1,NULL),('N49',2,1,NULL),('N490',13,1,NULL),('N491',13,1,NULL),('N492',13,1,NULL),('N493',13,1,NULL),('N494',13,1,'{\"path\":\"stairs\",\"stairs:link\":\"N473\"}'),('N495',13,1,NULL),('N496',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W177\"}'),('N497',13,1,NULL),('N498',13,1,NULL),('N499',13,1,NULL),('N5',1,1,NULL),('N50',2,1,NULL),('N500',13,1,NULL),('N501',13,1,NULL),('N502',13,1,NULL),('N503',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W178\"}'),('N504',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W178\"}'),('N505',13,1,NULL),('N506',13,1,NULL),('N507',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W179\"}'),('N508',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W179\"}'),('N509',13,1,NULL),('N51',2,1,NULL),('N510',13,1,NULL),('N511',13,1,NULL),('N512',13,1,NULL),('N513',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W180\"}'),('N514',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W180\"}'),('N515',13,1,NULL),('N516',13,1,NULL),('N517',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W181\"}'),('N518',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W181\"}'),('N519',13,1,NULL),('N52',2,1,NULL),('N520',13,1,NULL),('N521',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W182\"}'),('N522',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W182\"}'),('N523',13,1,NULL),('N524',13,1,NULL),('N525',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W183\"}'),('N526',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W183\"}'),('N527',13,1,NULL),('N528',13,1,NULL),('N529',13,1,NULL),('N53',2,1,NULL),('N530',13,1,NULL),('N531',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W184\"}'),('N532',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W184\"}'),('N533',13,1,NULL),('N534',13,1,NULL),('N535',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W185\"}'),('N536',13,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W185\"}'),('N54',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W20\"}'),('N55',2,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W20\"}'),('N56',2,1,NULL),('N57',2,1,NULL),('N58',2,1,NULL),('N59',2,1,NULL),('N6',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W1\",\"entrance:of_map\":2,\"entrance:link\":\"N33\"}'),('N60',3,1,NULL),('N61',3,1,NULL),('N62',3,1,NULL),('N63',3,1,NULL),('N64',3,1,NULL),('N65',3,1,NULL),('N66',3,1,NULL),('N67',3,1,NULL),('N68',3,1,NULL),('N69',3,1,NULL),('N7',1,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W1\",\"entrance:of_map\":2,\"entrance:link\":\"N26\"}'),('N70',3,1,NULL),('N71',3,1,NULL),('N72',3,1,NULL),('N73',3,1,NULL),('N74',3,1,NULL),('N75',3,1,NULL),('N76',3,1,NULL),('N77',3,1,NULL),('N78',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W35\"}'),('N79',3,1,NULL),('N8',1,1,NULL),('N80',3,1,NULL),('N81',3,1,NULL),('N82',3,1,NULL),('N83',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W25\"}'),('N84',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W25\"}'),('N85',3,1,NULL),('N86',3,1,NULL),('N87',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W26\"}'),('N88',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W26\"}'),('N89',3,1,NULL),('N9',2,1,'{\"path\":\"entrance\"}'),('N90',3,1,NULL),('N91',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W27\"}'),('N92',3,1,NULL),('N93',3,1,NULL),('N94',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W28\"}'),('N95',3,1,NULL),('N96',3,1,NULL),('N97',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W29\"}'),('N98',3,1,'{\"path\":\"entrance\",\"entrance:of_element\":\"W29\"}'),('N99',3,1,NULL),('W1',1,2,'{\"amenity\":\"building\",\"levels\": 5,\"name\":\"Gusaling Villegas\",\"address\":\"PLM Grounds\"}'),('W10',2,2,'{\"path\":\"walk\"}'),('W100',7,2,'{\"path\":\"walk\"}'),('W101',7,2,'{\"amenity\":\"comfort_room\",\"gender\":\"female\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W102',7,2,'{\"amenity\":\"comfort_room\",\"gender\":\"male\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W103',7,2,'{\"amenity\":\"office\",\"name\":\"Graduate School of Law\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W104',7,2,'{\"amenity\":\"office\",\"name\":\"Accounting Office\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W105',7,2,'{\"amenity\":\"office\",\"name\":\"Office of the Treasurer\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W106',7,2,'{\"amenity\":\"office\",\"name\":\"Offive of the Vice President for Finance and Management\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W107',7,2,'{\"amenity\":\"comfort_room\",\"gender\":\"male\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W108',7,2,'{\"amenity\":\"comfort_room\",\"gender\":\"female\",\"address\":\"1st Floor, Gusaling Emilio Ejercito\"}'),('W109',7,2,'{\"path\":\"walk\"}'),('W11',2,2,'{\"path\":\"walk\"}'),('W110',7,2,'{\"path\":\"walk\"}'),('W111',7,2,'{\"path\":\"walk\"}'),('W112',7,2,'{\"path\":\"walk\"}'),('W113',7,2,'{\"path\":\"walk\"}'),('W114',7,2,'{\"path\":\"walk\"}'),('W115',7,2,'{\"path\":\"walk\"}'),('W116',7,2,'{\"path\":\"walk\"}'),('W117',7,2,'{\"path\":\"walk\"}'),('W118',7,2,'{\"path\":\"walk\"}'),('W119',7,2,'{\"path\":\"walk\"}'),('W12',2,2,'{\"path\":\"walk\"}'),('W120',7,2,'{\"path\":\"walk\"}'),('W121',7,2,'{\"path\":\"walk\"}'),('W122',7,2,'{\"path\":\"walk\"}'),('W123',7,2,'{\"path\":\"walk\"}'),('W124',7,2,'{\"path\":\"walk\"}'),('W125',8,2,'{\"path\":\"walk\"}'),('W126',8,2,'{\"amenity\":\"office\",\"name\":\"Office of the University President\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W127',8,2,'{\"amenity\":\"comfort_room\",\"gender\":\"female\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W128',8,2,'{\"amenity\":\"classroom\",\"name\":\"GEE207\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W129',8,2,'{\"amenity\":\"classroom\",\"name\":\"GEE206\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W13',2,2,'{\"path\":\"walk\"}'),('W130',8,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Biology Lab\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W131',8,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Physics Lab\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W132',8,2,'{\"amenity\":\"hall\",\"name\":\"Audio Visual Room\",\"name:short\":\"AVR\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W133',8,2,'{\"amenity\":\"classroom\",\"name\":\"GEE203\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W134',8,2,'{\"amenity\":\"classroom\",\"name\":\"GEE202\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W135',8,2,'{\"amenity\":\"classroom\",\"name\":\"GEE201\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W136',8,2,'{\"amenity\":\"comfort_room\",\"gender\":\"male\",\"address\":\"2nd Floor, Gusaling Emilio Ejercito\"}'),('W137',8,2,'{\"path\":\"walk\"}'),('W138',8,2,'{\"path\":\"walk\"}'),('W139',8,2,'{\"path\":\"walk\"}'),('W14',2,2,'{\"path\":\"walk\"}'),('W140',8,2,'{\"path\":\"walk\"}'),('W141',8,2,'{\"path\":\"walk\"}'),('W142',8,2,'{\"path\":\"walk\"}'),('W143',8,2,'{\"path\":\"walk\"}'),('W144',8,2,'{\"path\":\"walk\"}'),('W145',8,2,'{\"path\":\"walk\"}'),('W146',8,2,'{\"path\":\"walk\"}'),('W147',8,2,'{\"path\":\"walk\"}'),('W148',8,2,'{\"path\":\"walk\"}'),('W149',8,2,'{\"path\":\"walk\"}'),('W15',2,2,'{\"amenity\":\"clinic\",\"name\":\"University Health Services\",\"name:short\":\"UHS\",\"address\":\"1st Floor, Gusaling Villegas\"}'),('W150',8,2,'{\"path\":\"walk\"}'),('W151',8,2,'{\"path\":\"walk\"}'),('W152',8,2,'{\"path\":\"walk\"}'),('W153',1,2,'{\"amenity\":\"building\",\"name\":\"Gusaling Lacson\",\"name:short\":\"GL\",\"address\":\"PLM Grounds\"}'),('W154',1,2,'{\"path\":\"walk\"}'),('W155',1,2,'{\"path\":\"walk\"}'),('W156',11,2,'{\"amenity\":\"maintenance\",\"name\":\"Maintenance Room\",\"address\":\"1st Floor, Gusaling Lacson\"}'),('W157',11,2,'{\"path\":\"walk\"}'),('W158',11,2,'{\"path\":\"walk\"}'),('W159',12,2,'{\"path\":\"walk\"}'),('W16',2,2,'{\"amenity\":\"office\",\"name\":\"Human Resource Department\",\"address\":\"1st Floor, Gusaling Villegas\"}'),('W160',12,2,'{\"amenity\":\"comfort_room\",\"gender\":\"female\",\"address\":\"2nd Floor, Gusaling Lacson\"}'),('W161',12,2,'{\"amenity\":\"office\",\"name\":\"College of Education Office\",\"name:short\":\"CED Office\",\"address\":\"2nd Floor, Gusaling Lacson\"}'),('W162',12,2,'{\"amenity\":\"lounge\",\"name\":\"Faculty Lounge\",\"address\":\"2nd Floor, Gusaling Lacson\"}'),('W163',12,2,'{\"amenity\":\"office\",\"name\":\"College of Medicine Office\",\"name:short\":\"CM Office\",\"address\":\"2nd Floor, Gusaling Lacson\"}'),('W164',12,2,'{\"amenity\":\"office\",\"name\":\"College of Humanities, Arts and Social Science Office\",\"name:short\":\"CHASS Office\",\"address\":\"2nd Floor, Gusaling Lacson\"}'),('W165',12,2,'{\"amenity\":\"office\",\"name\":\"PLM Business School Office\",\"name:short\":\"PLMBS Office\",\"address\":\"2nd Floor, Gusaling Lacson\"}'),('W166',12,2,'{\"amenity\":\"office\",\"name\":\"College of Science Office\",\"name:short\":\"CS Office\",\"address\":\"2nd Floor, Gusaling Lacson\"}'),('W167',12,2,'{\"path\":\"walk\"}'),('W168',12,2,'{\"path\":\"walk\"}'),('W169',12,2,'{\"path\":\"walk\"}'),('W17',2,2,'{\"amenity\":\"office\",\"name\":\"Procurement Office\",\"address\":\"1st Floor, Gusaling Villegas\"}'),('W170',12,2,'{\"path\":\"walk\"}'),('W171',12,2,'{\"path\":\"walk\"}'),('W172',12,2,'{\"path\":\"walk\"}'),('W173',12,2,'{\"path\":\"walk\"}'),('W174',12,2,'{\"path\":\"walk\"}'),('W175',13,2,'{\"path\":\"walk\"}'),('W176',13,2,'{\"path\":\"walk\"}'),('W177',13,2,'{\"amenity\":\"comfort_room\",\"gender\":\"male\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W178',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL303\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W179',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL301\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W18',2,2,'{\"amenity\":\"comfort_room\",\"gender\":\"male\",\"address\":\"1st Floor, Gusaling Villegas\"}'),('W180',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL302\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W181',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL304\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W182',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL306\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W183',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL308\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W184',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL305\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W185',13,2,'{\"amenity\":\"classroom\",\"name\":\"GL307\",\"address\":\"3rd Floor, Gusaling Lacson\"}'),('W186',13,2,'{\"path\":\"walk\"}'),('W187',13,2,'{\"path\":\"walk\"}'),('W188',13,2,'{\"path\":\"walk\"}'),('W189',13,2,'{\"path\":\"walk\"}'),('W19',2,2,'{\"amenity\":\"comfort_room\",\"gender\":\"female\",\"address\":\"1st Floor, Gusaling Villegas\"}'),('W190',13,2,'{\"path\":\"walk\"}'),('W191',13,2,'{\"path\":\"walk\"}'),('W192',13,2,'{\"path\":\"walk\"}'),('W193',13,2,'{\"path\":\"walk\"}'),('W194',13,2,'{\"path\":\"walk\"}'),('W195',13,2,'{\"path\":\"walk\"}'),('W196',13,2,'{\"path\":\"walk\"}'),('W197',13,2,'{\"path\":\"walk\"}'),('W198',13,2,'{\"path\":\"walk\"}'),('W199',13,2,'{\"path\":\"walk\"}'),('W2',2,2,'{\"path\":\"walk\"}'),('W20',2,2,'{\"amenity\":\"comfort_room\",\"gender\":\"neutral\",\"address\":\"1st Floor, Gusaling Villegas\"}'),('W200',13,2,'{\"path\":\"walk\"}'),('W201',13,2,'{\"path\":\"walk\"}'),('W202',13,2,'{\"path\":\"walk\"}'),('W21',2,2,'{\"path\":\"walk\"}'),('W22',2,2,'{\"path\":\"walk\"}'),('W23',2,2,'{\"amenity\":\"office\",\"name\":\"Information, Communications and Technology Office\", \"name:short\":\"ICTO\",\"address\":\"1st Floor, Gusaling Villegas\"}'),('W24',3,2,'{\"path\":\"walk\"}'),('W25',3,2,'{\"amenity\":\"classroom\",\"name\":\"GV204\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W26',3,2,'{\"amenity\":\"classroom\",\"name\":\"GV205\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W27',3,2,'{\"amenity\":\"comfort_room\",\"gender\":\"female\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W28',3,2,'{\"amenity\":\"office\",\"name\":\"SCOA Office\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W29',3,2,'{\"amenity\":\"classroom\",\"name\":\"GV206\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W3',2,2,'{\"path\":\"walk\"}'),('W30',3,2,'{\"amenity\":\"classroom\",\"name\":\"GV207\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W31',3,2,'{\"amenity\":\"classroom\",\"name\":\"GV208\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W32',3,2,'{\"amenity\":\"classroom\",\"name\":\"GV209\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W33',3,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Computer Lab 2\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W34',3,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Computer Lab 1\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W35',3,2,'{\"amenity\":\"hall\",\"name\":\"Meralco Hall\",\"address\":\"2nd Floor, Gusaling Villegas\"}'),('W36',3,2,'{\"path\":\"walk\"}'),('W37',3,2,'{\"path\":\"walk\"}'),('W38',3,2,'{\"path\":\"walk\"}'),('W39',3,2,'{\"path\":\"walk\"}'),('W4',2,2,'{\"path\":\"walk\"}'),('W40',3,2,'{\"path\":\"walk\"}'),('W41',3,2,'{\"path\":\"walk\"}'),('W42',3,2,'{\"path\":\"walk\"}'),('W43',3,2,'{\"path\":\"walk\"}'),('W44',3,2,'{\"path\":\"walk\"}'),('W45',3,2,'{\"path\":\"walk\"}'),('W46',3,2,'{\"path\":\"walk\"}'),('W47',3,2,'{\"path\":\"walk\"}'),('W48',3,2,'{\"path\":\"walk\"}'),('W49',3,2,'{\"path\":\"walk\"}'),('W5',2,2,'{\"path\":\"walk\"}'),('W50',3,2,'{\"path\":\"walk\"}'),('W51',3,2,'{\"path\":\"walk\"}'),('W52',3,2,'{\"path\":\"walk\"}'),('W53',3,2,'{\"path\":\"walk\"}'),('W54',4,2,'{\"path\":\"walk\"}'),('W55',4,2,'{\"amenity\":\"office\",\"name\":\"College of Engineering Office\",\"name:short\":\"CET Office\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W56',4,2,'{\"amenity\":\"classroom\",\"name\":\"GV304\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W57',4,2,'{\"amenity\":\"comfort_room\",\"gender\":\"male\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W58',4,2,'{\"amenity\":\"classroom\",\"name\":\"GV305\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W59',4,2,'{\"amenity\":\"classroom\",\"name\":\"GV306\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W6',2,2,'{\"path\":\"walk\"}'),('W60',4,2,'{\"amenity\":\"classroom\",\"name\":\"GV307\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W61',4,2,'{\"amenity\":\"classroom\",\"name\":\"GV308\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W62',4,2,'{\"amenity\":\"classroom\",\"name\":\"GV309\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W63',4,2,'{\"path\":\"walk\"}'),('W64',4,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Accenture\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W65',4,2,'{\"amenity\":\"classroom\",\"name\":\"GV310\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W66',4,2,'{\"path\":\"walk\"}'),('W67',4,2,'{\"amenity\":\"hall\",\"name\":\"PLDT-Smart Foundation Hall\",\"address\":\"3rd Floor, Gusaling Villegas\"}'),('W68',4,2,'{\"path\":\"walk\"}'),('W69',4,2,'{\"path\":\"walk\"}'),('W7',2,2,'{\"path\":\"walk\"}'),('W70',4,2,'{\"path\":\"walk\"}'),('W71',4,2,'{\"path\":\"walk\"}'),('W72',4,2,'{\"path\":\"walk\"}'),('W73',4,2,'{\"path\":\"walk\"}'),('W74',4,2,'{\"path\":\"walk\"}'),('W75',4,2,'{\"path\":\"walk\"}'),('W76',4,2,'{\"path\":\"walk\"}'),('W77',4,2,'{\"path\":\"walk\"}'),('W78',4,2,'{\"path\":\"walk\"}'),('W79',4,2,'{\"path\":\"walk\"}'),('W8',2,2,'{\"path\":\"walk\"}'),('W80',4,2,'{\"path\":\"walk\"}'),('W81',4,2,'{\"path\":\"walk\"}'),('W82',4,2,'{\"path\":\"walk\"}'),('W83',5,2,'{\"path\":\"walk\"}'),('W84',5,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Computer Laboratory Office\",\"address\":\"4th Floor, Gusaling Villegas\"}'),('W85',5,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Computer Lab 4\"},\"address\":\"4th Floor, Gusaling Villegas\"}'),('W86',5,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Computer Lab 3\"},\"address\":\"4th Floor, Gusaling Villegas\"}'),('W87',5,2,'{\"path\":\"walk\"}'),('W88',5,2,'{\"path\":\"walk\"}'),('W89',5,2,'{\"path\":\"walk\"}'),('W9',2,2,'{\"path\":\"walk\"}'),('W90',6,2,'{\"path\":\"walk\"}'),('W91',6,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Drawing Lab 2\",\"address\":\"5th Floor, Gusaling Villegas\"}'),('W92',6,2,'{\"amenity\":\"learning_laboratory\",\"name\":\"Drawing Lab 1\",\"address\":\"5th Floor, Gusaling Villegas\"}'),('W93',6,2,'{\"path\":\"walk\"}'),('W94',6,2,'{\"path\":\"walk\"}'),('W95',1,2,'{\"amenity\":\"building\",\"name\":\"Gusaling Emilio Ejercito\",\"name:short\":\"GEE\",\"address\":\"PLM Grounds\"}'),('W96',1,2,'{\"path\":\"walk\"}'),('W97',1,2,'{\"path\":\"walk\"}'),('W98',1,2,'{\"path\":\"walk\"}'),('W99',1,2,'{\"path\":\"walk\"}');
/*!40000 ALTER TABLE `element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `map`
--

DROP TABLE IF EXISTS `map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(12) NOT NULL,
  `parent_map_id` int DEFAULT NULL,
  `parent_element_id` varchar(12) NOT NULL,
  `level` int NOT NULL,
  `width` float NOT NULL,
  `height` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `map_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `map`
--

LOCK TABLES `map` WRITE;
/*!40000 ALTER TABLE `map` DISABLE KEYS */;
INSERT INTO `map` VALUES (1,'CqQWl2VhSiVP',NULL,'W27275574',1,234.227,234.227),(2,'CqQWl2VhSiVP',1,'W1',1,193.916,193.916),(3,'CqQWl2VhSiVP',1,'W1',2,193.916,193.916),(4,'CqQWl2VhSiVP',1,'W1',3,193.916,193.916),(5,'CqQWl2VhSiVP',1,'W1',4,32.8156,32.8156),(6,'CqQWl2VhSiVP',1,'W1',5,32.8156,32.8156),(7,'CqQWl2VhSiVP',1,'W95',1,144.805,144.805),(8,'CqQWl2VhSiVP',1,'W95',2,144.805,144.805),(9,'CqQWl2VhSiVP',1,'W95',3,144.805,144.805),(10,'CqQWl2VhSiVP',1,'W95',4,144.805,144.805),(11,'CqQWl2VhSiVP',1,'W153',1,71.4167,71.4167),(12,'CqQWl2VhSiVP',1,'W153',2,71.4167,71.4167),(13,'CqQWl2VhSiVP',1,'W153',3,71.4167,71.4167);
/*!40000 ALTER TABLE `map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Node`
--

DROP TABLE IF EXISTS `Node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Node` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lat` float NOT NULL,
  `lng` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=537 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Node`
--

LOCK TABLES `Node` WRITE;
/*!40000 ALTER TABLE `Node` DISABLE KEYS */;
INSERT INTO `Node` VALUES (1,-75.7043,129.476),(2,-75.7043,146.733),(3,14.2928,132.221),(4,82.0379,117.009),(5,81.9489,103.65),(6,50.8526,111.81),(7,5.42016,116.37),(8,-66.2273,125.143),(9,-81.2209,1.84762),(10,-77.8887,1.84762),(11,-73.3747,-0.00632),(12,-68.7273,-1.21981),(13,-59.0137,-3.32867),(14,-47.7628,-5.18051),(15,-43.7229,-5.63135),(16,-27.0113,-7.74021),(17,50.2431,-15.4088),(18,63.5177,-17.5177),(19,66.2526,-18.3498),(20,77.9713,-21.9924),(21,79.8894,-22.6961),(22,80.2096,-22.951),(23,-73.2844,2.23105),(24,-68.3465,0.956466),(25,-58.969,-1.2177),(26,-47.6122,-7.6117),(27,-43.1694,3.50985),(28,-42.8423,7.02602),(29,-42.4192,3.89328),(30,-27.1251,-2.81673),(31,-26.3833,3.63836),(32,-25.8669,10.3505),(33,55.4224,-16.1735),(34,63.966,-6.39821),(35,65.8094,-16.5612),(36,78.0055,-20.1406),(37,80.1317,-12.215),(38,-83.5289,9.3287),(39,-83.5289,25.5633),(40,-71.0789,18.6616),(41,-71.6305,1.97824),(42,-60.2798,15.5289),(43,-61.1858,-0.897477),(44,-44.1436,12.6532),(45,-44.6004,7.41156),(46,-44.1436,12.6532),(47,-34.8475,11.3744),(48,-35.0047,5.94104),(49,-42.044,7.02813),(50,-42.9393,-3.8385),(51,-36.0449,-4.47685),(52,-27.9225,10.3505),(53,-29.3806,-5.30902),(54,-28.2608,-2.81673),(55,-29.0459,3.63836),(56,64.3816,-16.1124),(57,65.0907,-1.72964),(58,79.5795,-7.6117),(59,79.4282,-20.5219),(60,-69.8348,-1.72964),(61,-63.2343,-3.00844),(62,-57.8063,-4.47896),(63,-47.6491,-5.69245),(64,-40.7878,-7.16296),(65,-30.3149,-7.99302),(66,-20.3361,-9.08011),(67,-4.47215,-10.2936),(68,4.65656,-10.9319),(69,22.5896,-13.0429),(70,29.7003,-13.6181),(71,44.5891,-15.2803),(72,49.8356,-16.1103),(73,60.238,-17.6462),(74,63.3748,-18.0296),(75,66.8914,-19.1167),(76,75.0079,-21.3541),(77,79.8114,-23.2712),(78,80.1668,-23.0795),(79,-71.444,1.4052),(80,-70.9079,18.0865),(81,-59.9866,15.4025),(82,-60.9007,-1.2788),(83,-63.3492,-0.640453),(84,-69.9885,1.02178),(85,-44.042,12.0801),(86,-44.9536,-4.02811),(87,-48.0778,-3.58148),(88,-58.0728,-1.85184),(89,-34.7313,10.993),(90,-35.775,-5.05199),(91,-40.4968,-4.60326),(92,-24.8191,9.52252),(93,-25.9162,-6.32869),(94,-30.8611,-5.69034),(95,0.891269,6.64681),(96,-0.386789,-8.56606),(97,-5.17262,-8.37434),(98,-20.9341,-6.90383),(99,26.5407,3.77109),(100,25.2183,-11.2501),(101,21.226,-10.8666),(102,4.59286,-8.94949),(103,47.7306,1.02178),(104,46.8638,-13.7424),(105,43.6223,-13.3589),(106,29.7003,-11.8884),(107,62.5301,-2.04776),(108,62.0547,-16.2367),(109,59.917,-15.7901),(110,50.0383,-14.1279),(111,64.2193,-16.2367),(112,64.6604,-2.4944),(113,73.8226,-5.18051),(114,73.5353,-18.7311),(115,66.5613,-17.0689),(116,79.5008,-8.11943),(117,79.3128,-21.2234),(118,75.1583,-19.5001),(119,80.1332,-25.378),(120,80.3069,-8.50286),(121,83.541,-11.189),(122,83.4463,-27.4868),(123,63.9419,-5.43332),(124,79.9788,-11.8884),(125,-82.8466,4.47264),(126,-77.6469,-0.128512),(127,-70.8479,-1.98246),(128,-70.8016,-0.00632),(129,-68.3799,-0.768965),(130,-51.2263,-4.28514),(131,-44.2349,-5.49863),(132,-29.4357,-6.96914),(133,-21.3636,-8.24794),(134,-3.72035,-9.65314),(135,4.58432,-10.5485),(136,21.3924,-12.2718),(137,29.7999,-13.104),(138,43.4738,-14.7662),(139,49.6205,-15.5963),(140,59.8806,-16.6202),(141,63.4548,-17.4502),(142,66.6069,-18.5373),(143,75.0376,-20.7747),(144,79.7977,-22.8836),(145,80.1646,-23.0753),(146,-83.4984,6.5836),(147,-83.4984,25.3758),(148,-70.9926,18.6637),(149,-71.5467,1.78863),(150,-71.4656,0.511941),(151,-71.5264,-0.89537),(152,-77.6595,1.15029),(153,-83.034,5.75354),(154,-54.538,14.3154),(155,-55.3818,-1.53582),(156,-68.0668,0.762645),(157,-46.2087,13.0366),(158,-47.2195,-2.81462),(159,-51.2263,-2.36588),(160,-24.9387,10.1609),(161,-25.8623,-5.49863),(162,-29.7097,-5.05199),(163,-43.5374,-3.64468),(164,0.951168,7.41156),(165,-0.326883,-7.99091),(166,-4.47614,-7.54428),(167,-21.1168,-5.88205),(168,26.5943,4.53584),(169,25.2725,-10.677),(170,20.5057,-10.2936),(171,4.84363,-8.43965),(172,47.4694,1.59692),(173,46.7736,-12.9776),(174,43.8502,-12.7859),(175,29.3632,-11.1237),(176,62.5598,-1.53582),(177,61.995,-15.7269),(178,60.077,-15.3435),(179,49.585,-13.6181),(180,63.884,-5.69034),(181,64.1639,-15.9186),(182,64.7698,-1.98456),(183,73.7871,-4.86028),(184,73.4979,-18.4109),(185,66.587,-16.557),(186,79.5241,-7.60959),(187,79.2892,-20.7115),(188,75.0376,-19.3063),(189,80.0011,-11.7641),(190,80.1114,-24.6743),(191,80.3607,-8.24794),(192,83.5549,-10.7423),(193,83.4391,-26.977),(194,-34.2902,-36.055),(195,-17.4765,-36.9525),(196,16.652,-40.2727),(197,75.9121,-49.3486),(198,81.27,-50.2461),(199,81.995,9.45511),(200,-83.474,-33.8808),(201,-82.4417,61.1001),(202,-77.1803,58.2896),(203,-78.5001,-16.8793),(204,-33.8668,-25.5718),(205,-35.3395,-45.2615),(206,5.1262,44.0986),(207,0.659696,-28.5128),(208,-15.0227,-27.7459),(209,80.051,29.0142),(210,79.0777,-41.0438),(211,75.9121,-39.3794),(212,18.9725,-30.1771),(213,-81.1296,-21.8681),(214,-81.2665,-29.4103),(215,-18.2065,-39.8935),(216,76.3088,-52.5466),(217,81.3294,-55.1042),(218,82.1198,13.2852),(219,-83.3271,-20.0858),(220,-82.391,60.4512),(221,6.39781,44.0901),(222,0.148471,-35.1701),(223,-18.2065,-33.51),(224,80.0903,28.6181),(225,79.1707,-48.468),(226,76.4407,-46.9827),(227,18.4676,131.647),(228,-82.0551,102.005),(229,-79.6275,106.798),(230,-77.3793,116.194),(231,-68.9527,97.8505),(232,-75.9044,80.08),(233,-71.5779,6.75871),(234,-63.713,-88.0325),(235,-65.1737,-88.8626),(236,-72.3332,-93.0845),(237,-77.8586,-3.21466),(238,50.243,107.809),(239,20.0255,110.623),(240,5.73842,110.623),(241,6.88172,74.3155),(242,-45.0053,0.044036),(243,-4.36296,103.465),(244,-29.3249,101.8),(245,-49.8488,65.366),(246,-65.0806,27.5919),(247,-59.444,79.496),(248,-49.3517,-104.847),(249,-63.8364,-94.3638),(250,-14.3948,153.02),(251,8.23469,134.87),(252,-14.1536,116.716),(253,-9.01546,96.0071),(254,-5.46592,81.1756),(255,-0.692606,58.5509),(256,3.84629,37.3296),(257,7.66507,21.2234),(258,13.3801,-5.49441),(259,20.049,-33.2338),(260,25.9367,-60.8491),(261,31.7152,-94.4827),(262,36.0631,-118.517),(263,38.303,-129.257),(264,43.1426,-156.358),(265,45.056,-164.849),(266,45.7292,-169.642),(267,-40.6142,103.215),(268,-30.9388,106.219),(269,-30.4442,103.982),(270,-29.2247,97.2066),(271,-38.9445,94.2024),(272,-27.8943,97.5406),(273,-27.0838,97.9734),(274,-25.6525,91.7733),(275,-37.4886,88.1939),(276,-41.3103,86.2275),(277,-12.8567,94.7915),(278,-9.78763,80.2842),(279,-7.19556,67.627),(280,-36.3315,60.0848),(281,-4.78061,57.5272),(282,-2.16556,46.9808),(283,-32.2141,39.7568),(284,0.139068,36.5608),(285,1.92804,27.1647),(286,-28.1272,19.8143),(287,3.71058,20.0081),(288,7.4669,2.81276),(289,-22.5865,-4.34599),(290,8.24012,-70.2473),(291,15.6126,-68.267),(292,22.6115,-66.668),(293,26.9614,-88.8479),(294,13.5097,-92.6189),(295,-6.67447,-73.7003),(296,0.276006,-71.8464),(297,-1.3215,-96.1983),(298,23.7227,163.187),(299,25.5235,170.217),(300,14.1745,167.276),(301,29.4828,120.934),(302,-22.0293,113.696),(303,-30.2236,110.755),(304,-29.1297,104.381),(305,-19.0375,100.403),(306,-15.1472,-12.3393),(307,23.548,-31.5779),(308,-12.7232,-46.1524),(309,23.5521,-171.241),(310,14.4965,-63.7862),(311,-0.683477,-68.1956),(312,-10.2282,120.808),(313,-13.7327,119.784),(314,-8.27748,96.5736),(315,-6.68446,90.3165),(316,-2.73654,73.9534),(317,1.41153,54.3858),(318,6.07444,35.0269),(319,10.4954,14.3154),(320,14.9291,-4.98668),(321,16.5809,-14.8358),(322,22.4209,-41.1702),(323,24.5434,-52.2222),(324,29.1597,-72.9969),(325,31.0393,-82.7764),(326,35.5247,-104.891),(327,36.8144,-113.331),(328,41.1824,-135.127),(329,43.8202,-150.277),(330,45.9448,-164.278),(331,23.6057,-171.368),(332,-16.6967,147.586),(333,-7.39118,160.945),(334,-1.78784,175.71),(335,40.3979,168.296),(336,38.6731,142.792),(337,31.8997,124.831),(338,14.1736,105.464),(339,-4.40389,97.4732),(340,-41.5062,88.2687),(341,-12.4924,95.4275),(342,-10.9864,89.3495),(343,-10.1742,83.4738),(344,-39.0693,75.6767),(345,-7.51791,72.9864),(346,-5.80419,63.3395),(347,-35.2511,55.9259),(348,-3.12402,53.4273),(349,-1.2129,43.9743),(350,-31.0763,36.6238),(351,1.47541,33.9967),(352,3.32239,24.097),(353,-26.714,16.2978),(354,6.19245,13.2873),(355,8.0901,3.13064),(356,-22.178,-4.28303),(357,-19.1288,-17.7705),(358,10.7377,-10.6117),(359,12.0532,-16.1714),(360,18.4699,-42.3858),(361,19.3723,-47.6843),(362,-10.4886,-54.7145),(363,20.7572,-53.1871),(364,25.3422,-74.1514),(365,26.2013,-78.6851),(366,-2.75022,-85.8439),(367,26.9443,-82.8396),(368,31.9578,-105.664),(369,32.2787,-109.557),(370,4.66111,-116.973),(371,33.4595,-114.422),(372,37.8235,-135.961),(373,38.6232,-140.56),(374,12.3031,-148.103),(375,40.5923,-151.299),(376,42.4108,-160.629),(377,16.9437,-167.853),(378,-22.4103,117.475),(379,-18.4027,100.541),(380,-14.9709,-11.8294),(381,16.6378,-148.417),(382,16.8214,-142.025),(383,23.1826,-142.025),(384,22.2394,-119.335),(385,16.0245,-119.335),(386,16.2087,-112.494),(387,25.6841,-112.943),(388,25.9142,-113.71),(389,26.0865,-115.69),(390,45.4474,-114.093),(391,45.1778,-110.706),(392,43.1612,-97.7302),(393,46.8201,-99.3271),(394,49.756,-96.9633),(395,52.9857,-96.5799),(396,55.0868,-98.5602),(397,58.144,-96.3882),(398,55.8834,-109.747),(399,55.7757,-112.494),(400,66.9165,-112.111),(401,66.7404,-110.131),(402,66.9165,-107.956),(403,70.8444,-107.318),(404,70.8444,-113.902),(405,68.6319,-113.902),(406,68.7016,-135.89),(407,70.8444,-135.441),(408,70.9072,-142.473),(409,66.6646,-142.473),(410,66.5885,-140.236),(411,66.5885,-138.062),(412,25.9142,-142.473),(413,25.9142,-145.029),(414,25.9142,-147.65),(415,-31.1276,-97.4174),(416,-5.47769,-95.4349),(417,13.7478,-95.3717),(418,38.7795,-94.4131),(419,55.9955,-93.0079),(420,60.5915,-92.6245),(421,59.8915,-108.988),(422,35.1556,-111.351),(423,8.91624,60.0762),(424,8.91624,65.4463),(425,9.29484,79.1886),(426,38.0719,79.3804),(427,33.4062,60.843),(428,-32.5964,65.638),(429,-13.4843,66.2132),(430,-13.8569,82.3846),(431,-28.2879,77.5959),(432,-19.175,48.0635),(433,-8.77285,47.1702),(434,-7.88764,26.4608),(435,40.9872,28.1209),(436,72.2833,32.8527),(437,82.2243,35.798),(438,82.3274,53.3093),(439,80.3539,52.9259),(440,8.98838,40.5234),(441,8.98838,49.8563),(442,8.60947,60.0825),(443,33.0931,59.8276),(444,32.9324,41.0985),(445,69.3458,-66.4765),(446,69.3458,-22.8836),(447,69.3458,23.3934),(448,72.8171,23.7768),(449,82.8055,26.5914),(450,82.8055,-61.6183),(451,33.2012,-27.0402),(452,33.5214,18.8533),(453,40.4614,19.2368),(454,39.8754,-26.6567),(455,-16.1307,-76.7027),(456,-16.1307,16.2346),(457,-5.21233,16.6181),(458,33.0406,-71.9751),(459,-54.5984,-81.1774),(460,-54.5984,11.8863),(461,-21.4522,15.4678),(462,-73.9433,-85.5258),(463,-74.049,6.26127),(464,-71.6804,7.02813),(465,-82.5915,-86.676),(466,-82.8505,1.53372),(467,-75.9021,5.11098),(468,-24.3947,25.3147),(469,-71.2744,14.5745),(470,-76.8936,10.9973),(471,-82.2026,9.84696),(472,-82.4248,27.3583),(473,-80.9906,27.7417),(474,-28.2959,77.9752),(475,-18.8125,48.5733),(476,-1.64977,48.9567),(477,6.76964,-15.3498),(478,41.276,-12.9186),(479,58.8813,-12.5352),(480,66.6687,-10.1082),(481,72.5891,-7.80763),(482,81.0342,-5.75986),(483,82.3432,-4.993),(484,82.5116,52.9174),(485,80.3094,52.9174),(486,-9.1516,-18.8007),(487,-36.9976,-19.5675),(488,-56.6243,-21.8681),(489,-62.9674,-23.1448),(490,-69.111,-24.2951),(491,-79.9995,-26.3428),(492,-81.9202,-28.26),(493,-82.5264,27.9903),(494,-80.6647,27.9903),(495,9.23627,40.3907),(496,9.23627,49.9785),(497,8.85761,59.9498),(498,33.1428,60.1415),(499,33.1428,41.1575),(500,33.1428,-4.35255),(501,69.6126,43.97),(502,69.4786,-0.132725),(503,67.5122,-0.32444),(504,38.4768,-3.96912),(505,81.8783,46.2727),(506,81.9412,4.21351),(507,81.1821,4.02179),(508,71.8671,0.634133),(509,62.3591,-67.8227),(510,62.8297,-18.3498),(511,66.0773,-17.9664),(512,82.1272,-12.7248),(513,82.8054,-12.3414),(514,82.8054,-61.8142),(515,-0.181383,-74.9815),(516,-0.76107,-24.4847),(517,6.8319,-23.9095),(518,59.4724,-18.925),(519,-60.7382,-82.1402),(520,-61.1109,-29.4714),(521,-58.3086,-29.0226),(522,-6.75246,-25.0598),(523,-82.4849,-86.676),(524,-82.6426,-35.0311),(525,-81.9754,-34.7741),(526,-63.602,-30.0444),(527,-65.8365,-15.2171),(528,-65.9148,27.6722),(529,-31.5638,37.26),(530,-31.5638,-11.446),(531,-35.712,-11.8294),(532,-63.2569,-14.4502),(533,-81.6656,-19.1799),(534,-81.867,20.8969),(535,-68.37,-15.6005),(536,-80.6856,-18.413);
/*!40000 ALTER TABLE `Node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relation`
--

DROP TABLE IF EXISTS `relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lat` float NOT NULL,
  `lng` float NOT NULL,
  `min_lat` float DEFAULT NULL,
  `min_lng` float DEFAULT NULL,
  `max_lat` float DEFAULT NULL,
  `max_lng` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relation`
--

LOCK TABLES `relation` WRITE;
/*!40000 ALTER TABLE `relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RelationMember`
--

DROP TABLE IF EXISTS `RelationMember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RelationMember` (
  `element_id` varchar(12) NOT NULL,
  `relation_id` int NOT NULL,
  `role` smallint DEFAULT NULL,
  KEY `element_id` (`element_id`),
  KEY `relation_id` (`relation_id`),
  CONSTRAINT `relationmember_ibfk_1` FOREIGN KEY (`element_id`) REFERENCES `Element` (`id`),
  CONSTRAINT `relationmember_ibfk_2` FOREIGN KEY (`relation_id`) REFERENCES `Relation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RelationMember`
--

LOCK TABLES `RelationMember` WRITE;
/*!40000 ALTER TABLE `RelationMember` DISABLE KEYS */;
/*!40000 ALTER TABLE `RelationMember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `id` varchar(12) NOT NULL,
  `type` smallint NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(64) NOT NULL,
  `pass_salt` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('CqQWl2VhSiVP',1,'hjadasal2020@plm.edu.ph','9086008fa5c14d92aa82920466c6e1fbcae6ef875e673e6e330b0f142513ad87','jJscUOyImaiS0g5wy4TCEPi761TvnUe9LSuOIbCQCe3g6O9SFtt5Kivc0Jq2Ogjn');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `way`
--

DROP TABLE IF EXISTS `way`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `way` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` smallint NOT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `min_lat` float DEFAULT NULL,
  `min_lng` float DEFAULT NULL,
  `max_lat` float DEFAULT NULL,
  `max_lng` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=203 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `way`
--

LOCK TABLES `way` WRITE;
/*!40000 ALTER TABLE `way` DISABLE KEYS */;
INSERT INTO `way` VALUES (1,3,3.16678,125.191,-75.7043,103.65,82.0379,146.733),(2,1,-0.505627,-10.5517,-81.2209,-22.951,80.2096,1.84762),(3,1,-73.3296,-10.36,-73.3747,-22.951,-73.2844,2.23105),(4,1,-71.0058,0.505621,-73.2844,-1.21981,-68.7272,2.23105),(5,1,-63.6801,-1.1861,-68.3465,-3.32867,-59.0137,0.956466),(6,1,-53.3659,-3.19911,-58.969,-5.18051,-47.7628,-1.2177),(7,1,-45.6675,-7.6117,-47.6122,-7.6117,-43.7229,-7.6117),(8,1,-42.7943,3.70157,-43.1694,3.50985,-42.4192,3.89328),(9,1,-26.496,1.30513,-27.1251,-7.74021,-25.8669,10.3505),(10,1,52.8327,-15.7912,50.2431,-16.1735,55.4224,-15.4088),(11,1,63.7418,-11.9579,63.5177,-17.5177,63.966,-6.39821),(12,1,66.031,-17.4555,65.8094,-18.3498,66.2526,-16.5612),(13,1,77.9884,-21.0665,77.9713,-21.9924,78.0055,-20.1406),(14,1,80.0105,-17.4555,79.8894,-22.6961,80.1317,-12.215),(15,3,-77.3039,13.7708,-83.5289,1.97824,-71.0789,25.5633),(16,3,-65.9551,8.88207,-71.6305,-0.897477,-60.2798,18.6616),(17,3,-52.6647,7.3157,-61.1858,-0.897477,-44.1436,15.5289),(18,3,-39.724,9.2971,-44.6004,5.94104,-34.8475,12.6532),(19,3,-38.972,1.27564,-42.9393,-4.47685,-35.0047,7.02813),(20,3,-31.9837,3.03267,-36.0449,-5.30902,-27.9225,11.3744),(21,1,-27.6929,-2.81673,-28.2608,-2.81673,-27.1251,-2.81673),(22,1,-27.7146,3.63836,-29.0459,3.63836,-26.3833,3.63836),(23,3,71.9805,-11.1258,64.3816,-20.5219,79.5795,-1.72964),(24,1,-69.8348,-23.2712,-69.8348,-23.2712,-69.8348,-23.2712),(25,3,-65.7153,8.40384,-71.444,-1.2788,-59.9866,18.0865),(26,3,-52.4714,5.68718,-60.9007,-4.02811,-44.042,15.4025),(27,3,-39.8425,3.51406,-44.9536,-5.05199,-34.7313,12.0801),(28,3,-30.297,2.33218,-35.775,-6.32869,-24.8191,10.993),(29,3,-12.5125,0.478233,-25.9162,-8.56606,0.891269,9.52252),(30,3,13.077,-2.30163,-0.386789,-11.2501,26.5407,6.64681),(31,3,36.4745,-4.98563,25.2183,-13.7424,47.7306,3.77109),(32,3,54.697,-7.60749,46.8638,-16.2367,62.5301,1.02178),(33,3,69.021,-10.6128,64.2193,-18.7311,73.8226,-2.4944),(34,3,76.518,-13.202,73.5353,-21.2234,79.5008,-5.18051),(35,3,81.8371,-17.9948,80.1332,-27.4868,83.541,-8.50286),(36,1,-66.592,-1.18505,-69.8348,-1.72964,-63.3492,-0.640453),(37,1,-66.6114,-0.993334,-69.9885,-3.00844,-63.2343,1.02178),(38,1,-52.9421,-4.03022,-57.8063,-4.47896,-48.0778,-3.58148),(39,1,-52.861,-3.77214,-58.0728,-5.69245,-47.6491,-1.85184),(40,1,-5.88311,-40.6423,-7.16296,-40.7878,-4.60326,-40.4968),(41,1,-30.588,-6.84168,-30.8611,-7.99302,-30.3149,-5.69034),(42,1,-8.72723,-12.7543,-9.08011,-20.3361,-8.37434,-5.17262),(43,1,-8.59871,-12.7031,-10.2936,-20.9341,-6.90383,-4.47215),(44,1,12.9413,-10.8993,4.65656,-10.9319,21.226,-10.8666),(45,1,13.5912,-10.9962,4.59286,-13.0429,22.5896,-8.94949),(46,1,36.6613,-13.4885,29.7003,-13.6181,43.6223,-13.3589),(47,1,37.1447,-13.5843,29.7003,-15.2803,44.5891,-11.8884),(48,1,54.8763,-15.9502,49.8356,-16.1103,59.917,-15.7901),(49,1,55.1381,-15.887,50.0383,-17.6462,60.238,-14.1279),(50,1,64.9681,-17.5493,63.3748,-18.0296,66.5613,-17.0689),(51,1,71.0249,-19.3084,66.8914,-19.5001,75.1583,-19.1167),(52,1,69.4749,-13.3937,63.9419,-21.3541,75.0079,-5.43332),(53,1,79.8951,-17.5798,79.8114,-23.2712,79.9788,-11.8884),(54,1,-1.34102,-9.30132,-82.8466,-23.0753,80.1646,4.47264),(55,3,-77.2455,12.2402,-83.4984,-0.89537,-70.9926,25.3758),(56,3,-63.0423,8.56395,-71.5467,-1.53582,-54.538,18.6637),(57,3,-50.7952,5.75038,-55.3818,-2.81462,-46.2087,14.3154),(58,3,-36.0791,3.76898,-47.2195,-5.49863,-24.9387,13.0366),(59,3,-12.4556,1.08498,-25.8623,-7.99092,0.951168,10.1609),(60,3,13.1337,-1.63273,-0.326883,-10.677,26.5943,7.41156),(61,3,36.3709,-4.22088,25.2725,-12.9776,47.4694,4.53584),(62,3,54.6667,-7.065,46.7736,-15.7269,62.5598,1.59692),(63,3,63.6694,-11.5703,63.4548,-17.4502,63.884,-5.69034),(64,3,68.9755,-10.1977,64.1639,-18.4109,73.7871,-1.98456),(65,3,76.511,-12.7859,73.4979,-20.7115,79.5241,-4.86028),(66,3,79.8994,-17.3238,79.7977,-22.8836,80.0011,-11.7641),(67,3,81.8332,-17.6125,80.1114,-26.977,83.5549,-8.24794),(68,1,-76.9178,2.87361,-83.034,-0.00632026,-70.8016,5.75354),(69,1,-68.2234,-0.00316,-68.3799,-0.768965,-68.0668,0.762645),(70,1,-51.2263,-3.32551,-51.2263,-4.28514,-51.2263,-2.36588),(71,1,-43.8862,-4.57165,-44.2349,-5.49863,-43.5374,-3.64468),(72,1,-29.5727,-6.01057,-29.7097,-6.96914,-29.4357,-5.05199),(73,1,-21.2402,-7.065,-21.3636,-8.24794,-21.1168,-5.88206),(74,1,-4.09825,-8.59871,-4.47614,-9.65314,-3.72035,-7.54428),(75,1,4.71398,-9.49408,4.58432,-10.5485,4.84363,-8.43965),(76,1,20.949,-11.2827,20.5057,-12.2718,21.3924,-10.2936),(77,1,29.5816,-12.1138,29.3632,-13.104,29.7999,-11.1237),(78,1,43.662,-13.7761,43.4738,-14.7662,43.8502,-12.7859),(79,1,49.6028,-14.6072,49.585,-15.5963,49.6205,-13.6181),(80,1,59.9788,-15.9818,59.8806,-16.6202,60.077,-15.3435),(81,1,66.5969,-17.5471,66.587,-18.5373,66.6069,-16.557),(82,1,75.0376,-20.0405,75.0376,-20.7747,75.0376,-19.3063),(83,1,23.8524,-20.3955,-34.2902,-50.2461,81.995,9.45511),(84,3,-58.6704,7.91929,-83.474,-45.2615,-33.8668,61.1001),(85,3,-36.6869,14.8884,-78.5001,-28.5128,5.1262,58.2896),(86,3,40.3553,1.5274,0.659696,-41.0438,80.051,44.0986),(87,1,-16.2496,-32.3492,-17.4765,-36.9525,-15.0227,-27.7459),(88,1,17.8123,-35.2249,16.652,-40.2727,18.9725,-30.1771),(89,1,75.9121,-44.364,75.9121,-49.3486,75.9121,-39.3794),(90,1,0.42665,-20.9095,-81.2665,-55.1042,82.1198,13.2852),(91,3,-38.4646,12.6405,-83.3271,-35.1701,6.39781,60.4512),(92,3,40.1194,-2.18892,0.148471,-48.468,80.0903,44.0901),(93,1,-18.2065,-36.7017,-18.2065,-39.8935,-18.2065,-33.51),(94,1,76.3748,-49.7647,76.3088,-52.5466,76.4407,-46.9827),(95,3,-77.0239,22.5378,-82.0551,-93.0845,-63.713,129.476),(96,1,NULL,NULL,NULL,NULL,NULL,NULL),(97,1,NULL,NULL,NULL,NULL,NULL,NULL),(98,1,NULL,NULL,NULL,NULL,NULL,NULL),(99,1,NULL,NULL,NULL,NULL,NULL,NULL),(100,1,NULL,NULL,NULL,NULL,NULL,NULL),(101,3,-34.9194,100.211,-40.6142,94.2024,-29.2247,106.219),(102,3,-32.2985,93.0837,-38.9445,88.1939,-25.6525,97.9734),(103,3,-24.2529,79.0292,-41.3103,60.0848,-7.19556,97.9734),(104,3,-19.2485,53.6919,-36.3315,39.7568,-2.16556,67.627),(105,3,-15.143,33.3976,-32.2141,19.8143,1.92804,46.9808),(106,3,-10.3302,11.4094,-28.1272,-4.34599,7.4669,27.1647),(107,3,17.6007,-79.6435,8.24012,-92.6189,26.9614,-66.668),(108,3,3.41763,-83.2228,-6.67447,-96.1983,13.5097,-70.2473),(109,1,NULL,NULL,NULL,NULL,NULL,NULL),(110,1,NULL,NULL,NULL,NULL,NULL,NULL),(111,1,NULL,NULL,NULL,NULL,NULL,NULL),(112,1,NULL,NULL,NULL,NULL,NULL,NULL),(113,1,NULL,NULL,NULL,NULL,NULL,NULL),(114,1,NULL,NULL,NULL,NULL,NULL,NULL),(115,1,NULL,NULL,NULL,NULL,NULL,NULL),(116,1,NULL,NULL,NULL,NULL,NULL,NULL),(117,1,NULL,NULL,NULL,NULL,NULL,NULL),(118,1,NULL,NULL,NULL,NULL,NULL,NULL),(119,1,NULL,NULL,NULL,NULL,NULL,NULL),(120,1,NULL,NULL,NULL,NULL,NULL,NULL),(121,1,NULL,NULL,NULL,NULL,NULL,NULL),(122,1,NULL,NULL,NULL,NULL,NULL,NULL),(123,1,NULL,NULL,NULL,NULL,NULL,NULL),(124,1,NULL,NULL,NULL,NULL,NULL,NULL),(125,1,NULL,NULL,NULL,NULL,NULL,NULL),(126,3,11.8506,136.591,-16.6967,97.4732,40.3979,175.71),(127,3,-25.8402,85.5521,-41.5062,75.6767,-10.1742,95.4275),(128,3,-22.4367,69.6998,-39.0693,55.9259,-5.80419,83.4738),(129,3,-18.232,49.9817,-35.2511,36.6238,-1.2129,63.3395),(130,3,-13.877,30.1361,-31.0763,16.2978,3.32239,43.9743),(131,3,-9.31196,9.90701,-26.714,-4.28303,8.0901,24.097),(132,3,0.121798,-32.6631,-19.1288,-54.7145,19.3723,-10.6117),(133,3,7.85634,-66.7641,-10.4886,-85.8439,26.2013,-47.6843),(134,3,14.7642,-97.8292,-2.75021,-116.973,32.2787,-78.6851),(135,3,21.6421,-128.83,4.66111,-148.103,38.6232,-109.557),(136,3,27.357,-154.207,12.3031,-167.853,42.4108,-140.56),(137,1,NULL,NULL,NULL,NULL,NULL,NULL),(138,1,NULL,NULL,NULL,NULL,NULL,NULL),(139,1,NULL,NULL,NULL,NULL,NULL,NULL),(140,1,NULL,NULL,NULL,NULL,NULL,NULL),(141,1,NULL,NULL,NULL,NULL,NULL,NULL),(142,1,NULL,NULL,NULL,NULL,NULL,NULL),(143,1,NULL,NULL,NULL,NULL,NULL,NULL),(144,1,NULL,NULL,NULL,NULL,NULL,NULL),(145,1,NULL,NULL,NULL,NULL,NULL,NULL),(146,1,NULL,NULL,NULL,NULL,NULL,NULL),(147,1,NULL,NULL,NULL,NULL,NULL,NULL),(148,1,NULL,NULL,NULL,NULL,NULL,NULL),(149,1,NULL,NULL,NULL,NULL,NULL,NULL),(150,1,NULL,NULL,NULL,NULL,NULL,NULL),(151,1,NULL,NULL,NULL,NULL,NULL,NULL),(152,1,NULL,NULL,NULL,NULL,NULL,NULL),(153,3,53.3305,-125.088,16.0245,-148.417,70.9072,-96.3882),(154,1,NULL,NULL,NULL,NULL,NULL,NULL),(155,1,NULL,NULL,NULL,NULL,NULL,NULL),(156,3,23.4941,69.7283,8.91624,60.0762,38.0719,79.3804),(157,1,NULL,NULL,NULL,NULL,NULL,NULL),(158,1,NULL,NULL,NULL,NULL,NULL,NULL),(159,1,NULL,NULL,NULL,NULL,NULL,NULL),(160,3,20.8513,50.3029,8.60947,40.5234,33.0931,60.0825),(161,3,76.0757,-19.9425,69.3458,-66.4765,82.8055,26.5914),(162,3,51.2735,-23.6199,33.2012,-66.4765,69.3458,19.2368),(163,3,8.69535,-28.9247,-16.1307,-76.7027,33.5214,18.8533),(164,3,-35.3646,-32.4714,-54.5984,-81.1774,-16.1307,16.2346),(165,3,-64.3237,-36.8197,-74.049,-85.5258,-54.5984,11.8863),(166,3,-78.3969,-40.2074,-82.8505,-86.676,-73.9433,6.26127),(167,1,NULL,NULL,NULL,NULL,NULL,NULL),(168,1,NULL,NULL,NULL,NULL,NULL,NULL),(169,1,NULL,NULL,NULL,NULL,NULL,NULL),(170,1,NULL,NULL,NULL,NULL,NULL,NULL),(171,1,NULL,NULL,NULL,NULL,NULL,NULL),(172,1,NULL,NULL,NULL,NULL,NULL,NULL),(173,1,NULL,NULL,NULL,NULL,NULL,NULL),(174,1,NULL,NULL,NULL,NULL,NULL,NULL),(175,1,NULL,NULL,NULL,NULL,NULL,NULL),(176,1,NULL,NULL,NULL,NULL,NULL,NULL),(177,3,21.0002,50.2661,8.85761,40.3907,33.1428,60.1415),(178,3,51.3777,19.8087,33.1428,-4.35255,69.6126,43.97),(179,3,75.7099,23.07,69.4786,-0.132725,81.9412,46.2727),(180,3,72.5822,-40.082,62.3591,-67.8227,82.8054,-12.3414),(181,3,31.0343,-46.6656,-0.76107,-74.9815,62.8297,-18.3498),(182,3,-30.6461,-53.3124,-61.1109,-82.1402,-0.181383,-24.4847),(183,3,-71.6904,-58.0737,-82.6426,-86.676,-60.7382,-29.4714),(184,3,-48.7393,11.0215,-65.9148,-15.2171,-31.5638,37.26),(185,3,-73.8517,4.24616,-81.867,-19.1799,-65.8365,27.6722),(186,1,NULL,NULL,NULL,NULL,NULL,NULL),(187,1,NULL,NULL,NULL,NULL,NULL,NULL),(188,1,NULL,NULL,NULL,NULL,NULL,NULL),(189,1,NULL,NULL,NULL,NULL,NULL,NULL),(190,1,NULL,NULL,NULL,NULL,NULL,NULL),(191,1,NULL,NULL,NULL,NULL,NULL,NULL),(192,1,NULL,NULL,NULL,NULL,NULL,NULL),(193,1,NULL,NULL,NULL,NULL,NULL,NULL),(194,1,NULL,NULL,NULL,NULL,NULL,NULL),(195,1,NULL,NULL,NULL,NULL,NULL,NULL),(196,1,NULL,NULL,NULL,NULL,NULL,NULL),(197,1,NULL,NULL,NULL,NULL,NULL,NULL),(198,1,NULL,NULL,NULL,NULL,NULL,NULL),(199,1,NULL,NULL,NULL,NULL,NULL,NULL),(200,1,NULL,NULL,NULL,NULL,NULL,NULL),(201,1,NULL,NULL,NULL,NULL,NULL,NULL),(202,1,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `way` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Waypoint`
--

DROP TABLE IF EXISTS `Waypoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Waypoint` (
  `way_id` int NOT NULL,
  `node_id` int NOT NULL,
  `sequence` int NOT NULL,
  KEY `way_id` (`way_id`),
  KEY `node_id` (`node_id`),
  CONSTRAINT `waypoint_ibfk_1` FOREIGN KEY (`way_id`) REFERENCES `Way` (`id`),
  CONSTRAINT `waypoint_ibfk_2` FOREIGN KEY (`node_id`) REFERENCES `Node` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Waypoint`
--

LOCK TABLES `Waypoint` WRITE;
/*!40000 ALTER TABLE `Waypoint` DISABLE KEYS */;
INSERT INTO `Waypoint` VALUES (1,1,1),(1,2,2),(1,3,3),(1,4,4),(1,5,5),(1,6,6),(1,7,7),(1,227,8),(1,8,9),(2,9,1),(2,10,2),(2,11,3),(2,12,4),(2,13,5),(2,14,6),(2,15,7),(2,16,8),(2,17,9),(2,18,10),(2,19,11),(2,20,12),(2,21,13),(2,22,14),(3,11,1),(3,23,2),(4,12,1),(4,24,2),(5,13,1),(5,25,2),(6,14,1),(6,26,2),(7,15,1),(7,27,2),(7,28,3),(8,27,1),(8,29,2),(9,16,1),(9,30,2),(9,31,3),(9,32,4),(10,17,1),(10,33,2),(11,18,1),(11,34,2),(12,19,1),(12,35,2),(13,20,1),(13,36,2),(14,21,1),(14,37,2),(15,23,5),(15,38,1),(15,39,2),(15,40,3),(15,41,4),(16,24,5),(16,40,2),(16,41,1),(16,42,3),(16,43,4),(17,25,6),(17,42,2),(17,43,1),(17,44,3),(17,45,4),(17,46,5),(18,28,6),(18,44,2),(18,45,1),(18,47,3),(18,48,4),(18,49,5),(19,29,2),(19,48,4),(19,49,3),(19,50,1),(19,51,5),(20,47,3),(20,48,2),(20,51,1),(20,52,4),(20,53,7),(20,54,5),(20,55,6),(21,30,1),(21,54,2),(22,31,1),(22,55,2),(23,35,5),(23,36,6),(23,56,1),(23,57,2),(23,58,3),(23,59,4),(24,60,1),(24,61,2),(24,62,3),(24,63,4),(24,64,5),(24,65,6),(24,66,7),(24,67,8),(24,68,9),(24,69,10),(24,70,11),(24,71,12),(24,72,13),(24,73,14),(24,74,15),(24,75,16),(24,76,17),(24,77,18),(24,78,19),(25,79,1),(25,80,2),(25,81,3),(25,82,4),(25,83,5),(25,84,6),(26,81,2),(26,82,1),(26,85,3),(26,86,4),(26,87,5),(26,88,6),(27,85,2),(27,86,1),(27,89,3),(27,90,4),(27,91,5),(28,89,2),(28,90,1),(28,92,3),(28,93,4),(28,94,5),(29,92,2),(29,93,1),(29,95,3),(29,96,4),(29,97,5),(29,98,6),(30,95,2),(30,96,1),(30,99,3),(30,100,4),(30,101,5),(30,102,6),(31,99,2),(31,100,1),(31,103,3),(31,104,4),(31,105,5),(31,106,6),(32,103,2),(32,104,1),(32,107,3),(32,108,4),(32,109,5),(32,110,6),(33,111,1),(33,112,2),(33,113,3),(33,114,4),(33,115,5),(34,113,2),(34,114,1),(34,116,3),(34,117,4),(34,118,5),(35,78,2),(35,119,1),(35,120,3),(35,121,4),(35,122,5),(36,60,1),(36,84,2),(37,61,1),(37,83,2),(38,62,1),(38,88,2),(39,63,1),(39,87,2),(40,64,1),(40,91,2),(41,65,1),(41,94,2),(42,66,1),(42,98,2),(43,67,1),(43,97,2),(44,68,1),(44,102,2),(45,69,1),(45,101,2),(46,70,1),(46,106,2),(47,71,1),(47,105,2),(48,72,1),(48,110,2),(49,73,1),(49,109,2),(50,74,1),(50,123,2),(51,75,1),(51,115,2),(52,76,1),(52,118,2),(53,77,1),(53,124,2),(54,125,2),(54,126,3),(54,127,4),(54,128,5),(54,129,6),(54,130,7),(54,131,8),(54,132,9),(54,133,10),(54,134,11),(54,135,12),(54,136,13),(54,137,14),(54,138,15),(54,139,16),(54,140,17),(54,141,18),(54,142,19),(54,143,20),(54,144,21),(54,145,22),(54,153,1),(55,146,1),(55,147,2),(55,148,3),(55,149,4),(55,150,5),(55,151,6),(55,152,7),(56,148,2),(56,149,1),(56,154,3),(56,155,4),(56,156,5),(57,154,2),(57,155,1),(57,157,3),(57,158,4),(57,159,5),(58,157,2),(58,158,1),(58,160,3),(58,161,4),(58,162,5),(58,163,6),(59,160,2),(59,161,1),(59,164,3),(59,165,4),(59,166,5),(59,167,6),(60,164,2),(60,165,1),(60,168,3),(60,169,4),(60,170,5),(60,171,6),(61,168,2),(61,169,1),(61,172,3),(61,173,4),(61,174,5),(61,175,6),(62,172,2),(62,173,1),(62,176,3),(62,177,4),(62,178,5),(62,179,6),(63,141,1),(63,180,2),(64,181,2),(64,182,1),(64,183,3),(64,184,4),(64,185,5),(65,183,2),(65,184,1),(65,186,3),(65,187,4),(65,188,5),(66,144,1),(66,189,2),(67,190,1),(67,191,3),(67,192,4),(67,193,5),(67,145,2),(68,128,1),(68,150,2),(69,129,1),(69,156,2),(70,130,1),(70,159,2),(71,131,1),(71,163,2),(72,132,1),(72,162,2),(73,133,1),(73,167,2),(74,134,1),(74,166,2),(75,135,1),(75,171,2),(76,136,1),(76,170,2),(77,137,1),(77,175,2),(78,138,1),(78,174,2),(79,139,1),(79,179,2),(80,140,1),(80,178,2),(81,142,1),(81,185,2),(82,143,1),(82,188,2),(83,194,1),(83,195,2),(83,196,3),(83,197,4),(83,198,5),(83,199,6),(84,194,6),(84,200,1),(84,201,2),(84,202,3),(84,203,4),(84,204,5),(84,205,7),(85,202,2),(85,203,1),(85,206,3),(85,207,4),(85,208,5),(86,206,2),(86,207,1),(86,209,3),(86,210,4),(86,211,5),(86,212,6),(87,195,1),(87,208,2),(88,196,1),(88,212,2),(89,197,1),(89,211,2),(90,213,1),(90,214,2),(90,215,3),(90,216,4),(90,217,5),(90,218,6),(91,213,6),(91,219,1),(91,220,2),(91,221,3),(91,222,4),(91,223,5),(92,221,2),(92,222,1),(92,224,3),(92,225,4),(92,226,5),(93,215,1),(93,223,2),(94,216,1),(94,226,2),(95,1,4),(95,8,5),(95,228,1),(95,229,2),(95,230,3),(95,231,6),(95,232,7),(95,233,8),(95,234,9),(95,235,10),(95,236,11),(95,237,12),(96,6,1),(96,233,7),(96,238,2),(96,239,3),(96,240,4),(96,241,5),(96,242,6),(97,7,1),(97,240,2),(97,243,3),(97,244,4),(97,245,5),(97,246,6),(97,233,7),(98,231,3),(98,245,1),(98,247,2),(99,235,4),(99,242,1),(99,248,2),(99,249,3),(100,250,1),(100,251,2),(100,252,3),(100,253,4),(100,254,5),(100,255,6),(100,256,7),(100,257,8),(100,258,9),(100,259,10),(100,260,11),(100,261,12),(100,262,13),(100,263,14),(100,264,15),(100,265,16),(100,266,17),(101,267,1),(101,268,2),(101,269,3),(101,270,4),(101,271,5),(102,270,2),(102,271,1),(102,272,3),(102,273,4),(102,274,5),(102,275,6),(103,273,3),(103,274,2),(103,276,1),(103,277,4),(103,278,5),(103,279,6),(103,280,7),(104,279,2),(104,280,1),(104,281,3),(104,282,4),(104,283,5),(105,282,2),(105,283,1),(105,284,3),(105,285,4),(105,286,5),(106,285,2),(106,286,1),(106,287,3),(106,288,4),(106,289,5),(107,290,1),(107,291,2),(107,292,3),(107,293,4),(107,294,5),(108,290,3),(108,294,4),(108,295,1),(108,296,2),(108,297,5),(109,251,1),(109,298,2),(109,299,3),(110,298,1),(110,300,2),(111,251,1),(111,301,2),(112,251,1),(112,272,5),(112,302,2),(112,303,3),(112,304,4),(113,302,1),(113,305,2),(114,269,2),(114,304,1),(115,254,1),(115,278,2),(116,255,1),(116,281,2),(117,256,1),(117,284,2),(118,257,1),(118,287,2),(119,258,1),(119,306,2),(120,259,1),(120,307,2),(121,259,1),(121,308,2),(122,265,1),(122,309,2),(123,260,1),(123,310,2),(123,311,3),(123,296,4),(124,291,2),(124,310,1),(125,312,1),(125,313,2),(125,314,3),(125,315,4),(125,316,5),(125,317,6),(125,318,7),(125,319,8),(125,320,9),(125,321,10),(125,322,11),(125,323,12),(125,324,13),(125,325,14),(125,326,15),(125,327,16),(125,328,17),(125,329,18),(125,330,19),(125,331,20),(126,312,9),(126,332,1),(126,333,2),(126,334,3),(126,335,4),(126,336,5),(126,337,6),(126,338,7),(126,339,8),(127,340,1),(127,341,2),(127,342,3),(127,343,4),(127,344,5),(128,343,2),(128,344,1),(128,345,3),(128,346,4),(128,347,5),(129,346,2),(129,347,1),(129,348,3),(129,349,4),(129,350,5),(130,349,2),(130,350,1),(130,351,3),(130,352,4),(130,353,5),(131,352,2),(131,353,1),(131,354,3),(131,355,4),(131,356,5),(132,357,1),(132,358,2),(132,359,3),(132,360,4),(132,361,5),(132,362,6),(133,361,2),(133,362,1),(133,363,3),(133,364,4),(133,365,5),(133,366,6),(134,365,2),(134,366,1),(134,367,3),(134,368,4),(134,369,5),(134,370,6),(135,369,2),(135,370,1),(135,371,3),(135,372,4),(135,373,5),(135,374,6),(136,373,2),(136,374,1),(136,375,3),(136,376,4),(136,377,5),(137,315,1),(137,342,2),(138,316,1),(138,345,2),(139,317,1),(139,348,2),(140,318,1),(140,351,2),(141,319,1),(141,354,2),(142,320,1),(142,380,2),(143,321,1),(143,359,2),(144,322,1),(144,360,2),(145,323,1),(145,363,2),(146,324,1),(146,364,2),(147,325,1),(147,367,2),(148,326,1),(148,368,2),(149,327,1),(149,371,2),(150,328,1),(150,372,2),(151,329,1),(151,375,2),(152,313,1),(152,378,2),(152,379,3),(153,381,1),(153,382,2),(153,383,3),(153,384,4),(153,385,5),(153,386,6),(153,387,7),(153,388,8),(153,389,9),(153,390,10),(153,391,11),(153,392,12),(153,393,13),(153,394,14),(153,395,15),(153,396,16),(153,397,17),(153,398,18),(153,399,19),(153,400,20),(153,401,21),(153,402,22),(153,403,23),(153,404,24),(153,405,25),(153,406,26),(153,407,27),(153,408,28),(153,409,29),(153,410,30),(153,411,31),(153,412,32),(153,413,33),(153,414,34),(154,248,1),(154,401,9),(154,415,2),(154,416,3),(154,417,4),(154,418,5),(154,419,6),(154,420,7),(154,421,8),(155,391,3),(155,420,1),(155,422,2),(156,423,1),(156,424,2),(156,425,3),(156,426,4),(156,427,5),(157,428,1),(157,429,2),(157,430,3),(158,424,1),(158,429,2),(159,431,1),(159,432,2),(159,433,3),(159,434,4),(159,435,5),(159,436,6),(159,437,7),(159,438,8),(159,439,9),(160,440,1),(160,441,2),(160,442,3),(160,443,4),(160,444,5),(161,445,1),(161,446,2),(161,447,3),(161,448,4),(161,449,5),(161,450,6),(162,445,5),(162,446,4),(162,451,1),(162,452,2),(162,453,3),(162,454,6),(163,451,5),(163,452,4),(163,455,1),(163,456,2),(163,457,3),(163,458,6),(164,455,5),(164,456,4),(164,459,1),(164,460,2),(164,461,3),(165,459,5),(165,460,4),(165,462,1),(165,463,2),(165,464,3),(166,462,5),(166,463,4),(166,465,1),(166,466,2),(166,467,3),(167,434,7),(167,468,1),(167,469,2),(167,470,3),(167,471,4),(167,472,5),(167,473,6),(168,433,1),(168,441,2),(169,434,1),(169,457,2),(170,435,1),(170,453,2),(171,436,1),(171,448,2),(172,461,2),(172,468,1),(173,464,2),(173,469,1),(174,467,2),(174,470,1),(175,474,1),(175,475,2),(175,476,3),(175,477,4),(175,478,5),(175,479,6),(175,480,7),(175,481,8),(175,482,9),(175,483,10),(175,484,11),(175,485,12),(176,477,1),(176,486,2),(176,487,3),(176,488,4),(176,489,5),(176,490,6),(176,491,7),(176,492,8),(176,493,9),(176,494,10),(177,495,1),(177,496,2),(177,497,3),(177,498,4),(177,499,5),(178,499,2),(178,500,1),(178,501,3),(178,502,4),(178,503,5),(178,504,6),(179,501,2),(179,502,1),(179,505,3),(179,506,4),(179,507,5),(179,508,6),(180,509,1),(180,510,2),(180,511,3),(180,512,4),(180,513,5),(180,514,6),(181,509,6),(181,510,5),(181,515,1),(181,516,2),(181,517,3),(181,518,4),(182,515,6),(182,516,5),(182,519,1),(182,520,2),(182,521,3),(182,522,4),(183,519,6),(183,520,5),(183,523,1),(183,524,2),(183,525,3),(183,526,4),(184,527,1),(184,528,2),(184,529,3),(184,530,4),(184,531,5),(184,532,6),(185,527,4),(185,528,3),(185,533,1),(185,534,2),(185,535,5),(185,536,6),(186,476,1),(186,496,2),(187,477,1),(187,517,2),(188,480,1),(188,518,2),(189,479,1),(189,504,2),(190,480,1),(190,503,2),(191,480,1),(191,514,2),(192,483,1),(192,513,2),(193,481,1),(193,508,2),(194,482,1),(194,507,2),(195,486,1),(195,522,2),(196,488,1),(196,521,2),(197,487,1),(197,531,2),(198,489,1),(198,532,2),(199,490,1),(199,535,2),(200,491,1),(200,536,2),(201,489,1),(201,526,2),(202,492,1),(202,525,2);
/*!40000 ALTER TABLE `Waypoint` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-12 16:41:27
