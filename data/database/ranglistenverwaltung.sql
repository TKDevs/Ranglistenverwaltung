-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 26. Mrz 2020 um 13:40
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
-- Datenbank: `ranglistenverwaltung`
--
CREATE DATABASE IF NOT EXISTS `ranglistenverwaltung` DEFAULT CHARACTER SET latin1 COLLATE latin1_german1_ci;
USE `ranglistenverwaltung`;

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
('Kentucky Tigers', 1300, 0, 7),
('Montana Eagles', 2800, 9, 1),
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
('1. FC Union Berlin', 0, 0, 0),
('Bayer 04 Leverkusen', 0, 0, 0),
('Borussia Dortmund', 0, 0, 0),
('Borussia Mönchengladbach', 0, 0, 0),
('Eintracht Frankfurt', 0, 0, 0),
('FC Augsburg', 0, 0, 0),
('FC Bayern München', 0, 0, 0),
('FC Köln', 0, 0, 0),
('FC Schalke 04', 0, 0, 0),
('Fortuna Düsseldorf', 0, 0, 0),
('FSV Mainz 05', 0, 0, 0),
('Hertha BSC', 0, 0, 0),
('RB Leipzig', 0, 0, 0),
('SC Freibrug', 0, 0, 0),
('SC Paderborn 07', 0, 0, 0),
('TSG 1899 Hoffenheim', 0, 0, 0),
('VFL Wolfsburg', 0, 0, 0),
('Werder Bremen', 0, 0, 0);

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
