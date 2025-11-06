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

-- Dumping structure for table udkp.akun
CREATE TABLE IF NOT EXISTS `akun` (
  `id_akun` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `nama_depan` varchar(255) NOT NULL,
  `nama_belakang` varchar(255) NOT NULL,
  `role` enum('admin','petugas','viewer') DEFAULT 'viewer',
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  PRIMARY KEY (`id_akun`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.akun: ~5 rows (approximately)
INSERT INTO `akun` (`id_akun`, `username`, `password`, `foto`, `nama_depan`, `nama_belakang`, `role`, `status`) VALUES
	(1, 'bini', '$2b$10$MqjVUea.eb/9VsW6hCPYn.x2m5Tdzjrf6osNjpf2vDfi98oU4yU..', NULL, 'bima', 'ajiiu', 'petugas', NULL),
	(3, 'bima', '$2b$10$uXNkwy5yumkPI.ZZ6EYSP.odYdiVQ64r/JZVcK/sXraQrODn927oW', NULL, 'Bij', 'Nug', 'admin', 'aktif'),
	(4, 'yudi', '$2b$10$6ZcsFqZYvYercH3N/ZV32eA4RZPezIE2OjBeiwfhkNWBJts4DleuO', NULL, 'Muhammad', 'Wahyudi', 'admin', 'aktif'),
	(5, 'Rafli', '$2b$10$J29Jne76MPA08IXGBlPRO.K2cfFl3ZaINMw8L6xNlDzSGnKOIvuLq', NULL, 'Ahmad', 'Rafli', 'viewer', 'aktif'),
	(6, 'biji', '$2b$10$DxNyAXItxgICezPyU/RXZubuQrQofAJDEKRcl/H0lJKlb9CBJb9Ci', NULL, 'bima', 'aji', 'petugas', NULL),
	(7, 'AdminVIII', '$2b$10$iUe6yCXvVEX/6eOaFbAGue1/cLJ8whn8WsN.QJ7aiZbV/HZVK00fW', NULL, 'Kanreg', 'VIII', 'admin', 'aktif');

-- Dumping structure for table udkp.instansi
CREATE TABLE IF NOT EXISTS `instansi` (
  `id_instansi` int NOT NULL AUTO_INCREMENT,
  `nama_instansi` varchar(255) DEFAULT NULL,
  `provinsi` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_instansi`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.instansi: ~51 rows (approximately)
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

-- Dumping structure for table udkp.login_log
CREATE TABLE IF NOT EXISTS `login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `ip` varchar(100) NOT NULL,
  `user_agent` text,
  `success` tinyint(1) NOT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`created_at`),
  KEY `username` (`username`,`created_at`),
  KEY `success` (`success`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.login_log: ~55 rows (approximately)
INSERT INTO `login_log` (`id`, `user_id`, `username`, `ip`, `user_agent`, `success`, `reason`, `created_at`) VALUES
	(1, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 07:23:56'),
	(2, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 07:56:09'),
	(3, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 08:23:47'),
	(4, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 08:24:06'),
	(5, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-30 03:45:30'),
	(6, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-30 03:51:48'),
	(7, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'PASSWORD_MISMATCH', '2025-10-31 02:13:26'),
	(8, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 02:13:33'),
	(9, NULL, 'Uajng', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'USERNAME_NOT_FOUND', '2025-10-31 07:29:00'),
	(10, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:06:45'),
	(11, NULL, 'Uajng', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'USERNAME_NOT_FOUND', '2025-10-31 08:15:24'),
	(12, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:15:35'),
	(13, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'PASSWORD_MISMATCH', '2025-10-31 08:22:42'),
	(14, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'PASSWORD_MISMATCH', '2025-10-31 08:22:53'),
	(15, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:22:59'),
	(16, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:24:20'),
	(17, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:30:02'),
	(18, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:39:00'),
	(19, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:39:15'),
	(20, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-31 08:39:41'),
	(21, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 05:36:00'),
	(22, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 06:21:49'),
	(23, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 06:29:36'),
	(24, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 06:38:05'),
	(25, 4, 'yudi', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 06:38:24'),
	(26, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'PASSWORD_MISMATCH', '2025-11-02 06:44:29'),
	(27, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 06:44:35'),
	(28, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 07:10:03'),
	(29, 4, 'yudi', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 07:10:55'),
	(30, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 07:15:58'),
	(31, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 07:16:32'),
	(32, 4, 'yudi', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-02 07:16:45'),
	(33, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:38:21'),
	(34, 4, 'yudi', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:38:33'),
	(35, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:43:03'),
	(36, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:43:53'),
	(37, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:44:09'),
	(38, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:44:38'),
	(39, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:45:58'),
	(40, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'NONAKTIF', '2025-11-03 01:46:21'),
	(41, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:46:33'),
	(42, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:52:35'),
	(43, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'NONAKTIF', '2025-11-03 01:53:30'),
	(44, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:53:39'),
	(45, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 01:57:27'),
	(46, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:02:26'),
	(47, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:06:09'),
	(48, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:07:38'),
	(49, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 0, 'PASSWORD_MISMATCH', '2025-11-03 02:19:46'),
	(50, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:19:52'),
	(51, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:21:51'),
	(52, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:35:22'),
	(53, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:35:38'),
	(54, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 02:41:50'),
	(55, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 03:02:24'),
	(56, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 03:04:50'),
	(57, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 08:33:15'),
	(58, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 08:45:26'),
	(59, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 09:12:51'),
	(60, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 09:13:00'),
	(61, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 09:46:41'),
	(62, 6, 'biji', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-03 09:52:46'),
	(63, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-05 02:55:49'),
	(64, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-05 02:56:40'),
	(65, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-06 04:56:00'),
	(66, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-06 04:58:39'),
	(67, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-06 05:06:28'),
	(68, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-06 05:07:37'),
	(69, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-06 13:07:29'),
	(70, 7, 'AdminVIII', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-11-06 13:09:14');

-- Dumping structure for table udkp.tabel
CREATE TABLE IF NOT EXISTS `tabel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_instansi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `jenis_ujian` varchar(255) DEFAULT NULL,
  `jumlah_peserta` int DEFAULT NULL,
  `tanggal_pelaksanaan` date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `dokumen` varchar(255) DEFAULT NULL,
  `petugas_cat` varchar(255) DEFAULT NULL,
  `nilai_tertinggi_pg` int DEFAULT NULL,
  `nilai_terendah_pg` int DEFAULT NULL,
  `jumlah_lulus_pg` int DEFAULT NULL,
  `jumlah_tidak_lulus_pg` int DEFAULT NULL,
  `group_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.tabel: ~22 rows (approximately)
INSERT INTO `tabel` (`id`, `id_instansi`, `jenis_ujian`, `jumlah_peserta`, `tanggal_pelaksanaan`, `status`, `dokumen`, `petugas_cat`, `nilai_tertinggi_pg`, `nilai_terendah_pg`, `jumlah_lulus_pg`, `jumlah_tidak_lulus_pg`, `group_id`) VALUES
	(82, '6', 'UPKP', 1400, '2025-09-29', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '324, rfdv', 10, 11, NULL, NULL, 'hwqawl6b'),
	(84, '6', 'UD TK. I', 2222, '2025-09-29', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '324, rfdv', NULL, NULL, 222, 22, 'hwqawl6b'),
	(86, '10', 'UPKP', 11112, '2025-09-08', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr', 943, 221, NULL, NULL, 'x21ra8v3'),
	(88, '10', 'REMED UD TK. II', 4444, '2025-09-08', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr', NULL, NULL, 444, 44, 'x21ra8v3'),
	(90, '11', 'UPKP', 1111, '2025-08-19', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', 11, 10, NULL, NULL, 'ussm4dww'),
	(93, '17', 'UPKP', 512, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', 762, 68, NULL, NULL, 'ng79fyz0'),
	(94, '17', 'UD TK. I', 243, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', NULL, NULL, 200, 11, 'ng79fyz0'),
	(95, '17', 'UD TK. II', 246, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', NULL, NULL, 150, 68, 'ng79fyz0'),
	(97, '17', 'REMED UD TK. I', 15, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', NULL, NULL, 182, 26, 'ng79fyz0'),
	(119, '20', 'UPKP', 289, '2025-10-28', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bima, Rafli, Yudi', 782, 92, NULL, NULL, 'z2ks502r'),
	(120, '20', 'UD TK. II', 480, '2025-10-28', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bima, Rafli, Yudi', NULL, NULL, 400, 80, 'z2ks502r'),
	(123, '34', 'UPKP', 400, '2025-10-30', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Cyrene', 920, 120, NULL, NULL, '80gwqqg2'),
	(125, '34', 'UD TK. I', 320, '2025-10-30', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Cyrene', NULL, NULL, 220, 100, '80gwqqg2'),
	(126, '18', 'UPKP', 123, '2025-10-30', 'Persiapan Administrasi', NULL, 'Bim, Senin', 431, 21, NULL, NULL, 'e5d2qbic'),
	(130, '9', 'UPKP', 123, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', 943, 34, NULL, NULL, 'xq86kl98'),
	(131, '9', 'UD TK. I', 321, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', NULL, NULL, 876, 401, 'xq86kl98'),
	(132, '9', 'UD TK. II', 4556, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', NULL, NULL, 501, 23, 'xq86kl98'),
	(133, '9', 'REMED UPKP', 231, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', 902, 221, NULL, NULL, 'xq86kl98'),
	(134, '9', 'REMED UD TK. I', 312, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', NULL, NULL, 76, 8, 'xq86kl98'),
	(135, '9', 'REMED UD TK. II', 654, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', NULL, NULL, 481, 71, 'xq86kl98'),
	(136, '26', 'REMED UD TK. I', 123, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr, Bim', NULL, NULL, NULL, NULL, 'cwsu1w7c'),
	(137, '26', 'UPKP', 567, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr, Bim', NULL, NULL, NULL, NULL, 'cwsu1w7c'),
	(138, '26', 'REMED UD TK. II', 1234, '2025-10-31', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr, Bim', NULL, NULL, NULL, NULL, 'cwsu1w7c'),
	(140, '18', 'UPKP', 456, '2025-11-03', 'Menunggu Pelaksanaan', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'ardan', NULL, NULL, NULL, NULL, '4s1hp0do');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
