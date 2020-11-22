-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: mysql
-- Generation Time: Nov 20, 2020 at 05:45 PM
-- Server version: 5.7.32
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sampledb`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `location_id` int(11) NOT NULL,
  `reference` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `vendor_id`, `start_time`, `end_time`, `location_id`, `reference`) VALUES
(1, 1, '2020-11-19 08:00:00', '2020-11-19 09:00:00', 2, NULL),
(2, 1, '2020-11-19 09:00:44', '2020-11-19 10:30:44', 1, NULL),
(6, 1, '2020-11-20 16:30:00', '2020-11-20 17:30:00', 1, NULL),
(7, 5, '2020-11-21 08:00:00', '2020-11-21 10:00:00', 3, NULL),
(8, 5, '2020-11-21 10:30:00', '2020-11-21 11:30:00', 4, NULL),
(9, 5, '2020-11-21 13:30:00', '2020-11-21 14:30:00', 5, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `longitude` double NOT NULL,
  `latitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `name`, `longitude`, `latitude`) VALUES
(1, 'Kaduwela', 79.9828, 6.9291),
(2, 'Battaramulla', 79.922, 6.898),
(3, 'Dehiwala', 79.8801, 6.8301),
(4, 'Maharagama', 79.9212, 6.8511),
(5, 'Galle', 80.221, 6.0535);

-- --------------------------------------------------------

--
-- Table structure for table `time_slots`
--

CREATE TABLE `time_slots` (
  `id` int(11) NOT NULL,
  `start_time` varchar(10) NOT NULL,
  `end_time` varchar(10) NOT NULL,
  `type` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `time_slots`
--

INSERT INTO `time_slots` (`id`, `start_time`, `end_time`, `type`) VALUES
(1, '8:00', '8:30', '30'),
(2, '8:30', '9:00', '30'),
(3, '9:00', '9:30', '30'),
(4, '9:30', '10:00', '30'),
(5, '10:00', '10:30', '30'),
(6, '10:30', '11:00', '30'),
(7, '11:00', '11:30', '30'),
(8, '11:30', '12:00', '30'),
(9, '12:00', '12:30', '30'),
(10, '12:30', '13:00', '30'),
(11, '13:00', '13:30', '30'),
(12, '13:30', '14:00', '30'),
(13, '14:00', '14:30', '30'),
(14, '14:30', '15:00', '30'),
(15, '15:00', '15:30', '30'),
(16, '15:30', '16:00', '30'),
(17, '16:00', '16:30', '30'),
(18, '16:30', '17:00', '30');

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `id` int(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `service_type` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vendors`
--

INSERT INTO `vendors` (`id`, `name`, `service_type`) VALUES
(1, 'Kapila', 'LS'),
(2, 'Mark', 'LS'),
(3, 'Amara', 'LM'),
(4, 'Murugeswaran', 'LM'),
(5, 'Kamal', 'LS');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_vendor_bookings` (`vendor_id`),
  ADD KEY `fk_location_id` (`location_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `time_slots`
--
ALTER TABLE `time_slots`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `time_slots`
--
ALTER TABLE `time_slots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_location_id` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`),
  ADD CONSTRAINT `fk_vendor_bookings` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
