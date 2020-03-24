-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 24. Mrz 2020 um 18:28
-- Server-Version: 10.4.11-MariaDB
-- PHP-Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `tunierauswertung`
--
CREATE DATABASE IF NOT EXISTS `tunierauswertung` DEFAULT CHARACTER SET latin1 COLLATE latin1_german1_ci;
USE `tunierauswertung`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `basketballrangliste`
--

CREATE TABLE `basketballrangliste` (
  `Teamname` varchar(35) COLLATE latin1_german1_ci NOT NULL,
  `Punktzahl` float UNSIGNED DEFAULT NULL,
  `Siege` int(2) DEFAULT NULL,
  `Niederlagen` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci;

--
-- Daten für Tabelle `basketballrangliste`
--

INSERT INTO `basketballrangliste` (`Teamname`, `Punktzahl`, `Siege`, `Niederlagen`) VALUES
('Kentucky Tigers', 800, 0, 7),
('Montana Eagles', 2300, 9, 1),
('New York Sharks', 200, 1, 2);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `fussballrangliste`
--

CREATE TABLE `fussballrangliste` (
  `Teamname` varchar(35) COLLATE latin1_german1_ci NOT NULL,
  `Punktzahl` float UNSIGNED DEFAULT NULL,
  `Siege` int(2) UNSIGNED DEFAULT NULL,
  `Niederlagen` int(2) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci;

--
-- Daten für Tabelle `fussballrangliste`
--

INSERT INTO `fussballrangliste` (`Teamname`, `Punktzahl`, `Siege`, `Niederlagen`) VALUES
('FC Kicker', 0, 0, 1),
('FC Pfosten', 1, 1, 0),
('FC Rasenball', 0, 0, 0);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `basketballrangliste`
--
ALTER TABLE `basketballrangliste`
  ADD PRIMARY KEY (`Teamname`);

--
-- Indizes für die Tabelle `fussballrangliste`
--
ALTER TABLE `fussballrangliste`
  ADD PRIMARY KEY (`Teamname`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
