-- MySQL dump 10.13  Distrib 5.5.29, for Win64 (x86)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	5.5.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `companyID` bigint(20) NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `companyType` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`companyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'','Hightech','comp1'),(2,'','Financial','comp2'),(3,'','Manufacturing','comp3');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conferences`
--

DROP TABLE IF EXISTS `conferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conferences` (
  `conferenceId` bigint(20) NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `location_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`conferenceId`),
  KEY `FKC0DCF2B7133695CF` (`location_name`),
  CONSTRAINT `FKC0DCF2B7133695CF` FOREIGN KEY (`location_name`) REFERENCES `location` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conferences`
--

LOCK TABLES `conferences` WRITE;
/*!40000 ALTER TABLE `conferences` DISABLE KEYS */;
INSERT INTO `conferences` VALUES (1,'','yada','2013-03-07 17:40:44','conf0','2013-03-04 17:40:44','locationNameBlah'),(2,'','yada','2013-03-07 17:40:44','conf1','2013-03-04 17:40:44','locationNameBlah'),(3,'','yada','2013-03-07 17:40:44','conf2','2013-03-04 17:40:44','locationNameBlah'),(4,'','yada','2013-03-07 17:40:44','conf3','2013-03-04 17:40:44','locationNameBlah'),(5,'','yada','2013-03-07 17:40:44','conf4','2013-03-04 17:40:44','locationNameBlah');
/*!40000 ALTER TABLE `conferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conferences_participants`
--

DROP TABLE IF EXISTS `conferences_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conferences_participants` (
  `date` datetime NOT NULL,
  `user_userId` bigint(20) NOT NULL,
  `conference_conferenceId` bigint(20) NOT NULL,
  PRIMARY KEY (`user_userId`,`date`,`conference_conferenceId`),
  KEY `FK5D9C90484DAAAE9B` (`conference_conferenceId`),
  KEY `FK5D9C9048751CA8AA` (`user_userId`),
  CONSTRAINT `FK5D9C9048751CA8AA` FOREIGN KEY (`user_userId`) REFERENCES `users` (`userId`),
  CONSTRAINT `FK5D9C90484DAAAE9B` FOREIGN KEY (`conference_conferenceId`) REFERENCES `conferences` (`conferenceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conferences_participants`
--

LOCK TABLES `conferences_participants` WRITE;
/*!40000 ALTER TABLE `conferences_participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `conferences_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conferences_users`
--

DROP TABLE IF EXISTS `conferences_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conferences_users` (
  `attendanceStatus` int(11) DEFAULT NULL,
  `notifiedByMail` bit(1) DEFAULT NULL,
  `uniqueIdForEmailNotification` varchar(255) DEFAULT NULL,
  `userRole` int(11) NOT NULL,
  `user_userId` bigint(20) NOT NULL,
  `conference_conferenceId` bigint(20) NOT NULL,
  PRIMARY KEY (`user_userId`,`conference_conferenceId`),
  KEY `FK7EAAE2604DAAAE9B` (`conference_conferenceId`),
  KEY `FK7EAAE260751CA8AA` (`user_userId`),
  CONSTRAINT `FK7EAAE260751CA8AA` FOREIGN KEY (`user_userId`) REFERENCES `users` (`userId`),
  CONSTRAINT `FK7EAAE2604DAAAE9B` FOREIGN KEY (`conference_conferenceId`) REFERENCES `conferences` (`conferenceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conferences_users`
--

LOCK TABLES `conferences_users` WRITE;
/*!40000 ALTER TABLE `conferences_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `conferences_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `name` varchar(255) NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `contactName` varchar(255) DEFAULT NULL,
  `locationId` bigint(20) NOT NULL,
  `maxCapacity` int(11) NOT NULL,
  `phone1` varchar(255) DEFAULT NULL,
  `phone2` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES ('locationNameBlah','','ydaa','moo',0,30,'56464654','54564654');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `userId` bigint(20) NOT NULL,
  `active` bit(1) DEFAULT NULL,
  `admin` bit(1) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `lastLogin` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `pasportID` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone1` varchar(255) DEFAULT NULL,
  `phone2` varchar(255) DEFAULT NULL,
  `userName` varchar(255) DEFAULT NULL,
  `company_companyID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`userId`),
  KEY `FK4E39DE8B5D743AE` (`company_companyID`),
  CONSTRAINT `FK4E39DE8B5D743AE` FOREIGN KEY (`company_companyID`) REFERENCES `company` (`companyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'','','admin@admin.com','2013-03-04 21:38:43','admin','admin','pass1','03-3333333','03-3333331','admin',1),(2,'','\0','email0',NULL,'name0','id0','pass0','num1 0','num2 0','userName0',1),(3,'','\0','email1',NULL,'name1','id1','pass1','num1 1','num2 1','userName1',2),(4,'','\0','email2',NULL,'name2','id2','pass2','num1 2','num2 2','userName2',3),(5,'','\0','email3',NULL,'name3','id3','pass3','num1 3','num2 3','userName3',1),(6,'','\0','email4',NULL,'name4','id4','pass4','num1 4','num2 4','userName4',2),(7,'','\0','email5',NULL,'name5','id5','pass5','num1 5','num2 5','userName5',3),(8,'','\0','email6',NULL,'name6','id6','pass6','num1 6','num2 6','userName6',1),(9,'','\0','email7',NULL,'name7','id7','pass7','num1 7','num2 7','userName7',2),(10,'','\0','email8',NULL,'name8','id8','pass8','num1 8','num2 8','userName8',3),(11,'','\0','email9',NULL,'name9','id9','pass9','num1 9','num2 9','userName9',1),(12,'','\0','email10',NULL,'name10','id10','pass10','num1 10','num2 10','userName10',2),(13,'','\0','email11',NULL,'name11','id11','pass11','num1 11','num2 11','userName11',3),(14,'','\0','email12',NULL,'name12','id12','pass12','num1 12','num2 12','userName12',1),(15,'','\0','email13',NULL,'name13','id13','pass13','num1 13','num2 13','userName13',2),(16,'','\0','email14',NULL,'name14','id14','pass14','num1 14','num2 14','userName14',3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-05 11:58:49
