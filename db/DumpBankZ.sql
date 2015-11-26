CREATE DATABASE  IF NOT EXISTS `BankZ` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `BankZ`;
-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: BankZ
-- ------------------------------------------------------
-- Server version	5.5.46-0ubuntu0.14.04.2

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
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Account` (
  `AccountNumber` varchar(45) NOT NULL,
  `ClientID` varchar(45) DEFAULT NULL COMMENT 'NIC, PASSPORT',
  `ClientName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AccountNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Agent`
--

DROP TABLE IF EXISTS `Agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Agent` (
  `idAgent` int(11) NOT NULL AUTO_INCREMENT,
  `AgentCode` varchar(45) DEFAULT NULL,
  `AgentName` varchar(45) DEFAULT NULL,
  `idBranch` int(11) DEFAULT NULL,
  PRIMARY KEY (`idAgent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AgentTransactionPermission`
--

DROP TABLE IF EXISTS `AgentTransactionPermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AgentTransactionPermission` (
  `idPermission` int(11) NOT NULL,
  `idAgent` int(11) NOT NULL,
  `tag` varchar(45) NOT NULL,
  `isAllow` int(11) DEFAULT '0',
  PRIMARY KEY (`idPermission`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Branch`
--

DROP TABLE IF EXISTS `Branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Branch` (
  `idBranch` int(11) NOT NULL AUTO_INCREMENT,
  `BranchCode` varchar(45) NOT NULL,
  `BranchName` varchar(45) NOT NULL,
  PRIMARY KEY (`idBranch`),
  UNIQUE KEY `BranchCode_UNIQUE` (`BranchCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EPICTransactionLog`
--

DROP TABLE IF EXISTS `EPICTransactionLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EPICTransactionLog` (
  `idETransactionLog` int(11) NOT NULL AUTO_INCREMENT,
  `trType` int(11) NOT NULL,
  `trBeginTime` datetime NOT NULL,
  `idAgent` int(11) NOT NULL,
  `AccountNumber` varchar(45) NOT NULL,
  `trAmount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `currentStatus` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`idETransactionLog`)
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SenZTransactionLog`
--

DROP TABLE IF EXISTS `SenZTransactionLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SenZTransactionLog` (
  `idZTransactionLog` int(11) NOT NULL AUTO_INCREMENT,
  `ztrDateTime` datetime DEFAULT NULL,
  `SenZClient` varchar(45) DEFAULT NULL COMMENT 'T,B',
  `SenZQuerry` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`idZTransactionLog`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TransactionStatusLog`
--

DROP TABLE IF EXISTS `TransactionStatusLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TransactionStatusLog` (
  `idETransactionLog` int(11) NOT NULL,
  `noStatus` int(11) NOT NULL,
  `status` varchar(5000) DEFAULT NULL,
  `statusTime` datetime DEFAULT NULL,
  `sFrom` varchar(45) DEFAULT NULL,
  `sTo` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idETransactionLog`,`noStatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'BankZ'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_account`(accnum varchar(45), cid varchar(45), cname varchar(45))
BEGIN

	DECLARE exit handler for sqlexception
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	START TRANSACTION;

	IF EXISTS(SELECT AccountNumber FROM Account WHERE AccountNumber = accnum) THEN
		UPDATE Account SET ClientID = cid, ClientName = cname WHERE AccountNumber = accnum;
	ELSE
		INSERT INTO Account(AccountNumber,ClientID,ClientName)
		VALUES (accnum,cid,cname);
	END IF;

	COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_agent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_agent`(acode varchar(45), aname varchar(45), bcode varchar(45))
BEGIN

	DECLARE bid int;

	DECLARE exit handler for sqlexception
	BEGIN
		-- ERROR
		ROLLBACK;
	END;
	
	START TRANSACTION;
	
	SELECT idBranch INTO bid FROM Branch WHERE BranchCode = bcode;
	
	IF EXISTS(SELECT AgentCode FROM Agent WHERE AgentCode = acode) THEN
		UPDATE Agent SET AgentName = aname, idBranch = bid WHERE AgentCode = acode;
	ELSE
		INSERT INTO Agent(AgentCode,AgentName,idBranch)
		VALUES (acode,aname,bid);
	END IF;

	COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_epictr` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_epictr`(/*OUT tkey int,*/tr_type varchar(45), agentid int, accnum varchar(45), tamount decimal(10,2),cstatus varchar(45),trF varchar(45), trT varchar(45))
BEGIN
		
	DECLARE poid INT;

	DECLARE exit handler for sqlexception
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	-- DECLARE exit handler for sqlwarning
	-- BEGIN
		-- WARNING
		
	-- END;
	
	START TRANSACTION;
	
	-- Inert EPICTransactionLog
	INSERT INTO `BankZ`.`EPICTransactionLog` (`trType`, `trBeginTime`, `idAgent`, `AccountNumber`, `trAmount`, `currentStatus`) 
	VALUES (tr_type, now(), agentid, accnum, tamount, cstatus);
	-- SELECT * FROM EPICTrans actionLog;
    
	-- get last insert EPICTransactionLog id
	SET poid = (SELECT LAST_INSERT_ID());
	
	-- Insert TransactionStatusLog
	INSERT INTO `BankZ`.`TransactionStatusLog`(`idETransactionLog`,`noStatus`,`status`,`statusTime`,`sFrom`,`sTo`)
	VALUES(poid,1,cstatus,NOW(),trF,trT);

	-- SET tkey := poid;

	COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_status`(tr_id int, cstatus varchar(45), sF varchar(45), sT varchar(45))
BEGIN

	DECLARE newn int;

	DECLARE exit handler for sqlexception
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	START TRANSACTION;

	SET newn = 0;

	SELECT max(noStatus) into newn FROM `BankZ`.`TransactionStatusLog` WHERE `idETransactionLog` = tr_id;

	INSERT INTO `BankZ`.`TransactionStatusLog`(`idETransactionLog`,`noStatus`,`status`,`statusTime`,`sFrom`,`sTo`)
	VALUES(tr_id,newn + 1,cstatus,NOW(),sF,sT);

	UPDATE `BankZ`.`EPICTransactionLog`	SET `currentStatus` = cstatus WHERE `idETransactionLog` = tr_id;

	COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-26 19:13:10
