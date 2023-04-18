-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 18 Des 2022 pada 08.10
-- Versi server: 5.7.33
-- Versi PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `no_banjir`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail`
--

CREATE TABLE `detail` (
  `id` int(11) NOT NULL,
  `node_id` varchar(10) NOT NULL,
  `nama_loc` varchar(30) NOT NULL,
  `tanggal` date NOT NULL,
  `tinggi_air` float NOT NULL,
  `curah_hujan` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `detail`
--

INSERT INTO `detail` (`id`, `node_id`, `nama_loc`, `tanggal`, `tinggi_air`, `curah_hujan`) VALUES
(1, 'handil', 'Kelurahan Handil Jaya', '2022-12-13', 10, 40),
(2, 'handil', 'Kelurahan Handil Jaya', '2022-12-14', 15, 30),
(3, 'handil', 'Kelurahan Handil Jaya', '2022-12-15', 25, 35),
(4, 'handil', 'Kelurahan Handil Jaya', '2022-12-16', 20, 50),
(5, 'bakung', 'Kelurahan Talang Bakung', '2022-12-13', 25, 40),
(6, 'tambak', 'Kelurahan Tambak Sari', '2022-12-13', 35, 55),
(7, 'tambak', 'Kelurahan Tambak Sari', '2022-12-14', 25, 40),
(8, 'bakung', 'Kelurahan Talang Bakung', '2022-12-14', 25, 40),
(9, 'bakung', 'Kelurahan Talang Bakung', '2022-12-15', 10, 30),
(10, 'bakung', 'Kelurahan Talang Bakung', '2022-12-16', 30, 55),
(11, 'bakung', 'Kelurahan Talang Bakung', '2022-12-17', 20, 50),
(12, 'tambak', 'Kelurahan Tambak Sari', '2022-12-15', 15, 55),
(13, 'tambak', 'Kelurahan Tambak Sari', '2022-12-17', 25, 30);

-- --------------------------------------------------------

--
-- Struktur dari tabel `location`
--

CREATE TABLE `location` (
  `id` int(11) NOT NULL,
  `node_id` varchar(10) NOT NULL,
  `nama_loc` varchar(50) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `location`
--

INSERT INTO `location` (`id`, `node_id`, `nama_loc`, `latitude`, `longitude`) VALUES
(1, 'handil', 'Kelurahan Handil Jaya', -1.6322324335188614, 103.61494506691037),
(2, 'bakung', 'Kelurahan Talang Bakung', -1.6298404169715242, 103.6526439162481),
(3, 'tambak', 'Kelurahan Tambak Sari', -1.61191286322701, 103.62463915879455),
(5, 'pasir', 'Kelurahan Pasir Putih', -1.6196124482794183, 103.6388934674252);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`id`, `username`, `password`) VALUES
(1, 'admin', 'admin'),
(2, 'sahdan', '1234');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `detail`
--
ALTER TABLE `detail`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `detail`
--
ALTER TABLE `detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `location`
--
ALTER TABLE `location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
