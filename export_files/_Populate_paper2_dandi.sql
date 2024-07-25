--
-- SPYGLASS VERSION: 0.5.0a2 --
--
CREATE DATABASE IF NOT EXISTS common_dandi; USE common_dandi;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_dandi
-- ------------------------------------------------------
-- Server version	8.0.34

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
-- Table structure for table `dandi_path`
--

DROP TABLE IF EXISTS `dandi_path`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dandi_path` (
  `export_id` int NOT NULL,
  `file_id` int NOT NULL,
  `dandiset_id` varchar(16) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `dandi_path` varchar(255) NOT NULL,
  `dandi_instance` varchar(32) NOT NULL DEFAULT 'dandi',
  PRIMARY KEY (`export_id`,`file_id`),
  CONSTRAINT `dandi_path_ibfk_1` FOREIGN KEY (`export_id`, `file_id`) REFERENCES `common_usage`.`__export__file` (`export_id`, `file_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dandi_path`
--
-- WHERE:  	((export_id=13))

LOCK TABLES `dandi_path` WRITE;
/*!40000 ALTER TABLE `dandi_path` DISABLE KEYS */;
INSERT INTO `dandi_path` VALUES (13,0,'213890','Winnie20220717_0LIY3FNTHB.nwb','sub-Winnie/sub-Winnie_obj-l69f2s.nwb','dandi-staging'),(13,1,'213890','Winnie20220717_5NULDSRNSZ.nwb','sub-Winnie/sub-Winnie_obj-g1avof.nwb','dandi-staging'),(13,2,'213890','Winnie20220717_193LTSHLIH.nwb','sub-Winnie/sub-Winnie_obj-1343lik.nwb','dandi-staging'),(13,4,'213890','Winnie20220717_1IIQZYXGW9.nwb','sub-Winnie/sub-Winnie_obj-168zlj1.nwb','dandi-staging'),(13,5,'213890','Winnie20220717_006OFVI0MG.nwb','sub-Winnie/sub-Winnie_obj-1w3pie7.nwb','dandi-staging');
/*!40000 ALTER TABLE `dandi_path` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-23  8:59:01
