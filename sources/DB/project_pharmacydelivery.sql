-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: project_pharmacydelivery
-- ------------------------------------------------------
-- Server version	8.0.22

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

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `addressId` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `addressDetail` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `tel` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `status` varchar(1) COLLATE utf8_unicode_ci NOT NULL,
  `MemberUsername` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`addressId`),
  KEY `address_ibfk_1` (`MemberUsername`),
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`MemberUsername`) REFERENCES `member` (`MemberUsername`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES ('100','กานดา จริงใจ','34 ม.1 ต.หนองหาร อ.สันทราข จ.เชีบงใหม่ 50290','0867465572','T','kanda123'),('101','มานี รานี','12 ม.2 ต.หนองหาร อ.สันทราข จ.เชีบงใหม่ 50290','0978566641','F','manee123'),('102','สมชาย มุ่งมานะ','45 ม.5 ต.หนองหาร อ.สันทราข จ.เชีบงใหม่ 50290','0875689900','T','somchai'),('103','นครินร์ มุ่งมานะใจ','77/1 ม.3 ต.หนองหาร อ.สันทราข จ.เชีบงใหม่ 50290','0653546619','T','nk12345'),('104','ธนาการ ถาวร','30/9 ซ.32 ต.หนองหาร อ.สันทราน จ.เชียงใหม่ 50290','0874523695','T','manee123'),('105','มาก ณ อยุธยา','32 ม.5 ต.หนองหาร อ.สันทราย จ.เชียงใหม่ 50290','0824586632','T','mark12'),('106','nateerat chokdee','5/90 ต.นคร อ.สิงราช จ.ตรัง 90758','0874522236','T','nateerat'),('107','yyyy uuu','wer ต.wrt อ.ufd จ.ry 12236','0816599460','T','user02'),('108','test teset','7/11 ต.โนริ อ.ปากข่อง จ.ตรัง 60425','0845783333','T','test'),('109','sa rah','3/7 ต.หนองหาร อ.สันทราย จ.เชียงใหม่ 50290','0845588888','T','sa123'),('110','test tt','33 ต.หนอง อ.สันทราย จ.เชียงใหม่ 50290','0975677785','T','sa123'),('111','มานี รานี','dd ต.ddd อ.ccc จ.ccc 55555','0978566641','T','manee123'),('112','yมานี รานี','yy ต.tt อ.yy จ.tt 22222','0978566641','T','manee123'),('113','มานี รานี','rr ต.ss อ.ww จ.dd 22222','0978566641','T','manee123'),('114','fมานี รานี','00 ต.pp อ.ppp จ.ppp 99999','0978562222','T','manee123'),('115','iii ooo','jjjj ต.rrrr อ.sssdd จ.ff 22222','0978566641','T','manee123'),('116','มานี รานี','66y ต.yyyyy อ.tt จ.rr 11111','0978566641','T','manee123'),('117','มานี รานี','23 ต.nonghan อ.sansai จ.chiangmai 50290','0978566641','T','manee123');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `advice`
--

DROP TABLE IF EXISTS `advice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `advice` (
  `adviceId` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `startTime` datetime NOT NULL,
  `endTime` datetime DEFAULT NULL,
  `pharmacistID` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `MemberUsername` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `orderId` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`adviceId`),
  KEY `fk_Advice_Order1_idx` (`orderId`),
  KEY `fk_Advice_Pharmacist1` (`pharmacistID`),
  KEY `advice_ibfk_1` (`MemberUsername`),
  CONSTRAINT `advice_ibfk_1` FOREIGN KEY (`MemberUsername`) REFERENCES `member` (`MemberUsername`),
  CONSTRAINT `fk_Advice_Order1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`orderId`),
  CONSTRAINT `fk_Advice_Pharmacist1` FOREIGN KEY (`pharmacistID`) REFERENCES `pharmacist` (`pharmacistID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `advice`
--

LOCK TABLES `advice` WRITE;
/*!40000 ALTER TABLE `advice` DISABLE KEYS */;
INSERT INTO `advice` VALUES ('101','2564-10-03 11:17:00','2565-10-02 16:27:37','60001','manee123','50001'),('102','2564-10-14 11:17:00','2564-10-03 11:17:20','60001','manee123','50002'),('103','2565-10-10 15:24:17','2565-10-10 15:26:34','60001','mark12','50003'),('104','2565-10-10 15:27:56','2565-10-10 15:29:55','60001','mark12','50004'),('105','2565-10-10 15:31:50','2565-10-10 15:33:27','60001','manee123','50005'),('106','2565-10-10 15:51:53','2565-10-10 15:52:20','60001','manee123','50006'),('107','2565-10-10 15:52:33','2565-10-10 15:53:10','60001','manee123','50007'),('108','2565-10-10 16:08:50','2565-10-10 16:14:26','60003','manee123','50008'),('109','2565-10-10 16:16:59','2565-10-10 16:17:51','60003','kanda123','50009'),('110','2565-10-10 16:20:35','2565-10-10 16:23:41','60003','nateerat','50010'),('111','2565-10-10 16:33:34','2565-10-10 16:34:10','60003','manee123','50011'),('112','2565-10-10 16:35:18','2565-10-10 16:36:29','60001','kanda123',NULL),('113','2565-10-10 16:36:32','2565-10-10 16:38:07','60001','kanda123','50012'),('114','2565-10-10 16:39:19','2565-10-10 16:39:47','60001','kanda123','50013'),('115','2565-10-10 16:40:34','2565-10-10 16:41:00','60001','manee123','50014'),('116','2565-10-10 16:41:50','2565-10-10 16:42:09','60001','manee123','50015'),('117','2565-10-10 16:43:36','2565-10-10 16:44:12','60001','mark12','50016'),('118','2565-10-10 23:47:40','2565-10-10 23:48:08','60005','user02',NULL),('119','2565-10-11 00:15:52','2565-10-11 00:18:48','60005','user02','50017'),('120','2565-10-11 00:23:40','2565-10-11 00:28:36','60005','user02','50018'),('121','2565-10-11 00:35:05',NULL,'60005','user02',NULL),('122','2565-10-11 00:49:41','2565-10-11 00:50:45','60005','kanda123',NULL),('123','2565-10-11 15:44:09','2565-10-11 15:53:07','60001','test','50019'),('124','2565-10-11 15:55:01','2565-10-11 15:57:43','60001','test','50020'),('125','2565-10-11 16:00:29','2565-10-11 16:00:33','60001','test',NULL),('126','2565-10-11 16:01:02','2565-10-11 16:01:51','60001','test','50021'),('127','2565-10-11 16:29:13','2565-10-11 16:29:47','60001','mark12','50022'),('128','2565-10-11 16:33:04','2565-10-11 16:33:32','60001','manee123','50023'),('129','2565-10-11 16:41:16','2565-10-11 16:42:14','60003','manee123','50024'),('130','2565-10-11 16:45:31','2565-10-11 16:47:30','60003','manee123','50025'),('131','2565-10-12 14:24:42','2565-10-12 14:33:00','60001','sa123','50026'),('132','2565-10-12 14:35:11','2565-10-12 14:35:37','60001','sa123',NULL),('133','2565-10-12 14:36:47','2565-10-12 14:38:35','60001','sa123','50027'),('134','2565-10-12 14:48:06','2565-10-12 15:01:11','60003','manee123','50028'),('135','2565-10-12 16:36:19','2565-10-12 17:24:57','60001','manee123',NULL),('136','2565-10-12 17:26:57','2565-10-12 17:29:31','60001','manee123',NULL),('137','2565-10-12 17:34:24','2565-10-12 17:45:06','60001','manee123',NULL),('138','2565-10-12 17:46:49','2565-10-12 18:07:20','60001','manee123','50029'),('139','2565-10-12 18:18:37','2565-10-12 18:41:39','60001','manee123','50030'),('140','2565-10-12 20:24:47','2565-10-12 20:25:55','60001','manee123','50031'),('141','2565-10-15 23:53:40',NULL,'60001','manee123',NULL),('142','2565-10-16 00:08:46','2565-10-16 00:35:36','60001','manee123','50032'),('143','2565-10-16 15:42:23','2565-10-16 15:42:30','60001','manee123',NULL),('144','2565-10-16 15:42:41','2565-10-16 15:42:47','60001','manee123',NULL),('145','2565-10-16 15:45:22','2565-10-16 15:45:34','60001','manee123','50033'),('146','2565-10-16 21:02:38','2565-10-16 21:02:41','60001','manee123',NULL),('147','2565-10-16 22:48:29','2565-10-16 22:51:11','60001','manee123',NULL),('148','2565-10-17 15:37:42','2565-10-17 15:38:47','60001','manee123','50034');
/*!40000 ALTER TABLE `advice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `couponName` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `minimumPrice` double NOT NULL,
  `discount` double NOT NULL,
  `couponQty` int NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `drugstoreID` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`couponName`),
  KEY `fk_Coupon_Drugstore1_idx` (`drugstoreID`),
  CONSTRAINT `fk_Coupon_Drugstore1` FOREIGN KEY (`drugstoreID`) REFERENCES `drugstore` (`drugstoreID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES ('Health30',250,30,100,'2565-06-01','2565-09-30','20002'),('NEWMJU',200,15,100,'2565-06-10','2566-12-30','20001'),('Pharma20',300,20,100,'2565-05-01','2566-07-01','20001'),('Sale2',400,45,100,'2565-07-02','2565-11-02','20002'),('Special',250,40,100,'2565-05-02','2565-12-31','20001');
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drugstore`
--

DROP TABLE IF EXISTS `drugstore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drugstore` (
  `drugstoreID` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `ownerid` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `drugstoreName` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `drugstoreAddress` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `drugstoreTel` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `drugstoreStatus` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `drugstoreImg` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`drugstoreID`,`ownerid`),
  KEY `fk_Drugstore_Owner1_idx` (`ownerid`),
  CONSTRAINT `fk_Drugstore_Owner1` FOREIGN KEY (`ownerid`) REFERENCES `owner` (`ownerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drugstore`
--

LOCK TABLES `drugstore` WRITE;
/*!40000 ALTER TABLE `drugstore` DISABLE KEYS */;
INSERT INTO `drugstore` VALUES ('20001','10001','V Care Pharma','50 ต.หนองหาร อ.สันทราย จ.เชียงใหม่','0816766351','t','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/drugstore%2Fdrugstore1.jpg?alt=media&token=41aa6f4d-af01-49a2-a059-936819df1a48'),('20002','10002','แม่โจ้เภสัช1','11/1 ซ.32 ต.หนองหาร อ.สันทราย จ.เชียงใหม่','0963542286','t','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/drugstore%2Fdrugstore2.png?alt=media&token=55850c4d-5df1-43d3-a1c2-8ce41b2268b1'),('20003','10003','โมโม่ฟาร์มา','21 ซ.2 ต.หนองหาร อ.สันทราย จ.เชียงใหม่','0973458812','t',NULL);
/*!40000 ALTER TABLE `drugstore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine`
--

DROP TABLE IF EXISTS `medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine` (
  `medId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `medName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `medDetail` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `medImg` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `typeId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`medId`),
  KEY `fk_Medicine_MedicineType1_idx` (`typeId`),
  CONSTRAINT `fk_Medicine_MedicineType1` FOREIGN KEY (`typeId`) REFERENCES `medicinetype` (`typeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine`
--

LOCK TABLES `medicine` WRITE;
/*!40000 ALTER TABLE `medicine` DISABLE KEYS */;
INSERT INTO `medicine` VALUES ('7001','เซตาฟิล เจนเทิล สกินคลีนเซอร์ 500 มล. Cetaphil Gentle Skin Cleanser 500 ml','ใช้กับผิวกาย และ ผิวหน้าได้','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_1.jpg?alt=media&token=0c96b30e-2bee-44fb-b13d-73a9849e1df7','2001'),('7002','ดิฟเฟอริน เจล 0.1% รักษาสิว 15 กรัม Differin Adapalene Gel 0.1% 15 g','ดิฟเฟอริน เจล 0.1% รักษาสิว 15 กรัม (Differin Adapalene Gel 0.1% 15 g)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_2.jpg?alt=media&token=fd9c7c60-c1cb-4f0f-b008-c986bf4a4b78','2001'),('7003','เซ็ท สมูทอี สำหรับผิวแพ้ง่ายและเป็นสิวง่าย Smooth E – Extra Sensitive Skincare Set','เซ็ท สมูทอี สำหรับผิวแพ้ง่ายและเป็นสิวง่าย (Smooth E – Extra Sensitive Skincare Set)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_3.jpg?alt=media&token=f9bc4471-2dd2-45c6-9de3-2630d1347e20','2001'),('7004','แคปซิกา เจล 60 กรัม Capsika Gel 60 g','แคปซิกา เจล 60 กรัม (Capsika Gel 60 g)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_4.jpg?alt=media&token=884f3de8-70a2-42bd-9b13-51a6e5585cfa','2002'),('7005','นีโอบัน พลาสเตอร์ยาบรรเทาปวด Neobun Menthol Plaster','พลาสเตอร์ยาบรรเทาปวด (Neobun Menthol Plaster)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_5.jpg?alt=media&token=cfc5d8ee-c12f-46c6-9644-87f497961821','2002'),('7006','ถุงยางอนามัย ดูเร็กซ์','ถุงยางอนามัย ดูเร็กซ์ ผ่านการตรวจสอบรอยรั่วด้วยเครื่องมืออิเล็กทรอนิกส์','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_6.jpg?alt=media&token=8783a659-6e92-4f5e-9fdb-53fe9a5e050b','2003'),('7007','ดูเร็กซ์ เพลย์ คลาสสิค เจลหล่อลื่น','เจลหล่อลื่น ดูเร็กซ์ เพลย์ คลาสสิค สูตรน้ำ เพิ่มความสมูทในทุกๆโอกาส เป็นโอกาสที่พิเศษได้...','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_7.jpg?alt=media&token=4d8acd5a-2800-4445-9333-38a2a6c46e9b','2003'),('7008','ลา โรช-โพเซย์ แบบเซตซื้อ1แถม3/La Roche-Posay Set Buy1 Get 3 Free','1ครีมกันแดด ที่แพทย์ผิวหนังในประเทศไทยแนะนำ','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_8.jpg?alt=media&token=22e0268a-5744-4739-a577-fbee6d4b01dd','2004'),('7009','ยูเซอริน สปอตเลส ไบรท์เทนนิ่ง บูสเตอร์ เซรั่ม 30 มล. Eucerin Spotless Brightening 30 ml','ยูเซอริน สปอตเลส ไบรท์เทนนิ่ง บูสเตอร์ เซรั่ม 30 มล. (Eucerin Spotless Brightening 30 ml)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_9.jpg?alt=media&token=9f625272-a533-48c8-991a-54be2d89f778','2004'),('7010','แบลคมอร์ส พรี 9 พลัส แคร์ โกลด์ 30 แคปซูล Blackmores Pre 9+ Care Glod 30 capsules','แบลคมอร์ส พรี 9 พลัส แคร์ โกลด์ 30 แคปซูล (Blackmores Pre 9+ Care Glod 30 capsules)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_10.jpg?alt=media&token=1f6f9d88-bdc5-4cb2-b475-b9a168532be6','2005'),('7011','แบลคมอร์ส แคลเซียม Blackmores Calcium (New Package)','แบลคมอร์ส แคลเซียม (Blackmores Calcium New Package)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_11.jpg?alt=media&token=dcc490ab-7496-4703-8d95-39472d77cbb9','2005'),('7012','ชุดเวชภัณฑ์ 7 รายการ Merit Medical Supply','ชุดเวชภัณฑ์ 7 รายการ','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_12.jpg?alt=media&token=21b6d471-d3d4-4adb-a650-6b54db1a7f50','2006'),('7013','เครื่องวัดออกซิเจน ปลายนิ้ว Blue Dot Pulse Oximeter รุ่น B-PO011','เครื่องวัดออกซิเจน ปลายนิ้ว (Blue Dot Pulse Oximeter รุ่น B-PO011)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_13.jpg?alt=media&token=29859ad9-97bc-44dc-a0fd-832c55c30727','2007'),('7014','เครื่องวัดออกซิเจน ปลายนิ้ว Yimi Life Fingertip Pulse Oximeter รุ่น YM201','เครื่องวัดออกซิเจน ปลายนิ้ว (Yimi Life Fingertip Pulse Oximeter รุ่น YM201)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_14.jpg?alt=media&token=8e712a8f-443a-41a5-89a3-0fa45450e83f','2007'),('7015','เอ็ม เอ็ม ยาระบาย มิลค์ ออฟ แมกนีเซีย 240 มล. MM Milk Of Magnesia Suspension 240 ml','รสมิ้นท์ แก้ท้องผูก','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_15.jpg?alt=media&token=09518327-047d-4bfc-83db-d574d817e2d9','2008'),('7016','ยาธาตุน้ำแดง ยาธาตุ 4 ตรากิเลน 300 ซี.ซี. Stomachic Mixture 4','ทิงเจอร์ขิงสกัด เข้มข้น รสหวาน ทานง่าย','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_16.jpg?alt=media&token=c359f933-4cfb-4a6b-8dd5-2fac742a2503','2008'),('7017','เมก้า ดีเอช เอ-125 และ มายบาซิน Mega DHA-125 & Mybacin Promotion','น้ำมันปลาทูน่า 500 มก.','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_17.jpg?alt=media&token=602212e4-e2f1-4a6f-91db-376168f46d7a','2009'),('7018','ยาสีฟัน เซ็นโซดายน์/Sensodyne 160g','เซ็นโซดายน์ สำหรับผู้มีอาการเสียวฟัน','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_18.jpg?alt=media&token=ed8c3519-2145-4ccf-8cd3-ae5238099a04','2009'),('7019','ยาอมมะแว้ง แก้ไอ ขับเสมหะ MA-WARNG Lozenges','ยาอมมะแว้ง แก้ไอ ขับเสมหะ','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_19.jpg?alt=media&token=02add764-272f-4c39-a984-8b95468bcc54','2010'),('7020','ยาดมตราเสือ แก้คัดจมูก Tiger Balm Inhaler','ยาดมตราเสือ แก้คัดจมูก (Tiger Balm Inhaler)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_20.jpg?alt=media&token=b5c73039-2b7c-428d-a592-5ba5e3b010d8','2010'),('7021','ชุดป้องกันสารเคมี Tyvek400','ชุดป้องกันฝุ่นและละอองสารเคมีทั่วไป','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_21.jpg?alt=media&token=bebe303b-39dd-4f84-bf3a-9aa1d6ca091c','2011'),('7022','ซีโตเฟล็กซ์ ผ้ายืดรัดศอกแบบสวม','สำหรับสวมใส่เพื่อป้องกันและบรรเทาอาการเจ็บ ปวดเมื่อย ลดอาการบวมบริเวณศอก','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_22.jpg?alt=media&token=deb315b4-5ec3-4d58-b8ea-1ff3ea730af3','2011'),('7023','เดทตอล สเปรย์ปรับอากาศลดการสะสมของเชื้อโรค Dettol Disinfection Spray','ทำความสะอาดได้ทั้ง ห้องครัว ห้องน้ำ และภายในบ้าน','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_23.jpg?alt=media&token=540543d9-8890-4c92-b0bd-33a6ad2ba4ec','2012'),('7024','วิทยาศรม สกินนอล แฮนด์ แอลกอฮอล์ โซลูชั่น 500 มล. Vidhyasom Skinol Hand Alcohol Solution 500 ml','วิทยาศรม สกินนอล แฮนด์ แอลกอฮอล์ โซลูชั่น 500 มล. (Vidhyasom Skinol Hand Alcohol Solution 500 ml)','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_24.jpg?alt=media&token=a1c9f1a4-dad8-4af6-8e6d-1a1e8afd1487','2012'),('7025','แอลกอฮอล์ แอลซอฟฟ์พิงค์ กลิ่นซากุระ/Alsoff Pink 450ml.','แอลกอฮอล์ แอลซอฟฟ์พิงค์ กลิ่นซากุระ/Alsoff Pink 450ml.','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/medicine%2Fmed_25.jpg?alt=media&token=b2117179-288d-4546-9f54-883fcfecb90d','2012');
/*!40000 ALTER TABLE `medicine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicinetype`
--

DROP TABLE IF EXISTS `medicinetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicinetype` (
  `typeId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `typeName` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`typeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicinetype`
--

LOCK TABLES `medicinetype` WRITE;
/*!40000 ALTER TABLE `medicinetype` DISABLE KEYS */;
INSERT INTO `medicinetype` VALUES ('2001','ผลิตภัณฑ์ความงาม'),('2002','ผลิตภัณฑ์ทาแก้ปวดเมื่อย'),('2003','ถุงยางอนามัยและเจล'),('2004','ครีมกันแดด/ลดฝ้า'),('2005','วิตามินและอาหารเสริม'),('2006','ชุดสังฆทานยาสามัญประจำบ้าน'),('2007','อุปกรณ์ตรวจวัดสุขภาพ'),('2008','ผลิตภัณฑ์ช่วยในการขับถ่าย'),('2009','สินค้าเพื่อสุขภาพ'),('2010','ยาสามัญประจำบ้าน'),('2011','อุปกรณ์ซัพพอร์ต'),('2012','ผลิตภัณฑ์ฆ่าเชื้อ');
/*!40000 ALTER TABLE `medicinetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `MemberUsername` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `MemberPassword` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `MemberName` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `MemberGender` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `MemberTel` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `MemberEmail` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `MemberImg` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MemberUsername`),
  UNIQUE KEY `MemberUsername_UNIQUE` (`MemberUsername`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES ('kanda123','12345678','กานดา จริงใจ','FM','0867465572','kanda@gmail.co.th','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fperson_1.jpg?alt=media&token=1652ab91-109c-4841-a139-bad9edb6325c'),('manee123','12345678','มานี รานี','FM','0978566641','manee6@hotmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fperson_5.jpg?alt=media&token=a09faeca-de6a-4704-8630-f9e3f47e05a9'),('mark12','mark123456','มาก ณ อยุธยา','M','0854263522','mark@gmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2F%20mark12.jpg?alt=media&token=b8f1158e-b9aa-4a98-a0b2-287c7a5cef55'),('nateerat','nateerat123','nateerat songdee','M','0979968375','nateerat@gmail.com',NULL),('nk12345','12345678','นครินร์ มุ่งมานะใจ','M','0653546619','nkker26@hotmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fperson_3.jpg?alt=media&token=71e9c02e-16e5-469a-bac8-3c3fc64f6bb1'),('sa123','sa123456','ซาร่า พาณิชย์','FM','0973522365','sah@gmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2F%20sa123.jpg?alt=media&token=d72c3a42-1e78-4db5-9bc7-e28da4b87973'),('somchai','12345678','สมชาย มุ่งมานะ','M','0875689900','somchai22@hotmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2Fperson_4.jpg?alt=media&token=1f8eeedc-8bb2-4c6f-90a2-e6dba5cee645'),('test','test123456','test test','M','0973444444','test@gmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2F%20test.jpg?alt=media&token=4eb0308b-cef3-460f-a8ff-68087e0ac0cf'),('ttrr','11111111','tt rr','FM','0973542262','we@gmsd.cp','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2F%20ttrr.jpg?alt=media&token=b3138b4b-9c9a-48b1-a7f0-d9be81d3a6b0'),('user02','12345678','นทีกานต์ เวียงอุดม','M','0816599460','aumrockker@hotmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2F%20user02.jpg?alt=media&token=17b563e1-1d6c-438b-8115-78f0b4d34c88'),('weccc','11111111','we eee','FM','0812345679','weww@gmail.com',NULL),('zzzz','11111111','zzzzz zzzz','FM','0879333333','zzz@gmail.com','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/member%2F%20zzzz.jpg?alt=media&token=ed6617d8-ddc8-4194-a55a-7eaa6a426290');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderdetail`
--

DROP TABLE IF EXISTS `orderdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderdetail` (
  `orderId` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `medId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `sumprice` double NOT NULL,
  `note` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`orderId`,`medId`),
  KEY `fk_OrderDetail_Medicine1_idx` (`medId`),
  CONSTRAINT `fk_OrderDetail_Medicine1` FOREIGN KEY (`medId`) REFERENCES `medicine` (`medId`),
  CONSTRAINT `fk_OrderDetail_Order1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderdetail`
--

LOCK TABLES `orderdetail` WRITE;
/*!40000 ALTER TABLE `orderdetail` DISABLE KEYS */;
INSERT INTO `orderdetail` VALUES ('50001','7021',1,500,NULL),('50002','7004',1,500,'-'),('50003','7010',1,580,NULL),('50003','7019',2,24,'ยาแก้ไอ'),('50004','7015',1,30,NULL),('50004','7016',1,35,NULL),('50005','7011',1,420,NULL),('50005','7014',1,799,NULL),('50006','7009',1,1620,NULL),('50007','7012',3,150,NULL),('50008','7002',1,350,NULL),('50008','7003',1,280,NULL),('50009','7013',1,1500,NULL),('50010','7001',1,420,NULL),('50010','7012',1,50,NULL),('50011','7010',1,580,NULL),('50011','7015',2,60,NULL),('50012','7017',1,199,NULL),('50012','7020',2,40,NULL),('50012','7023',1,199,NULL),('50013','7004',1,160,NULL),('50014','7014',1,799,NULL),('50015','7005',1,275,NULL),('50016','7021',1,500,NULL),('50016','7022',1,99,NULL),('50017','7001',1,420,NULL),('50017','7002',1,350,NULL),('50017','7003',1,280,NULL),('50017','7009',1,1620,NULL),('50017','7010',1,580,NULL),('50017','7012',1,50,NULL),('50017','7014',1,799,NULL),('50017','7015',1,30,NULL),('50017','7017',1,199,NULL),('50017','7022',1,99,NULL),('50017','7024',1,79,NULL),('50018','7001',9,3780,NULL),('50018','7002',5,1750,NULL),('50018','7003',7,1960,NULL),('50018','7004',5,800,NULL),('50018','7005',4,1100,NULL),('50019','7004',1,160,NULL),('50019','7005',1,275,NULL),('50020','7016',2,70,NULL),('50020','7019',1,12,NULL),('50020','7020',1,20,NULL),('50021','7012',2,100,NULL),('50021','7016',1,35,NULL),('50022','7008',1,930,NULL),('50023','7011',1,420,NULL),('50024','7002',1,350,NULL),('50024','7003',1,280,NULL),('50025','7011',1,420,NULL),('50026','7005',2,550,NULL),('50027','7012',1,50,NULL),('50027','7015',2,60,NULL),('50028','7002',1,350,NULL),('50029','7010',1,580,NULL),('50030','7008',1,930,NULL),('50031','7004',1,160,NULL),('50032','7004',1,160,NULL),('50032','7005',1,275,NULL),('50033','7004',1,160,NULL),('50033','7005',1,275,NULL),('50034','7004',1,160,NULL),('50034','7008',1,930,NULL);
/*!40000 ALTER TABLE `orderdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `orderId` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `orderDate` datetime NOT NULL,
  `sumQuantity` int NOT NULL,
  `subtotalPrice` double NOT NULL,
  `totalPrice` double NOT NULL,
  `orderStatus` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `receiptId` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payDate` datetime DEFAULT NULL,
  `shippingCost` double NOT NULL,
  `shippingCompany` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trackingNumber` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shippingDate` datetime DEFAULT NULL,
  `couponName` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `addressId` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reviewId` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`orderId`),
  KEY `fk_Order_Coupon1_idx` (`couponName`),
  KEY `fk_Order_Address1_idx` (`addressId`),
  KEY `fk_Order_Review1_idx` (`reviewId`),
  CONSTRAINT `fk_Order_Address1` FOREIGN KEY (`addressId`) REFERENCES `address` (`addressId`),
  CONSTRAINT `fk_Order_Coupon1` FOREIGN KEY (`couponName`) REFERENCES `coupon` (`couponName`),
  CONSTRAINT `fk_Order_Review1` FOREIGN KEY (`reviewId`) REFERENCES `review` (`reviewId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('50001','2564-10-03 11:18:00',1,500,550,'T','10101','2564-10-03 11:19:10',50,'Kerry','TH57469355','2565-09-03 11:13:10',NULL,'100','80001'),('50002','2564-10-14 11:18:00',1,500,550,'T','10102','2565-09-03 00:36:10',50,'Flash','TH59469351','2565-09-03 01:42:00',NULL,'101','80002'),('50003','2565-10-10 15:25:36',3,604,589,'T','1665390345','2565-10-10 15:26:08',0,NULL,NULL,'2565-10-10 15:35:07','NEWMJU',NULL,'80003'),('50004','2565-10-10 15:29:17',2,65,95,'T','1665390642','2565-10-10 15:30:59',30,'NINJA VAN','TH430037788KB','2565-10-10 15:50:00',NULL,'105',NULL),('50005','2565-10-10 15:33:19',2,1219,1269,'C',NULL,NULL,50,NULL,NULL,NULL,NULL,'104',NULL),('50006','2565-10-10 15:52:13',1,1620,1620,'cf',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50007','2565-10-10 15:53:03',3,150,150,'T','1665392044','2565-10-10 15:44:22',0,NULL,NULL,'2565-10-10 16:20:30',NULL,NULL,'80004'),('50008','2565-10-10 16:14:11',2,630,635,'T','1665393293','2565-10-10 16:15:26',50,'FLASH EXPRESS','MQ45875359TH','2565-10-10 16:24:00','Sale2','104','80005'),('50009','2565-10-10 16:17:19',1,1500,1500,'store','1665393442','2565-10-10 16:17:43',0,NULL,NULL,NULL,NULL,NULL,NULL),('50010','2565-10-10 16:23:23',2,470,475,'T','1665393838','2565-10-10 16:24:18',50,'J&T EXPRESS','JT550093332','2565-10-11 15:07:00','Sale2','106',NULL),('50011','2565-10-10 16:34:01',3,640,640,'cf',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50012','2565-10-10 16:37:51',4,438,478,'T','1665394707','2565-10-10 16:38:48',60,'KERRY EXPRESS','QW234678990','2565-10-11 16:25:00','Pharma20','100',NULL),('50013','2565-10-10 16:39:42',1,160,160,'cf',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50014','2565-10-10 16:40:53',1,799,799,'C',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50015','2565-10-10 16:42:05',1,275,275,'T','1665394936','2565-10-10 16:42:36',0,NULL,NULL,'2565-10-11 16:05:53',NULL,NULL,NULL),('50016','2565-10-10 16:44:05',2,599,599,'T','1665395059','2565-10-10 16:44:35',0,NULL,NULL,'2565-10-13 01:42:24',NULL,NULL,NULL),('50017','2565-10-11 00:17:17',11,4506,4506,'T','1665422262','2565-10-11 00:18:29',0,NULL,NULL,'2565-10-11 00:21:19',NULL,NULL,NULL),('50018','2565-10-11 00:28:13',30,9390,9392,'C',NULL,NULL,2,NULL,NULL,NULL,NULL,'107',NULL),('50019','2565-10-11 15:51:58',2,435,420,'T','1665478339','2565-10-11 15:52:42',0,NULL,NULL,'2565-10-11 16:24:22','NEWMJU',NULL,NULL),('50020','2565-10-11 15:57:26',4,102,132,'C',NULL,NULL,30,NULL,NULL,NULL,NULL,'108',NULL),('50021','2565-10-11 16:01:46',3,135,135,'T','1665478931','2565-10-11 16:02:29',0,'J&T EXPRESS','TH455590003','2565-10-11 16:03:00',NULL,'108','80006'),('50022','2565-10-11 16:29:34',1,930,980,'wt','1665480635','2565-10-11 16:31:01',50,NULL,NULL,NULL,NULL,'105',NULL),('50023','2565-10-11 16:33:22',1,420,420,'C',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50024','2565-10-11 16:42:08',2,630,615,'wt','1665481381','2565-10-11 16:43:17',30,NULL,NULL,NULL,'Sale2','104',NULL),('50025','2565-10-11 16:46:18',1,420,420,'T','1665481614','2565-10-11 16:47:10',0,NULL,NULL,'2565-10-12 15:03:31',NULL,NULL,NULL),('50026','2565-10-12 14:29:58',2,550,535,'store','1665559910','2565-10-12 14:32:20',0,NULL,NULL,NULL,'NEWMJU',NULL,NULL),('50027','2565-10-12 14:38:02',3,110,140,'T','1665560359','2565-10-12 14:39:55',30,'KERRY EXPRESS','TH124006444','2565-10-12 14:43:00',NULL,'109','80007'),('50028','2565-10-12 14:56:39',1,350,350,'C',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50029','2565-10-12 18:05:33',1,580,580,'cf',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50030','2565-10-12 18:41:25',1,930,930,'cf',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50031','2565-10-12 20:25:45',1,160,160,'cf',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),('50032','2565-10-16 00:32:10',2,435,465,'wt','1665855186','2565-10-16 00:33:25',30,NULL,NULL,NULL,NULL,'104',NULL),('50033','2565-10-16 15:45:30',2,435,465,'cf',NULL,NULL,30,NULL,NULL,NULL,NULL,'104',NULL),('50034','2565-10-17 15:38:39',2,1090,1140,'cf',NULL,NULL,50,NULL,NULL,NULL,NULL,'117',NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owner`
--

DROP TABLE IF EXISTS `owner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owner` (
  `ownerid` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `ownerName` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `ownerPassword` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `imgLicense` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ownerid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES ('10001','สุธิชา รัตนะ','12345678','drug_license.jpg'),('10002','มาโนช สมมาดี','123456789','drug_license.jpg'),('10003','กรณ์พงศ์ ตัณตระกูล','12345678','drug_license.jpg');
/*!40000 ALTER TABLE `owner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacist`
--

DROP TABLE IF EXISTS `pharmacist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacist` (
  `pharmacistID` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `pharmacistPassword` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `pharmacistName` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `pharmacistImg` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `imgCeritficate` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `pharmacistMobile` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `pharmacistEmail` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `pharmacistStatus` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `drugstoreID` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`pharmacistID`),
  KEY `fk_Pharmacist_Drugstore1_idx` (`drugstoreID`),
  CONSTRAINT `fk_Pharmacist_Drugstore1` FOREIGN KEY (`drugstoreID`) REFERENCES `drugstore` (`drugstoreID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacist`
--

LOCK TABLES `pharmacist` WRITE;
/*!40000 ALTER TABLE `pharmacist` DISABLE KEYS */;
INSERT INTO `pharmacist` VALUES ('60001','12345678','ภญ.วันวิสา ประดิษฐอุกฤษฎ์','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/pharmacist%2Fpharmacist_1.jpg?alt=media&token=c983592a-b364-4748-89bf-3d787c0ea8a8','certificate.png','0973542262','fanggg@gmail.com','ON','20001'),('60002','12345678','ภก.นทีกานต์ เวียงอุดม','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/pharmacist%2Fpharmacist_4.jpg?alt=media&token=e6e3f907-4dae-4779-813d-8c5dc4134be0','certificate.png','0984653334','3ckker26@hotmail.com','OF','20001'),('60003','12345678','ภญ.ณัฎฐพร ศิริบูรณ์','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/pharmacist%2Fpharmacist_2.jpg?alt=media&token=150b3b87-9b07-4f5b-8468-569d7cbb788f','certificate.png','0874653386','beamm@gmail.com','OF','20002'),('60004','12345678','ภก.ศุภกิต ดวงใจ','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/pharmacist%2Fpharmacist_3.jpg?alt=media&token=a59a48c1-e866-4d9e-a2dd-1d09b9b25839','certificate.png','0984653372','supakit12346@hotmail.com','OF','20002'),('60005','12345678','ภญ.สายใจ การัตน์','https://firebasestorage.googleapis.com/v0/b/pharmacy-delivery-737df.appspot.com/o/pharmacist%2Fpharmacist_5.jpg?alt=media&token=972bd1ce-b669-4f99-a699-dffcff367d36','certificate.png','0984653375','saijai1@hotmail.com','OF','20003');
/*!40000 ALTER TABLE `pharmacist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `reviewId` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `score` int NOT NULL,
  `comment` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `reviewDate` datetime NOT NULL,
  PRIMARY KEY (`reviewId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES ('80001',4,'ดีมากค่ะ ส่งเร้ว','2565-04-20 10:00:20'),('80002',5,'Good','2565-05-12 13:10:22'),('80003',5,'บริการดีมากครับ','2565-10-10 16:00:07'),('80004',3,'เยี่ยมมม','2565-10-10 16:07:18'),('80005',5,'nice!','2565-10-10 16:30:33'),('80006',3,'so good','2565-10-11 16:06:26'),('80007',4,'ดีๆมาก','2565-10-12 14:44:40');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock`
--

DROP TABLE IF EXISTS `stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock` (
  `drugstoreID` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `medId` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  `medQuantity` int NOT NULL,
  `expirationDate` date NOT NULL,
  `medPrice` double NOT NULL,
  PRIMARY KEY (`drugstoreID`,`medId`),
  KEY `fk_Stock_Medicine1_idx` (`medId`),
  CONSTRAINT `fk_Stock_Drugstore1` FOREIGN KEY (`drugstoreID`) REFERENCES `drugstore` (`drugstoreID`),
  CONSTRAINT `fk_Stock_Medicine1` FOREIGN KEY (`medId`) REFERENCES `medicine` (`medId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock`
--

LOCK TABLES `stock` WRITE;
/*!40000 ALTER TABLE `stock` DISABLE KEYS */;
INSERT INTO `stock` VALUES ('20001','7001',500,'2565-07-01',460),('20001','7002',500,'2565-08-01',350),('20001','7003',0,'2569-08-01',280),('20001','7004',493,'2569-10-03',160),('20001','7005',494,'2569-11-05',275),('20001','7006',500,'2563-09-23',110),('20001','7007',500,'2563-10-03',110),('20001','7008',496,'2569-04-19',930),('20001','7009',501,'2569-11-05',1620),('20001','7010',498,'2567-09-23',580),('20001','7011',500,'2569-10-03',420),('20001','7012',494,'2567-09-23',50),('20001','7013',500,'2569-11-05',1500),('20001','7014',500,'2567-09-23',799),('20001','7015',497,'2569-10-03',30),('20001','7016',498,'2569-08-01',35),('20001','7017',499,'2569-08-01',199),('20001','7018',500,'2569-10-03',299),('20001','7019',496,'2567-09-23',12),('20001','7020',498,'2569-10-03',20),('20001','7021',499,'2569-08-01',500),('20001','7022',499,'2568-12-26',99),('20001','7023',499,'2567-05-17',199),('20001','7024',500,'2569-03-02',79),('20001','7025',500,'2569-11-05',50),('20002','7001',499,'2568-12-26',420),('20002','7002',498,'2567-05-17',350),('20002','7003',498,'2569-03-02',280),('20002','7004',500,'2568-10-25',160),('20002','7005',500,'2569-04-18',275),('20002','7006',500,'2563-08-01',110),('20002','7007',500,'2563-10-03',110),('20002','7008',500,'2568-10-25',930),('20002','7009',500,'2569-04-18',1620),('20002','7010',499,'2569-08-01',580),('20002','7011',499,'2569-10-03',420),('20002','7012',499,'2568-10-25',50),('20002','7013',499,'2569-04-18',1500),('20002','7014',500,'2569-08-01',799),('20002','7015',498,'2569-10-03',30),('20002','7016',500,'2567-05-17',35),('20002','7017',500,'2569-03-02',199),('20002','7018',500,'2569-04-18',299),('20002','7019',500,'2569-08-01',12),('20002','7020',500,'2569-10-03',20),('20002','7021',500,'2569-03-02',500),('20002','7022',500,'2569-11-05',99),('20002','7023',500,'2567-09-23',199),('20002','7024',500,'2569-10-03',79),('20002','7025',500,'2569-11-05',50),('20003','7001',499,'2569-11-05',420),('20003','7002',499,'2567-09-23',350),('20003','7003',499,'2569-10-03',280),('20003','7004',500,'2568-12-26',160),('20003','7005',500,'2567-05-17',275),('20003','7006',500,'2563-03-02',110),('20003','7007',500,'2563-04-18',110),('20003','7008',500,'2568-12-26',930),('20003','7009',499,'2567-05-17',1620),('20003','7010',499,'2569-03-02',580),('20003','7011',500,'2567-09-23',420),('20003','7012',499,'2568-12-26',50),('20003','7013',500,'2567-05-17',1500),('20003','7014',499,'2569-03-02',799),('20003','7015',499,'2569-08-01',30),('20003','7016',500,'2567-09-23',35),('20003','7017',499,'2569-10-03',199),('20003','7018',500,'2567-05-17',299),('20003','7019',500,'2569-03-02',12),('20003','7020',500,'2567-09-23',20),('20003','7021',500,'2568-10-25',500),('20003','7022',499,'2569-04-18',99),('20003','7023',500,'2569-08-01',199),('20003','7024',499,'2569-10-03',79),('20003','7025',500,'2569-04-18',50);
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'project_pharmacydelivery'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-18 13:01:30
