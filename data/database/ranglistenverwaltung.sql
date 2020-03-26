-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 26, 2020 at 11:01 PM
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
-- Database: `ranglistenverwaltung`
--
CREATE DATABASE IF NOT EXISTS `ranglistenverwaltung` DEFAULT CHARACTER SET latin1 COLLATE latin1_german1_ci;
USE `ranglistenverwaltung`;

-- --------------------------------------------------------

--
-- Table structure for table `basketballrangliste`
--

CREATE TABLE `basketballrangliste` (
  `Teamname` varchar(35) COLLATE latin1_german1_ci NOT NULL,
  `Punktzahl` float UNSIGNED DEFAULT NULL,
  `Siege` int(2) DEFAULT NULL,
  `Niederlagen` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci;

--
-- Dumping data for table `basketballrangliste`
--

INSERT INTO `basketballrangliste` (`Teamname`, `Punktzahl`, `Siege`, `Niederlagen`) VALUES
('ALBA Berlin', 0, 0, 0),
('Basketball Loewen Braunschweig', 0, 0, 0),
('BG Goettingen', 0, 0, 0),
('Brose Bamberg', 0, 0, 0),
('EWE Baskets Oldenburg', 0, 0, 0),
('FC Bayern Basketball', 0, 0, 0),
('FRAPORT SKYLINERS', 0, 0, 0),
('HAKRO Merlins Crailsheim', 0, 0, 0),
('Hamburg Towers', 0, 0, 0),
('JobStairs GIESSEN 46ers', 0, 0, 0),
('medi bayreuth', 0, 0, 0),
('MHP Riesen Ludwigsburg', 0, 0, 0),
('Rasta Vechta', 0, 0, 0),
('ratiopharm ulm', 0, 0, 0),
('s.Oliver Wuerzburg', 0, 0, 0),
('SYNTAINIC MBC', 0, 0, 0),
('Telekom Baskets Bonn', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `fussballrangliste`
--

CREATE TABLE `fussballrangliste` (
  `Teamname` varchar(35) COLLATE latin1_german1_ci NOT NULL,
  `Punktzahl` float UNSIGNED DEFAULT NULL,
  `Siege` int(2) UNSIGNED DEFAULT NULL,
  `Niederlagen` int(2) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci;

--
-- Dumping data for table `fussballrangliste`
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
-- Indexes for dumped tables
--

--
-- Indexes for table `basketballrangliste`
--
ALTER TABLE `basketballrangliste`
  ADD PRIMARY KEY (`Teamname`);

--
-- Indexes for table `fussballrangliste`
--
ALTER TABLE `fussballrangliste`
  ADD PRIMARY KEY (`Teamname`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
