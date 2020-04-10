-- MariaDB dump 10.17  Distrib 10.4.11-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: log
-- ------------------------------------------------------
-- Server version	10.4.11-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `logmedicoes`
--

DROP TABLE IF EXISTS `logmedicoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logmedicoes` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `DataOperacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `EmailUtilizador` varchar(100) NOT NULL,
  `Operacao` varchar(15) NOT NULL,
  `IdMedicaoAnterior` int(11) DEFAULT NULL,
  `IdmedicaoNova` int(11) DEFAULT NULL,
  `ValorMedicaoAnterior` decimal(6,2) DEFAULT NULL,
  `ValorMedicaoNova` decimal(6,2) DEFAULT NULL,
  `TipoSensorAnterior` varchar(3) DEFAULT NULL,
  `TipoSensorNovo` varchar(3) DEFAULT NULL,
  `DataHoraMedicaoAnterior` timestamp NULL DEFAULT NULL,
  `DataHoraMedicaoNova` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logmedicoes`
--

LOCK TABLES `logmedicoes` WRITE;
/*!40000 ALTER TABLE `logmedicoes` DISABLE KEYS */;
/*!40000 ALTER TABLE `logmedicoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logrondaextra`
--

DROP TABLE IF EXISTS `logrondaextra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logrondaextra` (
  `Id` int(11) NOT NULL,
  `DataOperacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `EmailUtilizador` varchar(100) NOT NULL,
  `Operacao` varchar(15) NOT NULL,
  `EmailAnterior` varchar(100) DEFAULT NULL,
  `EmailNovo` varchar(100) DEFAULT NULL,
  `HoraInicioAnterior` time DEFAULT NULL,
  `HoraInicioNova` time DEFAULT NULL,
  `HoraFimAnterior` time DEFAULT NULL,
  `HoraFimNova` time DEFAULT NULL,
  `DataAnterior` date DEFAULT NULL,
  `DataNova` date DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logrondaextra`
--

LOCK TABLES `logrondaextra` WRITE;
/*!40000 ALTER TABLE `logrondaextra` DISABLE KEYS */;
/*!40000 ALTER TABLE `logrondaextra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logrondaplaneada`
--

DROP TABLE IF EXISTS `logrondaplaneada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logrondaplaneada` (
  `Id` int(11) NOT NULL,
  `DataOperacao` datetime NOT NULL,
  `EmailUtilizador` varchar(100) NOT NULL,
  `Operacao` varchar(15) NOT NULL,
  `EmailAnterior` varchar(100) DEFAULT NULL,
  `EmailNovo` varchar(100) DEFAULT NULL,
  `DataAnterior` date DEFAULT NULL,
  `DataNova` date DEFAULT NULL,
  `HoraAnterior` time DEFAULT NULL,
  `HoraNova` time DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logrondaplaneada`
--

LOCK TABLES `logrondaplaneada` WRITE;
/*!40000 ALTER TABLE `logrondaplaneada` DISABLE KEYS */;
/*!40000 ALTER TABLE `logrondaplaneada` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logsistema`
--

DROP TABLE IF EXISTS `logsistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logsistema` (
  `Id` int(11) NOT NULL,
  `DataOperacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `EmailUtilizador` varchar(100) NOT NULL,
  `Operacao` varchar(15) NOT NULL,
  `LimiteTemperaturaAnterior` decimal(6,2) DEFAULT NULL,
  `LimiteTemperaturaNovo` decimal(6,2) DEFAULT NULL,
  `LimiteHumidadeAnterior` decimal(6,2) DEFAULT NULL,
  `LimiteHumidadeNovo` decimal(6,2) DEFAULT NULL,
  `LimiteLuminosidadeAnterior` decimal(6,2) DEFAULT NULL,
  `LimiteLuminosidadeNovo` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logsistema`
--

LOCK TABLES `logsistema` WRITE;
/*!40000 ALTER TABLE `logsistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `logsistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logutilizador`
--

DROP TABLE IF EXISTS `logutilizador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logutilizador` (
  `Id` int(11) NOT NULL,
  `DataOperacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `EmailUtilizador` varchar(100) NOT NULL,
  `Operacao` varchar(15) NOT NULL,
  `EmailNovo` varchar(100) DEFAULT NULL,
  `EmailAnterior` varchar(100) DEFAULT NULL,
  `NomeAnterior` varchar(80) DEFAULT NULL,
  `NomeNovo` varchar(80) DEFAULT NULL,
  `TipoAnterior` enum('Seguranca','ChefeSeguranca','Administrador','DiretorMuseu') DEFAULT NULL,
  `TipoNovo` enum('Seguranca','ChefeSeguranca','Administrador','DiretorMuseu') DEFAULT NULL,
  `MoradaAnterior` varchar(200) DEFAULT NULL,
  `MoradaNova` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logutilizador`
--

LOCK TABLES `logutilizador` WRITE;
/*!40000 ALTER TABLE `logutilizador` DISABLE KEYS */;
/*!40000 ALTER TABLE `logutilizador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'log'
--
/*!50003 DROP PROCEDURE IF EXISTS `Consulta_LogMedicoes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Consulta_LogMedicoes`(IN `Email` INT(100))
    NO SQL
BEGIN
SELECT * FROM logmedicoes WHERE EmailUtilizador=Email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Consulta_LogRondaExtra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Consulta_LogRondaExtra`(IN `Email` INT(100))
    NO SQL
BEGIN
SELECT * FROM logrondaextra WHERE EmailUtilizador=Email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Consulta_LogRondaPlaneada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Consulta_LogRondaPlaneada`(IN `Email` VARCHAR(100))
    NO SQL
BEGIN
SELECT * FROM logrondaplaneada WHERE EmailUtilizador=Email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Consulta_LogSistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Consulta_LogSistema`(IN `Email` INT(100))
    NO SQL
BEGIN
SELECT * FROM logsistema WHERE EmailUtilizador=Email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Consulta_LogUtilizador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Consulta_LogUtilizador`(IN `Email` VARCHAR(100))
    NO SQL
BEGIN
SELECT * FROM logutilizador WHERE EmailUtilizador=Email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_logs`()
BEGIN
call main.Export_LogUtilizador();
call main.Export_LogRondaPlaneada();
call main.Export_LogRondaExtra();
call main.Export_LogSistema();
call main.Export_LogMedicoes();
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

-- Dump completed on 2020-04-08 15:27:28
