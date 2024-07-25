--
-- SPYGLASS VERSION: 0.5.0a2 --
--
CREATE DATABASE IF NOT EXISTS common_behav; USE common_behav;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_behav
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
-- Table structure for table `_raw_position`
--

DROP TABLE IF EXISTS `_raw_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_raw_position` (
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `interval_list_name` varchar(200) NOT NULL COMMENT 'descriptive name of this interval list',
  PRIMARY KEY (`nwb_file_name`,`interval_list_name`),
  CONSTRAINT `_raw_position_ibfk_1` FOREIGN KEY (`nwb_file_name`, `interval_list_name`) REFERENCES `position_source` (`nwb_file_name`, `interval_list_name`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_raw_position`
--
-- WHERE:  	((nwb_file_name='Banner20211227_.nwb') 	AND (interval_list_name='pos 1 valid times'))

LOCK TABLES `_raw_position` WRITE;
/*!40000 ALTER TABLE `_raw_position` DISABLE KEYS */;
INSERT INTO `_raw_position` VALUES ('Banner20211227_.nwb','pos 1 valid times');
/*!40000 ALTER TABLE `_raw_position` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_behav
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
-- Table structure for table `position_source`
--

DROP TABLE IF EXISTS `position_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `position_source` (
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `interval_list_name` varchar(200) NOT NULL COMMENT 'descriptive name of this interval list',
  `source` varchar(200) NOT NULL COMMENT 'source of data; current options are "trodes" and "dlc" (deep lab cut)',
  `import_file_name` varchar(2000) NOT NULL COMMENT 'path to import file if importing position data',
  PRIMARY KEY (`nwb_file_name`,`interval_list_name`),
  CONSTRAINT `position_source_ibfk_1` FOREIGN KEY (`nwb_file_name`) REFERENCES `common_session`.`_session` (`nwb_file_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `position_source_ibfk_2` FOREIGN KEY (`nwb_file_name`, `interval_list_name`) REFERENCES `common_interval`.`interval_list` (`nwb_file_name`, `interval_list_name`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `position_source`
--
-- WHERE:  	((nwb_file_name='Banner20211227_.nwb') 	AND (interval_list_name='pos 1 valid times'))

LOCK TABLES `position_source` WRITE;
/*!40000 ALTER TABLE `position_source` DISABLE KEYS */;
INSERT INTO `position_source` VALUES ('Banner20211227_.nwb','pos 1 valid times','trodes','');
/*!40000 ALTER TABLE `position_source` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
CREATE DATABASE IF NOT EXISTS common_interval; USE common_interval;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_interval
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
-- Table structure for table `interval_list`
--

DROP TABLE IF EXISTS `interval_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interval_list` (
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `interval_list_name` varchar(200) NOT NULL COMMENT 'descriptive name of this interval list',
  `valid_times` longblob NOT NULL COMMENT 'numpy array with start/end times for each interval',
  `pipeline` varchar(64) NOT NULL DEFAULT '' COMMENT 'type of interval list (e.g. ''position'', ''spikesorting_recording_v1'')',
  PRIMARY KEY (`nwb_file_name`,`interval_list_name`),
  CONSTRAINT `interval_list_ibfk_1` FOREIGN KEY (`nwb_file_name`) REFERENCES `common_session`.`_session` (`nwb_file_name`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Time intervals used for analysis';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interval_list`
--
-- WHERE:  	((nwb_file_name='Banner20211227_.nwb') 	AND (interval_list_name='pos 1 valid times'))

LOCK TABLES `interval_list` WRITE;
/*!40000 ALTER TABLE `interval_list` DISABLE KEYS */;
INSERT INTO `interval_list` VALUES ('Banner20211227_.nwb','pos 1 valid times',_binary 'mYm\0A\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0©\À_ír\ÿA1±åìr\ÿA','');
/*!40000 ALTER TABLE `interval_list` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
CREATE DATABASE IF NOT EXISTS common_lab; USE common_lab;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_lab
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
-- Table structure for table `institution`
--

DROP TABLE IF EXISTS `institution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `institution` (
  `institution_name` varchar(80) NOT NULL,
  PRIMARY KEY (`institution_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `institution`
--
-- WHERE:  	((institution_name='University of California, San Francisco'))

LOCK TABLES `institution` WRITE;
/*!40000 ALTER TABLE `institution` DISABLE KEYS */;
INSERT INTO `institution` VALUES ('University of California, San Francisco');
/*!40000 ALTER TABLE `institution` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_lab
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
-- Table structure for table `lab`
--

DROP TABLE IF EXISTS `lab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab` (
  `lab_name` varchar(80) NOT NULL,
  PRIMARY KEY (`lab_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab`
--
-- WHERE:  	((lab_name='Loren Frank'))

LOCK TABLES `lab` WRITE;
/*!40000 ALTER TABLE `lab` DISABLE KEYS */;
INSERT INTO `lab` VALUES ('Loren Frank');
/*!40000 ALTER TABLE `lab` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
CREATE DATABASE IF NOT EXISTS common_nwbfile; USE common_nwbfile;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_nwbfile
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
-- Table structure for table `analysis_nwbfile`
--

DROP TABLE IF EXISTS `analysis_nwbfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analysis_nwbfile` (
  `analysis_file_name` varchar(255) NOT NULL COMMENT 'name of the file',
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `analysis_file_abs_path` binary(16) NOT NULL COMMENT ':filepath@analysis:the full path to the file',
  `analysis_file_description` varchar(2000) NOT NULL DEFAULT '' COMMENT 'an optional description of this analysis',
  `analysis_parameters` blob COMMENT 'additional relevant parmeters. Currently used only for analyses',
  PRIMARY KEY (`analysis_file_name`),
  KEY `nwb_file_name` (`nwb_file_name`),
  KEY `analysis_file_abs_path` (`analysis_file_abs_path`),
  CONSTRAINT `analysis_nwbfile_ibfk_1` FOREIGN KEY (`nwb_file_name`) REFERENCES `nwbfile` (`nwb_file_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `analysis_nwbfile_ibfk_2` FOREIGN KEY (`analysis_file_abs_path`) REFERENCES `~external_analysis` (`hash`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table for holding the NWB files that contain results of analysis, such as spike sorting.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analysis_nwbfile`
--
-- WHERE:  	((analysis_file_name='Banner20211227_TDQGNX2XXZ.nwb') 	OR  (analysis_file_name='Banner20211227_ET6EXYMBNG.nwb'))

LOCK TABLES `analysis_nwbfile` WRITE;
/*!40000 ALTER TABLE `analysis_nwbfile` DISABLE KEYS */;
INSERT INTO `analysis_nwbfile` VALUES ('Banner20211227_ET6EXYMBNG.nwb','Banner20211227_.nwb',_binary '\ZuùÄ~õ¿ m…¶ôÑ','',NULL),('Banner20211227_TDQGNX2XXZ.nwb','Banner20211227_.nwb',_binary '§îê¢æ\—v	Ç/Ü\Ï‹å\«','',NULL);
/*!40000 ALTER TABLE `analysis_nwbfile` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_nwbfile
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
-- Table structure for table `nwbfile`
--

DROP TABLE IF EXISTS `nwbfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nwbfile` (
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `nwb_file_abs_path` binary(16) NOT NULL COMMENT ':filepath@raw:',
  PRIMARY KEY (`nwb_file_name`),
  KEY `nwb_file_abs_path` (`nwb_file_abs_path`),
  CONSTRAINT `nwbfile_ibfk_1` FOREIGN KEY (`nwb_file_abs_path`) REFERENCES `~external_raw` (`hash`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table for holding the NWB files.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nwbfile`
--
-- WHERE:  	((nwb_file_name='Banner20211227_.nwb'))

LOCK TABLES `nwbfile` WRITE;
/*!40000 ALTER TABLE `nwbfile` DISABLE KEYS */;
INSERT INTO `nwbfile` VALUES ('Banner20211227_.nwb',_binary 'Ç0<\Ÿ]∫Ω.:Çp4?Å⁄Æ');
/*!40000 ALTER TABLE `nwbfile` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
CREATE DATABASE IF NOT EXISTS common_session; USE common_session;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_session
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
-- Table structure for table `_session`
--

DROP TABLE IF EXISTS `_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_session` (
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `subject_id` varchar(80) DEFAULT NULL,
  `institution_name` varchar(80) DEFAULT NULL,
  `lab_name` varchar(80) DEFAULT NULL,
  `session_id` varchar(200) DEFAULT NULL,
  `session_description` varchar(2000) NOT NULL,
  `session_start_time` datetime NOT NULL,
  `timestamps_reference_time` datetime NOT NULL,
  `experiment_description` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`nwb_file_name`),
  KEY `subject_id` (`subject_id`),
  KEY `institution_name` (`institution_name`),
  KEY `lab_name` (`lab_name`),
  CONSTRAINT `_session_ibfk_1` FOREIGN KEY (`nwb_file_name`) REFERENCES `common_nwbfile`.`nwbfile` (`nwb_file_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `_session_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `common_subject`.`subject` (`subject_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `_session_ibfk_3` FOREIGN KEY (`institution_name`) REFERENCES `common_lab`.`institution` (`institution_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `_session_ibfk_4` FOREIGN KEY (`lab_name`) REFERENCES `common_lab`.`lab` (`lab_name`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table for holding experimental sessions.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_session`
--
-- WHERE:  	((nwb_file_name='Banner20211227_.nwb'))

LOCK TABLES `_session` WRITE;
/*!40000 ALTER TABLE `_session` DISABLE KEYS */;
INSERT INTO `_session` VALUES ('Banner20211227_.nwb','Banner','University of California, San Francisco','Loren Frank','Banner_20211227','Medial Septal stimulation','2021-12-27 14:13:16','1970-01-01 00:00:00','Medial Septal rhythmic and theta phase specific stimulation');
/*!40000 ALTER TABLE `_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
CREATE DATABASE IF NOT EXISTS common_subject; USE common_subject;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: common_subject
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
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `subject_id` varchar(80) NOT NULL,
  `age` varchar(200) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `genotype` varchar(2000) DEFAULT NULL,
  `sex` enum('M','F','U') NOT NULL DEFAULT 'U',
  `species` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject`
--
-- WHERE:  	((subject_id='Banner'))

LOCK TABLES `subject` WRITE;
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
INSERT INTO `subject` VALUES ('Banner',NULL,'Long Evans Rat','PV+ Cre','M','Rat');
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
CREATE DATABASE IF NOT EXISTS position_v1_trodes_position; USE position_v1_trodes_position;
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: position_v1_trodes_position
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
-- Table structure for table `__trodes_pos_v1`
--

DROP TABLE IF EXISTS `__trodes_pos_v1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `__trodes_pos_v1` (
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `interval_list_name` varchar(200) NOT NULL COMMENT 'descriptive name of this interval list',
  `trodes_pos_params_name` varchar(80) NOT NULL COMMENT 'name for this set of parameters',
  `analysis_file_name` varchar(255) NOT NULL COMMENT 'name of the file',
  `position_object_id` varchar(80) NOT NULL,
  `orientation_object_id` varchar(80) NOT NULL,
  `velocity_object_id` varchar(80) NOT NULL,
  PRIMARY KEY (`nwb_file_name`,`interval_list_name`,`trodes_pos_params_name`),
  KEY `analysis_file_name` (`analysis_file_name`),
  CONSTRAINT `__trodes_pos_v1_ibfk_1` FOREIGN KEY (`nwb_file_name`, `interval_list_name`, `trodes_pos_params_name`) REFERENCES `trodes_pos_selection` (`nwb_file_name`, `interval_list_name`, `trodes_pos_params_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `__trodes_pos_v1_ibfk_2` FOREIGN KEY (`analysis_file_name`) REFERENCES `common_nwbfile`.`analysis_nwbfile` (`analysis_file_name`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `__trodes_pos_v1`
--
-- WHERE:  	(((nwb_file_name LIKE '%%%%%%%%Ban%%%%%%%%21%%%%%%%%27%%%%%%%%'))) 	AND (((interval_list_name LIKE '%%%%%%%%1%%%%%%%%')))

LOCK TABLES `__trodes_pos_v1` WRITE;
/*!40000 ALTER TABLE `__trodes_pos_v1` DISABLE KEYS */;
INSERT INTO `__trodes_pos_v1` VALUES ('Banner20211227_.nwb','pos 1 valid times','single_led','Banner20211227_TDQGNX2XXZ.nwb','b0f7e5f0-db64-43a4-a474-6848904d03c3','3453f624-886a-4c63-90ca-bbf374f1fa74','dcddc5bb-7364-4985-a686-25c46c071cca'),('Banner20211227_.nwb','pos 1 valid times','single_led_upsampled','Banner20211227_ET6EXYMBNG.nwb','9af51aaf-ae63-40b9-af6d-b3a33a5c2f61','20442dd5-5517-4774-ae91-2ea18806f6d3','ef2b5737-2e90-48eb-afb8-6aeb816ff8ed');
/*!40000 ALTER TABLE `__trodes_pos_v1` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: position_v1_trodes_position
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
-- Table structure for table `trodes_pos_params`
--

DROP TABLE IF EXISTS `trodes_pos_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trodes_pos_params` (
  `trodes_pos_params_name` varchar(80) NOT NULL COMMENT 'name for this set of parameters',
  `params` longblob NOT NULL,
  PRIMARY KEY (`trodes_pos_params_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trodes_pos_params`
--
-- WHERE:  	((trodes_pos_params_name='single_led_upsampled') 	OR  (trodes_pos_params_name='single_led'))

LOCK TABLES `trodes_pos_params` WRITE;
/*!40000 ALTER TABLE `trodes_pos_params` DISABLE KEYS */;
INSERT INTO `trodes_pos_params` VALUES ('single_led',_binary 'dj0\0	\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0max_separation	\0\0\0\0\0\0\0\r\0\0\0\0\0à\√@\0\0\0\0\0\0\0	\0\0\0\0\0\0\0max_speed	\0\0\0\0\0\0\0\r\0\0\0\0\0¿r@$\0\0\0\0\0\0\0\0\0\0\0\0\0\0position_smoothing_duration	\0\0\0\0\0\0\0\r\0\0\0\0\0\0¿? \0\0\0\0\0\0\0\0\0\0\0\0\0\0speed_smoothing_std_dev	\0\0\0\0\0\0\0\röôôôôôπ?!\0\0\0\0\0\0\0\0\0\0\0\0\0\0orient_smoothing_std_dev	\0\0\0\0\0\0\0\r¸©\Ò\“MbP?\0\0\0\0\0\0\0\r\0\0\0\0\0\0\0led1_is_front\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0is_upsampled\0\0\0\0\0\0\0\n\0\0!\0\0\0\0\0\0\0\0\0\0\0\0\0\0upsampling_sampling_rate\0\0\0\0\0\0\0ˇ(\0\0\0\0\0\0\0\0\0\0\0\0\0\0upsampling_interpolation_method\0\0\0\0\0\0\0\0\0\0\0\0\0\0linear'),('single_led_upsampled',_binary 'dj0\0	\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0max_separation	\0\0\0\0\0\0\0\r\0\0\0\0\0à\√@\0\0\0\0\0\0\0	\0\0\0\0\0\0\0max_speed	\0\0\0\0\0\0\0\r\0\0\0\0\0¿r@$\0\0\0\0\0\0\0\0\0\0\0\0\0\0position_smoothing_duration	\0\0\0\0\0\0\0\r\0\0\0\0\0\0¿? \0\0\0\0\0\0\0\0\0\0\0\0\0\0speed_smoothing_std_dev	\0\0\0\0\0\0\0\röôôôôôπ?!\0\0\0\0\0\0\0\0\0\0\0\0\0\0orient_smoothing_std_dev	\0\0\0\0\0\0\0\r¸©\Ò\“MbP?\0\0\0\0\0\0\0\r\0\0\0\0\0\0\0led1_is_front\0\0\0\0\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0is_upsampled\0\0\0\0\0\0\0\n\0!\0\0\0\0\0\0\0\0\0\0\0\0\0\0upsampling_sampling_rate\0\0\0\0\0\0\0\n\0\Ù(\0\0\0\0\0\0\0\0\0\0\0\0\0\0upsampling_interpolation_method\0\0\0\0\0\0\0\0\0\0\0\0\0\0linear');
/*!40000 ALTER TABLE `trodes_pos_params` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:42
-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: 172.17.0.1    Database: position_v1_trodes_position
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
-- Table structure for table `trodes_pos_selection`
--

DROP TABLE IF EXISTS `trodes_pos_selection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trodes_pos_selection` (
  `nwb_file_name` varchar(255) NOT NULL COMMENT 'name of the NWB file',
  `interval_list_name` varchar(200) NOT NULL COMMENT 'descriptive name of this interval list',
  `trodes_pos_params_name` varchar(80) NOT NULL COMMENT 'name for this set of parameters',
  PRIMARY KEY (`nwb_file_name`,`interval_list_name`,`trodes_pos_params_name`),
  KEY `trodes_pos_params_name` (`trodes_pos_params_name`),
  CONSTRAINT `trodes_pos_selection_ibfk_1` FOREIGN KEY (`nwb_file_name`, `interval_list_name`) REFERENCES `common_behav`.`_raw_position` (`nwb_file_name`, `interval_list_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `trodes_pos_selection_ibfk_2` FOREIGN KEY (`trodes_pos_params_name`) REFERENCES `trodes_pos_params` (`trodes_pos_params_name`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trodes_pos_selection`
--
-- WHERE:  	((nwb_file_name='Banner20211227_.nwb') 	AND (interval_list_name='pos 1 valid times') 	AND (trodes_pos_params_name='single_led_upsampled') 	OR  (nwb_file_name='Banner20211227_.nwb') 	AND (interval_list_name='pos 1 valid times') 	AND (trodes_pos_params_name='single_led'))

LOCK TABLES `trodes_pos_selection` WRITE;
/*!40000 ALTER TABLE `trodes_pos_selection` DISABLE KEYS */;
INSERT INTO `trodes_pos_selection` VALUES ('Banner20211227_.nwb','pos 1 valid times','single_led'),('Banner20211227_.nwb','pos 1 valid times','single_led_upsampled');
/*!40000 ALTER TABLE `trodes_pos_selection` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-22 14:08:43
