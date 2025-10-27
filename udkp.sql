-- Buat database
CREATE DATABASE udkp;
USE udkp;

-- Buat tabel
CREATE TABLE ujian (
    id INT(10) NOT NULL AUTO_INCREMENT,
    instansi VARCHAR(255) DEFAULT '0',
    jenis_ujian VARCHAR(255) DEFAULT '0',
    jumlah_peserta INT(10) DEFAULT '0',
    tanggal_pelaksanaan DATE,
    status VARCHAR(255) DEFAULT '0',
    dokumen VARCHAR(255) DEFAULT '0',
    petugas_cat VARCHAR(255) DEFAULT '0',
    nilai_tertinggi_pg INT(10) DEFAULT '0',
    nilai_terendah_pg INT(10) DEFAULT '0',
    jumlah_lulus_pg INT(10) DEFAULT '0',
    jumlah_tidak_lulus_pg INT(10) DEFAULT '0',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
