-- MariaDB dump 10.17  Distrib 10.4.11-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: main
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
  `Id` int(11) NOT NULL,
  `DataOperacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `EmailUtilizador` varchar(100) NOT NULL,
  `Operacao` varchar(15) NOT NULL,
  `IdMedicaoAnterior` int(11) DEFAULT NULL,
  `IdMedicaoNova` int(11) DEFAULT NULL,
  `ValorMedicaoAnterior` decimal(6,2) DEFAULT NULL,
  `ValorMedicaoNova` decimal(6,2) DEFAULT NULL,
  `TipoSensorAnterior` varchar(3) DEFAULT NULL,
  `TipoSensorNovo` varchar(3) DEFAULT NULL,
  `DataHoraMedicaoAnterior` timestamp NULL DEFAULT NULL,
  `DataHoraMedicaoNovo` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
  `DataOperacao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
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
  `EmailAnterior` varchar(100) DEFAULT NULL,
  `EmailNovo` varchar(100) DEFAULT NULL,
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
-- Table structure for table `medicoessensores`
--

DROP TABLE IF EXISTS `medicoessensores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicoessensores` (
  `IDmedicao` int(11) NOT NULL,
  `ValorMedicao` decimal(6,2) NOT NULL,
  `TipoSensor` varchar(3) NOT NULL,
  `DataHoraMedicao` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`IDmedicao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicoessensores`
--

LOCK TABLES `medicoessensores` WRITE;
/*!40000 ALTER TABLE `medicoessensores` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicoessensores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rondaextra`
--

DROP TABLE IF EXISTS `rondaextra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rondaextra` (
  `EmailUtilizador` varchar(100) NOT NULL,
  `HoraInicio` time NOT NULL,
  `HoraFim` time NOT NULL,
  `Data` date NOT NULL,
  PRIMARY KEY (`EmailUtilizador`,`HoraInicio`,`HoraFim`,`Data`),
  CONSTRAINT `fk_email_utiliz` FOREIGN KEY (`EmailUtilizador`) REFERENCES `utilizador` (`EmailUtilizador`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rondaextra`
--

LOCK TABLES `rondaextra` WRITE;
/*!40000 ALTER TABLE `rondaextra` DISABLE KEYS */;
/*!40000 ALTER TABLE `rondaextra` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RondaExtra_insert_trigger` AFTER INSERT ON `rondaextra` FOR EACH ROW BEGIN
declare new_id DOUBLE; 
select max(Id) + 1 into new_id from logrondaextra;             insert into logrondaextra(Id, DataOperacao, EmailUtilizador, Operacao, EmailAnterior, EmailNovo,HoraInicioAnterior, HoraInicioNova, HoraFimAnterior, HoraFimNova, DataAnterior, DataNova)             VALUES(new_id, now(), USER(), "I", NULL, NEW.EmailUtilizador, NULL, NEW.HoraInicio, NULL, NEW.HoraFim, NULL, NEW.Data); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RondaExtra_delete_trigger` AFTER DELETE ON `rondaextra` FOR EACH ROW BEGIN 

             declare new_id DOUBLE; 
             select max(Id) + 1 into new_id from logrondaextra; 
             insert into logrondaextra(Id, DataOperacao, EmailUtilizador, Operacao, EmailAnterior, EmailNovo,HoraInicioAnterior, HoraInicioNova, HoraFimAnterior, HoraFimNova, DataAnterior, DataNova)
             VALUES(new_id, now(), USER(), "D", OLD.EmailUtilizador, NULL, OLD.HoraInicio, NULL, OLD.HoraFim, NULL, OLD.Data, NULL); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rondaplaneada`
--

DROP TABLE IF EXISTS `rondaplaneada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rondaplaneada` (
  `EmailUtilizador` varchar(100) NOT NULL,
  `DataAno` date NOT NULL,
  `HoraRonda` time NOT NULL,
  PRIMARY KEY (`EmailUtilizador`,`DataAno`,`HoraRonda`),
  CONSTRAINT `fk_email_util` FOREIGN KEY (`EmailUtilizador`) REFERENCES `utilizador` (`EmailUtilizador`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rondaplaneada`
--

LOCK TABLES `rondaplaneada` WRITE;
/*!40000 ALTER TABLE `rondaplaneada` DISABLE KEYS */;
/*!40000 ALTER TABLE `rondaplaneada` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RondaPlaneada_insert_trigger` AFTER INSERT ON `rondaplaneada` FOR EACH ROW BEGIN 

             declare new_id DOUBLE; 
             select max(Id) + 1 into new_id from logrondaplaneada; 
             insert into logrondaplaneada(Id, DataOperacao, EmailUtilizador, Operacao, EmailAnterior, EmailNovo, DataAnterior, DataNova, HoraAnterior, HoraNova)
             VALUES(new_id, now(), USER(), "I", NULL, NEW.EmailUtilizador, NULL, NEW.DataAno, NULL, NEW.HoraRonda); 

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RondaPlaneada_update_trigger` AFTER UPDATE ON `rondaplaneada` FOR EACH ROW BEGIN 
           
           declare new_id DOUBLE; 
           select max(Id) + 1 into new_id from logrondaplaneada; 
           insert into logrondaplaneada(Id, DataOperacao, EmailUtilizador, Operacao) VALUES (new_id, now(), USER(),"U"); 

if (OLD.EmailUtilizador is NULL and NEW.EmailUtilizador is NOT NULL) THEN 
update logrondaplaneada set  EmailAnterior = OLD.EmailUtilizador, EmailNovo = NEW.EmailUtilizador where Id = new_id; 
           end if; 

           if(OLD.DataAno <> NEW.DataAno) or (OLD.DataAno is NULL and NEW.DataAno is NOT NULL) THEN 
           update logrondaplaneada set EmailAnterior = Old.EmailUtilizador, DataAnterior = OLD.DataAno, DataNova = NEW.DataAno where Id = new_id; 
           end if; 

           if(OLD.HoraRonda <> NEW.HoraRonda) or (OLD.HoraRonda is NULL and NEW.HoraRonda is NOT NULL) THEN 
           update logrondaplaneada set EmailAnterior = Old.EmailUtilizador, HoraAnterior = OLD.HoraRonda, HoraNova = NEW.HoraRonda where Id = new_id; 
           end if; 

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RondaPlaneada_delete_trigger` AFTER DELETE ON `rondaplaneada` FOR EACH ROW BEGIN 

             declare new_id DOUBLE; 
             select max(Id) + 1 into new_id from logrondaplaneada; 
             insert into logrondaplaneada(Id, DataOperacao, EmailUtilizador, Operacao, EmailAnterior, EmailNovo, DataAnterior, DataNova, HoraAnterior, HoraNova)
             VALUES(new_id, now(), USER(), "D", OLD.EmailUtilizador, NULL, OLD.DataAno, NULL, OLD.HoraRonda, NULL); 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sistema`
--

DROP TABLE IF EXISTS `sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sistema` (
  `LimiteTemperatura` decimal(6,2) NOT NULL,
  `LimiteHumidade` decimal(6,2) NOT NULL,
  `LimiteLuminosidade` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema`
--

LOCK TABLES `sistema` WRITE;
/*!40000 ALTER TABLE `sistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `sistema` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Sistema_insert_trigger` AFTER INSERT ON `sistema` FOR EACH ROW BEGIN 

             declare new_id DOUBLE; 
             select max(Id) + 1 into new_id from logsistema; 
             insert into logsistema(Id, DataOperacao, EmailUtilizador, Operacao, LimiteTemperaturaAnterior, LimiteTemperaturaNovo, 
                                                   LimiteHumidadeAnterior, LimiteHumidadeNovo, LimiteLuminosidadeAnterior,  LimiteLuminosidadeNovo) 
             VALUES(new_id, now(), USER(), "I", NULL, NEW.LimiteTemperatura, NULL, NEW.LimiteHumidade, NULL, NEW.LimiteLuminosidade); 

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Sistema_update_trigger` AFTER UPDATE ON `sistema` FOR EACH ROW BEGIN 
           
           declare new_id DOUBLE; 
           select max(Id) + 1 into new_id from logsistema; 
           insert into logsistema(Id, DataOperacao, EmailUtilizador, Operacao) VALUES (new_id, now(), USER(),"U"); 

           if(OLD.LimiteTemperatura<> NEW.LimiteTemperatura) or (OLD.LimiteTemperatura is NULL and NEW.LimiteTemperatura is NOT NULL) THEN 
           update logsistema set  LimiteTemperaturaAnterior = OLD.LimiteTemperatura, LimiteTemperaturaNovo = NEW.LimiteTemperatura where Id = new_id; 
           end if; 

            if(OLD.LimiteHumidade<> NEW.LimiteHumidade) or (OLD.LimiteHumidade is NULL and NEW.LimiteHumidade is NOT NULL) THEN 
           update logsistema set  LimiteHumidadeAnterior = OLD.LimiteHumidade, LimiteHumidadeNovo = NEW.LimiteHumidade where Id = new_id; 
           end if; 

            if(OLD.LimiteLuminosidade<> NEW.LimiteLuminosidade) or (OLD.LimiteLuminosidade is NULL and NEW.LimiteLuminosidade is NOT NULL) THEN 
           update logsistema set  LimiteLuminosidadeAnterior = OLD.LimiteLuminosidade, LimiteLuminosidadeNovo = NEW.LimiteLuminosidade where Id = new_id; 
           end if; 


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Sistema_delete_trigger` AFTER DELETE ON `sistema` FOR EACH ROW BEGIN 

             declare new_id DOUBLE; 
             select max(Id) + 1 into new_id from logsistema; 
             insert into logsistema(Id, DataOperacao, EmailUtilizador, Operacao, LimiteTemperaturaAnterior, LimiteTemperaturaNovo, 
                                                   LimiteHumidadeAnterior, LimiteHumidadeNovo, LimiteLuminosidadeAnterior,  LimiteLuminosidadeNovo) 
             VALUES(new_id, now(), USER(), "D", OLD.LimiteTemperatura, NULL, OLD.LimiteHumidade, NULL, OLD.LimiteLuminosidade, NULL); 

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `utilizador`
--

DROP TABLE IF EXISTS `utilizador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utilizador` (
  `EmailUtilizador` varchar(100) NOT NULL,
  `NomeUtilizador` varchar(80) NOT NULL,
  `TipoUtilizador` enum('Seguranca','ChefeSeguranca','Administrador','DiretorMuseu') NOT NULL,
  `MoradaUtilizador` varchar(200) NOT NULL,
  PRIMARY KEY (`EmailUtilizador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilizador`
--

LOCK TABLES `utilizador` WRITE;
/*!40000 ALTER TABLE `utilizador` DISABLE KEYS */;
/*!40000 ALTER TABLE `utilizador` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Utilizador_insert_trigger` AFTER INSERT ON `utilizador` FOR EACH ROW BEGIN declare new_id DOUBLE; select max(Id) + 1 into new_id from logutilizador; insert into logutilizador(Id, DataOperacao, EmailUtilizador, Operacao, EmailAnterior, EmailNovo, NomeAnterior, NomeNovo, TipoAnterior, TipoNovo, MoradaAnterior, MoradaNova) VALUES(new_id, now(), USER(), "I", NULL, NEW.EmailUtilizador, NULL, NEW.NomeUtilizador, NULL, NEW.TipoUtilizador, NULL, NEW.MoradaUtilizador); END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Utilizador_update_trigger` AFTER UPDATE ON `utilizador` FOR EACH ROW BEGIN declare new_id DOUBLE; select max(Id) + 1 into new_id from logutilizador; insert into logutilizador(Id, DataOperacao, EmailUtilizador, Operacao) VALUES (new_id, now(), USER(),"U"); if(OLD.EmailUtilizador<> NEW.EmailUtilizador) or (OLD.EmailUtilizador is NULL and NEW.EmailUtilizador is NOT NULL) THEN update logutilizador set  EmailAnterior = OLD.EmailUtilizador, EmailNovo = NEW.EmailUtilizador where Id = new_id; end if; if(OLD.NomeUtilizador <> NEW.NomeUtilizador) or (OLD.NomeUtilizador is NULL and NEW.NomeUtilizador is NOT NULL) THEN update logutilizador set NomeAnterior = OLD.NomeUtilizador, NomeNovo = NEW.NomeUtilizador where Id = new_id; end if; if(OLD.TipoUtilizador <> NEW.TipoUtilizador) or (OLD.TipoUtilizador is NULL and NEW.TipoUtilizador is NOT NULL) THEN update logutilizador set TipoAnterior = OLD.TipoUtilizador, TipoNovo = NEW.TipoUtilizador where Id = new_id; end if; if(OLD.MoradaUtilizador <> NEW.MoradaUtilizador) or (OLD.MoradaUtilizador is NULL and NEW.MoradaUtilizador is NOT NULL) THEN update logutilizador set EmailAnterior=Old.EmailUtilizador, MoradaAnterior = OLD.MoradaUtilizador, MoradaNova = NEW.MoradaUtilizador where Id = new_id; end if; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Utilizador_delete_trigger` AFTER DELETE ON `utilizador` FOR EACH ROW BEGIN declare new_id DOUBLE; select max(Id) + 1 into new_id from logutilizador; insert into logutilizador(Id, DataOperacao, EmailUtilizador, Operacao, EmailAnterior, EmailNovo, NomeAnterior, NomeNovo, TipoAnterior, TipoNovo, MoradaAnterior, MoradaNova) VALUES(new_id, now(), USER(), "D", OLD.EmailUtilizador, NULL, OLD.NomeUtilizador, NULL, OLD.TipoUtilizador, NULL, OLD.MoradaUtilizador, NULL); END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'main'
--
/*!50003 DROP PROCEDURE IF EXISTS `Alterar_LimiteHumidade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Alterar_LimiteHumidade`(IN `Limite` DECIMAL(6,2))
    NO SQL
BEGIN
UPDATE sistema
SET LimiteHumidade=Limite;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Alterar_LimiteLuminosidade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Alterar_LimiteLuminosidade`(IN `Limite` DECIMAL(6,2))
    NO SQL
BEGIN
UPDATE sistema
SET LimiteLuminosidade=Limite;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Alterar_LimiteTemperatura` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Alterar_LimiteTemperatura`(IN `Limite` DECIMAL(6,2))
    NO SQL
BEGIN
UPDATE sistema
SET LimiteTemperatura=Limite;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Alterar_RondaPlaneada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Alterar_RondaPlaneada`(IN `Email` VARCHAR(80), IN `DataMudar` DATE, IN `DataNova` DATE, IN `HoraMudar` TIME, IN `HoraNova` TIME)
    NO SQL
BEGIN
UPDATE rondaplaneada
SET
DataAno=DataNova, HoraRonda=HoraNova
WHERE
EmailUtilizador = Email and
DataAno=DataMudar and HoraRonda=HoraMudar;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Consulta_Utilizador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Consulta_Utilizador`(IN `Email` VARCHAR(100))
    NO SQL
BEGIN
DECLARE new_id DOUBLE;
SELECT max(Id) + 1 into new_id from logutilizador;
insert into logutilizador(Id,DataOperacao,EmailUtilizador,Operacao, EmailAnterior)VALUES
(new_id, NOW(), USER(), 'S',Email);
SELECT * FROM utilizador
WHERE EmailUtilizador=Email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Eliminar_RondaPlaneada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Eliminar_RondaPlaneada`(IN `Email` VARCHAR(100), IN `DataRonda` DATE, IN `Hora` TIME)
    NO SQL
BEGIN
DELETE FROM rondaplaneada
WHERE Email=EmailUtilizador AND DataRonda=DataAno AND Hora=HoraRonda;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Export` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Export`()
    NO SQL
BEGIN
(SELECT 'Tabela','Id', 'DataOperacao', 'EmailUtilizador', 'Operacao', 'EmailAnterior', 'EmailNovo', 'NomeAnterior', 'NomeNovo', 'TipoAnterior', 'TipoNovo', 'MoradaAnterior', 'MoradaNova', 'DataAnterior', 'DataNova', 'HoraAnterior', 'HoraNova', 'HoraInicioAnterior', 'HoraInicioNova', 'HoraFimAnterior', 'HoraFimNovo', 'LimiteTemperaturaAnterior', 'LimiteTemperaturaNovo','LimiteHumidadeAnterior', 'LimiteHumidadeNovo','LimiteLuminosidadeAnterior', 'LimiteLuminosidadeNovo') 
UNION 
(SELECT 'logutilizador', Id, DataOperacao, EmailUtilizador, Operacao, IFNULL(EmailAnterior,'NULL'), IFNULL(EmailNovo,'NULL'), IFNULL(NomeAnterior,'NULL'), IFNULL(NomeNovo,'NULL'), IFNULL(TipoAnterior,'NULL'), IFNULL(TipoNovo,'NULL'), IFNULL(MoradaAnterior,'NULL'), IFNULL(MoradaNova,'NULL'),'NULL', 'NULL','NULL', 'NULL','NULL', 'NULL','NULL', 'NULL','NULL', 'NULL','NULL', 'NULL','NULL', 'NULL' from logutilizador where DATE(dataoperacao)=DATE(NOW()-INTERVAL 1 DAY)) 
UNION 
(SELECT 'logrondaplaneada', Id, DataOperacao, EmailUtilizador, Operacao, IFNULL(EmailAnterior,'NULL'), IFNULL(EmailNovo,'NULL'), 'NULL', 'NULL', 'NULL', 'NULL','NULL', 'NULL', IFNULL(DataAnterior,'NULL'), IFNULL(DataNova,'NULL'), IFNULL(HoraAnterior,'NULL'), IFNULL(HoraNova,'NULL'),'NULL', 'NULL','NULL', 'NULL','NULL', 'NULL','NULL', 'NULL','NULL', 'NULL' from logrondaplaneada where DATE(dataoperacao)=DATE(NOW()-INTERVAL 1 DAY)) 
UNION 
(SELECT 'logrondaextra', Id, DataOperacao, EmailUtilizador, Operacao, IFNULL(EmailAnterior,'NULL'), IFNULL(EmailNovo,'NULL'), 'NULL', 'NULL', 'NULL', 'NULL','NULL', 'NULL', IFNULL(DataAnterior,'NULL'), IFNULL(DataNova,'NULL'), 'NULL', 'NULL', IFNULL(HoraInicioAnterior,'NULL'), IFNULL(HoraInicioNova,'NULL'), IFNULL(HoraFimAnterior,'NULL'),IFNULL(HoraFimNova,'NULL'),'NULL', 'NULL','NULL', 'NULL','NULL', 'NULL' from logrondaextra where DATE(dataoperacao)=DATE(NOW()-INTERVAL 1 DAY)) 
UNION 
(SELECT 'logsistema', Id, DataOperacao, EmailUtilizador, Operacao, 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL','NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', 'NULL', IFNULL(LimiteTemperaturaAnterior,'NULL'), IFNULL(LimiteTemperaturaNovo,'NULL'), IFNULL(LimiteHumidadeAnterior,'NULL'), IFNULL(LimiteHumidadeNovo,'NULL'), IFNULL(LimiteLuminosidadeAnterior,'NULL'), IFNULL(LimiteLuminosidadeNovo,'NULL') from logsistema where DATE(dataoperacao)=DATE(NOW()-INTERVAL 1 DAY))
into OUTFILE 'C:/Users/pmsan/Desktop/migrate.csv' FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' LINES TERMINATED BY '\r\n';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Export_LogMedicoes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Export_LogMedicoes`()
    NO SQL
BEGIN
DECLARE last_id_main DOUBLE;
DECLARE last_id_log DOUBLE;
SELECT max(Id) into last_id_main from main.logmedicoes;
SELECT max(Id) into last_id_log from log.logmedicoes;
SELECT * FROM logmedicoes WHERE Id<= last_id_main and Id>last_id_log INTO OUTFILE 'c:/Users/pmsan/Desktop/SID/migraM.csv';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Export_LogRondaExtra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Export_LogRondaExtra`()
    NO SQL
BEGIN
DECLARE last_id_main DOUBLE;
DECLARE last_id_log DOUBLE;
SELECT max(Id) into last_id_main from main.logrondaextra;
SELECT max(Id) into last_id_log from log.logrondaextra;
SELECT * FROM logrondaextra WHERE Id<= last_id_main and Id>last_id_log INTO OUTFILE 'c:/Users/pmsan/Desktop/SID/migraRE.csv';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Export_LogRondaPlaneada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Export_LogRondaPlaneada`()
    NO SQL
BEGIN
DECLARE last_id_main DOUBLE;
DECLARE last_id_log DOUBLE;
select max(Id) into last_id_main from main.logrondaplaneada;
select max(Id) into last_id_log from log.logrondaplaneada;
SELECT * FROM logrondaplaneada WHERE Id <= last_id_main and Id > last_id_log into OUTFILE 'c:/Users/pmsan/Desktop/SID/migraRP.csv';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Export_LogSistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Export_LogSistema`()
    NO SQL
BEGIN
DECLARE last_id_main DOUBLE;
DECLARE last_id_log DOUBLE;
SELECT max(Id) into last_id_main from main.logsistema;
SELECT max(Id) into last_id_log from log.logsistema;
SELECT * FROM logsistema WHERE Id<= last_id_main and Id>last_id_log INTO OUTFILE 'c:/Users/pmsan/Desktop/SID/migraS.csv';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Export_LogUtilizador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Export_LogUtilizador`()
    NO SQL
BEGIN
DECLARE last_id_main DOUBLE;
DECLARE last_id_log DOUBLE;
SELECT max(Id) into last_id_main from main.logutilizador;
SELECT max(Id) into last_id_log from log.logutilizador;
SELECT * FROM logutilizador WHERE Id<= last_id_main and Id>last_id_log INTO OUTFILE 'c:/Users/pmsan/Desktop/SID/migraU.csv';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `export_test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `export_test`()
    NO SQL
BEGIN
DECLARE last_id_origin DOUBLE;
DECLARE last_id_destiny DOUBLE;
select count(*) from main.logutilizador into last_id_origin;
select count(*) from log.logutilizador into last_id_destiny;
IF last_id_origin > last_id_destiny THEN
call main.Export_LogUtilizador();
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Insercao_Utilizador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insercao_Utilizador`(IN `Nome` VARCHAR(80), IN `Morada` VARCHAR(200), IN `Email` VARCHAR(100), IN `Tipo` ENUM('Seguranca','ChefeSeguranca','DiretorMuseu','Administrador'))
    NO SQL
BEGIN DECLARE NEW_USER VARCHAR(80); INSERT INTO utilizador(EmailUtilizador, NomeUtilizador, TipoUtilizador, MoradaUtilizador) VALUES(Email, Nome,Tipo, Morada); SET NEW_USER = CONCAT('"', Email, '"@"localhost"'); SET @stmt = CONCAT('CREATE USER ', NEW_USER, ' IDENTIFIED BY "123456";'); PREPARE stm FROM @stmt; EXECUTE stm; SET @stmt = CONCAT('GRANT ', Tipo, ' TO ', NEW_USER); PREPARE stm FROM @stmt; EXECUTE stm; SET @stmt = CONCAT('SET DEFAULT ROLE ', Tipo, ' FOR ', NEW_USER); PREPARE stm FROM @stmt; EXECUTE stm; DEALLOCATE PREPARE stm; END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Inserir_RondaExtra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Inserir_RondaExtra`(IN `Email` VARCHAR(100), IN `HoraIn` TIME, IN `HoraOut` TIME, IN `DataRondaExtra` DATE)
    NO SQL
BEGIN
INSERT INTO rondaextra(EmailUtilizador, HoraInicio, HoraFim, Data) VALUES (Email, HoraIn, HoraOut, DataRondaExtra);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Inserir_RondaPlaneada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Inserir_RondaPlaneada`(IN `Email` VARCHAR(80), IN `NovaData` DATE, IN `Ronda` TIME)
    NO SQL
BEGIN
INSERT INTO rondaplaneada(EmailUtilizador, DataAno, HoraRonda)
VALUES(Email, NovaData, Ronda);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Mudar_Morada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Mudar_Morada`(IN `Morada` VARCHAR(200))
    NO SQL
BEGIN
SET @USER_P = SUBSTRING_INDEX(USER(),'@',2);
UPDATE utilizador
SET MoradaUtilizador=Morada
WHERE EmailUtilizador=@USER_P;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Mudar_Password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Mudar_Password`(IN `Pass` VARCHAR(20))
    NO SQL
BEGIN
SET @user_p = CONCAT("'",SUBSTRING_INDEX(USER(), '@',2),"'@'localhost'");
SET @sql = CONCAT("SET PASSWORD FOR ", @user_p, "=PASSWORD('", Pass,"')");
PREPARE stm FROM @sql; 
EXECUTE stm; 
DEALLOCATE PREPARE stm; 
FLUSH PRIVILEGES;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Remocao_Utilizador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Remocao_Utilizador`(IN `Email` VARCHAR(100))
    NO SQL
BEGIN
DELETE FROM utilizador
WHERE Email=EmailUtilizador;
SET @stm = CONCAT ("DROP USER '", Email, "'@localhost");
PREPARE stm FROM @stm;
EXECUTE stm;
DEALLOCATE PREPARE stm;
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

-- Dump completed on 2020-04-08 15:27:10
