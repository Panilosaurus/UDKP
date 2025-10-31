-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for udkp
CREATE DATABASE IF NOT EXISTS `udkp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `udkp`;

-- Dumping structure for table udkp.instansi
CREATE TABLE IF NOT EXISTS `instansi` (
  `id_instansi` int NOT NULL AUTO_INCREMENT,
  `nama_instansi` varchar(255) DEFAULT NULL,
  `provinsi` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_instansi`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.instansi: ~46 rows (approximately)
INSERT INTO `instansi` (`id_instansi`, `nama_instansi`, `provinsi`) VALUES
	(6, 'Provinsi Kalimantan Selatan', 'KALIMANTAN SELATAN'),
	(7, 'Kota Banjarmasin', 'KALIMANTAN SELATAN'),
	(8, 'Kota Banjarbaru', 'KALIMANTAN SELATAN'),
	(9, 'Kab. Banjar', 'KALIMANTAN SELATAN'),
	(10, 'Kab. Barito Kuala', 'KALIMANTAN SELATAN'),
	(11, 'Kab. Tanah Laut', 'KALIMANTAN SELATAN'),
	(12, 'Kab. Tapin', 'KALIMANTAN SELATAN'),
	(13, 'Kab. Hulu Sungai Selatan', 'KALIMANTAN SELATAN'),
	(14, 'Kab. Hulu Sungai Tengah', 'KALIMANTAN SELATAN'),
	(15, 'Kab. Hulu Sungai Utara', 'KALIMANTAN SELATAN'),
	(16, 'Kab. Tabalong', 'KALIMANTAN SELATAN'),
	(17, 'Kab. Kotabaru', 'KALIMANTAN SELATAN'),
	(18, 'Kab. Balangan', 'KALIMANTAN SELATAN'),
	(19, 'Kab. Tanah Bumbu', 'KALIMANTAN SELATAN'),
	(20, 'Provinsi Kalimantan Timur', 'KALIMANTAN TIMUR'),
	(21, 'Kota Samarinda', 'KALIMANTAN TIMUR'),
	(22, 'Kota Balikpapan', 'KALIMANTAN TIMUR'),
	(23, 'Kota Bontang', 'KALIMANTAN TIMUR'),
	(24, 'Kab. Paser', 'KALIMANTAN TIMUR'),
	(25, 'Kab. Penajam Paser Utara', 'KALIMANTAN TIMUR'),
	(26, 'Kab. Kutai Barat', 'KALIMANTAN TIMUR'),
	(27, 'Kab. Kutai Kartanegara', 'KALIMANTAN TIMUR'),
	(28, 'Kab. Kutai Timur', 'KALIMANTAN TIMUR'),
	(29, 'Kab. Berau', 'KALIMANTAN TIMUR'),
	(30, 'Kab. Mahakam Ulu', 'KALIMANTAN TIMUR'),
	(31, 'Provinsi Kalimantan Tengah', 'KALIMANTAN TENGAH'),
	(32, 'Kota Palangkaraya', 'KALIMANTAN TENGAH'),
	(33, 'Kab. Barito Utara', 'KALIMANTAN TENGAH'),
	(34, 'Kab. Barito Selatan', 'KALIMANTAN TENGAH'),
	(35, 'Kab. Barito Timur', 'KALIMANTAN TENGAH'),
	(36, 'Kab. Gunung Mas', 'KALIMANTAN TENGAH'),
	(37, 'Kab. Kapuas', 'KALIMANTAN TENGAH'),
	(38, 'Kab. Kotawaringin Barat', 'KALIMANTAN TENGAH'),
	(39, 'Kab. Kotawaringin Timur', 'KALIMANTAN TENGAH'),
	(40, 'Kab. Lamandau', 'KALIMANTAN TENGAH'),
	(41, 'Kab. Murung Raya', 'KALIMANTAN TENGAH'),
	(42, 'Kab. Pulang Pisau', 'KALIMANTAN TENGAH'),
	(43, 'Kab. Seruyan', 'KALIMANTAN TENGAH'),
	(44, 'Kab. Sukamara', 'KALIMANTAN TENGAH'),
	(45, 'Kab. Katingan', 'KALIMANTAN TENGAH'),
	(46, 'Provinsi Kalimantan Utara', 'KALIMANTAN UTARA'),
	(47, 'Kab. Bulungan', 'KALIMANTAN UTARA'),
	(48, 'Kota Tarakan', 'KALIMANTAN UTARA'),
	(49, 'Kab. Malinau', 'KALIMANTAN UTARA'),
	(50, 'Kab. Nunukan', 'KALIMANTAN UTARA'),
	(51, 'Kab. Tana Tidung', 'KALIMANTAN UTARA');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
