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
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_idx` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime DEFAULT NULL,
  `last_modified_date` datetime DEFAULT NULL,
  `comment_cnt` int DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `img_path` varchar(255) DEFAULT NULL,
  `like_cnt` int DEFAULT NULL,
  `report_cnt` int DEFAULT NULL,
  `running_time` int DEFAULT NULL,
  `recipe_idx` bigint DEFAULT NULL,
  `user_idx` bigint DEFAULT NULL,
  `resized_img_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`review_idx`),
  KEY `FKtjap0xxrvokqvyhf5lik7ylyc` (`recipe_idx`),
  KEY `FKm5cd0xpkolu4skvx00yqhusgv` (`user_idx`),
  CONSTRAINT `FKm5cd0xpkolu4skvx00yqhusgv` FOREIGN KEY (`user_idx`) REFERENCES `user` (`user_idx`),
  CONSTRAINT `FKtjap0xxrvokqvyhf5lik7ylyc` FOREIGN KEY (`recipe_idx`) REFERENCES `recipe` (`recipe_idx`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (129,'2023-04-05 21:54:40','2023-04-05 21:54:40',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/851e95d7-56fe-4bc0-96c8-89344b730298image_picker_87D7C7BA-4618-42C0-80D5-6D716AEE4959-2257-000001088BCFC0B7.jpg',0,0,0,25,1,NULL),(130,'2023-04-05 21:55:18','2023-04-05 21:55:18',0,'ㅇ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/0b1a5e8f-da38-444d-bbe1-1b396700e74eimage_picker_2F1FEBFB-6038-4CA5-B105-95D23928ADEA-2257-00000108C7F62235.jpg',0,0,0,25,1,NULL),(136,'2023-04-06 10:42:59','2023-04-06 10:42:59',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/a50c0a79-8afb-4b1d-b97d-dfa8d1704861image_picker_4ED9DCA5-38A2-4B73-B7F7-307E6022C5F2-2968-0000018532FF80BD.jpg',0,0,0,44,1,NULL),(137,'2023-04-06 11:06:33','2023-04-06 11:06:33',0,'ㅈ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/aac51c08-fa0d-40d5-9632-e7ad0395972aimage_picker_7121AAAE-2AFF-476F-87AD-BF169A14B3D6-2999-00000188C4FD2380.jpg',0,0,0,44,1,NULL),(138,'2023-04-06 11:15:10','2023-04-06 11:15:10',0,'ㅂ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/93245e86-2d86-4a95-8a28-9f4869922d6eimage_picker_BD281FFE-9CDD-473D-8B5C-D0C461909D92-2999-00000189EE775EDC.jpg',0,0,0,14,1,NULL),(139,'2023-04-06 11:19:15','2023-04-06 11:19:15',0,'review test 20','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/493b1875-4268-416d-a2e9-db76a41942b827.jpg',0,0,25,22,1,NULL),(140,'2023-04-06 11:19:19','2023-04-06 11:19:19',0,'review test 20','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/ca186465-e13d-4bc8-a892-ddb8a82240e927.jpg',0,0,25,22,1,NULL),(141,'2023-04-06 11:20:03','2023-04-06 11:20:03',0,'review test 20','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/fd3321aa-6320-444d-bc99-e3fe1340c04erhdydfid.jpg',0,0,25,22,1,NULL),(142,'2023-04-06 11:22:13','2023-04-06 11:22:13',0,'ㅂ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/10c1e244-cc9c-4bc7-88e5-155287d394f0image_picker_803152A5-372C-4454-9897-E851A7981B60-2999-0000018A8AE5D4D0.jpg',0,0,0,14,1,NULL),(143,'2023-04-06 11:22:56','2023-04-06 11:22:56',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/14ce3229-8942-454b-8ac5-e81c5f9fa64aimage_picker_72BDEC88-3C60-43CA-A895-7DDEB71941D3-2999-0000018AC7128BFD.jpg',0,0,0,14,1,NULL),(144,'2023-04-06 11:23:50','2023-04-06 11:23:50',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/114323fb-510f-484d-b657-69045d936428image_picker_9F9D85CF-E184-4EBE-8D69-693AC1BDE5DB-2999-0000018B1437640A.jpg',0,0,0,14,1,NULL),(145,'2023-04-06 11:24:28','2023-04-06 11:24:28',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/2f5934ed-be11-403e-9b80-4ac433a503a9image_picker_047B9D31-4F1C-40F3-9EAA-D9E98A6A7D75-2999-0000018B481AA66C.jpg',0,0,0,14,1,NULL),(146,'2023-04-06 11:25:09','2023-04-06 11:25:09',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/03e695a9-7dc1-4351-83d8-d71e1b3a7dcbimage_picker_9C188034-8B73-4614-AEBF-ABC92C6246D6-2999-0000018B835635F8.jpg',0,0,0,14,1,NULL),(147,'2023-04-06 11:26:12','2023-04-06 11:26:12',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/374a5128-018e-4e4e-a966-0512bb2ae7ddimage_picker_0285BEDA-2B9F-494E-8D07-48EC9082CC05-2999-0000018BDDCEDE1A.jpg',0,0,0,14,1,NULL),(148,'2023-04-06 11:27:33','2023-04-06 11:27:33',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/de5dc9b9-f43a-49c9-ab8a-b1248e2102cfimage_picker_15758E6F-18F1-4A6E-AA78-46524842548E-2999-0000018C51DB510F.jpg',0,0,0,14,1,NULL),(149,'2023-04-06 11:28:08','2023-04-06 11:28:08',0,'ㄱ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/616ded7b-c65c-4550-afcf-f6facd77ab69image_picker_EAD21104-CDA7-4632-B638-9D9C403CF2A3-2999-0000018C85ECE241.jpg',0,0,0,6,1,NULL),(150,'2023-04-06 11:28:38','2023-04-06 11:28:38',0,'ㄴ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/6f80aca8-a39e-4f46-b745-065711b9e413image_picker_1C6E48B1-C004-4CAB-9A89-D05A5C344943-2999-0000018CAFA648DB.jpg',0,0,0,20,1,NULL),(151,'2023-04-06 11:29:56','2023-04-06 11:29:56',0,'ㅁㄴㅁㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/9069cdcd-6faa-45c9-bac4-2649663d57fcimage_picker_B88A7CF0-DEBA-4E31-B3E8-6F6323288B4F-2999-0000018D1F6D0B2B.jpg',0,0,0,20,1,NULL),(152,'2023-04-06 11:30:15','2023-04-06 11:30:15',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/68004c95-ab12-4c0d-997f-b677789cb00eimage_picker_8D5646C4-4211-4BD2-9AB6-BF9D96B0FDFA-2999-0000018D3ABA2C86.jpg',0,0,0,20,1,NULL),(153,'2023-04-06 12:47:25','2023-04-06 12:47:25',0,'ㅂ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/ed9dca4d-b500-47db-8fee-33cd8cf986bdimage_picker_392993C3-985F-4214-B985-874F7F57BE03-3061-000001945A17F0EB.jpg',0,0,0,28,1,NULL),(154,'2023-04-06 12:53:51','2023-04-06 12:53:51',0,'ㅁ','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/998608e8-e655-4dea-a7bc-fd5231e47841image_picker_F7B7AF49-ACB6-4E97-A278-B383ED2E711C-3061-000001955619F5E9.jpg',0,0,0,28,1,NULL),(155,'2023-04-06 12:54:08','2023-04-06 12:54:08',0,'저녁 요리로 딱이에요','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/4ba349d3-1a3a-4428-beca-f4de528ef424%EC%A0%9C%EC%9C%A1%EB%B3%B6%EC%9D%8C.jpg',0,0,0,28,1,NULL),(156,'2023-04-06 12:54:27','2023-04-06 12:54:27',0,'너무 맛있어요','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/26731ea8-d967-4af8-aa4a-c91b7682428f%EB%93%A4%EA%B9%A8%EC%B9%BC%EA%B5%AD%EC%88%98.jpg',0,0,0,14,1,NULL),(157,'2023-04-06 12:54:49','2023-04-06 12:54:49',0,'어려울줄 알았는데 너무 쉬워요','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/1c9f1510-d1ef-11ed-8179-f787a595249b%EC%9C%A11.jpg',0,0,0,14,1,NULL),(159,'2023-04-06 14:17:34','2023-04-06 14:17:34',0,'좋네요','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/4675346a-8f65-4a86-aacb-2ac80fb909edimage_picker_38D49D0D-68D5-403A-B486-23C8DF0B7B51-6347-0000052ED7ED2FC0.jpg',0,0,-1,52,4,NULL),(160,'2023-04-06 15:00:33','2023-04-06 15:00:33',0,'굿','https://cocookproject.s3.ap-northeast-2.amazonaws.com/images/ee539e63-e9eb-4899-9d4a-291e549e9f05image_picker_49BAB724-57F9-44DE-8750-3AA87C374763-6469-0000053A9297E7D0.jpg',0,0,-1,52,4,NULL);
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
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

-- Dump completed on 2023-04-06 15:56:06
