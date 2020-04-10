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
-- Database: `php_destino`
--

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
-- Indexes for dumped tables
--

--
-- Indexes for table `medicoes_logs`
--
ALTER TABLE `medicoes_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `rondaextra_logs`
--
ALTER TABLE `rondaextra_logs`
  ADD PRIMARY KEY (`ID`);

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
-- Indexes for table `sensores_logs`
--
ALTER TABLE `sensores_logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `medicoes_logs`
--
ALTER TABLE `medicoes_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rondaextra_logs`
--
ALTER TABLE `rondaextra_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

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
-- AUTO_INCREMENT for table `sensores_logs`
--
ALTER TABLE `sensores_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_logs`
--
ALTER TABLE `user_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
