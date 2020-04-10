-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 10, 2020 at 04:00 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sid_php`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Acknowledge_sensor` (IN `sensorID` INT)  NO SQL
BEGIN
UPDATE sensores SET senAck=1 WHERE ID=sensorID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Apagar_User` (IN `userID` INT)  NO SQL
BEGIN
SET @usernameToDrop:=(SELECT username from user where user.ID=userID);
SET @sql:=concat("DROP USER ", @usernameToDrop,"@","localhost");
PREPARE stmt1 FROM @sql;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;
DELETE FROM user where user.ID=userID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Atualizar_sensores` (IN `sensorID` INT, IN `senAviso` INT, IN `senAlarme` INT, IN `senLeitura` INT)  NO SQL
BEGIN
UPDATE sensores
SET sensores.senAviso=sensorAviso, sensores.senAlarme=sensorAlarme, sensores.senLeitura=sensorLeitura
WHERE sensores.ID=sensorID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Editar_user` (IN `Email` VARCHAR(50), IN `Nome` VARCHAR(20), IN `Apelido` VARCHAR(20))  NO SQL
BEGIN
SET @currentUsername:=substring_index(user(),'@',1);
UPDATE user SET user.email=Email, user.nome=Nome, user.apelido=Apelido WHERE user.username=@currentUsername;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Inserir_User` (IN `username` VARCHAR(20), IN `passwd` VARCHAR(50), IN `email` VARCHAR(50), IN `nome` VARCHAR(20), IN `apelido` VARCHAR(20), IN `grupoID` INT)  NO SQL
BEGIN
insert into user(ID, username, email, nome, apelido, grupoID) VALUES(NULL,username,email,nome ,apelido ,grupoID);
set @sql = concat("CREATE USER '",username,"'@'",'localhost',"' IDENTIFIED BY '",`passwd`,"'");
   PREPARE stmt1 FROM @sql;
   EXECUTE stmt1;
   DEALLOCATE PREPARE stmt1;
IF grupoID=1 THEN
	set @sql1=concat("Grant grupoSegurancas to", username,'@','localhost');
END IF;
IF grupoID=2 THEN
	SET @sql1=concat("Grant grupoSegurancas to ",username,'@','localhost');
END IF;
IF grupoID=3 THEN
	SET @sql1=concat("Grant chefeSeguranca to ",username,'@','localhost');
END IF;
IF grupoID=4 THEN
	SET @sql1=concat("Grant diretorMuseu to ", username,'@','localhost');
END IF;
   PREPARE stmt1 FROM @sql1;
   EXECUTE stmt1;
   DEALLOCATE PREPARE stmt1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Mudar_password` (IN `PassNova` VARCHAR(20))  NO SQL
BEGIN
set @sql = concat("set password for ", USER(), " = PASSWORD('",PassNova , "')");
prepare stmt1 from @sql;
execute stmt1;
deallocate prepare stmt1;
FLUSH PRIVILEGES;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ronda_extra` ()  NO SQL
BEGIN SET @currentUser=substring_index(user(),'@',1); SET @currentID=(SELECT ID from sid_php.user where user.username=@currentUser); SET @uID=(SELECT MAX(ID) FROM(SELECT ID,userID FROM rondaextra where userID=@currentID)as subquery); IF @uID is not NULL THEN SET @dataFimToCheck=(SELECT dataFim FROM rondaextra WHERE ID=@uID); SET @dataInicioToCheck=(SELECT dataInicio FROM rondaextra WHERE ID=@uID); END IF; IF @dataFimToCheck is NULL AND @dataInicioToCheck is NULL THEN INSERT INTO rondaextra(ID,dataInicio,dataFim,userID) VALUES (NULL,NOW(),NULL,@currentID); END IF; IF @dataFimToCheck is NULL AND @dataInicioToCheck is NOT NULL THEN UPDATE rondaextra SET dataFim=now() WHERE dataInicio=@dataInicioToCheck ; END IF; IF @dataFimToCheck is NOT NULL AND @dataInicioToCheck is NOT NULL THEN INSERT INTO rondaextra(ID,dataInicio,dataFim,userID) VALUES (NULL,NOW(),NULL,@currentID); END IF; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test` ()  NO SQL
BEGIN set @x=1; label: LOOP IF @x > 1000 THEN LEAVE label; END IF; SET @x=@x+1; set @usernameToadd=concat("user",@x); INSERT INTO user(ID,username,email,nome,apelido,grupoID) VALUES (NULL,@usernameToadd,"m@m","nome","apelido", 2); ITERATE label; END LOOP; END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `grupo`
--

CREATE TABLE `grupo` (
  `ID` int(11) NOT NULL,
  `descricao` varchar(50) NOT NULL,
  `nome` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `grupo`
--

INSERT INTO `grupo` (`ID`, `descricao`, `nome`) VALUES
(1, 'para o(s) administrador(es)', 'grupoAdministradores'),
(2, 'para os segurancas', 'segurancas'),
(3, 'chefe de seguranca', 'chefeSeguranca'),
(4, 'Diretor de museu', 'Diretor de museu');

-- --------------------------------------------------------

--
-- Table structure for table `medicoes`
--

CREATE TABLE `medicoes` (
  `ID` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sensorID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `medicoes_logs`
--

CREATE TABLE `medicoes_logs` (
  `ID` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `dataHora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ronda`
--

CREATE TABLE `ronda` (
  `dia` varchar(20) NOT NULL,
  `inicio` time NOT NULL,
  `duracao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `ronda`
--
DELIMITER $$
CREATE TRIGGER `Ronda_delete_trigger` AFTER DELETE ON `ronda` FOR EACH ROW BEGIN
	insert into ronda_logs(op, opUser, opDAta, ID, diaAntes, diaDepois, inicioAntes, inicioDepois, duracaoAntes, duracaoDepois)
	VALUES("D", CURRENT_USER, NOW(), NULL, OLD.dia, NULL, OLD.inicio, NULL, OLD.duracao, NULL);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ronda_insert_trigger` AFTER INSERT ON `ronda` FOR EACH ROW BEGIN   
	insert into ronda_logs(op, opUser, opDAta, ID, diaAntes, diaDepois, inicioAntes, inicioDepois, duracaoAntes, duracaoDepois)
	VALUES("I", CURRENT_USER, NOW(), NULL, NULL, NEW.dia, NULL, NEW.inicio, NULL, NEW.duracao);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ronda_update_trigger` AFTER UPDATE ON `ronda` FOR EACH ROW BEGIN
	declare new_id DOUBLE;
	select max(id) + 1 into new_id from ronda_logs;
	insert into ronda_logs(op, opUser, opData, ID)
	VALUES ("U", CURRENT_USER, NOW(), NULL);

	
	if(old.dia <> new.dia) or (old.dia is NULL and new.dia is NOT NULL) THEN
		update ronda_logs set diaAntes = OLD.dia, diaDepois = NEW.dia where ID = new_id;
	end if;

	if(old.inicio <> new.inicio) or (old.inicio is NULL and new.inicio is NOT NULL) THEN
		update ronda_logs set inicioAntes = OLD.inicio, inicioDepois = NEW.inicio where ID = new_id;
	end if;

	if(old.duracao <> new.duracao) or (old.duracao is NULL and new.duracao is NOT NULL) THEN
		update ronda_logs set duracaoAntes = OLD.duracao, duracaoDepois = NEW.duracao where ID = new_id;
	end if;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rondaextra`
--

CREATE TABLE `rondaextra` (
  `ID` int(11) NOT NULL,
  `dataInicio` date DEFAULT NULL,
  `dataFim` date DEFAULT NULL,
  `userID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rondaextra`
--

INSERT INTO `rondaextra` (`ID`, `dataInicio`, `dataFim`, `userID`) VALUES
(6, '2020-04-03', '2020-04-03', 12);

--
-- Triggers `rondaextra`
--
DELIMITER $$
CREATE TRIGGER `RondaExtra_delete_trigger` AFTER DELETE ON `rondaextra` FOR EACH ROW BEGIN
	insert into  rondaextra_logs(op, opUser, opData, ID, dataAntes, dataDepois)
	VALUES("D", CURRENT_USER, NOW(), NULL, OLD.dataInicio, NULL);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `RondaExtra_insert_trigger` AFTER INSERT ON `rondaextra` FOR EACH ROW BEGIN
	insert into  rondaextra_logs(op, opUser, opData, ID, dataAntes, dataDepois)
	VALUES("I", CURRENT_USER, NOW(), NULL, NULL, NEW.dataInicio);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rondaextra_logs`
--

CREATE TABLE `rondaextra_logs` (
  `ID` int(11) NOT NULL,
  `op` varchar(30) NOT NULL,
  `opUser` varchar(20) NOT NULL,
  `opData` date NOT NULL,
  `dataAntes` date DEFAULT NULL,
  `dataDepois` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rondaextra_logs`
--

INSERT INTO `rondaextra_logs` (`ID`, `op`, `opUser`, `opData`, `dataAntes`, `dataDepois`) VALUES
(1, 'I', 'root@localhost', '2020-04-02', NULL, '2020-04-02'),
(2, 'I', 'root@localhost', '2020-04-02', NULL, '2020-04-02'),
(3, 'D', 'root@localhost', '2020-04-02', '2020-04-02', NULL),
(4, 'I', 'root@localhost', '2020-04-02', NULL, NULL),
(5, 'D', 'root@localhost', '2020-04-02', '2020-04-02', NULL),
(6, 'D', 'root@localhost', '2020-04-02', NULL, NULL),
(7, 'I', 'root@localhost', '2020-04-03', NULL, '2020-04-03'),
(8, 'I', 'root@localhost', '2020-04-03', NULL, '2020-04-03'),
(9, 'D', 'root@localhost', '2020-04-03', '2020-04-03', NULL),
(10, 'D', 'root@localhost', '2020-04-03', '2020-04-03', NULL),
(11, 'I', 'root@localhost', '2020-04-03', NULL, '2020-04-03');

-- --------------------------------------------------------

--
-- Table structure for table `rondaplaneada`
--

CREATE TABLE `rondaplaneada` (
  `ID` int(11) NOT NULL,
  `data` date NOT NULL,
  `dia` varchar(20) NOT NULL,
  `inicio` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `rondaplaneada`
--
DELIMITER $$
CREATE TRIGGER `RondaPlaneada_delete_trigger` AFTER DELETE ON `rondaplaneada` FOR EACH ROW BEGIN
	insert into rondaplaneada_logs(ID, data)
	VALUES(NULL, OLD.data);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `RondaPlaneada_insert_trigger` AFTER INSERT ON `rondaplaneada` FOR EACH ROW BEGIN
	insert into rondaplaneada_logs(ID, data)
	VALUES(NULL, NEW.data);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `RondaPlaneada_update_trigger` AFTER UPDATE ON `rondaplaneada` FOR EACH ROW BEGIN
	declare new_id DOUBLE;
	select max(id) + 1 into new_id from rondaplaneada_logs;
	insert into rondaplaneada_logs(ID)
	VALUES(NULL);

	if(old.data <> new.data) or (old.data is NULL and new.data is NOT NULL) THEN
		update rondaplaneada_logs set data = NEW.data where ID = new_id;
	end if;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rondaplaneada_logs`
--

CREATE TABLE `rondaplaneada_logs` (
  `ID` int(11) NOT NULL,
  `data` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ronda_logs`
--

CREATE TABLE `ronda_logs` (
  `ID` int(11) NOT NULL,
  `op` varchar(30) NOT NULL,
  `opUser` varchar(20) NOT NULL,
  `opData` date NOT NULL,
  `diaAntes` varchar(20) DEFAULT NULL,
  `diaDepois` varchar(20) DEFAULT NULL,
  `inicioAntes` time DEFAULT NULL,
  `inicioDepois` time DEFAULT NULL,
  `duracaoAntes` int(11) DEFAULT NULL,
  `duracaoDepois` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `sensores`
--

CREATE TABLE `sensores` (
  `ID` int(11) NOT NULL,
  `senTipo` varchar(10) NOT NULL,
  `senEstado` int(11) NOT NULL,
  `senAck` tinyint(1) NOT NULL,
  `senAviso` int(11) NOT NULL,
  `senAlarme` int(11) NOT NULL,
  `senLeitura` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `sensores`
--
DELIMITER $$
CREATE TRIGGER `Sensores_delete_trigger` AFTER DELETE ON `sensores` FOR EACH ROW BEGIN
	insert into sensores_logs(op, opUser, opDAta, ID, senTip, senEstadoAntes, senEstadoDepois, senAckAntes, senAckDepois, senAvisoAntes, senAvisoDepois, senAlarmeAntes, senAlarmeDepois, sen_leitura)
	VALUES("D", CURRENT_USER, NOW(), NULL, OLD.senTipo, OLD.senEstado, NULL, OLD.senAck, NULL , OLD.senAviso, NULL , OLD.senAlarme, NULL , OLD.senLeitura);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Sensores_insert_trigger` AFTER INSERT ON `sensores` FOR EACH ROW BEGIN
	insert into sensores_logs(op, opUser, opDAta, ID, senTip, senEstadoAntes, senEstadoDepois, senAckAntes, senAckDepois, senAvisoAntes, senAvisoDepois, senAlarmeAntes, senAlarmeDepois, sen_leitura)
	VALUES("I", CURRENT_USER, NOW(), NULL, NEW.senTipo, NULL, NEW.senEstado, NULL, NEW.senAck, NULL, NEW.senAviso, NULL, NEW.senAlarme, NEW.senLeitura);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Sensores_update_trigger` AFTER UPDATE ON `sensores` FOR EACH ROW BEGIN
	declare new_id DOUBLE;
	select max(id) + 1 into new_id from sensores_logs;
	insert into sensores_logs(op, opUser, opDAta, ID)
	VALUES("U", CURRENT_USER, NOW(), NULL);


	if(old.senTipo <> new.senTipo) or (old.senTipo is NULL and new.senTipo is NOT NULL) THEN
		update sensores_logs set senTip = NEW.senTipo where ID = new_id;
	end if;

	if(old.senEstado <> new.senEstado) or (old.senEstado is NULL and new.senEstado is NOT NULL) THEN
		update sensores_logs set senEstadoAntes = OLD.senEstado, senEstadoDepois = NEW.senEstado where ID = new_id;
	end if;

	if(old.senAck <> new.senAck) or (old.senAck is NULL and new.senAck is NOT NULL) THEN
		update sensores_logs set senAckAntes = OLD.senAck, senAckDepois = NEW.senAck where ID = new_id;
	end if;

	if(old.senAviso <> new.senAviso) or (old.senAviso is NULL and new.senAviso is NOT NULL) THEN
		update sensores_logs set senAvisoAntes = OLD.senAviso, senAvisoDepois = NEW.senAviso where ID = new_id;
	end if;
	
	if(old.senAlarme <> new.senAlarme) or (old.senAlarme is NULL and new.senAlarme is NOT NULL) THEN
		update sensores_logs set senAlarmeAntes = OLD.senAlarme, senAlarmeDepois = NEW.senAlarme where ID = new_id;
	end if;


	if(old.senLeitura <> new.senLeitura) or (old.senLeitura is NULL and new.senLeitura is NOT NULL) THEN
		update sensores_logs set sen_leitura = NEW.senLeitura where ID = new_id;
	end if;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sensores_logs`
--

CREATE TABLE `sensores_logs` (
  `ID` int(11) NOT NULL,
  `op` varchar(30) NOT NULL,
  `opUser` varchar(20) NOT NULL,
  `opData` date NOT NULL,
  `senTip` varchar(10) DEFAULT NULL,
  `senEstadoAntes` int(11) DEFAULT NULL,
  `senEstadoDepois` int(11) DEFAULT NULL,
  `senAckAntes` tinyint(1) DEFAULT NULL,
  `senAckDepois` tinyint(1) DEFAULT NULL,
  `senAvisoAntes` int(11) DEFAULT NULL,
  `senAvisoDepois` int(11) DEFAULT NULL,
  `senAlarmeAntes` int(11) DEFAULT NULL,
  `senAlarmeDepois` int(11) DEFAULT NULL,
  `sen_leitura` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `ID` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `apelido` varchar(20) NOT NULL,
  `grupoID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`ID`, `username`, `email`, `nome`, `apelido`, `grupoID`) VALUES
(5, 'administrador', 'admin@admin', 'admin', 'admin', 1),
(12, 'seguranca', 'seg@seg', 'Seguranca', 'seg', 2),
(13, 'user2', 'm@m', 'nome', 'apelido', 2),
(14, 'user3', 'm@m', 'nome', 'apelido', 2),
(15, 'user4', 'm@m', 'nome', 'apelido', 2),
(16, 'user5', 'm@m', 'nome', 'apelido', 2),
(17, 'user6', 'm@m', 'nome', 'apelido', 2),
(18, 'user7', 'm@m', 'nome', 'apelido', 2),
(19, 'user8', 'm@m', 'nome', 'apelido', 2),
(20, 'user9', 'm@m', 'nome', 'apelido', 2),
(21, 'user10', 'm@m', 'nome', 'apelido', 2),
(22, 'user11', 'm@m', 'nome', 'apelido', 2),
(23, 'user12', 'm@m', 'nome', 'apelido', 2),
(24, 'user13', 'm@m', 'nome', 'apelido', 2),
(25, 'user14', 'm@m', 'nome', 'apelido', 2),
(26, 'user15', 'm@m', 'nome', 'apelido', 2),
(27, 'user16', 'm@m', 'nome', 'apelido', 2),
(28, 'user17', 'm@m', 'nome', 'apelido', 2),
(29, 'user18', 'm@m', 'nome', 'apelido', 2),
(30, 'user19', 'm@m', 'nome', 'apelido', 2),
(31, 'user20', 'm@m', 'nome', 'apelido', 2),
(32, 'user21', 'm@m', 'nome', 'apelido', 2),
(33, 'user22', 'm@m', 'nome', 'apelido', 2),
(34, 'user23', 'm@m', 'nome', 'apelido', 2),
(35, 'user24', 'm@m', 'nome', 'apelido', 2),
(36, 'user25', 'm@m', 'nome', 'apelido', 2),
(37, 'user26', 'm@m', 'nome', 'apelido', 2),
(38, 'user27', 'm@m', 'nome', 'apelido', 2),
(39, 'user28', 'm@m', 'nome', 'apelido', 2),
(40, 'user29', 'm@m', 'nome', 'apelido', 2),
(41, 'user30', 'm@m', 'nome', 'apelido', 2),
(42, 'user31', 'm@m', 'nome', 'apelido', 2),
(43, 'user32', 'm@m', 'nome', 'apelido', 2),
(44, 'user33', 'm@m', 'nome', 'apelido', 2),
(45, 'user34', 'm@m', 'nome', 'apelido', 2),
(46, 'user35', 'm@m', 'nome', 'apelido', 2),
(47, 'user36', 'm@m', 'nome', 'apelido', 2),
(48, 'user37', 'm@m', 'nome', 'apelido', 2),
(49, 'user38', 'm@m', 'nome', 'apelido', 2),
(50, 'user39', 'm@m', 'nome', 'apelido', 2),
(51, 'user40', 'm@m', 'nome', 'apelido', 2),
(52, 'user41', 'm@m', 'nome', 'apelido', 2),
(53, 'user42', 'm@m', 'nome', 'apelido', 2),
(54, 'user43', 'm@m', 'nome', 'apelido', 2),
(55, 'user44', 'm@m', 'nome', 'apelido', 2),
(56, 'user45', 'm@m', 'nome', 'apelido', 2),
(57, 'user46', 'm@m', 'nome', 'apelido', 2),
(58, 'user47', 'm@m', 'nome', 'apelido', 2),
(59, 'user48', 'm@m', 'nome', 'apelido', 2),
(60, 'user49', 'm@m', 'nome', 'apelido', 2),
(61, 'user50', 'm@m', 'nome', 'apelido', 2),
(62, 'user51', 'm@m', 'nome', 'apelido', 2),
(63, 'user52', 'm@m', 'nome', 'apelido', 2),
(64, 'user53', 'm@m', 'nome', 'apelido', 2),
(65, 'user54', 'm@m', 'nome', 'apelido', 2),
(66, 'user55', 'm@m', 'nome', 'apelido', 2),
(67, 'user56', 'm@m', 'nome', 'apelido', 2),
(68, 'user57', 'm@m', 'nome', 'apelido', 2),
(69, 'user58', 'm@m', 'nome', 'apelido', 2),
(70, 'user59', 'm@m', 'nome', 'apelido', 2),
(71, 'user60', 'm@m', 'nome', 'apelido', 2),
(72, 'user61', 'm@m', 'nome', 'apelido', 2),
(73, 'user62', 'm@m', 'nome', 'apelido', 2),
(74, 'user63', 'm@m', 'nome', 'apelido', 2),
(75, 'user64', 'm@m', 'nome', 'apelido', 2),
(76, 'user65', 'm@m', 'nome', 'apelido', 2),
(77, 'user66', 'm@m', 'nome', 'apelido', 2),
(78, 'user67', 'm@m', 'nome', 'apelido', 2),
(79, 'user68', 'm@m', 'nome', 'apelido', 2),
(80, 'user69', 'm@m', 'nome', 'apelido', 2),
(81, 'user70', 'm@m', 'nome', 'apelido', 2),
(82, 'user71', 'm@m', 'nome', 'apelido', 2),
(83, 'user72', 'm@m', 'nome', 'apelido', 2),
(84, 'user73', 'm@m', 'nome', 'apelido', 2),
(85, 'user74', 'm@m', 'nome', 'apelido', 2),
(86, 'user75', 'm@m', 'nome', 'apelido', 2),
(87, 'user76', 'm@m', 'nome', 'apelido', 2),
(88, 'user77', 'm@m', 'nome', 'apelido', 2),
(89, 'user78', 'm@m', 'nome', 'apelido', 2),
(90, 'user79', 'm@m', 'nome', 'apelido', 2),
(91, 'user80', 'm@m', 'nome', 'apelido', 2),
(92, 'user81', 'm@m', 'nome', 'apelido', 2),
(93, 'user82', 'm@m', 'nome', 'apelido', 2),
(94, 'user83', 'm@m', 'nome', 'apelido', 2),
(95, 'user84', 'm@m', 'nome', 'apelido', 2),
(96, 'user85', 'm@m', 'nome', 'apelido', 2),
(97, 'user86', 'm@m', 'nome', 'apelido', 2),
(98, 'user87', 'm@m', 'nome', 'apelido', 2),
(99, 'user88', 'm@m', 'nome', 'apelido', 2),
(100, 'user89', 'm@m', 'nome', 'apelido', 2),
(101, 'user90', 'm@m', 'nome', 'apelido', 2),
(102, 'user91', 'm@m', 'nome', 'apelido', 2),
(103, 'user92', 'm@m', 'nome', 'apelido', 2),
(104, 'user93', 'm@m', 'nome', 'apelido', 2),
(105, 'user94', 'm@m', 'nome', 'apelido', 2),
(106, 'user95', 'm@m', 'nome', 'apelido', 2),
(107, 'user96', 'm@m', 'nome', 'apelido', 2),
(108, 'user97', 'm@m', 'nome', 'apelido', 2),
(109, 'user98', 'm@m', 'nome', 'apelido', 2),
(110, 'user99', 'm@m', 'nome', 'apelido', 2),
(111, 'user100', 'm@m', 'nome', 'apelido', 2),
(112, 'user101', 'm@m', 'nome', 'apelido', 2),
(113, 'user102', 'm@m', 'nome', 'apelido', 2),
(114, 'user103', 'm@m', 'nome', 'apelido', 2),
(115, 'user104', 'm@m', 'nome', 'apelido', 2),
(116, 'user105', 'm@m', 'nome', 'apelido', 2),
(117, 'user106', 'm@m', 'nome', 'apelido', 2),
(118, 'user107', 'm@m', 'nome', 'apelido', 2),
(119, 'user108', 'm@m', 'nome', 'apelido', 2),
(120, 'user109', 'm@m', 'nome', 'apelido', 2),
(121, 'user110', 'm@m', 'nome', 'apelido', 2),
(122, 'user111', 'm@m', 'nome', 'apelido', 2),
(123, 'user112', 'm@m', 'nome', 'apelido', 2),
(124, 'user113', 'm@m', 'nome', 'apelido', 2),
(125, 'user114', 'm@m', 'nome', 'apelido', 2),
(126, 'user115', 'm@m', 'nome', 'apelido', 2),
(127, 'user116', 'm@m', 'nome', 'apelido', 2),
(128, 'user117', 'm@m', 'nome', 'apelido', 2),
(129, 'user118', 'm@m', 'nome', 'apelido', 2),
(130, 'user119', 'm@m', 'nome', 'apelido', 2),
(131, 'user120', 'm@m', 'nome', 'apelido', 2),
(132, 'user121', 'm@m', 'nome', 'apelido', 2),
(133, 'user122', 'm@m', 'nome', 'apelido', 2),
(134, 'user123', 'm@m', 'nome', 'apelido', 2),
(135, 'user124', 'm@m', 'nome', 'apelido', 2),
(136, 'user125', 'm@m', 'nome', 'apelido', 2),
(137, 'user126', 'm@m', 'nome', 'apelido', 2),
(138, 'user127', 'm@m', 'nome', 'apelido', 2),
(139, 'user128', 'm@m', 'nome', 'apelido', 2),
(140, 'user129', 'm@m', 'nome', 'apelido', 2),
(141, 'user130', 'm@m', 'nome', 'apelido', 2),
(142, 'user131', 'm@m', 'nome', 'apelido', 2),
(143, 'user132', 'm@m', 'nome', 'apelido', 2),
(144, 'user133', 'm@m', 'nome', 'apelido', 2),
(145, 'user134', 'm@m', 'nome', 'apelido', 2),
(146, 'user135', 'm@m', 'nome', 'apelido', 2),
(147, 'user136', 'm@m', 'nome', 'apelido', 2),
(148, 'user137', 'm@m', 'nome', 'apelido', 2),
(149, 'user138', 'm@m', 'nome', 'apelido', 2),
(150, 'user139', 'm@m', 'nome', 'apelido', 2),
(151, 'user140', 'm@m', 'nome', 'apelido', 2),
(152, 'user141', 'm@m', 'nome', 'apelido', 2),
(153, 'user142', 'm@m', 'nome', 'apelido', 2),
(154, 'user143', 'm@m', 'nome', 'apelido', 2),
(155, 'user144', 'm@m', 'nome', 'apelido', 2),
(156, 'user145', 'm@m', 'nome', 'apelido', 2),
(157, 'user146', 'm@m', 'nome', 'apelido', 2),
(158, 'user147', 'm@m', 'nome', 'apelido', 2),
(159, 'user148', 'm@m', 'nome', 'apelido', 2),
(160, 'user149', 'm@m', 'nome', 'apelido', 2),
(161, 'user150', 'm@m', 'nome', 'apelido', 2),
(162, 'user151', 'm@m', 'nome', 'apelido', 2),
(163, 'user152', 'm@m', 'nome', 'apelido', 2),
(164, 'user153', 'm@m', 'nome', 'apelido', 2),
(165, 'user154', 'm@m', 'nome', 'apelido', 2),
(166, 'user155', 'm@m', 'nome', 'apelido', 2),
(167, 'user156', 'm@m', 'nome', 'apelido', 2),
(168, 'user157', 'm@m', 'nome', 'apelido', 2),
(169, 'user158', 'm@m', 'nome', 'apelido', 2),
(170, 'user159', 'm@m', 'nome', 'apelido', 2),
(171, 'user160', 'm@m', 'nome', 'apelido', 2),
(172, 'user161', 'm@m', 'nome', 'apelido', 2),
(173, 'user162', 'm@m', 'nome', 'apelido', 2),
(174, 'user163', 'm@m', 'nome', 'apelido', 2),
(175, 'user164', 'm@m', 'nome', 'apelido', 2),
(176, 'user165', 'm@m', 'nome', 'apelido', 2),
(177, 'user166', 'm@m', 'nome', 'apelido', 2),
(178, 'user167', 'm@m', 'nome', 'apelido', 2),
(179, 'user168', 'm@m', 'nome', 'apelido', 2),
(180, 'user169', 'm@m', 'nome', 'apelido', 2),
(181, 'user170', 'm@m', 'nome', 'apelido', 2),
(182, 'user171', 'm@m', 'nome', 'apelido', 2),
(183, 'user172', 'm@m', 'nome', 'apelido', 2),
(184, 'user173', 'm@m', 'nome', 'apelido', 2),
(185, 'user174', 'm@m', 'nome', 'apelido', 2),
(186, 'user175', 'm@m', 'nome', 'apelido', 2),
(187, 'user176', 'm@m', 'nome', 'apelido', 2),
(188, 'user177', 'm@m', 'nome', 'apelido', 2),
(189, 'user178', 'm@m', 'nome', 'apelido', 2),
(190, 'user179', 'm@m', 'nome', 'apelido', 2),
(191, 'user180', 'm@m', 'nome', 'apelido', 2),
(192, 'user181', 'm@m', 'nome', 'apelido', 2),
(193, 'user182', 'm@m', 'nome', 'apelido', 2),
(194, 'user183', 'm@m', 'nome', 'apelido', 2),
(195, 'user184', 'm@m', 'nome', 'apelido', 2),
(196, 'user185', 'm@m', 'nome', 'apelido', 2),
(197, 'user186', 'm@m', 'nome', 'apelido', 2),
(198, 'user187', 'm@m', 'nome', 'apelido', 2),
(199, 'user188', 'm@m', 'nome', 'apelido', 2),
(200, 'user189', 'm@m', 'nome', 'apelido', 2),
(201, 'user190', 'm@m', 'nome', 'apelido', 2),
(202, 'user191', 'm@m', 'nome', 'apelido', 2),
(203, 'user192', 'm@m', 'nome', 'apelido', 2),
(204, 'user193', 'm@m', 'nome', 'apelido', 2),
(205, 'user194', 'm@m', 'nome', 'apelido', 2),
(206, 'user195', 'm@m', 'nome', 'apelido', 2),
(207, 'user196', 'm@m', 'nome', 'apelido', 2),
(208, 'user197', 'm@m', 'nome', 'apelido', 2),
(209, 'user198', 'm@m', 'nome', 'apelido', 2),
(210, 'user199', 'm@m', 'nome', 'apelido', 2),
(211, 'user200', 'm@m', 'nome', 'apelido', 2),
(212, 'user201', 'm@m', 'nome', 'apelido', 2),
(213, 'user202', 'm@m', 'nome', 'apelido', 2),
(214, 'user203', 'm@m', 'nome', 'apelido', 2),
(215, 'user204', 'm@m', 'nome', 'apelido', 2),
(216, 'user205', 'm@m', 'nome', 'apelido', 2),
(217, 'user206', 'm@m', 'nome', 'apelido', 2),
(218, 'user207', 'm@m', 'nome', 'apelido', 2),
(219, 'user208', 'm@m', 'nome', 'apelido', 2),
(220, 'user209', 'm@m', 'nome', 'apelido', 2),
(221, 'user210', 'm@m', 'nome', 'apelido', 2),
(222, 'user211', 'm@m', 'nome', 'apelido', 2),
(223, 'user212', 'm@m', 'nome', 'apelido', 2),
(224, 'user213', 'm@m', 'nome', 'apelido', 2),
(225, 'user214', 'm@m', 'nome', 'apelido', 2),
(226, 'user215', 'm@m', 'nome', 'apelido', 2),
(227, 'user216', 'm@m', 'nome', 'apelido', 2),
(228, 'user217', 'm@m', 'nome', 'apelido', 2),
(229, 'user218', 'm@m', 'nome', 'apelido', 2),
(230, 'user219', 'm@m', 'nome', 'apelido', 2),
(231, 'user220', 'm@m', 'nome', 'apelido', 2),
(232, 'user221', 'm@m', 'nome', 'apelido', 2),
(233, 'user222', 'm@m', 'nome', 'apelido', 2),
(234, 'user223', 'm@m', 'nome', 'apelido', 2),
(235, 'user224', 'm@m', 'nome', 'apelido', 2),
(236, 'user225', 'm@m', 'nome', 'apelido', 2),
(237, 'user226', 'm@m', 'nome', 'apelido', 2),
(238, 'user227', 'm@m', 'nome', 'apelido', 2),
(239, 'user228', 'm@m', 'nome', 'apelido', 2),
(240, 'user229', 'm@m', 'nome', 'apelido', 2),
(241, 'user230', 'm@m', 'nome', 'apelido', 2),
(242, 'user231', 'm@m', 'nome', 'apelido', 2),
(243, 'user232', 'm@m', 'nome', 'apelido', 2),
(244, 'user233', 'm@m', 'nome', 'apelido', 2),
(245, 'user234', 'm@m', 'nome', 'apelido', 2),
(246, 'user235', 'm@m', 'nome', 'apelido', 2),
(247, 'user236', 'm@m', 'nome', 'apelido', 2),
(248, 'user237', 'm@m', 'nome', 'apelido', 2),
(249, 'user238', 'm@m', 'nome', 'apelido', 2),
(250, 'user239', 'm@m', 'nome', 'apelido', 2),
(251, 'user240', 'm@m', 'nome', 'apelido', 2),
(252, 'user241', 'm@m', 'nome', 'apelido', 2),
(253, 'user242', 'm@m', 'nome', 'apelido', 2),
(254, 'user243', 'm@m', 'nome', 'apelido', 2),
(255, 'user244', 'm@m', 'nome', 'apelido', 2),
(256, 'user245', 'm@m', 'nome', 'apelido', 2),
(257, 'user246', 'm@m', 'nome', 'apelido', 2),
(258, 'user247', 'm@m', 'nome', 'apelido', 2),
(259, 'user248', 'm@m', 'nome', 'apelido', 2),
(260, 'user249', 'm@m', 'nome', 'apelido', 2),
(261, 'user250', 'm@m', 'nome', 'apelido', 2),
(262, 'user251', 'm@m', 'nome', 'apelido', 2),
(263, 'user252', 'm@m', 'nome', 'apelido', 2),
(264, 'user253', 'm@m', 'nome', 'apelido', 2),
(265, 'user254', 'm@m', 'nome', 'apelido', 2),
(266, 'user255', 'm@m', 'nome', 'apelido', 2),
(267, 'user256', 'm@m', 'nome', 'apelido', 2),
(268, 'user257', 'm@m', 'nome', 'apelido', 2),
(269, 'user258', 'm@m', 'nome', 'apelido', 2),
(270, 'user259', 'm@m', 'nome', 'apelido', 2),
(271, 'user260', 'm@m', 'nome', 'apelido', 2),
(272, 'user261', 'm@m', 'nome', 'apelido', 2),
(273, 'user262', 'm@m', 'nome', 'apelido', 2),
(274, 'user263', 'm@m', 'nome', 'apelido', 2),
(275, 'user264', 'm@m', 'nome', 'apelido', 2),
(276, 'user265', 'm@m', 'nome', 'apelido', 2),
(277, 'user266', 'm@m', 'nome', 'apelido', 2),
(278, 'user267', 'm@m', 'nome', 'apelido', 2),
(279, 'user268', 'm@m', 'nome', 'apelido', 2),
(280, 'user269', 'm@m', 'nome', 'apelido', 2),
(281, 'user270', 'm@m', 'nome', 'apelido', 2),
(282, 'user271', 'm@m', 'nome', 'apelido', 2),
(283, 'user272', 'm@m', 'nome', 'apelido', 2),
(284, 'user273', 'm@m', 'nome', 'apelido', 2),
(285, 'user274', 'm@m', 'nome', 'apelido', 2),
(286, 'user275', 'm@m', 'nome', 'apelido', 2),
(287, 'user276', 'm@m', 'nome', 'apelido', 2),
(288, 'user277', 'm@m', 'nome', 'apelido', 2),
(289, 'user278', 'm@m', 'nome', 'apelido', 2),
(290, 'user279', 'm@m', 'nome', 'apelido', 2),
(291, 'user280', 'm@m', 'nome', 'apelido', 2),
(292, 'user281', 'm@m', 'nome', 'apelido', 2),
(293, 'user282', 'm@m', 'nome', 'apelido', 2),
(294, 'user283', 'm@m', 'nome', 'apelido', 2),
(295, 'user284', 'm@m', 'nome', 'apelido', 2),
(296, 'user285', 'm@m', 'nome', 'apelido', 2),
(297, 'user286', 'm@m', 'nome', 'apelido', 2),
(298, 'user287', 'm@m', 'nome', 'apelido', 2),
(299, 'user288', 'm@m', 'nome', 'apelido', 2),
(300, 'user289', 'm@m', 'nome', 'apelido', 2),
(301, 'user290', 'm@m', 'nome', 'apelido', 2),
(302, 'user291', 'm@m', 'nome', 'apelido', 2),
(303, 'user292', 'm@m', 'nome', 'apelido', 2),
(304, 'user293', 'm@m', 'nome', 'apelido', 2),
(305, 'user294', 'm@m', 'nome', 'apelido', 2),
(306, 'user295', 'm@m', 'nome', 'apelido', 2),
(307, 'user296', 'm@m', 'nome', 'apelido', 2),
(308, 'user297', 'm@m', 'nome', 'apelido', 2),
(309, 'user298', 'm@m', 'nome', 'apelido', 2),
(310, 'user299', 'm@m', 'nome', 'apelido', 2),
(311, 'user300', 'm@m', 'nome', 'apelido', 2),
(312, 'user301', 'm@m', 'nome', 'apelido', 2),
(313, 'user302', 'm@m', 'nome', 'apelido', 2),
(314, 'user303', 'm@m', 'nome', 'apelido', 2),
(315, 'user304', 'm@m', 'nome', 'apelido', 2),
(316, 'user305', 'm@m', 'nome', 'apelido', 2),
(317, 'user306', 'm@m', 'nome', 'apelido', 2),
(318, 'user307', 'm@m', 'nome', 'apelido', 2),
(319, 'user308', 'm@m', 'nome', 'apelido', 2),
(320, 'user309', 'm@m', 'nome', 'apelido', 2),
(321, 'user310', 'm@m', 'nome', 'apelido', 2),
(322, 'user311', 'm@m', 'nome', 'apelido', 2),
(323, 'user312', 'm@m', 'nome', 'apelido', 2),
(324, 'user313', 'm@m', 'nome', 'apelido', 2),
(325, 'user314', 'm@m', 'nome', 'apelido', 2),
(326, 'user315', 'm@m', 'nome', 'apelido', 2),
(327, 'user316', 'm@m', 'nome', 'apelido', 2),
(328, 'user317', 'm@m', 'nome', 'apelido', 2),
(329, 'user318', 'm@m', 'nome', 'apelido', 2),
(330, 'user319', 'm@m', 'nome', 'apelido', 2),
(331, 'user320', 'm@m', 'nome', 'apelido', 2),
(332, 'user321', 'm@m', 'nome', 'apelido', 2),
(333, 'user322', 'm@m', 'nome', 'apelido', 2),
(334, 'user323', 'm@m', 'nome', 'apelido', 2),
(335, 'user324', 'm@m', 'nome', 'apelido', 2),
(336, 'user325', 'm@m', 'nome', 'apelido', 2),
(337, 'user326', 'm@m', 'nome', 'apelido', 2),
(338, 'user327', 'm@m', 'nome', 'apelido', 2),
(339, 'user328', 'm@m', 'nome', 'apelido', 2),
(340, 'user329', 'm@m', 'nome', 'apelido', 2),
(341, 'user330', 'm@m', 'nome', 'apelido', 2),
(342, 'user331', 'm@m', 'nome', 'apelido', 2),
(343, 'user332', 'm@m', 'nome', 'apelido', 2),
(344, 'user333', 'm@m', 'nome', 'apelido', 2),
(345, 'user334', 'm@m', 'nome', 'apelido', 2),
(346, 'user335', 'm@m', 'nome', 'apelido', 2),
(347, 'user336', 'm@m', 'nome', 'apelido', 2),
(348, 'user337', 'm@m', 'nome', 'apelido', 2),
(349, 'user338', 'm@m', 'nome', 'apelido', 2),
(350, 'user339', 'm@m', 'nome', 'apelido', 2),
(351, 'user340', 'm@m', 'nome', 'apelido', 2),
(352, 'user341', 'm@m', 'nome', 'apelido', 2),
(353, 'user342', 'm@m', 'nome', 'apelido', 2),
(354, 'user343', 'm@m', 'nome', 'apelido', 2),
(355, 'user344', 'm@m', 'nome', 'apelido', 2),
(356, 'user345', 'm@m', 'nome', 'apelido', 2),
(357, 'user346', 'm@m', 'nome', 'apelido', 2),
(358, 'user347', 'm@m', 'nome', 'apelido', 2),
(359, 'user348', 'm@m', 'nome', 'apelido', 2),
(360, 'user349', 'm@m', 'nome', 'apelido', 2),
(361, 'user350', 'm@m', 'nome', 'apelido', 2),
(362, 'user351', 'm@m', 'nome', 'apelido', 2),
(363, 'user352', 'm@m', 'nome', 'apelido', 2),
(364, 'user353', 'm@m', 'nome', 'apelido', 2),
(365, 'user354', 'm@m', 'nome', 'apelido', 2),
(366, 'user355', 'm@m', 'nome', 'apelido', 2),
(367, 'user356', 'm@m', 'nome', 'apelido', 2),
(368, 'user357', 'm@m', 'nome', 'apelido', 2),
(369, 'user358', 'm@m', 'nome', 'apelido', 2),
(370, 'user359', 'm@m', 'nome', 'apelido', 2),
(371, 'user360', 'm@m', 'nome', 'apelido', 2),
(372, 'user361', 'm@m', 'nome', 'apelido', 2),
(373, 'user362', 'm@m', 'nome', 'apelido', 2),
(374, 'user363', 'm@m', 'nome', 'apelido', 2),
(375, 'user364', 'm@m', 'nome', 'apelido', 2),
(376, 'user365', 'm@m', 'nome', 'apelido', 2),
(377, 'user366', 'm@m', 'nome', 'apelido', 2),
(378, 'user367', 'm@m', 'nome', 'apelido', 2),
(379, 'user368', 'm@m', 'nome', 'apelido', 2),
(380, 'user369', 'm@m', 'nome', 'apelido', 2),
(381, 'user370', 'm@m', 'nome', 'apelido', 2),
(382, 'user371', 'm@m', 'nome', 'apelido', 2),
(383, 'user372', 'm@m', 'nome', 'apelido', 2),
(384, 'user373', 'm@m', 'nome', 'apelido', 2),
(385, 'user374', 'm@m', 'nome', 'apelido', 2),
(386, 'user375', 'm@m', 'nome', 'apelido', 2),
(387, 'user376', 'm@m', 'nome', 'apelido', 2),
(388, 'user377', 'm@m', 'nome', 'apelido', 2),
(389, 'user378', 'm@m', 'nome', 'apelido', 2),
(390, 'user379', 'm@m', 'nome', 'apelido', 2),
(391, 'user380', 'm@m', 'nome', 'apelido', 2),
(392, 'user381', 'm@m', 'nome', 'apelido', 2),
(393, 'user382', 'm@m', 'nome', 'apelido', 2),
(394, 'user383', 'm@m', 'nome', 'apelido', 2),
(395, 'user384', 'm@m', 'nome', 'apelido', 2),
(396, 'user385', 'm@m', 'nome', 'apelido', 2),
(397, 'user386', 'm@m', 'nome', 'apelido', 2),
(398, 'user387', 'm@m', 'nome', 'apelido', 2),
(399, 'user388', 'm@m', 'nome', 'apelido', 2),
(400, 'user389', 'm@m', 'nome', 'apelido', 2),
(401, 'user390', 'm@m', 'nome', 'apelido', 2),
(402, 'user391', 'm@m', 'nome', 'apelido', 2),
(403, 'user392', 'm@m', 'nome', 'apelido', 2),
(404, 'user393', 'm@m', 'nome', 'apelido', 2),
(405, 'user394', 'm@m', 'nome', 'apelido', 2),
(406, 'user395', 'm@m', 'nome', 'apelido', 2),
(407, 'user396', 'm@m', 'nome', 'apelido', 2),
(408, 'user397', 'm@m', 'nome', 'apelido', 2),
(409, 'user398', 'm@m', 'nome', 'apelido', 2),
(410, 'user399', 'm@m', 'nome', 'apelido', 2),
(411, 'user400', 'm@m', 'nome', 'apelido', 2),
(412, 'user401', 'm@m', 'nome', 'apelido', 2),
(413, 'user402', 'm@m', 'nome', 'apelido', 2),
(414, 'user403', 'm@m', 'nome', 'apelido', 2),
(415, 'user404', 'm@m', 'nome', 'apelido', 2),
(416, 'user405', 'm@m', 'nome', 'apelido', 2),
(417, 'user406', 'm@m', 'nome', 'apelido', 2),
(418, 'user407', 'm@m', 'nome', 'apelido', 2),
(419, 'user408', 'm@m', 'nome', 'apelido', 2),
(420, 'user409', 'm@m', 'nome', 'apelido', 2),
(421, 'user410', 'm@m', 'nome', 'apelido', 2),
(422, 'user411', 'm@m', 'nome', 'apelido', 2),
(423, 'user412', 'm@m', 'nome', 'apelido', 2),
(424, 'user413', 'm@m', 'nome', 'apelido', 2),
(425, 'user414', 'm@m', 'nome', 'apelido', 2),
(426, 'user415', 'm@m', 'nome', 'apelido', 2),
(427, 'user416', 'm@m', 'nome', 'apelido', 2),
(428, 'user417', 'm@m', 'nome', 'apelido', 2),
(429, 'user418', 'm@m', 'nome', 'apelido', 2),
(430, 'user419', 'm@m', 'nome', 'apelido', 2),
(431, 'user420', 'm@m', 'nome', 'apelido', 2),
(432, 'user421', 'm@m', 'nome', 'apelido', 2),
(433, 'user422', 'm@m', 'nome', 'apelido', 2),
(434, 'user423', 'm@m', 'nome', 'apelido', 2),
(435, 'user424', 'm@m', 'nome', 'apelido', 2),
(436, 'user425', 'm@m', 'nome', 'apelido', 2),
(437, 'user426', 'm@m', 'nome', 'apelido', 2),
(438, 'user427', 'm@m', 'nome', 'apelido', 2),
(439, 'user428', 'm@m', 'nome', 'apelido', 2),
(440, 'user429', 'm@m', 'nome', 'apelido', 2),
(441, 'user430', 'm@m', 'nome', 'apelido', 2),
(442, 'user431', 'm@m', 'nome', 'apelido', 2),
(443, 'user432', 'm@m', 'nome', 'apelido', 2),
(444, 'user433', 'm@m', 'nome', 'apelido', 2),
(445, 'user434', 'm@m', 'nome', 'apelido', 2),
(446, 'user435', 'm@m', 'nome', 'apelido', 2),
(447, 'user436', 'm@m', 'nome', 'apelido', 2),
(448, 'user437', 'm@m', 'nome', 'apelido', 2),
(449, 'user438', 'm@m', 'nome', 'apelido', 2),
(450, 'user439', 'm@m', 'nome', 'apelido', 2),
(451, 'user440', 'm@m', 'nome', 'apelido', 2),
(452, 'user441', 'm@m', 'nome', 'apelido', 2),
(453, 'user442', 'm@m', 'nome', 'apelido', 2),
(454, 'user443', 'm@m', 'nome', 'apelido', 2),
(455, 'user444', 'm@m', 'nome', 'apelido', 2),
(456, 'user445', 'm@m', 'nome', 'apelido', 2),
(457, 'user446', 'm@m', 'nome', 'apelido', 2),
(458, 'user447', 'm@m', 'nome', 'apelido', 2),
(459, 'user448', 'm@m', 'nome', 'apelido', 2),
(460, 'user449', 'm@m', 'nome', 'apelido', 2),
(461, 'user450', 'm@m', 'nome', 'apelido', 2),
(462, 'user451', 'm@m', 'nome', 'apelido', 2),
(463, 'user452', 'm@m', 'nome', 'apelido', 2),
(464, 'user453', 'm@m', 'nome', 'apelido', 2),
(465, 'user454', 'm@m', 'nome', 'apelido', 2),
(466, 'user455', 'm@m', 'nome', 'apelido', 2),
(467, 'user456', 'm@m', 'nome', 'apelido', 2),
(468, 'user457', 'm@m', 'nome', 'apelido', 2),
(469, 'user458', 'm@m', 'nome', 'apelido', 2),
(470, 'user459', 'm@m', 'nome', 'apelido', 2),
(471, 'user460', 'm@m', 'nome', 'apelido', 2),
(472, 'user461', 'm@m', 'nome', 'apelido', 2),
(473, 'user462', 'm@m', 'nome', 'apelido', 2),
(474, 'user463', 'm@m', 'nome', 'apelido', 2),
(475, 'user464', 'm@m', 'nome', 'apelido', 2),
(476, 'user465', 'm@m', 'nome', 'apelido', 2),
(477, 'user466', 'm@m', 'nome', 'apelido', 2),
(478, 'user467', 'm@m', 'nome', 'apelido', 2),
(479, 'user468', 'm@m', 'nome', 'apelido', 2),
(480, 'user469', 'm@m', 'nome', 'apelido', 2),
(481, 'user470', 'm@m', 'nome', 'apelido', 2),
(482, 'user471', 'm@m', 'nome', 'apelido', 2),
(483, 'user472', 'm@m', 'nome', 'apelido', 2),
(484, 'user473', 'm@m', 'nome', 'apelido', 2),
(485, 'user474', 'm@m', 'nome', 'apelido', 2),
(486, 'user475', 'm@m', 'nome', 'apelido', 2),
(487, 'user476', 'm@m', 'nome', 'apelido', 2),
(488, 'user477', 'm@m', 'nome', 'apelido', 2),
(489, 'user478', 'm@m', 'nome', 'apelido', 2),
(490, 'user479', 'm@m', 'nome', 'apelido', 2),
(491, 'user480', 'm@m', 'nome', 'apelido', 2),
(492, 'user481', 'm@m', 'nome', 'apelido', 2),
(493, 'user482', 'm@m', 'nome', 'apelido', 2),
(494, 'user483', 'm@m', 'nome', 'apelido', 2),
(495, 'user484', 'm@m', 'nome', 'apelido', 2),
(496, 'user485', 'm@m', 'nome', 'apelido', 2),
(497, 'user486', 'm@m', 'nome', 'apelido', 2),
(498, 'user487', 'm@m', 'nome', 'apelido', 2),
(499, 'user488', 'm@m', 'nome', 'apelido', 2),
(500, 'user489', 'm@m', 'nome', 'apelido', 2),
(501, 'user490', 'm@m', 'nome', 'apelido', 2),
(502, 'user491', 'm@m', 'nome', 'apelido', 2),
(503, 'user492', 'm@m', 'nome', 'apelido', 2),
(504, 'user493', 'm@m', 'nome', 'apelido', 2),
(505, 'user494', 'm@m', 'nome', 'apelido', 2),
(506, 'user495', 'm@m', 'nome', 'apelido', 2),
(507, 'user496', 'm@m', 'nome', 'apelido', 2),
(508, 'user497', 'm@m', 'nome', 'apelido', 2),
(509, 'user498', 'm@m', 'nome', 'apelido', 2),
(510, 'user499', 'm@m', 'nome', 'apelido', 2),
(511, 'user500', 'm@m', 'nome', 'apelido', 2),
(512, 'user501', 'm@m', 'nome', 'apelido', 2),
(513, 'user502', 'm@m', 'nome', 'apelido', 2),
(514, 'user503', 'm@m', 'nome', 'apelido', 2),
(515, 'user504', 'm@m', 'nome', 'apelido', 2),
(516, 'user505', 'm@m', 'nome', 'apelido', 2),
(517, 'user506', 'm@m', 'nome', 'apelido', 2),
(518, 'user507', 'm@m', 'nome', 'apelido', 2),
(519, 'user508', 'm@m', 'nome', 'apelido', 2),
(520, 'user509', 'm@m', 'nome', 'apelido', 2),
(521, 'user510', 'm@m', 'nome', 'apelido', 2),
(522, 'user511', 'm@m', 'nome', 'apelido', 2),
(523, 'user512', 'm@m', 'nome', 'apelido', 2),
(524, 'user513', 'm@m', 'nome', 'apelido', 2),
(525, 'user514', 'm@m', 'nome', 'apelido', 2),
(526, 'user515', 'm@m', 'nome', 'apelido', 2),
(527, 'user516', 'm@m', 'nome', 'apelido', 2),
(528, 'user517', 'm@m', 'nome', 'apelido', 2),
(529, 'user518', 'm@m', 'nome', 'apelido', 2),
(530, 'user519', 'm@m', 'nome', 'apelido', 2),
(531, 'user520', 'm@m', 'nome', 'apelido', 2),
(532, 'user521', 'm@m', 'nome', 'apelido', 2),
(533, 'user522', 'm@m', 'nome', 'apelido', 2),
(534, 'user523', 'm@m', 'nome', 'apelido', 2),
(535, 'user524', 'm@m', 'nome', 'apelido', 2),
(536, 'user525', 'm@m', 'nome', 'apelido', 2),
(537, 'user526', 'm@m', 'nome', 'apelido', 2),
(538, 'user527', 'm@m', 'nome', 'apelido', 2),
(539, 'user528', 'm@m', 'nome', 'apelido', 2),
(540, 'user529', 'm@m', 'nome', 'apelido', 2),
(541, 'user530', 'm@m', 'nome', 'apelido', 2),
(542, 'user531', 'm@m', 'nome', 'apelido', 2),
(543, 'user532', 'm@m', 'nome', 'apelido', 2),
(544, 'user533', 'm@m', 'nome', 'apelido', 2),
(545, 'user534', 'm@m', 'nome', 'apelido', 2),
(546, 'user535', 'm@m', 'nome', 'apelido', 2),
(547, 'user536', 'm@m', 'nome', 'apelido', 2),
(548, 'user537', 'm@m', 'nome', 'apelido', 2),
(549, 'user538', 'm@m', 'nome', 'apelido', 2),
(550, 'user539', 'm@m', 'nome', 'apelido', 2),
(551, 'user540', 'm@m', 'nome', 'apelido', 2),
(552, 'user541', 'm@m', 'nome', 'apelido', 2),
(553, 'user542', 'm@m', 'nome', 'apelido', 2),
(554, 'user543', 'm@m', 'nome', 'apelido', 2),
(555, 'user544', 'm@m', 'nome', 'apelido', 2),
(556, 'user545', 'm@m', 'nome', 'apelido', 2),
(557, 'user546', 'm@m', 'nome', 'apelido', 2),
(558, 'user547', 'm@m', 'nome', 'apelido', 2),
(559, 'user548', 'm@m', 'nome', 'apelido', 2),
(560, 'user549', 'm@m', 'nome', 'apelido', 2),
(561, 'user550', 'm@m', 'nome', 'apelido', 2),
(562, 'user551', 'm@m', 'nome', 'apelido', 2),
(563, 'user552', 'm@m', 'nome', 'apelido', 2),
(564, 'user553', 'm@m', 'nome', 'apelido', 2),
(565, 'user554', 'm@m', 'nome', 'apelido', 2),
(566, 'user555', 'm@m', 'nome', 'apelido', 2),
(567, 'user556', 'm@m', 'nome', 'apelido', 2),
(568, 'user557', 'm@m', 'nome', 'apelido', 2),
(569, 'user558', 'm@m', 'nome', 'apelido', 2),
(570, 'user559', 'm@m', 'nome', 'apelido', 2),
(571, 'user560', 'm@m', 'nome', 'apelido', 2),
(572, 'user561', 'm@m', 'nome', 'apelido', 2),
(573, 'user562', 'm@m', 'nome', 'apelido', 2),
(574, 'user563', 'm@m', 'nome', 'apelido', 2),
(575, 'user564', 'm@m', 'nome', 'apelido', 2),
(576, 'user565', 'm@m', 'nome', 'apelido', 2),
(577, 'user566', 'm@m', 'nome', 'apelido', 2),
(578, 'user567', 'm@m', 'nome', 'apelido', 2),
(579, 'user568', 'm@m', 'nome', 'apelido', 2),
(580, 'user569', 'm@m', 'nome', 'apelido', 2),
(581, 'user570', 'm@m', 'nome', 'apelido', 2),
(582, 'user571', 'm@m', 'nome', 'apelido', 2),
(583, 'user572', 'm@m', 'nome', 'apelido', 2),
(584, 'user573', 'm@m', 'nome', 'apelido', 2),
(585, 'user574', 'm@m', 'nome', 'apelido', 2),
(586, 'user575', 'm@m', 'nome', 'apelido', 2),
(587, 'user576', 'm@m', 'nome', 'apelido', 2),
(588, 'user577', 'm@m', 'nome', 'apelido', 2),
(589, 'user578', 'm@m', 'nome', 'apelido', 2),
(590, 'user579', 'm@m', 'nome', 'apelido', 2),
(591, 'user580', 'm@m', 'nome', 'apelido', 2),
(592, 'user581', 'm@m', 'nome', 'apelido', 2),
(593, 'user582', 'm@m', 'nome', 'apelido', 2),
(594, 'user583', 'm@m', 'nome', 'apelido', 2),
(595, 'user584', 'm@m', 'nome', 'apelido', 2),
(596, 'user585', 'm@m', 'nome', 'apelido', 2),
(597, 'user586', 'm@m', 'nome', 'apelido', 2),
(598, 'user587', 'm@m', 'nome', 'apelido', 2),
(599, 'user588', 'm@m', 'nome', 'apelido', 2),
(600, 'user589', 'm@m', 'nome', 'apelido', 2),
(601, 'user590', 'm@m', 'nome', 'apelido', 2),
(602, 'user591', 'm@m', 'nome', 'apelido', 2),
(603, 'user592', 'm@m', 'nome', 'apelido', 2),
(604, 'user593', 'm@m', 'nome', 'apelido', 2),
(605, 'user594', 'm@m', 'nome', 'apelido', 2),
(606, 'user595', 'm@m', 'nome', 'apelido', 2),
(607, 'user596', 'm@m', 'nome', 'apelido', 2),
(608, 'user597', 'm@m', 'nome', 'apelido', 2),
(609, 'user598', 'm@m', 'nome', 'apelido', 2),
(610, 'user599', 'm@m', 'nome', 'apelido', 2),
(611, 'user600', 'm@m', 'nome', 'apelido', 2),
(612, 'user601', 'm@m', 'nome', 'apelido', 2),
(613, 'user602', 'm@m', 'nome', 'apelido', 2),
(614, 'user603', 'm@m', 'nome', 'apelido', 2),
(615, 'user604', 'm@m', 'nome', 'apelido', 2),
(616, 'user605', 'm@m', 'nome', 'apelido', 2),
(617, 'user606', 'm@m', 'nome', 'apelido', 2),
(618, 'user607', 'm@m', 'nome', 'apelido', 2),
(619, 'user608', 'm@m', 'nome', 'apelido', 2),
(620, 'user609', 'm@m', 'nome', 'apelido', 2),
(621, 'user610', 'm@m', 'nome', 'apelido', 2),
(622, 'user611', 'm@m', 'nome', 'apelido', 2),
(623, 'user612', 'm@m', 'nome', 'apelido', 2),
(624, 'user613', 'm@m', 'nome', 'apelido', 2),
(625, 'user614', 'm@m', 'nome', 'apelido', 2),
(626, 'user615', 'm@m', 'nome', 'apelido', 2),
(627, 'user616', 'm@m', 'nome', 'apelido', 2),
(628, 'user617', 'm@m', 'nome', 'apelido', 2),
(629, 'user618', 'm@m', 'nome', 'apelido', 2),
(630, 'user619', 'm@m', 'nome', 'apelido', 2),
(631, 'user620', 'm@m', 'nome', 'apelido', 2),
(632, 'user621', 'm@m', 'nome', 'apelido', 2),
(633, 'user622', 'm@m', 'nome', 'apelido', 2),
(634, 'user623', 'm@m', 'nome', 'apelido', 2),
(635, 'user624', 'm@m', 'nome', 'apelido', 2),
(636, 'user625', 'm@m', 'nome', 'apelido', 2),
(637, 'user626', 'm@m', 'nome', 'apelido', 2),
(638, 'user627', 'm@m', 'nome', 'apelido', 2),
(639, 'user628', 'm@m', 'nome', 'apelido', 2),
(640, 'user629', 'm@m', 'nome', 'apelido', 2),
(641, 'user630', 'm@m', 'nome', 'apelido', 2),
(642, 'user631', 'm@m', 'nome', 'apelido', 2),
(643, 'user632', 'm@m', 'nome', 'apelido', 2),
(644, 'user633', 'm@m', 'nome', 'apelido', 2),
(645, 'user634', 'm@m', 'nome', 'apelido', 2),
(646, 'user635', 'm@m', 'nome', 'apelido', 2),
(647, 'user636', 'm@m', 'nome', 'apelido', 2),
(648, 'user637', 'm@m', 'nome', 'apelido', 2),
(649, 'user638', 'm@m', 'nome', 'apelido', 2),
(650, 'user639', 'm@m', 'nome', 'apelido', 2),
(651, 'user640', 'm@m', 'nome', 'apelido', 2),
(652, 'user641', 'm@m', 'nome', 'apelido', 2),
(653, 'user642', 'm@m', 'nome', 'apelido', 2),
(654, 'user643', 'm@m', 'nome', 'apelido', 2),
(655, 'user644', 'm@m', 'nome', 'apelido', 2),
(656, 'user645', 'm@m', 'nome', 'apelido', 2),
(657, 'user646', 'm@m', 'nome', 'apelido', 2),
(658, 'user647', 'm@m', 'nome', 'apelido', 2),
(659, 'user648', 'm@m', 'nome', 'apelido', 2),
(660, 'user649', 'm@m', 'nome', 'apelido', 2),
(661, 'user650', 'm@m', 'nome', 'apelido', 2),
(662, 'user651', 'm@m', 'nome', 'apelido', 2),
(663, 'user652', 'm@m', 'nome', 'apelido', 2),
(664, 'user653', 'm@m', 'nome', 'apelido', 2),
(665, 'user654', 'm@m', 'nome', 'apelido', 2),
(666, 'user655', 'm@m', 'nome', 'apelido', 2),
(667, 'user656', 'm@m', 'nome', 'apelido', 2),
(668, 'user657', 'm@m', 'nome', 'apelido', 2),
(669, 'user658', 'm@m', 'nome', 'apelido', 2),
(670, 'user659', 'm@m', 'nome', 'apelido', 2),
(671, 'user660', 'm@m', 'nome', 'apelido', 2),
(672, 'user661', 'm@m', 'nome', 'apelido', 2),
(673, 'user662', 'm@m', 'nome', 'apelido', 2),
(674, 'user663', 'm@m', 'nome', 'apelido', 2),
(675, 'user664', 'm@m', 'nome', 'apelido', 2),
(676, 'user665', 'm@m', 'nome', 'apelido', 2),
(677, 'user666', 'm@m', 'nome', 'apelido', 2),
(678, 'user667', 'm@m', 'nome', 'apelido', 2),
(679, 'user668', 'm@m', 'nome', 'apelido', 2),
(680, 'user669', 'm@m', 'nome', 'apelido', 2),
(681, 'user670', 'm@m', 'nome', 'apelido', 2),
(682, 'user671', 'm@m', 'nome', 'apelido', 2),
(683, 'user672', 'm@m', 'nome', 'apelido', 2),
(684, 'user673', 'm@m', 'nome', 'apelido', 2),
(685, 'user674', 'm@m', 'nome', 'apelido', 2),
(686, 'user675', 'm@m', 'nome', 'apelido', 2),
(687, 'user676', 'm@m', 'nome', 'apelido', 2),
(688, 'user677', 'm@m', 'nome', 'apelido', 2),
(689, 'user678', 'm@m', 'nome', 'apelido', 2),
(690, 'user679', 'm@m', 'nome', 'apelido', 2),
(691, 'user680', 'm@m', 'nome', 'apelido', 2),
(692, 'user681', 'm@m', 'nome', 'apelido', 2),
(693, 'user682', 'm@m', 'nome', 'apelido', 2),
(694, 'user683', 'm@m', 'nome', 'apelido', 2),
(695, 'user684', 'm@m', 'nome', 'apelido', 2),
(696, 'user685', 'm@m', 'nome', 'apelido', 2),
(697, 'user686', 'm@m', 'nome', 'apelido', 2),
(698, 'user687', 'm@m', 'nome', 'apelido', 2),
(699, 'user688', 'm@m', 'nome', 'apelido', 2),
(700, 'user689', 'm@m', 'nome', 'apelido', 2),
(701, 'user690', 'm@m', 'nome', 'apelido', 2),
(702, 'user691', 'm@m', 'nome', 'apelido', 2),
(703, 'user692', 'm@m', 'nome', 'apelido', 2),
(704, 'user693', 'm@m', 'nome', 'apelido', 2),
(705, 'user694', 'm@m', 'nome', 'apelido', 2),
(706, 'user695', 'm@m', 'nome', 'apelido', 2),
(707, 'user696', 'm@m', 'nome', 'apelido', 2),
(708, 'user697', 'm@m', 'nome', 'apelido', 2),
(709, 'user698', 'm@m', 'nome', 'apelido', 2),
(710, 'user699', 'm@m', 'nome', 'apelido', 2),
(711, 'user700', 'm@m', 'nome', 'apelido', 2),
(712, 'user701', 'm@m', 'nome', 'apelido', 2),
(713, 'user702', 'm@m', 'nome', 'apelido', 2),
(714, 'user703', 'm@m', 'nome', 'apelido', 2),
(715, 'user704', 'm@m', 'nome', 'apelido', 2),
(716, 'user705', 'm@m', 'nome', 'apelido', 2),
(717, 'user706', 'm@m', 'nome', 'apelido', 2),
(718, 'user707', 'm@m', 'nome', 'apelido', 2),
(719, 'user708', 'm@m', 'nome', 'apelido', 2),
(720, 'user709', 'm@m', 'nome', 'apelido', 2),
(721, 'user710', 'm@m', 'nome', 'apelido', 2),
(722, 'user711', 'm@m', 'nome', 'apelido', 2),
(723, 'user712', 'm@m', 'nome', 'apelido', 2),
(724, 'user713', 'm@m', 'nome', 'apelido', 2),
(725, 'user714', 'm@m', 'nome', 'apelido', 2),
(726, 'user715', 'm@m', 'nome', 'apelido', 2),
(727, 'user716', 'm@m', 'nome', 'apelido', 2),
(728, 'user717', 'm@m', 'nome', 'apelido', 2),
(729, 'user718', 'm@m', 'nome', 'apelido', 2),
(730, 'user719', 'm@m', 'nome', 'apelido', 2),
(731, 'user720', 'm@m', 'nome', 'apelido', 2),
(732, 'user721', 'm@m', 'nome', 'apelido', 2),
(733, 'user722', 'm@m', 'nome', 'apelido', 2),
(734, 'user723', 'm@m', 'nome', 'apelido', 2),
(735, 'user724', 'm@m', 'nome', 'apelido', 2),
(736, 'user725', 'm@m', 'nome', 'apelido', 2),
(737, 'user726', 'm@m', 'nome', 'apelido', 2),
(738, 'user727', 'm@m', 'nome', 'apelido', 2),
(739, 'user728', 'm@m', 'nome', 'apelido', 2),
(740, 'user729', 'm@m', 'nome', 'apelido', 2),
(741, 'user730', 'm@m', 'nome', 'apelido', 2),
(742, 'user731', 'm@m', 'nome', 'apelido', 2),
(743, 'user732', 'm@m', 'nome', 'apelido', 2),
(744, 'user733', 'm@m', 'nome', 'apelido', 2),
(745, 'user734', 'm@m', 'nome', 'apelido', 2),
(746, 'user735', 'm@m', 'nome', 'apelido', 2),
(747, 'user736', 'm@m', 'nome', 'apelido', 2),
(748, 'user737', 'm@m', 'nome', 'apelido', 2),
(749, 'user738', 'm@m', 'nome', 'apelido', 2),
(750, 'user739', 'm@m', 'nome', 'apelido', 2),
(751, 'user740', 'm@m', 'nome', 'apelido', 2),
(752, 'user741', 'm@m', 'nome', 'apelido', 2),
(753, 'user742', 'm@m', 'nome', 'apelido', 2),
(754, 'user743', 'm@m', 'nome', 'apelido', 2),
(755, 'user744', 'm@m', 'nome', 'apelido', 2),
(756, 'user745', 'm@m', 'nome', 'apelido', 2),
(757, 'user746', 'm@m', 'nome', 'apelido', 2),
(758, 'user747', 'm@m', 'nome', 'apelido', 2),
(759, 'user748', 'm@m', 'nome', 'apelido', 2),
(760, 'user749', 'm@m', 'nome', 'apelido', 2),
(761, 'user750', 'm@m', 'nome', 'apelido', 2),
(762, 'user751', 'm@m', 'nome', 'apelido', 2),
(763, 'user752', 'm@m', 'nome', 'apelido', 2),
(764, 'user753', 'm@m', 'nome', 'apelido', 2),
(765, 'user754', 'm@m', 'nome', 'apelido', 2),
(766, 'user755', 'm@m', 'nome', 'apelido', 2),
(767, 'user756', 'm@m', 'nome', 'apelido', 2),
(768, 'user757', 'm@m', 'nome', 'apelido', 2),
(769, 'user758', 'm@m', 'nome', 'apelido', 2),
(770, 'user759', 'm@m', 'nome', 'apelido', 2),
(771, 'user760', 'm@m', 'nome', 'apelido', 2),
(772, 'user761', 'm@m', 'nome', 'apelido', 2),
(773, 'user762', 'm@m', 'nome', 'apelido', 2),
(774, 'user763', 'm@m', 'nome', 'apelido', 2),
(775, 'user764', 'm@m', 'nome', 'apelido', 2),
(776, 'user765', 'm@m', 'nome', 'apelido', 2),
(777, 'user766', 'm@m', 'nome', 'apelido', 2),
(778, 'user767', 'm@m', 'nome', 'apelido', 2),
(779, 'user768', 'm@m', 'nome', 'apelido', 2),
(780, 'user769', 'm@m', 'nome', 'apelido', 2),
(781, 'user770', 'm@m', 'nome', 'apelido', 2),
(782, 'user771', 'm@m', 'nome', 'apelido', 2),
(783, 'user772', 'm@m', 'nome', 'apelido', 2),
(784, 'user773', 'm@m', 'nome', 'apelido', 2),
(785, 'user774', 'm@m', 'nome', 'apelido', 2),
(786, 'user775', 'm@m', 'nome', 'apelido', 2),
(787, 'user776', 'm@m', 'nome', 'apelido', 2),
(788, 'user777', 'm@m', 'nome', 'apelido', 2),
(789, 'user778', 'm@m', 'nome', 'apelido', 2),
(790, 'user779', 'm@m', 'nome', 'apelido', 2),
(791, 'user780', 'm@m', 'nome', 'apelido', 2),
(792, 'user781', 'm@m', 'nome', 'apelido', 2),
(793, 'user782', 'm@m', 'nome', 'apelido', 2),
(794, 'user783', 'm@m', 'nome', 'apelido', 2),
(795, 'user784', 'm@m', 'nome', 'apelido', 2),
(796, 'user785', 'm@m', 'nome', 'apelido', 2),
(797, 'user786', 'm@m', 'nome', 'apelido', 2),
(798, 'user787', 'm@m', 'nome', 'apelido', 2),
(799, 'user788', 'm@m', 'nome', 'apelido', 2),
(800, 'user789', 'm@m', 'nome', 'apelido', 2),
(801, 'user790', 'm@m', 'nome', 'apelido', 2),
(802, 'user791', 'm@m', 'nome', 'apelido', 2),
(803, 'user792', 'm@m', 'nome', 'apelido', 2),
(804, 'user793', 'm@m', 'nome', 'apelido', 2),
(805, 'user794', 'm@m', 'nome', 'apelido', 2),
(806, 'user795', 'm@m', 'nome', 'apelido', 2),
(807, 'user796', 'm@m', 'nome', 'apelido', 2),
(808, 'user797', 'm@m', 'nome', 'apelido', 2),
(809, 'user798', 'm@m', 'nome', 'apelido', 2),
(810, 'user799', 'm@m', 'nome', 'apelido', 2),
(811, 'user800', 'm@m', 'nome', 'apelido', 2),
(812, 'user801', 'm@m', 'nome', 'apelido', 2),
(813, 'user802', 'm@m', 'nome', 'apelido', 2),
(814, 'user803', 'm@m', 'nome', 'apelido', 2),
(815, 'user804', 'm@m', 'nome', 'apelido', 2),
(816, 'user805', 'm@m', 'nome', 'apelido', 2),
(817, 'user806', 'm@m', 'nome', 'apelido', 2),
(818, 'user807', 'm@m', 'nome', 'apelido', 2),
(819, 'user808', 'm@m', 'nome', 'apelido', 2),
(820, 'user809', 'm@m', 'nome', 'apelido', 2),
(821, 'user810', 'm@m', 'nome', 'apelido', 2),
(822, 'user811', 'm@m', 'nome', 'apelido', 2),
(823, 'user812', 'm@m', 'nome', 'apelido', 2),
(824, 'user813', 'm@m', 'nome', 'apelido', 2),
(825, 'user814', 'm@m', 'nome', 'apelido', 2),
(826, 'user815', 'm@m', 'nome', 'apelido', 2),
(827, 'user816', 'm@m', 'nome', 'apelido', 2),
(828, 'user817', 'm@m', 'nome', 'apelido', 2),
(829, 'user818', 'm@m', 'nome', 'apelido', 2),
(830, 'user819', 'm@m', 'nome', 'apelido', 2),
(831, 'user820', 'm@m', 'nome', 'apelido', 2),
(832, 'user821', 'm@m', 'nome', 'apelido', 2),
(833, 'user822', 'm@m', 'nome', 'apelido', 2),
(834, 'user823', 'm@m', 'nome', 'apelido', 2),
(835, 'user824', 'm@m', 'nome', 'apelido', 2),
(836, 'user825', 'm@m', 'nome', 'apelido', 2),
(837, 'user826', 'm@m', 'nome', 'apelido', 2),
(838, 'user827', 'm@m', 'nome', 'apelido', 2),
(839, 'user828', 'm@m', 'nome', 'apelido', 2),
(840, 'user829', 'm@m', 'nome', 'apelido', 2),
(841, 'user830', 'm@m', 'nome', 'apelido', 2),
(842, 'user831', 'm@m', 'nome', 'apelido', 2),
(843, 'user832', 'm@m', 'nome', 'apelido', 2),
(844, 'user833', 'm@m', 'nome', 'apelido', 2),
(845, 'user834', 'm@m', 'nome', 'apelido', 2),
(846, 'user835', 'm@m', 'nome', 'apelido', 2),
(847, 'user836', 'm@m', 'nome', 'apelido', 2),
(848, 'user837', 'm@m', 'nome', 'apelido', 2),
(849, 'user838', 'm@m', 'nome', 'apelido', 2),
(850, 'user839', 'm@m', 'nome', 'apelido', 2),
(851, 'user840', 'm@m', 'nome', 'apelido', 2),
(852, 'user841', 'm@m', 'nome', 'apelido', 2),
(853, 'user842', 'm@m', 'nome', 'apelido', 2),
(854, 'user843', 'm@m', 'nome', 'apelido', 2),
(855, 'user844', 'm@m', 'nome', 'apelido', 2),
(856, 'user845', 'm@m', 'nome', 'apelido', 2),
(857, 'user846', 'm@m', 'nome', 'apelido', 2),
(858, 'user847', 'm@m', 'nome', 'apelido', 2),
(859, 'user848', 'm@m', 'nome', 'apelido', 2),
(860, 'user849', 'm@m', 'nome', 'apelido', 2),
(861, 'user850', 'm@m', 'nome', 'apelido', 2),
(862, 'user851', 'm@m', 'nome', 'apelido', 2),
(863, 'user852', 'm@m', 'nome', 'apelido', 2),
(864, 'user853', 'm@m', 'nome', 'apelido', 2),
(865, 'user854', 'm@m', 'nome', 'apelido', 2),
(866, 'user855', 'm@m', 'nome', 'apelido', 2),
(867, 'user856', 'm@m', 'nome', 'apelido', 2),
(868, 'user857', 'm@m', 'nome', 'apelido', 2),
(869, 'user858', 'm@m', 'nome', 'apelido', 2),
(870, 'user859', 'm@m', 'nome', 'apelido', 2),
(871, 'user860', 'm@m', 'nome', 'apelido', 2),
(872, 'user861', 'm@m', 'nome', 'apelido', 2),
(873, 'user862', 'm@m', 'nome', 'apelido', 2),
(874, 'user863', 'm@m', 'nome', 'apelido', 2),
(875, 'user864', 'm@m', 'nome', 'apelido', 2),
(876, 'user865', 'm@m', 'nome', 'apelido', 2),
(877, 'user866', 'm@m', 'nome', 'apelido', 2),
(878, 'user867', 'm@m', 'nome', 'apelido', 2),
(879, 'user868', 'm@m', 'nome', 'apelido', 2),
(880, 'user869', 'm@m', 'nome', 'apelido', 2),
(881, 'user870', 'm@m', 'nome', 'apelido', 2),
(882, 'user871', 'm@m', 'nome', 'apelido', 2),
(883, 'user872', 'm@m', 'nome', 'apelido', 2),
(884, 'user873', 'm@m', 'nome', 'apelido', 2),
(885, 'user874', 'm@m', 'nome', 'apelido', 2),
(886, 'user875', 'm@m', 'nome', 'apelido', 2),
(887, 'user876', 'm@m', 'nome', 'apelido', 2),
(888, 'user877', 'm@m', 'nome', 'apelido', 2),
(889, 'user878', 'm@m', 'nome', 'apelido', 2),
(890, 'user879', 'm@m', 'nome', 'apelido', 2),
(891, 'user880', 'm@m', 'nome', 'apelido', 2),
(892, 'user881', 'm@m', 'nome', 'apelido', 2),
(893, 'user882', 'm@m', 'nome', 'apelido', 2),
(894, 'user883', 'm@m', 'nome', 'apelido', 2),
(895, 'user884', 'm@m', 'nome', 'apelido', 2),
(896, 'user885', 'm@m', 'nome', 'apelido', 2),
(897, 'user886', 'm@m', 'nome', 'apelido', 2),
(898, 'user887', 'm@m', 'nome', 'apelido', 2),
(899, 'user888', 'm@m', 'nome', 'apelido', 2),
(900, 'user889', 'm@m', 'nome', 'apelido', 2),
(901, 'user890', 'm@m', 'nome', 'apelido', 2),
(902, 'user891', 'm@m', 'nome', 'apelido', 2),
(903, 'user892', 'm@m', 'nome', 'apelido', 2),
(904, 'user893', 'm@m', 'nome', 'apelido', 2),
(905, 'user894', 'm@m', 'nome', 'apelido', 2),
(906, 'user895', 'm@m', 'nome', 'apelido', 2),
(907, 'user896', 'm@m', 'nome', 'apelido', 2),
(908, 'user897', 'm@m', 'nome', 'apelido', 2),
(909, 'user898', 'm@m', 'nome', 'apelido', 2),
(910, 'user899', 'm@m', 'nome', 'apelido', 2),
(911, 'user900', 'm@m', 'nome', 'apelido', 2),
(912, 'user901', 'm@m', 'nome', 'apelido', 2),
(913, 'user902', 'm@m', 'nome', 'apelido', 2),
(914, 'user903', 'm@m', 'nome', 'apelido', 2),
(915, 'user904', 'm@m', 'nome', 'apelido', 2),
(916, 'user905', 'm@m', 'nome', 'apelido', 2),
(917, 'user906', 'm@m', 'nome', 'apelido', 2),
(918, 'user907', 'm@m', 'nome', 'apelido', 2),
(919, 'user908', 'm@m', 'nome', 'apelido', 2),
(920, 'user909', 'm@m', 'nome', 'apelido', 2),
(921, 'user910', 'm@m', 'nome', 'apelido', 2),
(922, 'user911', 'm@m', 'nome', 'apelido', 2),
(923, 'user912', 'm@m', 'nome', 'apelido', 2),
(924, 'user913', 'm@m', 'nome', 'apelido', 2),
(925, 'user914', 'm@m', 'nome', 'apelido', 2),
(926, 'user915', 'm@m', 'nome', 'apelido', 2),
(927, 'user916', 'm@m', 'nome', 'apelido', 2),
(928, 'user917', 'm@m', 'nome', 'apelido', 2),
(929, 'user918', 'm@m', 'nome', 'apelido', 2),
(930, 'user919', 'm@m', 'nome', 'apelido', 2),
(931, 'user920', 'm@m', 'nome', 'apelido', 2),
(932, 'user921', 'm@m', 'nome', 'apelido', 2),
(933, 'user922', 'm@m', 'nome', 'apelido', 2),
(934, 'user923', 'm@m', 'nome', 'apelido', 2),
(935, 'user924', 'm@m', 'nome', 'apelido', 2),
(936, 'user925', 'm@m', 'nome', 'apelido', 2),
(937, 'user926', 'm@m', 'nome', 'apelido', 2),
(938, 'user927', 'm@m', 'nome', 'apelido', 2),
(939, 'user928', 'm@m', 'nome', 'apelido', 2),
(940, 'user929', 'm@m', 'nome', 'apelido', 2),
(941, 'user930', 'm@m', 'nome', 'apelido', 2),
(942, 'user931', 'm@m', 'nome', 'apelido', 2),
(943, 'user932', 'm@m', 'nome', 'apelido', 2),
(944, 'user933', 'm@m', 'nome', 'apelido', 2),
(945, 'user934', 'm@m', 'nome', 'apelido', 2),
(946, 'user935', 'm@m', 'nome', 'apelido', 2),
(947, 'user936', 'm@m', 'nome', 'apelido', 2),
(948, 'user937', 'm@m', 'nome', 'apelido', 2),
(949, 'user938', 'm@m', 'nome', 'apelido', 2),
(950, 'user939', 'm@m', 'nome', 'apelido', 2),
(951, 'user940', 'm@m', 'nome', 'apelido', 2),
(952, 'user941', 'm@m', 'nome', 'apelido', 2),
(953, 'user942', 'm@m', 'nome', 'apelido', 2),
(954, 'user943', 'm@m', 'nome', 'apelido', 2),
(955, 'user944', 'm@m', 'nome', 'apelido', 2),
(956, 'user945', 'm@m', 'nome', 'apelido', 2),
(957, 'user946', 'm@m', 'nome', 'apelido', 2),
(958, 'user947', 'm@m', 'nome', 'apelido', 2),
(959, 'user948', 'm@m', 'nome', 'apelido', 2),
(960, 'user949', 'm@m', 'nome', 'apelido', 2),
(961, 'user950', 'm@m', 'nome', 'apelido', 2),
(962, 'user951', 'm@m', 'nome', 'apelido', 2),
(963, 'user952', 'm@m', 'nome', 'apelido', 2),
(964, 'user953', 'm@m', 'nome', 'apelido', 2),
(965, 'user954', 'm@m', 'nome', 'apelido', 2),
(966, 'user955', 'm@m', 'nome', 'apelido', 2),
(967, 'user956', 'm@m', 'nome', 'apelido', 2),
(968, 'user957', 'm@m', 'nome', 'apelido', 2),
(969, 'user958', 'm@m', 'nome', 'apelido', 2),
(970, 'user959', 'm@m', 'nome', 'apelido', 2),
(971, 'user960', 'm@m', 'nome', 'apelido', 2),
(972, 'user961', 'm@m', 'nome', 'apelido', 2),
(973, 'user962', 'm@m', 'nome', 'apelido', 2),
(974, 'user963', 'm@m', 'nome', 'apelido', 2),
(975, 'user964', 'm@m', 'nome', 'apelido', 2),
(976, 'user965', 'm@m', 'nome', 'apelido', 2),
(977, 'user966', 'm@m', 'nome', 'apelido', 2),
(978, 'user967', 'm@m', 'nome', 'apelido', 2),
(979, 'user968', 'm@m', 'nome', 'apelido', 2),
(980, 'user969', 'm@m', 'nome', 'apelido', 2),
(981, 'user970', 'm@m', 'nome', 'apelido', 2),
(982, 'user971', 'm@m', 'nome', 'apelido', 2),
(983, 'user972', 'm@m', 'nome', 'apelido', 2),
(984, 'user973', 'm@m', 'nome', 'apelido', 2),
(985, 'user974', 'm@m', 'nome', 'apelido', 2),
(986, 'user975', 'm@m', 'nome', 'apelido', 2),
(987, 'user976', 'm@m', 'nome', 'apelido', 2),
(988, 'user977', 'm@m', 'nome', 'apelido', 2),
(989, 'user978', 'm@m', 'nome', 'apelido', 2),
(990, 'user979', 'm@m', 'nome', 'apelido', 2),
(991, 'user980', 'm@m', 'nome', 'apelido', 2),
(992, 'user981', 'm@m', 'nome', 'apelido', 2),
(993, 'user982', 'm@m', 'nome', 'apelido', 2),
(994, 'user983', 'm@m', 'nome', 'apelido', 2),
(995, 'user984', 'm@m', 'nome', 'apelido', 2),
(996, 'user985', 'm@m', 'nome', 'apelido', 2),
(997, 'user986', 'm@m', 'nome', 'apelido', 2),
(998, 'user987', 'm@m', 'nome', 'apelido', 2),
(999, 'user988', 'm@m', 'nome', 'apelido', 2),
(1000, 'user989', 'm@m', 'nome', 'apelido', 2),
(1001, 'user990', 'm@m', 'nome', 'apelido', 2),
(1002, 'user991', 'm@m', 'nome', 'apelido', 2),
(1003, 'user992', 'm@m', 'nome', 'apelido', 2),
(1004, 'user993', 'm@m', 'nome', 'apelido', 2),
(1005, 'user994', 'm@m', 'nome', 'apelido', 2),
(1006, 'user995', 'm@m', 'nome', 'apelido', 2),
(1007, 'user996', 'm@m', 'nome', 'apelido', 2),
(1008, 'user997', 'm@m', 'nome', 'apelido', 2),
(1009, 'user998', 'm@m', 'nome', 'apelido', 2),
(1010, 'user999', 'm@m', 'nome', 'apelido', 2),
(1011, 'user1000', 'm@m', 'nome', 'apelido', 2),
(1012, 'user1001', 'm@m', 'nome', 'apelido', 2);

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `User_delete_trigger` AFTER DELETE ON `user` FOR EACH ROW BEGIN
	insert into user_logs(op, opUser, opData, ID, usernameAntes, usernameDepois, emailAntes, emailDepois, nomeAntes, nomeDepois, apelidoAntes, apelidoDepois)
 	VALUES("D", CURRENT_USER, NOW(), NULL, OLD.username, NULL, OLD.email, NULL, OLD.nome, NULL, OLD.apelido, NULL);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `User_insert_trigger` AFTER INSERT ON `user` FOR EACH ROW BEGIN
insert into user_logs(op, opUser, opData, ID, usernameAntes, usernameDepois, emailAntes, emailDepois, nomeAntes, nomeDepois, apelidoAntes, apelidoDepois) VALUES("I", CURRENT_USER, NOW(), NULL, NULL, NEW.username, NULL, NEW.email, NULL, NEW.nome, NULL, NEW.apelido);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `User_update_trigger` AFTER UPDATE ON `user` FOR EACH ROW BEGIN
	declare new_id DOUBLE;
	select max(id) + 1 into new_id from user_logs;
	insert into user_logs(op, opUser, opData, ID)
	VALUES ("U", CURRENT_USER, NOW(), NULL);

	
	if(old.username <> new.username) or (old.username is NULL and new.username is NOT NULL) THEN
		update user_logs set usernameAntes = OLD.username, usernameDepois = NEW.username where ID = new_id;
	end if;

	if(old.email <> new.email) or (old.email is NULL and new.email is NOT NULL) THEN
		update user_logs set emailAntes = OLD.email, emailDepois = NEW.email where ID = new_id;
	end if;

	if(old.nome <> new.nome) or (old.nome is NULL and new.nome is NOT NULL) THEN
		update user_logs set nomeAntes = OLD.nome, nomeDepois = NEW.nome where ID = new_id;
	end if;

	if(old.apelido <> new.apelido) or (old.apelido is NULL and new.apelido is NOT NULL) THEN
		update user_logs set apelidoAntes = OLD.apelido, apelidoDepois = NEW.apelido where ID = new_id;
	end if;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_logs`
--

CREATE TABLE `user_logs` (
  `ID` int(11) NOT NULL,
  `op` varchar(30) NOT NULL,
  `opUser` varchar(20) NOT NULL,
  `opData` date NOT NULL,
  `usernameAntes` varchar(20) DEFAULT NULL,
  `usernameDepois` varchar(20) DEFAULT NULL,
  `emailAntes` varchar(50) DEFAULT NULL,
  `emailDepois` varchar(50) DEFAULT NULL,
  `nomeAntes` varchar(20) DEFAULT NULL,
  `nomeDepois` varchar(20) DEFAULT NULL,
  `apelidoAntes` varchar(20) DEFAULT NULL,
  `apelidoDepois` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_logs`
--

INSERT INTO `user_logs` (`ID`, `op`, `opUser`, `opData`, `usernameAntes`, `usernameDepois`, `emailAntes`, `emailDepois`, `nomeAntes`, `nomeDepois`, `apelidoAntes`, `apelidoDepois`) VALUES
(1, 'I', 'root@localhost', '2020-03-26', NULL, 'asd', NULL, 'asd', NULL, 'ads', NULL, 'asd'),
(2, 'D', 'root@localhost', '2020-03-26', 'asd', NULL, 'asd', NULL, 'ads', NULL, 'asd', NULL),
(3, 'I', 'root@localhost', '2020-03-26', NULL, 'dsf', NULL, 'sdf', NULL, 'sdf', NULL, 'sdf'),
(4, 'D', 'root@localhost', '2020-03-26', 'dsf', NULL, 'sdf', NULL, 'sdf', NULL, 'sdf', NULL),
(5, 'I', 'root@localhost', '2020-03-30', NULL, 'administrador', NULL, 'asd@asd', NULL, 'asd', NULL, 'asd'),
(6, 'U', 'root@localhost', '2020-03-30', NULL, NULL, 'asd@asd', 'administrador@administrador', 'asd', 'Alvaro', 'asd', 'admin'),
(7, 'U', 'root@localhost', '2020-03-30', NULL, NULL, 'administrador@administrador', 'administrador@admin', 'Alvaro', 'Admin', NULL, NULL),
(8, 'I', 'root@localhost', '2020-03-30', NULL, 'seguranca', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg'),
(9, 'I', 'root@localhost', '2020-03-30', NULL, 'seguranca', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg'),
(10, 'I', 'root@localhost', '2020-03-30', NULL, 'seguranca', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg'),
(11, 'I', 'root@localhost', '2020-03-30', NULL, 'seg', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg'),
(12, 'I', 'root@localhost', '2020-03-30', NULL, 'seg1', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg'),
(13, 'D', 'root@localhost', '2020-03-30', 'seguranca', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg', NULL),
(14, 'D', 'root@localhost', '2020-03-30', 'seguranca', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg', NULL),
(15, 'D', 'root@localhost', '2020-03-30', 'seguranca', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg', NULL),
(16, 'D', 'root@localhost', '2020-03-30', 'seg', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg', NULL),
(17, 'D', 'root@localhost', '2020-03-30', 'seg1', NULL, 'seguranca@seguranca', NULL, 'Seg', NULL, 'seg', NULL),
(18, 'U', 'root@localhost', '2020-03-31', NULL, NULL, 'administrador@admin', 'admin@admin', NULL, NULL, NULL, NULL),
(19, 'I', 'root@localhost', '2020-03-31', NULL, 'seg', NULL, 'seg', NULL, 'seg', NULL, 'seg'),
(20, 'D', 'root@localhost', '2020-03-31', 'seg', NULL, 'seg', NULL, 'seg', NULL, 'seg', NULL),
(21, 'I', 'root@localhost', '2020-03-31', NULL, 'seg', NULL, 'seg', NULL, 'seg', NULL, 'seg'),
(22, 'D', 'root@localhost', '2020-03-31', 'seg', NULL, 'seg', NULL, 'seg', NULL, 'seg', NULL),
(23, 'I', 'root@localhost', '2020-04-01', NULL, 'seg', NULL, 'seg', NULL, 'seg', NULL, 'seg'),
(24, 'D', 'root@localhost', '2020-04-01', 'seg', NULL, 'seg', NULL, 'seg', NULL, 'seg', NULL),
(25, 'I', 'root@localhost', '2020-04-02', NULL, 'seguranca', NULL, 'seg@seg', NULL, 'Seguranca', NULL, 'seg'),
(26, 'D', 'root@localhost', '2020-04-02', 'seguranca', NULL, 'seg@seg', NULL, 'Seguranca', NULL, 'seg', NULL),
(27, 'I', 'root@localhost', '2020-04-02', NULL, 'seguranca', NULL, 'seg@seg', NULL, 'Seguranca', NULL, 'seg'),
(28, 'I', 'root@localhost', '2020-04-05', NULL, 'user2', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(29, 'I', 'root@localhost', '2020-04-05', NULL, 'user3', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(30, 'I', 'root@localhost', '2020-04-05', NULL, 'user4', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(31, 'I', 'root@localhost', '2020-04-05', NULL, 'user5', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(32, 'I', 'root@localhost', '2020-04-05', NULL, 'user6', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(33, 'I', 'root@localhost', '2020-04-05', NULL, 'user7', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(34, 'I', 'root@localhost', '2020-04-05', NULL, 'user8', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(35, 'I', 'root@localhost', '2020-04-05', NULL, 'user9', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(36, 'I', 'root@localhost', '2020-04-05', NULL, 'user10', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(37, 'I', 'root@localhost', '2020-04-05', NULL, 'user11', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(38, 'I', 'root@localhost', '2020-04-05', NULL, 'user12', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(39, 'I', 'root@localhost', '2020-04-05', NULL, 'user13', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(40, 'I', 'root@localhost', '2020-04-05', NULL, 'user14', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(41, 'I', 'root@localhost', '2020-04-05', NULL, 'user15', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(42, 'I', 'root@localhost', '2020-04-05', NULL, 'user16', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(43, 'I', 'root@localhost', '2020-04-05', NULL, 'user17', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(44, 'I', 'root@localhost', '2020-04-05', NULL, 'user18', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(45, 'I', 'root@localhost', '2020-04-05', NULL, 'user19', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(46, 'I', 'root@localhost', '2020-04-05', NULL, 'user20', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(47, 'I', 'root@localhost', '2020-04-05', NULL, 'user21', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(48, 'I', 'root@localhost', '2020-04-05', NULL, 'user22', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(49, 'I', 'root@localhost', '2020-04-05', NULL, 'user23', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(50, 'I', 'root@localhost', '2020-04-05', NULL, 'user24', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(51, 'I', 'root@localhost', '2020-04-05', NULL, 'user25', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(52, 'I', 'root@localhost', '2020-04-05', NULL, 'user26', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(53, 'I', 'root@localhost', '2020-04-05', NULL, 'user27', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(54, 'I', 'root@localhost', '2020-04-05', NULL, 'user28', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(55, 'I', 'root@localhost', '2020-04-05', NULL, 'user29', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(56, 'I', 'root@localhost', '2020-04-05', NULL, 'user30', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(57, 'I', 'root@localhost', '2020-04-05', NULL, 'user31', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(58, 'I', 'root@localhost', '2020-04-05', NULL, 'user32', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(59, 'I', 'root@localhost', '2020-04-05', NULL, 'user33', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(60, 'I', 'root@localhost', '2020-04-05', NULL, 'user34', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(61, 'I', 'root@localhost', '2020-04-05', NULL, 'user35', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(62, 'I', 'root@localhost', '2020-04-05', NULL, 'user36', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(63, 'I', 'root@localhost', '2020-04-05', NULL, 'user37', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(64, 'I', 'root@localhost', '2020-04-05', NULL, 'user38', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(65, 'I', 'root@localhost', '2020-04-05', NULL, 'user39', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(66, 'I', 'root@localhost', '2020-04-05', NULL, 'user40', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(67, 'I', 'root@localhost', '2020-04-05', NULL, 'user41', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(68, 'I', 'root@localhost', '2020-04-05', NULL, 'user42', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(69, 'I', 'root@localhost', '2020-04-05', NULL, 'user43', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(70, 'I', 'root@localhost', '2020-04-05', NULL, 'user44', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(71, 'I', 'root@localhost', '2020-04-05', NULL, 'user45', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(72, 'I', 'root@localhost', '2020-04-05', NULL, 'user46', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(73, 'I', 'root@localhost', '2020-04-05', NULL, 'user47', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(74, 'I', 'root@localhost', '2020-04-05', NULL, 'user48', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(75, 'I', 'root@localhost', '2020-04-05', NULL, 'user49', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(76, 'I', 'root@localhost', '2020-04-05', NULL, 'user50', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(77, 'I', 'root@localhost', '2020-04-05', NULL, 'user51', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(78, 'I', 'root@localhost', '2020-04-05', NULL, 'user52', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(79, 'I', 'root@localhost', '2020-04-05', NULL, 'user53', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(80, 'I', 'root@localhost', '2020-04-05', NULL, 'user54', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(81, 'I', 'root@localhost', '2020-04-05', NULL, 'user55', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(82, 'I', 'root@localhost', '2020-04-05', NULL, 'user56', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(83, 'I', 'root@localhost', '2020-04-05', NULL, 'user57', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(84, 'I', 'root@localhost', '2020-04-05', NULL, 'user58', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(85, 'I', 'root@localhost', '2020-04-05', NULL, 'user59', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(86, 'I', 'root@localhost', '2020-04-05', NULL, 'user60', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(87, 'I', 'root@localhost', '2020-04-05', NULL, 'user61', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(88, 'I', 'root@localhost', '2020-04-05', NULL, 'user62', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(89, 'I', 'root@localhost', '2020-04-05', NULL, 'user63', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(90, 'I', 'root@localhost', '2020-04-05', NULL, 'user64', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(91, 'I', 'root@localhost', '2020-04-05', NULL, 'user65', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(92, 'I', 'root@localhost', '2020-04-05', NULL, 'user66', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(93, 'I', 'root@localhost', '2020-04-05', NULL, 'user67', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(94, 'I', 'root@localhost', '2020-04-05', NULL, 'user68', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(95, 'I', 'root@localhost', '2020-04-05', NULL, 'user69', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(96, 'I', 'root@localhost', '2020-04-05', NULL, 'user70', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(97, 'I', 'root@localhost', '2020-04-05', NULL, 'user71', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(98, 'I', 'root@localhost', '2020-04-05', NULL, 'user72', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(99, 'I', 'root@localhost', '2020-04-05', NULL, 'user73', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(100, 'I', 'root@localhost', '2020-04-05', NULL, 'user74', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(101, 'I', 'root@localhost', '2020-04-05', NULL, 'user75', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(102, 'I', 'root@localhost', '2020-04-05', NULL, 'user76', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(103, 'I', 'root@localhost', '2020-04-05', NULL, 'user77', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(104, 'I', 'root@localhost', '2020-04-05', NULL, 'user78', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(105, 'I', 'root@localhost', '2020-04-05', NULL, 'user79', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(106, 'I', 'root@localhost', '2020-04-05', NULL, 'user80', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(107, 'I', 'root@localhost', '2020-04-05', NULL, 'user81', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(108, 'I', 'root@localhost', '2020-04-05', NULL, 'user82', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(109, 'I', 'root@localhost', '2020-04-05', NULL, 'user83', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(110, 'I', 'root@localhost', '2020-04-05', NULL, 'user84', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(111, 'I', 'root@localhost', '2020-04-05', NULL, 'user85', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(112, 'I', 'root@localhost', '2020-04-05', NULL, 'user86', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(113, 'I', 'root@localhost', '2020-04-05', NULL, 'user87', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(114, 'I', 'root@localhost', '2020-04-05', NULL, 'user88', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(115, 'I', 'root@localhost', '2020-04-05', NULL, 'user89', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(116, 'I', 'root@localhost', '2020-04-05', NULL, 'user90', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(117, 'I', 'root@localhost', '2020-04-05', NULL, 'user91', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(118, 'I', 'root@localhost', '2020-04-05', NULL, 'user92', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(119, 'I', 'root@localhost', '2020-04-05', NULL, 'user93', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(120, 'I', 'root@localhost', '2020-04-05', NULL, 'user94', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(121, 'I', 'root@localhost', '2020-04-05', NULL, 'user95', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(122, 'I', 'root@localhost', '2020-04-05', NULL, 'user96', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(123, 'I', 'root@localhost', '2020-04-05', NULL, 'user97', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(124, 'I', 'root@localhost', '2020-04-05', NULL, 'user98', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(125, 'I', 'root@localhost', '2020-04-05', NULL, 'user99', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(126, 'I', 'root@localhost', '2020-04-05', NULL, 'user100', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(127, 'I', 'root@localhost', '2020-04-05', NULL, 'user101', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(128, 'I', 'root@localhost', '2020-04-05', NULL, 'user102', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(129, 'I', 'root@localhost', '2020-04-05', NULL, 'user103', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(130, 'I', 'root@localhost', '2020-04-05', NULL, 'user104', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(131, 'I', 'root@localhost', '2020-04-05', NULL, 'user105', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(132, 'I', 'root@localhost', '2020-04-05', NULL, 'user106', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(133, 'I', 'root@localhost', '2020-04-05', NULL, 'user107', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(134, 'I', 'root@localhost', '2020-04-05', NULL, 'user108', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(135, 'I', 'root@localhost', '2020-04-05', NULL, 'user109', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(136, 'I', 'root@localhost', '2020-04-05', NULL, 'user110', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(137, 'I', 'root@localhost', '2020-04-05', NULL, 'user111', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(138, 'I', 'root@localhost', '2020-04-05', NULL, 'user112', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(139, 'I', 'root@localhost', '2020-04-05', NULL, 'user113', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(140, 'I', 'root@localhost', '2020-04-05', NULL, 'user114', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(141, 'I', 'root@localhost', '2020-04-05', NULL, 'user115', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(142, 'I', 'root@localhost', '2020-04-05', NULL, 'user116', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(143, 'I', 'root@localhost', '2020-04-05', NULL, 'user117', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(144, 'I', 'root@localhost', '2020-04-05', NULL, 'user118', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(145, 'I', 'root@localhost', '2020-04-05', NULL, 'user119', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(146, 'I', 'root@localhost', '2020-04-05', NULL, 'user120', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(147, 'I', 'root@localhost', '2020-04-05', NULL, 'user121', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(148, 'I', 'root@localhost', '2020-04-05', NULL, 'user122', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(149, 'I', 'root@localhost', '2020-04-05', NULL, 'user123', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(150, 'I', 'root@localhost', '2020-04-05', NULL, 'user124', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(151, 'I', 'root@localhost', '2020-04-05', NULL, 'user125', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(152, 'I', 'root@localhost', '2020-04-05', NULL, 'user126', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(153, 'I', 'root@localhost', '2020-04-05', NULL, 'user127', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(154, 'I', 'root@localhost', '2020-04-05', NULL, 'user128', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(155, 'I', 'root@localhost', '2020-04-05', NULL, 'user129', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(156, 'I', 'root@localhost', '2020-04-05', NULL, 'user130', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(157, 'I', 'root@localhost', '2020-04-05', NULL, 'user131', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(158, 'I', 'root@localhost', '2020-04-05', NULL, 'user132', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(159, 'I', 'root@localhost', '2020-04-05', NULL, 'user133', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(160, 'I', 'root@localhost', '2020-04-05', NULL, 'user134', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(161, 'I', 'root@localhost', '2020-04-05', NULL, 'user135', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(162, 'I', 'root@localhost', '2020-04-05', NULL, 'user136', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(163, 'I', 'root@localhost', '2020-04-05', NULL, 'user137', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(164, 'I', 'root@localhost', '2020-04-05', NULL, 'user138', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(165, 'I', 'root@localhost', '2020-04-05', NULL, 'user139', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(166, 'I', 'root@localhost', '2020-04-05', NULL, 'user140', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(167, 'I', 'root@localhost', '2020-04-05', NULL, 'user141', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(168, 'I', 'root@localhost', '2020-04-05', NULL, 'user142', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(169, 'I', 'root@localhost', '2020-04-05', NULL, 'user143', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(170, 'I', 'root@localhost', '2020-04-05', NULL, 'user144', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(171, 'I', 'root@localhost', '2020-04-05', NULL, 'user145', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(172, 'I', 'root@localhost', '2020-04-05', NULL, 'user146', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(173, 'I', 'root@localhost', '2020-04-05', NULL, 'user147', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(174, 'I', 'root@localhost', '2020-04-05', NULL, 'user148', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(175, 'I', 'root@localhost', '2020-04-05', NULL, 'user149', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(176, 'I', 'root@localhost', '2020-04-05', NULL, 'user150', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(177, 'I', 'root@localhost', '2020-04-05', NULL, 'user151', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(178, 'I', 'root@localhost', '2020-04-05', NULL, 'user152', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(179, 'I', 'root@localhost', '2020-04-05', NULL, 'user153', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(180, 'I', 'root@localhost', '2020-04-05', NULL, 'user154', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(181, 'I', 'root@localhost', '2020-04-05', NULL, 'user155', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(182, 'I', 'root@localhost', '2020-04-05', NULL, 'user156', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(183, 'I', 'root@localhost', '2020-04-05', NULL, 'user157', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(184, 'I', 'root@localhost', '2020-04-05', NULL, 'user158', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(185, 'I', 'root@localhost', '2020-04-05', NULL, 'user159', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(186, 'I', 'root@localhost', '2020-04-05', NULL, 'user160', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(187, 'I', 'root@localhost', '2020-04-05', NULL, 'user161', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(188, 'I', 'root@localhost', '2020-04-05', NULL, 'user162', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(189, 'I', 'root@localhost', '2020-04-05', NULL, 'user163', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(190, 'I', 'root@localhost', '2020-04-05', NULL, 'user164', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(191, 'I', 'root@localhost', '2020-04-05', NULL, 'user165', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(192, 'I', 'root@localhost', '2020-04-05', NULL, 'user166', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(193, 'I', 'root@localhost', '2020-04-05', NULL, 'user167', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(194, 'I', 'root@localhost', '2020-04-05', NULL, 'user168', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(195, 'I', 'root@localhost', '2020-04-05', NULL, 'user169', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(196, 'I', 'root@localhost', '2020-04-05', NULL, 'user170', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(197, 'I', 'root@localhost', '2020-04-05', NULL, 'user171', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(198, 'I', 'root@localhost', '2020-04-05', NULL, 'user172', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(199, 'I', 'root@localhost', '2020-04-05', NULL, 'user173', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(200, 'I', 'root@localhost', '2020-04-05', NULL, 'user174', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(201, 'I', 'root@localhost', '2020-04-05', NULL, 'user175', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(202, 'I', 'root@localhost', '2020-04-05', NULL, 'user176', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(203, 'I', 'root@localhost', '2020-04-05', NULL, 'user177', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(204, 'I', 'root@localhost', '2020-04-05', NULL, 'user178', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(205, 'I', 'root@localhost', '2020-04-05', NULL, 'user179', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(206, 'I', 'root@localhost', '2020-04-05', NULL, 'user180', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(207, 'I', 'root@localhost', '2020-04-05', NULL, 'user181', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(208, 'I', 'root@localhost', '2020-04-05', NULL, 'user182', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(209, 'I', 'root@localhost', '2020-04-05', NULL, 'user183', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(210, 'I', 'root@localhost', '2020-04-05', NULL, 'user184', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(211, 'I', 'root@localhost', '2020-04-05', NULL, 'user185', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(212, 'I', 'root@localhost', '2020-04-05', NULL, 'user186', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(213, 'I', 'root@localhost', '2020-04-05', NULL, 'user187', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(214, 'I', 'root@localhost', '2020-04-05', NULL, 'user188', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(215, 'I', 'root@localhost', '2020-04-05', NULL, 'user189', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(216, 'I', 'root@localhost', '2020-04-05', NULL, 'user190', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(217, 'I', 'root@localhost', '2020-04-05', NULL, 'user191', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(218, 'I', 'root@localhost', '2020-04-05', NULL, 'user192', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(219, 'I', 'root@localhost', '2020-04-05', NULL, 'user193', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(220, 'I', 'root@localhost', '2020-04-05', NULL, 'user194', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(221, 'I', 'root@localhost', '2020-04-05', NULL, 'user195', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(222, 'I', 'root@localhost', '2020-04-05', NULL, 'user196', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(223, 'I', 'root@localhost', '2020-04-05', NULL, 'user197', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(224, 'I', 'root@localhost', '2020-04-05', NULL, 'user198', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(225, 'I', 'root@localhost', '2020-04-05', NULL, 'user199', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(226, 'I', 'root@localhost', '2020-04-05', NULL, 'user200', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(227, 'I', 'root@localhost', '2020-04-05', NULL, 'user201', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(228, 'I', 'root@localhost', '2020-04-05', NULL, 'user202', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(229, 'I', 'root@localhost', '2020-04-05', NULL, 'user203', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(230, 'I', 'root@localhost', '2020-04-05', NULL, 'user204', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(231, 'I', 'root@localhost', '2020-04-05', NULL, 'user205', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(232, 'I', 'root@localhost', '2020-04-05', NULL, 'user206', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(233, 'I', 'root@localhost', '2020-04-05', NULL, 'user207', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(234, 'I', 'root@localhost', '2020-04-05', NULL, 'user208', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(235, 'I', 'root@localhost', '2020-04-05', NULL, 'user209', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(236, 'I', 'root@localhost', '2020-04-05', NULL, 'user210', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(237, 'I', 'root@localhost', '2020-04-05', NULL, 'user211', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(238, 'I', 'root@localhost', '2020-04-05', NULL, 'user212', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(239, 'I', 'root@localhost', '2020-04-05', NULL, 'user213', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(240, 'I', 'root@localhost', '2020-04-05', NULL, 'user214', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(241, 'I', 'root@localhost', '2020-04-05', NULL, 'user215', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(242, 'I', 'root@localhost', '2020-04-05', NULL, 'user216', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(243, 'I', 'root@localhost', '2020-04-05', NULL, 'user217', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(244, 'I', 'root@localhost', '2020-04-05', NULL, 'user218', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(245, 'I', 'root@localhost', '2020-04-05', NULL, 'user219', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(246, 'I', 'root@localhost', '2020-04-05', NULL, 'user220', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(247, 'I', 'root@localhost', '2020-04-05', NULL, 'user221', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(248, 'I', 'root@localhost', '2020-04-05', NULL, 'user222', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(249, 'I', 'root@localhost', '2020-04-05', NULL, 'user223', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(250, 'I', 'root@localhost', '2020-04-05', NULL, 'user224', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(251, 'I', 'root@localhost', '2020-04-05', NULL, 'user225', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(252, 'I', 'root@localhost', '2020-04-05', NULL, 'user226', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(253, 'I', 'root@localhost', '2020-04-05', NULL, 'user227', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(254, 'I', 'root@localhost', '2020-04-05', NULL, 'user228', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(255, 'I', 'root@localhost', '2020-04-05', NULL, 'user229', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(256, 'I', 'root@localhost', '2020-04-05', NULL, 'user230', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(257, 'I', 'root@localhost', '2020-04-05', NULL, 'user231', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(258, 'I', 'root@localhost', '2020-04-05', NULL, 'user232', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(259, 'I', 'root@localhost', '2020-04-05', NULL, 'user233', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(260, 'I', 'root@localhost', '2020-04-05', NULL, 'user234', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(261, 'I', 'root@localhost', '2020-04-05', NULL, 'user235', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(262, 'I', 'root@localhost', '2020-04-05', NULL, 'user236', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(263, 'I', 'root@localhost', '2020-04-05', NULL, 'user237', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(264, 'I', 'root@localhost', '2020-04-05', NULL, 'user238', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(265, 'I', 'root@localhost', '2020-04-05', NULL, 'user239', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(266, 'I', 'root@localhost', '2020-04-05', NULL, 'user240', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(267, 'I', 'root@localhost', '2020-04-05', NULL, 'user241', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(268, 'I', 'root@localhost', '2020-04-05', NULL, 'user242', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(269, 'I', 'root@localhost', '2020-04-05', NULL, 'user243', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(270, 'I', 'root@localhost', '2020-04-05', NULL, 'user244', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(271, 'I', 'root@localhost', '2020-04-05', NULL, 'user245', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(272, 'I', 'root@localhost', '2020-04-05', NULL, 'user246', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(273, 'I', 'root@localhost', '2020-04-05', NULL, 'user247', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(274, 'I', 'root@localhost', '2020-04-05', NULL, 'user248', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(275, 'I', 'root@localhost', '2020-04-05', NULL, 'user249', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(276, 'I', 'root@localhost', '2020-04-05', NULL, 'user250', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(277, 'I', 'root@localhost', '2020-04-05', NULL, 'user251', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(278, 'I', 'root@localhost', '2020-04-05', NULL, 'user252', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(279, 'I', 'root@localhost', '2020-04-05', NULL, 'user253', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(280, 'I', 'root@localhost', '2020-04-05', NULL, 'user254', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(281, 'I', 'root@localhost', '2020-04-05', NULL, 'user255', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(282, 'I', 'root@localhost', '2020-04-05', NULL, 'user256', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(283, 'I', 'root@localhost', '2020-04-05', NULL, 'user257', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(284, 'I', 'root@localhost', '2020-04-05', NULL, 'user258', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(285, 'I', 'root@localhost', '2020-04-05', NULL, 'user259', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(286, 'I', 'root@localhost', '2020-04-05', NULL, 'user260', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(287, 'I', 'root@localhost', '2020-04-05', NULL, 'user261', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(288, 'I', 'root@localhost', '2020-04-05', NULL, 'user262', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(289, 'I', 'root@localhost', '2020-04-05', NULL, 'user263', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(290, 'I', 'root@localhost', '2020-04-05', NULL, 'user264', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(291, 'I', 'root@localhost', '2020-04-05', NULL, 'user265', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(292, 'I', 'root@localhost', '2020-04-05', NULL, 'user266', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(293, 'I', 'root@localhost', '2020-04-05', NULL, 'user267', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(294, 'I', 'root@localhost', '2020-04-05', NULL, 'user268', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(295, 'I', 'root@localhost', '2020-04-05', NULL, 'user269', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(296, 'I', 'root@localhost', '2020-04-05', NULL, 'user270', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(297, 'I', 'root@localhost', '2020-04-05', NULL, 'user271', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(298, 'I', 'root@localhost', '2020-04-05', NULL, 'user272', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(299, 'I', 'root@localhost', '2020-04-05', NULL, 'user273', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(300, 'I', 'root@localhost', '2020-04-05', NULL, 'user274', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(301, 'I', 'root@localhost', '2020-04-05', NULL, 'user275', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(302, 'I', 'root@localhost', '2020-04-05', NULL, 'user276', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(303, 'I', 'root@localhost', '2020-04-05', NULL, 'user277', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(304, 'I', 'root@localhost', '2020-04-05', NULL, 'user278', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(305, 'I', 'root@localhost', '2020-04-05', NULL, 'user279', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(306, 'I', 'root@localhost', '2020-04-05', NULL, 'user280', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(307, 'I', 'root@localhost', '2020-04-05', NULL, 'user281', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(308, 'I', 'root@localhost', '2020-04-05', NULL, 'user282', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(309, 'I', 'root@localhost', '2020-04-05', NULL, 'user283', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(310, 'I', 'root@localhost', '2020-04-05', NULL, 'user284', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(311, 'I', 'root@localhost', '2020-04-05', NULL, 'user285', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(312, 'I', 'root@localhost', '2020-04-05', NULL, 'user286', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(313, 'I', 'root@localhost', '2020-04-05', NULL, 'user287', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(314, 'I', 'root@localhost', '2020-04-05', NULL, 'user288', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(315, 'I', 'root@localhost', '2020-04-05', NULL, 'user289', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(316, 'I', 'root@localhost', '2020-04-05', NULL, 'user290', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(317, 'I', 'root@localhost', '2020-04-05', NULL, 'user291', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(318, 'I', 'root@localhost', '2020-04-05', NULL, 'user292', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(319, 'I', 'root@localhost', '2020-04-05', NULL, 'user293', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(320, 'I', 'root@localhost', '2020-04-05', NULL, 'user294', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(321, 'I', 'root@localhost', '2020-04-05', NULL, 'user295', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(322, 'I', 'root@localhost', '2020-04-05', NULL, 'user296', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(323, 'I', 'root@localhost', '2020-04-05', NULL, 'user297', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(324, 'I', 'root@localhost', '2020-04-05', NULL, 'user298', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(325, 'I', 'root@localhost', '2020-04-05', NULL, 'user299', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(326, 'I', 'root@localhost', '2020-04-05', NULL, 'user300', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(327, 'I', 'root@localhost', '2020-04-05', NULL, 'user301', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(328, 'I', 'root@localhost', '2020-04-05', NULL, 'user302', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(329, 'I', 'root@localhost', '2020-04-05', NULL, 'user303', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(330, 'I', 'root@localhost', '2020-04-05', NULL, 'user304', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(331, 'I', 'root@localhost', '2020-04-05', NULL, 'user305', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(332, 'I', 'root@localhost', '2020-04-05', NULL, 'user306', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(333, 'I', 'root@localhost', '2020-04-05', NULL, 'user307', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(334, 'I', 'root@localhost', '2020-04-05', NULL, 'user308', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(335, 'I', 'root@localhost', '2020-04-05', NULL, 'user309', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(336, 'I', 'root@localhost', '2020-04-05', NULL, 'user310', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(337, 'I', 'root@localhost', '2020-04-05', NULL, 'user311', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(338, 'I', 'root@localhost', '2020-04-05', NULL, 'user312', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(339, 'I', 'root@localhost', '2020-04-05', NULL, 'user313', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(340, 'I', 'root@localhost', '2020-04-05', NULL, 'user314', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(341, 'I', 'root@localhost', '2020-04-05', NULL, 'user315', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(342, 'I', 'root@localhost', '2020-04-05', NULL, 'user316', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(343, 'I', 'root@localhost', '2020-04-05', NULL, 'user317', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(344, 'I', 'root@localhost', '2020-04-05', NULL, 'user318', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(345, 'I', 'root@localhost', '2020-04-05', NULL, 'user319', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(346, 'I', 'root@localhost', '2020-04-05', NULL, 'user320', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(347, 'I', 'root@localhost', '2020-04-05', NULL, 'user321', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(348, 'I', 'root@localhost', '2020-04-05', NULL, 'user322', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(349, 'I', 'root@localhost', '2020-04-05', NULL, 'user323', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(350, 'I', 'root@localhost', '2020-04-05', NULL, 'user324', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(351, 'I', 'root@localhost', '2020-04-05', NULL, 'user325', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(352, 'I', 'root@localhost', '2020-04-05', NULL, 'user326', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(353, 'I', 'root@localhost', '2020-04-05', NULL, 'user327', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(354, 'I', 'root@localhost', '2020-04-05', NULL, 'user328', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(355, 'I', 'root@localhost', '2020-04-05', NULL, 'user329', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(356, 'I', 'root@localhost', '2020-04-05', NULL, 'user330', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(357, 'I', 'root@localhost', '2020-04-05', NULL, 'user331', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(358, 'I', 'root@localhost', '2020-04-05', NULL, 'user332', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(359, 'I', 'root@localhost', '2020-04-05', NULL, 'user333', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(360, 'I', 'root@localhost', '2020-04-05', NULL, 'user334', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(361, 'I', 'root@localhost', '2020-04-05', NULL, 'user335', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(362, 'I', 'root@localhost', '2020-04-05', NULL, 'user336', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(363, 'I', 'root@localhost', '2020-04-05', NULL, 'user337', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(364, 'I', 'root@localhost', '2020-04-05', NULL, 'user338', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(365, 'I', 'root@localhost', '2020-04-05', NULL, 'user339', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(366, 'I', 'root@localhost', '2020-04-05', NULL, 'user340', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(367, 'I', 'root@localhost', '2020-04-05', NULL, 'user341', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(368, 'I', 'root@localhost', '2020-04-05', NULL, 'user342', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(369, 'I', 'root@localhost', '2020-04-05', NULL, 'user343', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(370, 'I', 'root@localhost', '2020-04-05', NULL, 'user344', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(371, 'I', 'root@localhost', '2020-04-05', NULL, 'user345', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(372, 'I', 'root@localhost', '2020-04-05', NULL, 'user346', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(373, 'I', 'root@localhost', '2020-04-05', NULL, 'user347', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(374, 'I', 'root@localhost', '2020-04-05', NULL, 'user348', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(375, 'I', 'root@localhost', '2020-04-05', NULL, 'user349', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(376, 'I', 'root@localhost', '2020-04-05', NULL, 'user350', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(377, 'I', 'root@localhost', '2020-04-05', NULL, 'user351', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(378, 'I', 'root@localhost', '2020-04-05', NULL, 'user352', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(379, 'I', 'root@localhost', '2020-04-05', NULL, 'user353', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(380, 'I', 'root@localhost', '2020-04-05', NULL, 'user354', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(381, 'I', 'root@localhost', '2020-04-05', NULL, 'user355', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(382, 'I', 'root@localhost', '2020-04-05', NULL, 'user356', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(383, 'I', 'root@localhost', '2020-04-05', NULL, 'user357', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(384, 'I', 'root@localhost', '2020-04-05', NULL, 'user358', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(385, 'I', 'root@localhost', '2020-04-05', NULL, 'user359', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(386, 'I', 'root@localhost', '2020-04-05', NULL, 'user360', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(387, 'I', 'root@localhost', '2020-04-05', NULL, 'user361', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(388, 'I', 'root@localhost', '2020-04-05', NULL, 'user362', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(389, 'I', 'root@localhost', '2020-04-05', NULL, 'user363', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(390, 'I', 'root@localhost', '2020-04-05', NULL, 'user364', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(391, 'I', 'root@localhost', '2020-04-05', NULL, 'user365', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(392, 'I', 'root@localhost', '2020-04-05', NULL, 'user366', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(393, 'I', 'root@localhost', '2020-04-05', NULL, 'user367', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(394, 'I', 'root@localhost', '2020-04-05', NULL, 'user368', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(395, 'I', 'root@localhost', '2020-04-05', NULL, 'user369', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(396, 'I', 'root@localhost', '2020-04-05', NULL, 'user370', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(397, 'I', 'root@localhost', '2020-04-05', NULL, 'user371', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(398, 'I', 'root@localhost', '2020-04-05', NULL, 'user372', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(399, 'I', 'root@localhost', '2020-04-05', NULL, 'user373', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(400, 'I', 'root@localhost', '2020-04-05', NULL, 'user374', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(401, 'I', 'root@localhost', '2020-04-05', NULL, 'user375', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(402, 'I', 'root@localhost', '2020-04-05', NULL, 'user376', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(403, 'I', 'root@localhost', '2020-04-05', NULL, 'user377', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(404, 'I', 'root@localhost', '2020-04-05', NULL, 'user378', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(405, 'I', 'root@localhost', '2020-04-05', NULL, 'user379', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(406, 'I', 'root@localhost', '2020-04-05', NULL, 'user380', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(407, 'I', 'root@localhost', '2020-04-05', NULL, 'user381', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(408, 'I', 'root@localhost', '2020-04-05', NULL, 'user382', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(409, 'I', 'root@localhost', '2020-04-05', NULL, 'user383', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(410, 'I', 'root@localhost', '2020-04-05', NULL, 'user384', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(411, 'I', 'root@localhost', '2020-04-05', NULL, 'user385', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(412, 'I', 'root@localhost', '2020-04-05', NULL, 'user386', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(413, 'I', 'root@localhost', '2020-04-05', NULL, 'user387', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(414, 'I', 'root@localhost', '2020-04-05', NULL, 'user388', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(415, 'I', 'root@localhost', '2020-04-05', NULL, 'user389', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(416, 'I', 'root@localhost', '2020-04-05', NULL, 'user390', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(417, 'I', 'root@localhost', '2020-04-05', NULL, 'user391', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(418, 'I', 'root@localhost', '2020-04-05', NULL, 'user392', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(419, 'I', 'root@localhost', '2020-04-05', NULL, 'user393', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(420, 'I', 'root@localhost', '2020-04-05', NULL, 'user394', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(421, 'I', 'root@localhost', '2020-04-05', NULL, 'user395', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(422, 'I', 'root@localhost', '2020-04-05', NULL, 'user396', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(423, 'I', 'root@localhost', '2020-04-05', NULL, 'user397', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(424, 'I', 'root@localhost', '2020-04-05', NULL, 'user398', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(425, 'I', 'root@localhost', '2020-04-05', NULL, 'user399', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(426, 'I', 'root@localhost', '2020-04-05', NULL, 'user400', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(427, 'I', 'root@localhost', '2020-04-05', NULL, 'user401', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(428, 'I', 'root@localhost', '2020-04-05', NULL, 'user402', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(429, 'I', 'root@localhost', '2020-04-05', NULL, 'user403', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(430, 'I', 'root@localhost', '2020-04-05', NULL, 'user404', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(431, 'I', 'root@localhost', '2020-04-05', NULL, 'user405', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(432, 'I', 'root@localhost', '2020-04-05', NULL, 'user406', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(433, 'I', 'root@localhost', '2020-04-05', NULL, 'user407', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(434, 'I', 'root@localhost', '2020-04-05', NULL, 'user408', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(435, 'I', 'root@localhost', '2020-04-05', NULL, 'user409', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(436, 'I', 'root@localhost', '2020-04-05', NULL, 'user410', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(437, 'I', 'root@localhost', '2020-04-05', NULL, 'user411', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(438, 'I', 'root@localhost', '2020-04-05', NULL, 'user412', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(439, 'I', 'root@localhost', '2020-04-05', NULL, 'user413', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(440, 'I', 'root@localhost', '2020-04-05', NULL, 'user414', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(441, 'I', 'root@localhost', '2020-04-05', NULL, 'user415', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(442, 'I', 'root@localhost', '2020-04-05', NULL, 'user416', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(443, 'I', 'root@localhost', '2020-04-05', NULL, 'user417', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(444, 'I', 'root@localhost', '2020-04-05', NULL, 'user418', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(445, 'I', 'root@localhost', '2020-04-05', NULL, 'user419', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(446, 'I', 'root@localhost', '2020-04-05', NULL, 'user420', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(447, 'I', 'root@localhost', '2020-04-05', NULL, 'user421', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(448, 'I', 'root@localhost', '2020-04-05', NULL, 'user422', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(449, 'I', 'root@localhost', '2020-04-05', NULL, 'user423', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(450, 'I', 'root@localhost', '2020-04-05', NULL, 'user424', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(451, 'I', 'root@localhost', '2020-04-05', NULL, 'user425', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(452, 'I', 'root@localhost', '2020-04-05', NULL, 'user426', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(453, 'I', 'root@localhost', '2020-04-05', NULL, 'user427', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(454, 'I', 'root@localhost', '2020-04-05', NULL, 'user428', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(455, 'I', 'root@localhost', '2020-04-05', NULL, 'user429', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(456, 'I', 'root@localhost', '2020-04-05', NULL, 'user430', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(457, 'I', 'root@localhost', '2020-04-05', NULL, 'user431', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(458, 'I', 'root@localhost', '2020-04-05', NULL, 'user432', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(459, 'I', 'root@localhost', '2020-04-05', NULL, 'user433', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(460, 'I', 'root@localhost', '2020-04-05', NULL, 'user434', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(461, 'I', 'root@localhost', '2020-04-05', NULL, 'user435', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(462, 'I', 'root@localhost', '2020-04-05', NULL, 'user436', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(463, 'I', 'root@localhost', '2020-04-05', NULL, 'user437', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(464, 'I', 'root@localhost', '2020-04-05', NULL, 'user438', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(465, 'I', 'root@localhost', '2020-04-05', NULL, 'user439', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(466, 'I', 'root@localhost', '2020-04-05', NULL, 'user440', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(467, 'I', 'root@localhost', '2020-04-05', NULL, 'user441', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(468, 'I', 'root@localhost', '2020-04-05', NULL, 'user442', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(469, 'I', 'root@localhost', '2020-04-05', NULL, 'user443', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(470, 'I', 'root@localhost', '2020-04-05', NULL, 'user444', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(471, 'I', 'root@localhost', '2020-04-05', NULL, 'user445', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(472, 'I', 'root@localhost', '2020-04-05', NULL, 'user446', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(473, 'I', 'root@localhost', '2020-04-05', NULL, 'user447', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(474, 'I', 'root@localhost', '2020-04-05', NULL, 'user448', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(475, 'I', 'root@localhost', '2020-04-05', NULL, 'user449', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(476, 'I', 'root@localhost', '2020-04-05', NULL, 'user450', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(477, 'I', 'root@localhost', '2020-04-05', NULL, 'user451', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(478, 'I', 'root@localhost', '2020-04-05', NULL, 'user452', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(479, 'I', 'root@localhost', '2020-04-05', NULL, 'user453', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(480, 'I', 'root@localhost', '2020-04-05', NULL, 'user454', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(481, 'I', 'root@localhost', '2020-04-05', NULL, 'user455', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(482, 'I', 'root@localhost', '2020-04-05', NULL, 'user456', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(483, 'I', 'root@localhost', '2020-04-05', NULL, 'user457', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(484, 'I', 'root@localhost', '2020-04-05', NULL, 'user458', NULL, 'm@m', NULL, 'nome', NULL, 'apelido');
INSERT INTO `user_logs` (`ID`, `op`, `opUser`, `opData`, `usernameAntes`, `usernameDepois`, `emailAntes`, `emailDepois`, `nomeAntes`, `nomeDepois`, `apelidoAntes`, `apelidoDepois`) VALUES
(485, 'I', 'root@localhost', '2020-04-05', NULL, 'user459', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(486, 'I', 'root@localhost', '2020-04-05', NULL, 'user460', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(487, 'I', 'root@localhost', '2020-04-05', NULL, 'user461', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(488, 'I', 'root@localhost', '2020-04-05', NULL, 'user462', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(489, 'I', 'root@localhost', '2020-04-05', NULL, 'user463', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(490, 'I', 'root@localhost', '2020-04-05', NULL, 'user464', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(491, 'I', 'root@localhost', '2020-04-05', NULL, 'user465', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(492, 'I', 'root@localhost', '2020-04-05', NULL, 'user466', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(493, 'I', 'root@localhost', '2020-04-05', NULL, 'user467', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(494, 'I', 'root@localhost', '2020-04-05', NULL, 'user468', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(495, 'I', 'root@localhost', '2020-04-05', NULL, 'user469', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(496, 'I', 'root@localhost', '2020-04-05', NULL, 'user470', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(497, 'I', 'root@localhost', '2020-04-05', NULL, 'user471', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(498, 'I', 'root@localhost', '2020-04-05', NULL, 'user472', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(499, 'I', 'root@localhost', '2020-04-05', NULL, 'user473', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(500, 'I', 'root@localhost', '2020-04-05', NULL, 'user474', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(501, 'I', 'root@localhost', '2020-04-05', NULL, 'user475', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(502, 'I', 'root@localhost', '2020-04-05', NULL, 'user476', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(503, 'I', 'root@localhost', '2020-04-05', NULL, 'user477', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(504, 'I', 'root@localhost', '2020-04-05', NULL, 'user478', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(505, 'I', 'root@localhost', '2020-04-05', NULL, 'user479', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(506, 'I', 'root@localhost', '2020-04-05', NULL, 'user480', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(507, 'I', 'root@localhost', '2020-04-05', NULL, 'user481', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(508, 'I', 'root@localhost', '2020-04-05', NULL, 'user482', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(509, 'I', 'root@localhost', '2020-04-05', NULL, 'user483', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(510, 'I', 'root@localhost', '2020-04-05', NULL, 'user484', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(511, 'I', 'root@localhost', '2020-04-05', NULL, 'user485', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(512, 'I', 'root@localhost', '2020-04-05', NULL, 'user486', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(513, 'I', 'root@localhost', '2020-04-05', NULL, 'user487', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(514, 'I', 'root@localhost', '2020-04-05', NULL, 'user488', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(515, 'I', 'root@localhost', '2020-04-05', NULL, 'user489', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(516, 'I', 'root@localhost', '2020-04-05', NULL, 'user490', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(517, 'I', 'root@localhost', '2020-04-05', NULL, 'user491', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(518, 'I', 'root@localhost', '2020-04-05', NULL, 'user492', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(519, 'I', 'root@localhost', '2020-04-05', NULL, 'user493', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(520, 'I', 'root@localhost', '2020-04-05', NULL, 'user494', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(521, 'I', 'root@localhost', '2020-04-05', NULL, 'user495', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(522, 'I', 'root@localhost', '2020-04-05', NULL, 'user496', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(523, 'I', 'root@localhost', '2020-04-05', NULL, 'user497', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(524, 'I', 'root@localhost', '2020-04-05', NULL, 'user498', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(525, 'I', 'root@localhost', '2020-04-05', NULL, 'user499', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(526, 'I', 'root@localhost', '2020-04-05', NULL, 'user500', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(527, 'I', 'root@localhost', '2020-04-05', NULL, 'user501', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(528, 'I', 'root@localhost', '2020-04-05', NULL, 'user502', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(529, 'I', 'root@localhost', '2020-04-05', NULL, 'user503', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(530, 'I', 'root@localhost', '2020-04-05', NULL, 'user504', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(531, 'I', 'root@localhost', '2020-04-05', NULL, 'user505', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(532, 'I', 'root@localhost', '2020-04-05', NULL, 'user506', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(533, 'I', 'root@localhost', '2020-04-05', NULL, 'user507', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(534, 'I', 'root@localhost', '2020-04-05', NULL, 'user508', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(535, 'I', 'root@localhost', '2020-04-05', NULL, 'user509', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(536, 'I', 'root@localhost', '2020-04-05', NULL, 'user510', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(537, 'I', 'root@localhost', '2020-04-05', NULL, 'user511', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(538, 'I', 'root@localhost', '2020-04-05', NULL, 'user512', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(539, 'I', 'root@localhost', '2020-04-05', NULL, 'user513', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(540, 'I', 'root@localhost', '2020-04-05', NULL, 'user514', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(541, 'I', 'root@localhost', '2020-04-05', NULL, 'user515', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(542, 'I', 'root@localhost', '2020-04-05', NULL, 'user516', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(543, 'I', 'root@localhost', '2020-04-05', NULL, 'user517', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(544, 'I', 'root@localhost', '2020-04-05', NULL, 'user518', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(545, 'I', 'root@localhost', '2020-04-05', NULL, 'user519', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(546, 'I', 'root@localhost', '2020-04-05', NULL, 'user520', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(547, 'I', 'root@localhost', '2020-04-05', NULL, 'user521', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(548, 'I', 'root@localhost', '2020-04-05', NULL, 'user522', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(549, 'I', 'root@localhost', '2020-04-05', NULL, 'user523', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(550, 'I', 'root@localhost', '2020-04-05', NULL, 'user524', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(551, 'I', 'root@localhost', '2020-04-05', NULL, 'user525', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(552, 'I', 'root@localhost', '2020-04-05', NULL, 'user526', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(553, 'I', 'root@localhost', '2020-04-05', NULL, 'user527', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(554, 'I', 'root@localhost', '2020-04-05', NULL, 'user528', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(555, 'I', 'root@localhost', '2020-04-05', NULL, 'user529', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(556, 'I', 'root@localhost', '2020-04-05', NULL, 'user530', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(557, 'I', 'root@localhost', '2020-04-05', NULL, 'user531', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(558, 'I', 'root@localhost', '2020-04-05', NULL, 'user532', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(559, 'I', 'root@localhost', '2020-04-05', NULL, 'user533', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(560, 'I', 'root@localhost', '2020-04-05', NULL, 'user534', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(561, 'I', 'root@localhost', '2020-04-05', NULL, 'user535', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(562, 'I', 'root@localhost', '2020-04-05', NULL, 'user536', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(563, 'I', 'root@localhost', '2020-04-05', NULL, 'user537', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(564, 'I', 'root@localhost', '2020-04-05', NULL, 'user538', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(565, 'I', 'root@localhost', '2020-04-05', NULL, 'user539', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(566, 'I', 'root@localhost', '2020-04-05', NULL, 'user540', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(567, 'I', 'root@localhost', '2020-04-05', NULL, 'user541', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(568, 'I', 'root@localhost', '2020-04-05', NULL, 'user542', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(569, 'I', 'root@localhost', '2020-04-05', NULL, 'user543', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(570, 'I', 'root@localhost', '2020-04-05', NULL, 'user544', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(571, 'I', 'root@localhost', '2020-04-05', NULL, 'user545', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(572, 'I', 'root@localhost', '2020-04-05', NULL, 'user546', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(573, 'I', 'root@localhost', '2020-04-05', NULL, 'user547', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(574, 'I', 'root@localhost', '2020-04-05', NULL, 'user548', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(575, 'I', 'root@localhost', '2020-04-05', NULL, 'user549', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(576, 'I', 'root@localhost', '2020-04-05', NULL, 'user550', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(577, 'I', 'root@localhost', '2020-04-05', NULL, 'user551', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(578, 'I', 'root@localhost', '2020-04-05', NULL, 'user552', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(579, 'I', 'root@localhost', '2020-04-05', NULL, 'user553', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(580, 'I', 'root@localhost', '2020-04-05', NULL, 'user554', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(581, 'I', 'root@localhost', '2020-04-05', NULL, 'user555', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(582, 'I', 'root@localhost', '2020-04-05', NULL, 'user556', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(583, 'I', 'root@localhost', '2020-04-05', NULL, 'user557', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(584, 'I', 'root@localhost', '2020-04-05', NULL, 'user558', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(585, 'I', 'root@localhost', '2020-04-05', NULL, 'user559', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(586, 'I', 'root@localhost', '2020-04-05', NULL, 'user560', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(587, 'I', 'root@localhost', '2020-04-05', NULL, 'user561', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(588, 'I', 'root@localhost', '2020-04-05', NULL, 'user562', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(589, 'I', 'root@localhost', '2020-04-05', NULL, 'user563', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(590, 'I', 'root@localhost', '2020-04-05', NULL, 'user564', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(591, 'I', 'root@localhost', '2020-04-05', NULL, 'user565', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(592, 'I', 'root@localhost', '2020-04-05', NULL, 'user566', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(593, 'I', 'root@localhost', '2020-04-05', NULL, 'user567', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(594, 'I', 'root@localhost', '2020-04-05', NULL, 'user568', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(595, 'I', 'root@localhost', '2020-04-05', NULL, 'user569', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(596, 'I', 'root@localhost', '2020-04-05', NULL, 'user570', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(597, 'I', 'root@localhost', '2020-04-05', NULL, 'user571', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(598, 'I', 'root@localhost', '2020-04-05', NULL, 'user572', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(599, 'I', 'root@localhost', '2020-04-05', NULL, 'user573', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(600, 'I', 'root@localhost', '2020-04-05', NULL, 'user574', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(601, 'I', 'root@localhost', '2020-04-05', NULL, 'user575', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(602, 'I', 'root@localhost', '2020-04-05', NULL, 'user576', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(603, 'I', 'root@localhost', '2020-04-05', NULL, 'user577', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(604, 'I', 'root@localhost', '2020-04-05', NULL, 'user578', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(605, 'I', 'root@localhost', '2020-04-05', NULL, 'user579', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(606, 'I', 'root@localhost', '2020-04-05', NULL, 'user580', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(607, 'I', 'root@localhost', '2020-04-05', NULL, 'user581', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(608, 'I', 'root@localhost', '2020-04-05', NULL, 'user582', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(609, 'I', 'root@localhost', '2020-04-05', NULL, 'user583', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(610, 'I', 'root@localhost', '2020-04-05', NULL, 'user584', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(611, 'I', 'root@localhost', '2020-04-05', NULL, 'user585', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(612, 'I', 'root@localhost', '2020-04-05', NULL, 'user586', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(613, 'I', 'root@localhost', '2020-04-05', NULL, 'user587', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(614, 'I', 'root@localhost', '2020-04-05', NULL, 'user588', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(615, 'I', 'root@localhost', '2020-04-05', NULL, 'user589', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(616, 'I', 'root@localhost', '2020-04-05', NULL, 'user590', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(617, 'I', 'root@localhost', '2020-04-05', NULL, 'user591', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(618, 'I', 'root@localhost', '2020-04-05', NULL, 'user592', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(619, 'I', 'root@localhost', '2020-04-05', NULL, 'user593', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(620, 'I', 'root@localhost', '2020-04-05', NULL, 'user594', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(621, 'I', 'root@localhost', '2020-04-05', NULL, 'user595', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(622, 'I', 'root@localhost', '2020-04-05', NULL, 'user596', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(623, 'I', 'root@localhost', '2020-04-05', NULL, 'user597', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(624, 'I', 'root@localhost', '2020-04-05', NULL, 'user598', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(625, 'I', 'root@localhost', '2020-04-05', NULL, 'user599', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(626, 'I', 'root@localhost', '2020-04-05', NULL, 'user600', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(627, 'I', 'root@localhost', '2020-04-05', NULL, 'user601', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(628, 'I', 'root@localhost', '2020-04-05', NULL, 'user602', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(629, 'I', 'root@localhost', '2020-04-05', NULL, 'user603', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(630, 'I', 'root@localhost', '2020-04-05', NULL, 'user604', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(631, 'I', 'root@localhost', '2020-04-05', NULL, 'user605', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(632, 'I', 'root@localhost', '2020-04-05', NULL, 'user606', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(633, 'I', 'root@localhost', '2020-04-05', NULL, 'user607', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(634, 'I', 'root@localhost', '2020-04-05', NULL, 'user608', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(635, 'I', 'root@localhost', '2020-04-05', NULL, 'user609', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(636, 'I', 'root@localhost', '2020-04-05', NULL, 'user610', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(637, 'I', 'root@localhost', '2020-04-05', NULL, 'user611', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(638, 'I', 'root@localhost', '2020-04-05', NULL, 'user612', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(639, 'I', 'root@localhost', '2020-04-05', NULL, 'user613', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(640, 'I', 'root@localhost', '2020-04-05', NULL, 'user614', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(641, 'I', 'root@localhost', '2020-04-05', NULL, 'user615', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(642, 'I', 'root@localhost', '2020-04-05', NULL, 'user616', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(643, 'I', 'root@localhost', '2020-04-05', NULL, 'user617', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(644, 'I', 'root@localhost', '2020-04-05', NULL, 'user618', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(645, 'I', 'root@localhost', '2020-04-05', NULL, 'user619', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(646, 'I', 'root@localhost', '2020-04-05', NULL, 'user620', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(647, 'I', 'root@localhost', '2020-04-05', NULL, 'user621', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(648, 'I', 'root@localhost', '2020-04-05', NULL, 'user622', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(649, 'I', 'root@localhost', '2020-04-05', NULL, 'user623', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(650, 'I', 'root@localhost', '2020-04-05', NULL, 'user624', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(651, 'I', 'root@localhost', '2020-04-05', NULL, 'user625', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(652, 'I', 'root@localhost', '2020-04-05', NULL, 'user626', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(653, 'I', 'root@localhost', '2020-04-05', NULL, 'user627', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(654, 'I', 'root@localhost', '2020-04-05', NULL, 'user628', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(655, 'I', 'root@localhost', '2020-04-05', NULL, 'user629', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(656, 'I', 'root@localhost', '2020-04-05', NULL, 'user630', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(657, 'I', 'root@localhost', '2020-04-05', NULL, 'user631', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(658, 'I', 'root@localhost', '2020-04-05', NULL, 'user632', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(659, 'I', 'root@localhost', '2020-04-05', NULL, 'user633', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(660, 'I', 'root@localhost', '2020-04-05', NULL, 'user634', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(661, 'I', 'root@localhost', '2020-04-05', NULL, 'user635', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(662, 'I', 'root@localhost', '2020-04-05', NULL, 'user636', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(663, 'I', 'root@localhost', '2020-04-05', NULL, 'user637', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(664, 'I', 'root@localhost', '2020-04-05', NULL, 'user638', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(665, 'I', 'root@localhost', '2020-04-05', NULL, 'user639', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(666, 'I', 'root@localhost', '2020-04-05', NULL, 'user640', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(667, 'I', 'root@localhost', '2020-04-05', NULL, 'user641', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(668, 'I', 'root@localhost', '2020-04-05', NULL, 'user642', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(669, 'I', 'root@localhost', '2020-04-05', NULL, 'user643', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(670, 'I', 'root@localhost', '2020-04-05', NULL, 'user644', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(671, 'I', 'root@localhost', '2020-04-05', NULL, 'user645', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(672, 'I', 'root@localhost', '2020-04-05', NULL, 'user646', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(673, 'I', 'root@localhost', '2020-04-05', NULL, 'user647', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(674, 'I', 'root@localhost', '2020-04-05', NULL, 'user648', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(675, 'I', 'root@localhost', '2020-04-05', NULL, 'user649', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(676, 'I', 'root@localhost', '2020-04-05', NULL, 'user650', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(677, 'I', 'root@localhost', '2020-04-05', NULL, 'user651', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(678, 'I', 'root@localhost', '2020-04-05', NULL, 'user652', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(679, 'I', 'root@localhost', '2020-04-05', NULL, 'user653', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(680, 'I', 'root@localhost', '2020-04-05', NULL, 'user654', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(681, 'I', 'root@localhost', '2020-04-05', NULL, 'user655', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(682, 'I', 'root@localhost', '2020-04-05', NULL, 'user656', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(683, 'I', 'root@localhost', '2020-04-05', NULL, 'user657', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(684, 'I', 'root@localhost', '2020-04-05', NULL, 'user658', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(685, 'I', 'root@localhost', '2020-04-05', NULL, 'user659', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(686, 'I', 'root@localhost', '2020-04-05', NULL, 'user660', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(687, 'I', 'root@localhost', '2020-04-05', NULL, 'user661', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(688, 'I', 'root@localhost', '2020-04-05', NULL, 'user662', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(689, 'I', 'root@localhost', '2020-04-05', NULL, 'user663', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(690, 'I', 'root@localhost', '2020-04-05', NULL, 'user664', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(691, 'I', 'root@localhost', '2020-04-05', NULL, 'user665', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(692, 'I', 'root@localhost', '2020-04-05', NULL, 'user666', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(693, 'I', 'root@localhost', '2020-04-05', NULL, 'user667', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(694, 'I', 'root@localhost', '2020-04-05', NULL, 'user668', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(695, 'I', 'root@localhost', '2020-04-05', NULL, 'user669', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(696, 'I', 'root@localhost', '2020-04-05', NULL, 'user670', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(697, 'I', 'root@localhost', '2020-04-05', NULL, 'user671', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(698, 'I', 'root@localhost', '2020-04-05', NULL, 'user672', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(699, 'I', 'root@localhost', '2020-04-05', NULL, 'user673', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(700, 'I', 'root@localhost', '2020-04-05', NULL, 'user674', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(701, 'I', 'root@localhost', '2020-04-05', NULL, 'user675', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(702, 'I', 'root@localhost', '2020-04-05', NULL, 'user676', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(703, 'I', 'root@localhost', '2020-04-05', NULL, 'user677', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(704, 'I', 'root@localhost', '2020-04-05', NULL, 'user678', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(705, 'I', 'root@localhost', '2020-04-05', NULL, 'user679', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(706, 'I', 'root@localhost', '2020-04-05', NULL, 'user680', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(707, 'I', 'root@localhost', '2020-04-05', NULL, 'user681', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(708, 'I', 'root@localhost', '2020-04-05', NULL, 'user682', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(709, 'I', 'root@localhost', '2020-04-05', NULL, 'user683', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(710, 'I', 'root@localhost', '2020-04-05', NULL, 'user684', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(711, 'I', 'root@localhost', '2020-04-05', NULL, 'user685', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(712, 'I', 'root@localhost', '2020-04-05', NULL, 'user686', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(713, 'I', 'root@localhost', '2020-04-05', NULL, 'user687', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(714, 'I', 'root@localhost', '2020-04-05', NULL, 'user688', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(715, 'I', 'root@localhost', '2020-04-05', NULL, 'user689', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(716, 'I', 'root@localhost', '2020-04-05', NULL, 'user690', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(717, 'I', 'root@localhost', '2020-04-05', NULL, 'user691', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(718, 'I', 'root@localhost', '2020-04-05', NULL, 'user692', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(719, 'I', 'root@localhost', '2020-04-05', NULL, 'user693', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(720, 'I', 'root@localhost', '2020-04-05', NULL, 'user694', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(721, 'I', 'root@localhost', '2020-04-05', NULL, 'user695', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(722, 'I', 'root@localhost', '2020-04-05', NULL, 'user696', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(723, 'I', 'root@localhost', '2020-04-05', NULL, 'user697', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(724, 'I', 'root@localhost', '2020-04-05', NULL, 'user698', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(725, 'I', 'root@localhost', '2020-04-05', NULL, 'user699', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(726, 'I', 'root@localhost', '2020-04-05', NULL, 'user700', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(727, 'I', 'root@localhost', '2020-04-05', NULL, 'user701', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(728, 'I', 'root@localhost', '2020-04-05', NULL, 'user702', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(729, 'I', 'root@localhost', '2020-04-05', NULL, 'user703', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(730, 'I', 'root@localhost', '2020-04-05', NULL, 'user704', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(731, 'I', 'root@localhost', '2020-04-05', NULL, 'user705', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(732, 'I', 'root@localhost', '2020-04-05', NULL, 'user706', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(733, 'I', 'root@localhost', '2020-04-05', NULL, 'user707', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(734, 'I', 'root@localhost', '2020-04-05', NULL, 'user708', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(735, 'I', 'root@localhost', '2020-04-05', NULL, 'user709', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(736, 'I', 'root@localhost', '2020-04-05', NULL, 'user710', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(737, 'I', 'root@localhost', '2020-04-05', NULL, 'user711', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(738, 'I', 'root@localhost', '2020-04-05', NULL, 'user712', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(739, 'I', 'root@localhost', '2020-04-05', NULL, 'user713', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(740, 'I', 'root@localhost', '2020-04-05', NULL, 'user714', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(741, 'I', 'root@localhost', '2020-04-05', NULL, 'user715', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(742, 'I', 'root@localhost', '2020-04-05', NULL, 'user716', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(743, 'I', 'root@localhost', '2020-04-05', NULL, 'user717', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(744, 'I', 'root@localhost', '2020-04-05', NULL, 'user718', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(745, 'I', 'root@localhost', '2020-04-05', NULL, 'user719', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(746, 'I', 'root@localhost', '2020-04-05', NULL, 'user720', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(747, 'I', 'root@localhost', '2020-04-05', NULL, 'user721', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(748, 'I', 'root@localhost', '2020-04-05', NULL, 'user722', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(749, 'I', 'root@localhost', '2020-04-05', NULL, 'user723', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(750, 'I', 'root@localhost', '2020-04-05', NULL, 'user724', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(751, 'I', 'root@localhost', '2020-04-05', NULL, 'user725', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(752, 'I', 'root@localhost', '2020-04-05', NULL, 'user726', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(753, 'I', 'root@localhost', '2020-04-05', NULL, 'user727', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(754, 'I', 'root@localhost', '2020-04-05', NULL, 'user728', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(755, 'I', 'root@localhost', '2020-04-05', NULL, 'user729', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(756, 'I', 'root@localhost', '2020-04-05', NULL, 'user730', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(757, 'I', 'root@localhost', '2020-04-05', NULL, 'user731', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(758, 'I', 'root@localhost', '2020-04-05', NULL, 'user732', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(759, 'I', 'root@localhost', '2020-04-05', NULL, 'user733', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(760, 'I', 'root@localhost', '2020-04-05', NULL, 'user734', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(761, 'I', 'root@localhost', '2020-04-05', NULL, 'user735', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(762, 'I', 'root@localhost', '2020-04-05', NULL, 'user736', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(763, 'I', 'root@localhost', '2020-04-05', NULL, 'user737', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(764, 'I', 'root@localhost', '2020-04-05', NULL, 'user738', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(765, 'I', 'root@localhost', '2020-04-05', NULL, 'user739', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(766, 'I', 'root@localhost', '2020-04-05', NULL, 'user740', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(767, 'I', 'root@localhost', '2020-04-05', NULL, 'user741', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(768, 'I', 'root@localhost', '2020-04-05', NULL, 'user742', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(769, 'I', 'root@localhost', '2020-04-05', NULL, 'user743', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(770, 'I', 'root@localhost', '2020-04-05', NULL, 'user744', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(771, 'I', 'root@localhost', '2020-04-05', NULL, 'user745', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(772, 'I', 'root@localhost', '2020-04-05', NULL, 'user746', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(773, 'I', 'root@localhost', '2020-04-05', NULL, 'user747', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(774, 'I', 'root@localhost', '2020-04-05', NULL, 'user748', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(775, 'I', 'root@localhost', '2020-04-05', NULL, 'user749', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(776, 'I', 'root@localhost', '2020-04-05', NULL, 'user750', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(777, 'I', 'root@localhost', '2020-04-05', NULL, 'user751', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(778, 'I', 'root@localhost', '2020-04-05', NULL, 'user752', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(779, 'I', 'root@localhost', '2020-04-05', NULL, 'user753', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(780, 'I', 'root@localhost', '2020-04-05', NULL, 'user754', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(781, 'I', 'root@localhost', '2020-04-05', NULL, 'user755', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(782, 'I', 'root@localhost', '2020-04-05', NULL, 'user756', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(783, 'I', 'root@localhost', '2020-04-05', NULL, 'user757', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(784, 'I', 'root@localhost', '2020-04-05', NULL, 'user758', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(785, 'I', 'root@localhost', '2020-04-05', NULL, 'user759', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(786, 'I', 'root@localhost', '2020-04-05', NULL, 'user760', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(787, 'I', 'root@localhost', '2020-04-05', NULL, 'user761', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(788, 'I', 'root@localhost', '2020-04-05', NULL, 'user762', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(789, 'I', 'root@localhost', '2020-04-05', NULL, 'user763', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(790, 'I', 'root@localhost', '2020-04-05', NULL, 'user764', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(791, 'I', 'root@localhost', '2020-04-05', NULL, 'user765', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(792, 'I', 'root@localhost', '2020-04-05', NULL, 'user766', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(793, 'I', 'root@localhost', '2020-04-05', NULL, 'user767', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(794, 'I', 'root@localhost', '2020-04-05', NULL, 'user768', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(795, 'I', 'root@localhost', '2020-04-05', NULL, 'user769', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(796, 'I', 'root@localhost', '2020-04-05', NULL, 'user770', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(797, 'I', 'root@localhost', '2020-04-05', NULL, 'user771', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(798, 'I', 'root@localhost', '2020-04-05', NULL, 'user772', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(799, 'I', 'root@localhost', '2020-04-05', NULL, 'user773', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(800, 'I', 'root@localhost', '2020-04-05', NULL, 'user774', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(801, 'I', 'root@localhost', '2020-04-05', NULL, 'user775', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(802, 'I', 'root@localhost', '2020-04-05', NULL, 'user776', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(803, 'I', 'root@localhost', '2020-04-05', NULL, 'user777', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(804, 'I', 'root@localhost', '2020-04-05', NULL, 'user778', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(805, 'I', 'root@localhost', '2020-04-05', NULL, 'user779', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(806, 'I', 'root@localhost', '2020-04-05', NULL, 'user780', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(807, 'I', 'root@localhost', '2020-04-05', NULL, 'user781', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(808, 'I', 'root@localhost', '2020-04-05', NULL, 'user782', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(809, 'I', 'root@localhost', '2020-04-05', NULL, 'user783', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(810, 'I', 'root@localhost', '2020-04-05', NULL, 'user784', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(811, 'I', 'root@localhost', '2020-04-05', NULL, 'user785', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(812, 'I', 'root@localhost', '2020-04-05', NULL, 'user786', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(813, 'I', 'root@localhost', '2020-04-05', NULL, 'user787', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(814, 'I', 'root@localhost', '2020-04-05', NULL, 'user788', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(815, 'I', 'root@localhost', '2020-04-05', NULL, 'user789', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(816, 'I', 'root@localhost', '2020-04-05', NULL, 'user790', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(817, 'I', 'root@localhost', '2020-04-05', NULL, 'user791', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(818, 'I', 'root@localhost', '2020-04-05', NULL, 'user792', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(819, 'I', 'root@localhost', '2020-04-05', NULL, 'user793', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(820, 'I', 'root@localhost', '2020-04-05', NULL, 'user794', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(821, 'I', 'root@localhost', '2020-04-05', NULL, 'user795', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(822, 'I', 'root@localhost', '2020-04-05', NULL, 'user796', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(823, 'I', 'root@localhost', '2020-04-05', NULL, 'user797', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(824, 'I', 'root@localhost', '2020-04-05', NULL, 'user798', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(825, 'I', 'root@localhost', '2020-04-05', NULL, 'user799', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(826, 'I', 'root@localhost', '2020-04-05', NULL, 'user800', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(827, 'I', 'root@localhost', '2020-04-05', NULL, 'user801', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(828, 'I', 'root@localhost', '2020-04-05', NULL, 'user802', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(829, 'I', 'root@localhost', '2020-04-05', NULL, 'user803', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(830, 'I', 'root@localhost', '2020-04-05', NULL, 'user804', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(831, 'I', 'root@localhost', '2020-04-05', NULL, 'user805', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(832, 'I', 'root@localhost', '2020-04-05', NULL, 'user806', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(833, 'I', 'root@localhost', '2020-04-05', NULL, 'user807', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(834, 'I', 'root@localhost', '2020-04-05', NULL, 'user808', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(835, 'I', 'root@localhost', '2020-04-05', NULL, 'user809', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(836, 'I', 'root@localhost', '2020-04-05', NULL, 'user810', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(837, 'I', 'root@localhost', '2020-04-05', NULL, 'user811', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(838, 'I', 'root@localhost', '2020-04-05', NULL, 'user812', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(839, 'I', 'root@localhost', '2020-04-05', NULL, 'user813', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(840, 'I', 'root@localhost', '2020-04-05', NULL, 'user814', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(841, 'I', 'root@localhost', '2020-04-05', NULL, 'user815', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(842, 'I', 'root@localhost', '2020-04-05', NULL, 'user816', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(843, 'I', 'root@localhost', '2020-04-05', NULL, 'user817', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(844, 'I', 'root@localhost', '2020-04-05', NULL, 'user818', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(845, 'I', 'root@localhost', '2020-04-05', NULL, 'user819', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(846, 'I', 'root@localhost', '2020-04-05', NULL, 'user820', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(847, 'I', 'root@localhost', '2020-04-05', NULL, 'user821', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(848, 'I', 'root@localhost', '2020-04-05', NULL, 'user822', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(849, 'I', 'root@localhost', '2020-04-05', NULL, 'user823', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(850, 'I', 'root@localhost', '2020-04-05', NULL, 'user824', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(851, 'I', 'root@localhost', '2020-04-05', NULL, 'user825', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(852, 'I', 'root@localhost', '2020-04-05', NULL, 'user826', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(853, 'I', 'root@localhost', '2020-04-05', NULL, 'user827', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(854, 'I', 'root@localhost', '2020-04-05', NULL, 'user828', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(855, 'I', 'root@localhost', '2020-04-05', NULL, 'user829', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(856, 'I', 'root@localhost', '2020-04-05', NULL, 'user830', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(857, 'I', 'root@localhost', '2020-04-05', NULL, 'user831', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(858, 'I', 'root@localhost', '2020-04-05', NULL, 'user832', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(859, 'I', 'root@localhost', '2020-04-05', NULL, 'user833', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(860, 'I', 'root@localhost', '2020-04-05', NULL, 'user834', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(861, 'I', 'root@localhost', '2020-04-05', NULL, 'user835', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(862, 'I', 'root@localhost', '2020-04-05', NULL, 'user836', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(863, 'I', 'root@localhost', '2020-04-05', NULL, 'user837', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(864, 'I', 'root@localhost', '2020-04-05', NULL, 'user838', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(865, 'I', 'root@localhost', '2020-04-05', NULL, 'user839', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(866, 'I', 'root@localhost', '2020-04-05', NULL, 'user840', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(867, 'I', 'root@localhost', '2020-04-05', NULL, 'user841', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(868, 'I', 'root@localhost', '2020-04-05', NULL, 'user842', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(869, 'I', 'root@localhost', '2020-04-05', NULL, 'user843', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(870, 'I', 'root@localhost', '2020-04-05', NULL, 'user844', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(871, 'I', 'root@localhost', '2020-04-05', NULL, 'user845', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(872, 'I', 'root@localhost', '2020-04-05', NULL, 'user846', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(873, 'I', 'root@localhost', '2020-04-05', NULL, 'user847', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(874, 'I', 'root@localhost', '2020-04-05', NULL, 'user848', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(875, 'I', 'root@localhost', '2020-04-05', NULL, 'user849', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(876, 'I', 'root@localhost', '2020-04-05', NULL, 'user850', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(877, 'I', 'root@localhost', '2020-04-05', NULL, 'user851', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(878, 'I', 'root@localhost', '2020-04-05', NULL, 'user852', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(879, 'I', 'root@localhost', '2020-04-05', NULL, 'user853', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(880, 'I', 'root@localhost', '2020-04-05', NULL, 'user854', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(881, 'I', 'root@localhost', '2020-04-05', NULL, 'user855', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(882, 'I', 'root@localhost', '2020-04-05', NULL, 'user856', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(883, 'I', 'root@localhost', '2020-04-05', NULL, 'user857', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(884, 'I', 'root@localhost', '2020-04-05', NULL, 'user858', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(885, 'I', 'root@localhost', '2020-04-05', NULL, 'user859', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(886, 'I', 'root@localhost', '2020-04-05', NULL, 'user860', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(887, 'I', 'root@localhost', '2020-04-05', NULL, 'user861', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(888, 'I', 'root@localhost', '2020-04-05', NULL, 'user862', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(889, 'I', 'root@localhost', '2020-04-05', NULL, 'user863', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(890, 'I', 'root@localhost', '2020-04-05', NULL, 'user864', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(891, 'I', 'root@localhost', '2020-04-05', NULL, 'user865', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(892, 'I', 'root@localhost', '2020-04-05', NULL, 'user866', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(893, 'I', 'root@localhost', '2020-04-05', NULL, 'user867', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(894, 'I', 'root@localhost', '2020-04-05', NULL, 'user868', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(895, 'I', 'root@localhost', '2020-04-05', NULL, 'user869', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(896, 'I', 'root@localhost', '2020-04-05', NULL, 'user870', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(897, 'I', 'root@localhost', '2020-04-05', NULL, 'user871', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(898, 'I', 'root@localhost', '2020-04-05', NULL, 'user872', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(899, 'I', 'root@localhost', '2020-04-05', NULL, 'user873', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(900, 'I', 'root@localhost', '2020-04-05', NULL, 'user874', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(901, 'I', 'root@localhost', '2020-04-05', NULL, 'user875', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(902, 'I', 'root@localhost', '2020-04-05', NULL, 'user876', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(903, 'I', 'root@localhost', '2020-04-05', NULL, 'user877', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(904, 'I', 'root@localhost', '2020-04-05', NULL, 'user878', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(905, 'I', 'root@localhost', '2020-04-05', NULL, 'user879', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(906, 'I', 'root@localhost', '2020-04-05', NULL, 'user880', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(907, 'I', 'root@localhost', '2020-04-05', NULL, 'user881', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(908, 'I', 'root@localhost', '2020-04-05', NULL, 'user882', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(909, 'I', 'root@localhost', '2020-04-05', NULL, 'user883', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(910, 'I', 'root@localhost', '2020-04-05', NULL, 'user884', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(911, 'I', 'root@localhost', '2020-04-05', NULL, 'user885', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(912, 'I', 'root@localhost', '2020-04-05', NULL, 'user886', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(913, 'I', 'root@localhost', '2020-04-05', NULL, 'user887', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(914, 'I', 'root@localhost', '2020-04-05', NULL, 'user888', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(915, 'I', 'root@localhost', '2020-04-05', NULL, 'user889', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(916, 'I', 'root@localhost', '2020-04-05', NULL, 'user890', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(917, 'I', 'root@localhost', '2020-04-05', NULL, 'user891', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(918, 'I', 'root@localhost', '2020-04-05', NULL, 'user892', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(919, 'I', 'root@localhost', '2020-04-05', NULL, 'user893', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(920, 'I', 'root@localhost', '2020-04-05', NULL, 'user894', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(921, 'I', 'root@localhost', '2020-04-05', NULL, 'user895', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(922, 'I', 'root@localhost', '2020-04-05', NULL, 'user896', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(923, 'I', 'root@localhost', '2020-04-05', NULL, 'user897', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(924, 'I', 'root@localhost', '2020-04-05', NULL, 'user898', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(925, 'I', 'root@localhost', '2020-04-05', NULL, 'user899', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(926, 'I', 'root@localhost', '2020-04-05', NULL, 'user900', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(927, 'I', 'root@localhost', '2020-04-05', NULL, 'user901', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(928, 'I', 'root@localhost', '2020-04-05', NULL, 'user902', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(929, 'I', 'root@localhost', '2020-04-05', NULL, 'user903', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(930, 'I', 'root@localhost', '2020-04-05', NULL, 'user904', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(931, 'I', 'root@localhost', '2020-04-05', NULL, 'user905', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(932, 'I', 'root@localhost', '2020-04-05', NULL, 'user906', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(933, 'I', 'root@localhost', '2020-04-05', NULL, 'user907', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(934, 'I', 'root@localhost', '2020-04-05', NULL, 'user908', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(935, 'I', 'root@localhost', '2020-04-05', NULL, 'user909', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(936, 'I', 'root@localhost', '2020-04-05', NULL, 'user910', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(937, 'I', 'root@localhost', '2020-04-05', NULL, 'user911', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(938, 'I', 'root@localhost', '2020-04-05', NULL, 'user912', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(939, 'I', 'root@localhost', '2020-04-05', NULL, 'user913', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(940, 'I', 'root@localhost', '2020-04-05', NULL, 'user914', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(941, 'I', 'root@localhost', '2020-04-05', NULL, 'user915', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(942, 'I', 'root@localhost', '2020-04-05', NULL, 'user916', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(943, 'I', 'root@localhost', '2020-04-05', NULL, 'user917', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(944, 'I', 'root@localhost', '2020-04-05', NULL, 'user918', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(945, 'I', 'root@localhost', '2020-04-05', NULL, 'user919', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(946, 'I', 'root@localhost', '2020-04-05', NULL, 'user920', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(947, 'I', 'root@localhost', '2020-04-05', NULL, 'user921', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(948, 'I', 'root@localhost', '2020-04-05', NULL, 'user922', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(949, 'I', 'root@localhost', '2020-04-05', NULL, 'user923', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(950, 'I', 'root@localhost', '2020-04-05', NULL, 'user924', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(951, 'I', 'root@localhost', '2020-04-05', NULL, 'user925', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(952, 'I', 'root@localhost', '2020-04-05', NULL, 'user926', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(953, 'I', 'root@localhost', '2020-04-05', NULL, 'user927', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(954, 'I', 'root@localhost', '2020-04-05', NULL, 'user928', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(955, 'I', 'root@localhost', '2020-04-05', NULL, 'user929', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(956, 'I', 'root@localhost', '2020-04-05', NULL, 'user930', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(957, 'I', 'root@localhost', '2020-04-05', NULL, 'user931', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(958, 'I', 'root@localhost', '2020-04-05', NULL, 'user932', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(959, 'I', 'root@localhost', '2020-04-05', NULL, 'user933', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(960, 'I', 'root@localhost', '2020-04-05', NULL, 'user934', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(961, 'I', 'root@localhost', '2020-04-05', NULL, 'user935', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(962, 'I', 'root@localhost', '2020-04-05', NULL, 'user936', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(963, 'I', 'root@localhost', '2020-04-05', NULL, 'user937', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(964, 'I', 'root@localhost', '2020-04-05', NULL, 'user938', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(965, 'I', 'root@localhost', '2020-04-05', NULL, 'user939', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(966, 'I', 'root@localhost', '2020-04-05', NULL, 'user940', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(967, 'I', 'root@localhost', '2020-04-05', NULL, 'user941', NULL, 'm@m', NULL, 'nome', NULL, 'apelido');
INSERT INTO `user_logs` (`ID`, `op`, `opUser`, `opData`, `usernameAntes`, `usernameDepois`, `emailAntes`, `emailDepois`, `nomeAntes`, `nomeDepois`, `apelidoAntes`, `apelidoDepois`) VALUES
(968, 'I', 'root@localhost', '2020-04-05', NULL, 'user942', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(969, 'I', 'root@localhost', '2020-04-05', NULL, 'user943', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(970, 'I', 'root@localhost', '2020-04-05', NULL, 'user944', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(971, 'I', 'root@localhost', '2020-04-05', NULL, 'user945', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(972, 'I', 'root@localhost', '2020-04-05', NULL, 'user946', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(973, 'I', 'root@localhost', '2020-04-05', NULL, 'user947', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(974, 'I', 'root@localhost', '2020-04-05', NULL, 'user948', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(975, 'I', 'root@localhost', '2020-04-05', NULL, 'user949', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(976, 'I', 'root@localhost', '2020-04-05', NULL, 'user950', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(977, 'I', 'root@localhost', '2020-04-05', NULL, 'user951', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(978, 'I', 'root@localhost', '2020-04-05', NULL, 'user952', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(979, 'I', 'root@localhost', '2020-04-05', NULL, 'user953', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(980, 'I', 'root@localhost', '2020-04-05', NULL, 'user954', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(981, 'I', 'root@localhost', '2020-04-05', NULL, 'user955', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(982, 'I', 'root@localhost', '2020-04-05', NULL, 'user956', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(983, 'I', 'root@localhost', '2020-04-05', NULL, 'user957', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(984, 'I', 'root@localhost', '2020-04-05', NULL, 'user958', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(985, 'I', 'root@localhost', '2020-04-05', NULL, 'user959', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(986, 'I', 'root@localhost', '2020-04-05', NULL, 'user960', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(987, 'I', 'root@localhost', '2020-04-05', NULL, 'user961', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(988, 'I', 'root@localhost', '2020-04-05', NULL, 'user962', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(989, 'I', 'root@localhost', '2020-04-05', NULL, 'user963', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(990, 'I', 'root@localhost', '2020-04-05', NULL, 'user964', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(991, 'I', 'root@localhost', '2020-04-05', NULL, 'user965', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(992, 'I', 'root@localhost', '2020-04-05', NULL, 'user966', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(993, 'I', 'root@localhost', '2020-04-05', NULL, 'user967', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(994, 'I', 'root@localhost', '2020-04-05', NULL, 'user968', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(995, 'I', 'root@localhost', '2020-04-05', NULL, 'user969', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(996, 'I', 'root@localhost', '2020-04-05', NULL, 'user970', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(997, 'I', 'root@localhost', '2020-04-05', NULL, 'user971', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(998, 'I', 'root@localhost', '2020-04-05', NULL, 'user972', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(999, 'I', 'root@localhost', '2020-04-05', NULL, 'user973', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1000, 'I', 'root@localhost', '2020-04-05', NULL, 'user974', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1001, 'I', 'root@localhost', '2020-04-05', NULL, 'user975', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1002, 'I', 'root@localhost', '2020-04-05', NULL, 'user976', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1003, 'I', 'root@localhost', '2020-04-05', NULL, 'user977', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1004, 'I', 'root@localhost', '2020-04-05', NULL, 'user978', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1005, 'I', 'root@localhost', '2020-04-05', NULL, 'user979', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1006, 'I', 'root@localhost', '2020-04-05', NULL, 'user980', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1007, 'I', 'root@localhost', '2020-04-05', NULL, 'user981', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1008, 'I', 'root@localhost', '2020-04-05', NULL, 'user982', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1009, 'I', 'root@localhost', '2020-04-05', NULL, 'user983', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1010, 'I', 'root@localhost', '2020-04-05', NULL, 'user984', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1011, 'I', 'root@localhost', '2020-04-05', NULL, 'user985', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1012, 'I', 'root@localhost', '2020-04-05', NULL, 'user986', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1013, 'I', 'root@localhost', '2020-04-05', NULL, 'user987', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1014, 'I', 'root@localhost', '2020-04-05', NULL, 'user988', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1015, 'I', 'root@localhost', '2020-04-05', NULL, 'user989', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1016, 'I', 'root@localhost', '2020-04-05', NULL, 'user990', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1017, 'I', 'root@localhost', '2020-04-05', NULL, 'user991', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1018, 'I', 'root@localhost', '2020-04-05', NULL, 'user992', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1019, 'I', 'root@localhost', '2020-04-05', NULL, 'user993', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1020, 'I', 'root@localhost', '2020-04-05', NULL, 'user994', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1021, 'I', 'root@localhost', '2020-04-05', NULL, 'user995', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1022, 'I', 'root@localhost', '2020-04-05', NULL, 'user996', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1023, 'I', 'root@localhost', '2020-04-05', NULL, 'user997', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1024, 'I', 'root@localhost', '2020-04-05', NULL, 'user998', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1025, 'I', 'root@localhost', '2020-04-05', NULL, 'user999', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1026, 'I', 'root@localhost', '2020-04-05', NULL, 'user1000', NULL, 'm@m', NULL, 'nome', NULL, 'apelido'),
(1027, 'I', 'root@localhost', '2020-04-05', NULL, 'user1001', NULL, 'm@m', NULL, 'nome', NULL, 'apelido');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `grupo`
--
ALTER TABLE `grupo`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `medicoes`
--
ALTER TABLE `medicoes`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `sensorID` (`sensorID`);

--
-- Indexes for table `medicoes_logs`
--
ALTER TABLE `medicoes_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `ronda`
--
ALTER TABLE `ronda`
  ADD PRIMARY KEY (`dia`,`inicio`),
  ADD KEY `inicio` (`inicio`);

--
-- Indexes for table `rondaextra`
--
ALTER TABLE `rondaextra`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `rondaextra_ibfk_1` (`userID`);

--
-- Indexes for table `rondaextra_logs`
--
ALTER TABLE `rondaextra_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `rondaplaneada`
--
ALTER TABLE `rondaplaneada`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `dia` (`dia`),
  ADD KEY `inicio` (`inicio`);

--
-- Indexes for table `rondaplaneada_logs`
--
ALTER TABLE `rondaplaneada_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `ronda_logs`
--
ALTER TABLE `ronda_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `sensores`
--
ALTER TABLE `sensores`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `sensores_logs`
--
ALTER TABLE `sensores_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `grupoID` (`grupoID`);

--
-- Indexes for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `grupo`
--
ALTER TABLE `grupo`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `medicoes`
--
ALTER TABLE `medicoes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes_logs`
--
ALTER TABLE `medicoes_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rondaextra`
--
ALTER TABLE `rondaextra`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `rondaextra_logs`
--
ALTER TABLE `rondaextra_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `rondaplaneada_logs`
--
ALTER TABLE `rondaplaneada_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ronda_logs`
--
ALTER TABLE `ronda_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sensores`
--
ALTER TABLE `sensores`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sensores_logs`
--
ALTER TABLE `sensores_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1013;

--
-- AUTO_INCREMENT for table `user_logs`
--
ALTER TABLE `user_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1028;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `medicoes`
--
ALTER TABLE `medicoes`
  ADD CONSTRAINT `medicoes_ibfk_1` FOREIGN KEY (`sensorID`) REFERENCES `sensores` (`ID`) ON UPDATE CASCADE;

--
-- Constraints for table `rondaextra`
--
ALTER TABLE `rondaextra`
  ADD CONSTRAINT `rondaextra_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON UPDATE CASCADE;

--
-- Constraints for table `rondaplaneada`
--
ALTER TABLE `rondaplaneada`
  ADD CONSTRAINT `rondaplaneada_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `user` (`ID`),
  ADD CONSTRAINT `rondaplaneada_ibfk_2` FOREIGN KEY (`dia`) REFERENCES `ronda` (`dia`),
  ADD CONSTRAINT `rondaplaneada_ibfk_3` FOREIGN KEY (`inicio`) REFERENCES `ronda` (`inicio`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`grupoID`) REFERENCES `grupo` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
