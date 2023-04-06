-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: database-1.ci2hp2jo8ok0.ap-northeast-2.rds.amazonaws.com    Database: cocook
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `theme`
--

DROP TABLE IF EXISTS `theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `theme` (
  `theme_idx` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime DEFAULT NULL,
  `last_modified_date` datetime DEFAULT NULL,
  `img_path` varchar(255) DEFAULT NULL,
  `theme_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`theme_idx`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme`
--

LOCK TABLES `theme` WRITE;
/*!40000 ALTER TABLE `theme` DISABLE KEYS */;
INSERT INTO `theme` VALUES (1,'2023-03-22 20:47:32','2023-03-22 20:47:32','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/201b1929-dd0d-4312-9616-4c71b45cd1f3%EC%95%84%EC%B9%A8.jpg','아침'),(2,'2023-03-22 20:48:43','2023-03-22 20:48:43','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/e28e0c8c-779d-4f51-82b5-be165fc59256%EC%A0%90%EC%8B%AC.jpg','점심'),(3,'2023-03-22 20:50:19','2023-03-22 20:50:19','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/ea55970c-7a30-4c18-a15b-1a2ab2785265%EC%A0%80%EB%85%81.jpg','저녁'),(4,'2023-03-22 20:50:30','2023-03-22 20:50:30','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/deb24276-fe33-4135-bfea-2632debfbaca%EC%95%BC%EC%8B%9D.jpg','야식'),(5,'2023-03-22 20:50:49','2023-03-22 20:50:49','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/5c2cc4e1-a6db-4efe-8852-23fc60a1c63c%EA%B1%B4%EA%B0%95%ED%95%9C%20%EB%A8%B9%EA%B1%B0%EB%A6%AC.jpg','건강한 먹거리'),(6,'2023-03-22 20:51:00','2023-03-22 20:51:00','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/400d5ca4-b231-4f56-8140-fbe404f6e9f7%EA%B8%B0%EB%8B%A4%EB%A6%AC%20%EA%B3%A0%EA%B8%B0%20%EB%8B%A4%EB%A0%B8%EC%96%B4.jpg','기다리 고기\n다렸어'),(7,'2023-03-22 20:51:18','2023-03-22 20:51:18','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/6ccb3b0a-78dc-46cf-966d-86becbba01cd%EB%A7%A4%EC%BD%A4%ED%95%9C%EA%B2%8C%20%EB%8B%B9%EA%B8%B0%EB%8A%94%20%EB%82%A0%EC%97%94.jpg','매콤한게 \n당기는 날엔'),(8,'2023-03-22 20:51:28','2023-03-22 20:51:28','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/9d9df678-a9df-44ea-9c66-64913b042dc4%EB%B0%94%EC%82%AD%ED%95%9C%20%ED%8A%80%EA%B9%80%20%EC%9A%94%EB%A6%AC.jpg','바삭한 튀김 요리'),(9,'2023-03-22 20:51:34','2023-03-22 20:51:34','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/81f852ec-821a-49f6-a314-12fc5fa0c46b%EC%88%A0%EA%B3%BC%20%EC%96%B4%EC%9A%B8%EB%A6%AC%EB%8A%94%20%EC%95%88%EC%A3%BC.jpg','술과 어울리는 \n안주'),(10,'2023-03-22 20:51:43','2023-03-22 20:51:43','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/bca24d8d-84e6-4685-8270-9ee89d35eb91%EC%8B%9C%EC%9B%90%ED%95%9C%20%EA%B5%AD%EB%AC%BC%20%EC%9A%94%EB%A6%AC.jpg','시원한 국물 요리');
/*!40000 ALTER TABLE `theme` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-06 15:56:02
