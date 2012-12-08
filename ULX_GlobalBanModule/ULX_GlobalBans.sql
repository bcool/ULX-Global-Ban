-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 08, 2012 at 02:54 AM
-- Server version: 5.5.24-log
-- PHP Version: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bans`
--

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `BanID` int(255) NOT NULL AUTO_INCREMENT,
  `OSteamID` varchar(255) NOT NULL,
  `OName` varchar(255) NOT NULL,
  `Length` bigint(255) NOT NULL,
  `Time` bigint(255) NOT NULL,
  `AName` varchar(255) NOT NULL,
  `ASteamID` varchar(255) NOT NULL,
  `Reason` varchar(255) NOT NULL,
  `ServerID` int(255) NOT NULL,
  `MAdmin` varchar(255) NOT NULL,
  `MTime` bigint(255) NOT NULL,
  PRIMARY KEY (`BanID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `servers`
--

CREATE TABLE IF NOT EXISTS `servers` (
  `ServerID` int(255) NOT NULL AUTO_INCREMENT,
  `IPAddress` varchar(255) NOT NULL,
  `Port` varchar(255) NOT NULL,
  `HostName` varchar(255) NOT NULL,
  PRIMARY KEY (`ServerID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
