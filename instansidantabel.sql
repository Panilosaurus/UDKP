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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.akun: ~5 rows (approximately)
INSERT INTO `akun` (`id_akun`, `username`, `password`, `foto`, `nama_depan`, `nama_belakang`, `role`, `status`) VALUES
	(1, 'bini', '$2b$10$MqjVUea.eb/9VsW6hCPYn.x2m5Tdzjrf6osNjpf2vDfi98oU4yU..', NULL, 'biji', 'ajiiu', 'petugas', 'aktif'),
	(3, 'bima', '$2b$10$uXNkwy5yumkPI.ZZ6EYSP.odYdiVQ64r/JZVcK/sXraQrODn927oW', NULL, 'Bij', 'Nug', 'admin', 'aktif'),
	(4, 'yudi', '$2b$10$6ZcsFqZYvYercH3N/ZV32eA4RZPezIE2OjBeiwfhkNWBJts4DleuO', NULL, 'Muhammad', 'Wahyudi', 'admin', 'aktif'),
	(5, 'Rafli', '$2b$10$J29Jne76MPA08IXGBlPRO.K2cfFl3ZaINMw8L6xNlDzSGnKOIvuLq', NULL, 'Ahmad', 'Rafli', 'viewer', 'aktif');

-- Dumping structure for table udkp.instansi
CREATE TABLE IF NOT EXISTS `instansi` (
  `id_instansi` int NOT NULL AUTO_INCREMENT,
  `nama_instansi` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_instansi`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.instansi: ~5 rows (approximately)
INSERT INTO `instansi` (`id_instansi`, `nama_instansi`) VALUES
	(1, 'Kab. Banjar'),
	(2, 'Kab. Tana Tidung'),
	(3, 'Kab. HSU'),
	(4, 'Kab. HSS'),
	(5, 'Kab. Malinau');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.login_log: ~6 rows (approximately)
INSERT INTO `login_log` (`id`, `user_id`, `username`, `ip`, `user_agent`, `success`, `reason`, `created_at`) VALUES
	(1, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 07:23:56'),
	(2, 5, 'rafli', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 07:56:09'),
	(3, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 08:23:47'),
	(4, 1, 'bini', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-29 08:24:06'),
	(5, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-30 03:45:30'),
	(6, 3, 'bima', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 1, 'OK', '2025-10-30 03:51:48');

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
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.tabel: ~17 rows (approximately)
INSERT INTO `tabel` (`id`, `id_instansi`, `jenis_ujian`, `jumlah_peserta`, `tanggal_pelaksanaan`, `status`, `dokumen`, `petugas_cat`, `nilai_tertinggi_pg`, `nilai_terendah_pg`, `jumlah_lulus_pg`, `jumlah_tidak_lulus_pg`, `group_id`) VALUES
	(82, '1', 'UPKP', 1400, '2025-09-29', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '324, rfdv', 10, 11, NULL, NULL, 'hwqawl6b'),
	(84, '2', 'UD TK. I', 2222, '2025-09-29', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '324, rfdv', NULL, NULL, 222, 22, 'hwqawl6b'),
	(86, '3', 'UPKP', 11112, '2025-09-08', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr', 345, 221, NULL, NULL, 'x21ra8v3'),
	(88, '4', 'REMED UD TK. II', 4444, '2025-09-08', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr', NULL, NULL, 444, 44, 'x21ra8v3'),
	(90, '5', 'UPKP', 1111, '2025-08-19', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', 11, 10, NULL, NULL, 'ussm4dww'),
	(91, '1', 'UPKP', 111, '2025-10-21', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Nugg', 675, 9, NULL, NULL, 'bq9obkun'),
	(93, '2', 'UPKP', 512, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', 762, 68, NULL, NULL, 'ng79fyz0'),
	(94, '3', 'UD TK. I', 243, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', NULL, NULL, 200, 11, 'ng79fyz0'),
	(95, '4', 'UD TK. II', 246, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', NULL, NULL, 150, 68, 'ng79fyz0'),
	(97, '5', 'REMED UD TK. I', 15, '2025-10-17', 'Selesai', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene, Castorice', NULL, NULL, 182, 26, 'ng79fyz0'),
	(119, '1', 'UPKP', 289, '2025-10-28', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bima, Rafli, Yudi', 782, 92, NULL, NULL, 'z2ks502r'),
	(120, '2', 'UD TK. II', 480, '2025-10-28', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bima, Rafli, Yudi', NULL, NULL, 400, 80, 'z2ks502r'),
	(121, '3', 'UD TK. II', 242, '2025-10-28', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1dsWL-V2154oB7QcReL2scikfEEHFNep5', 'Cyrene', NULL, NULL, NULL, NULL, 'fy4gmm0u'),
	(122, '4', 'UPKP', 400, '2025-10-31', 'Persiapan Administrasi', '', 'Cyrene', NULL, NULL, NULL, NULL, '6fl3rmqh'),
	(123, '5', 'UPKP', 400, '2025-10-30', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Cyrene', 920, 120, NULL, NULL, '80gwqqg2'),
	(125, '1', 'UD TK. I', 320, '2025-10-30', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Cyrene', NULL, NULL, 220, 100, '80gwqqg2'),
	(126, '3', 'UPKP', 123, '2025-10-30', 'Selesai', '', 'Bim', NULL, NULL, NULL, NULL, 'e5d2qbic');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
