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
  PRIMARY KEY (`id_akun`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.akun: ~0 rows (approximately)
INSERT INTO `akun` (`id_akun`, `username`, `password`, `foto`, `nama_depan`, `nama_belakang`) VALUES
	(1, 'bini', '$2b$10$p8Me48jzkgUceeCO0BpVgOVE8tJEoPd/6bvhkP69lMq19SMiggX4u', NULL, 'biji', 'aji'),
	(2, 'tes', '$2b$10$9pQEtmV91yDq0jPfSpV8TOVgGEa0tQqH7xA/5zYvWcL7n7tiWw3ty', NULL, 'te', 's'),
	(3, 'bima', '$2b$10$uXNkwy5yumkPI.ZZ6EYSP.odYdiVQ64r/JZVcK/sXraQrODn927oW', NULL, 'Bij', 'Nug');

-- Dumping structure for table udkp.tabel
CREATE TABLE IF NOT EXISTS `tabel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instansi` varchar(255) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table udkp.tabel: ~10 rows (approximately)
INSERT INTO `tabel` (`id`, `instansi`, `jenis_ujian`, `jumlah_peserta`, `tanggal_pelaksanaan`, `status`, `dokumen`, `petugas_cat`, `nilai_tertinggi_pg`, `nilai_terendah_pg`, `jumlah_lulus_pg`, `jumlah_tidak_lulus_pg`, `group_id`) VALUES
	(29, 'Kab. Banjar Uji', 'UPKP', 1111, '2025-10-16', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '3123, Bim', 1, 100, NULL, NULL, 'fsxjckeo'),
	(30, 'Kab. Banjar Uji', 'UD TK. I', 2222, '2025-10-16', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '3123, Bim', NULL, NULL, 222, 22, 'fsxjckeo'),
	(31, 'Kab. Banjar Uji', 'UD TK. II', 3333, '2025-10-16', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '3123, Bim', NULL, NULL, 333, 33, 'fsxjckeo'),
	(32, 'Kab. Banjar Uji', 'REMED UPKP', 5555, '2025-10-16', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '3123, Bim', 555, 80, NULL, NULL, 'fsxjckeo'),
	(33, 'Kab. Banjar Uji', 'REMED UD TK. I', 4444, '2025-10-16', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '3123, Bim', NULL, NULL, 444, 44, 'fsxjckeo'),
	(34, 'Kab. Banjar Uji', 'REMED UD TK. II', 6666, '2025-10-16', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '3123, Bim', NULL, NULL, 666, 66, 'fsxjckeo'),
	(82, 'Kab. Tana Tidung', 'UPKP', 1111, '2025-10-21', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '324, rfdv', 10, 11, NULL, NULL, 'hwqawl6b'),
	(84, 'Kab. Tana Tidung', 'UD TK. I', 2222, '2025-10-21', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '324, rfdv', NULL, NULL, 222, 22, 'hwqawl6b'),
	(86, 'Kab. Banjar Uji 3', 'UPKP', 1111, '2025-10-21', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr', 345, 221, NULL, NULL, 'x21ra8v3'),
	(88, 'Kab. Banjar Uji 3', 'REMED UD TK. II', 4444, '2025-10-21', 'Selesai', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'freggtr', NULL, NULL, 444, 44, 'x21ra8v3'),
	(90, 'Kab. Tana Tidung', 'UPKP', 1111, '2025-10-22', 'Persiapan Administrasi', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'Bim', 11, 7, NULL, NULL, 'ussm4dww'),
	(91, 'Kab. Banjar Uji 2', 'UPKP', 111, '2025-10-22', 'Menunggu Pelaksanaan', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', 'h', 11, 1, NULL, NULL, 'bq9obkun'),
	(92, 'h', 'UPKP', 11111111, '2025-10-22', 'Menunggu Pelaksanaan', 'https://drive.google.com/drive/folders/1WWevi7_KXBB0-peBFe8rCLMeC7BFUunc', '', NULL, NULL, NULL, NULL, '5jzg2d7w');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
