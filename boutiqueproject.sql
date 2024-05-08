-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : mer. 08 mai 2024 à 22:28
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `flaskapp`
--

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `password` varchar(200) NOT NULL,
  `mail` varchar(45) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  `cart` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`cart`)),
  `wishlist` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`wishlist`)),
  `totp_secret` varchar(45) DEFAULT NULL,
  `attemp_counter` int(11) DEFAULT 0,
  `last_attemp` datetime DEFAULT NULL,
  `locked_counter` int(11) DEFAULT 0,
  `reset_password` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `name`, `password`, `mail`, `admin`, `cart`, `wishlist`, `totp_secret`, `attemp_counter`, `last_attemp`, `locked_counter`, `reset_password`) VALUES
(1, 'admin', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'qhjksvsqjdvqsdv', 1, '\"[28, 33, 41, 30]\"', '\"[]\"', 'GF7AWW274DS7HU4D', 0, NULL, 0, NULL),
(2, 'theo', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'theo@gmail.com', 0, '\"[28]\"', '\"[]\"', 'MGXYRDFIV2G5Z4RT', 0, NULL, 0, NULL),
(3, 'test', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'teste@gmail.com', 0, '\"[]\"', '\"[]\"', '4XQCQ2QALAMVIK26', 0, '2024-05-06 14:27:15', 1, NULL),
(4, 'tom', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'tom@tom.com', 0, '\"[34]\"', '\"[32]\"', '5KEBUEAB5SYSKTQP', 0, NULL, 0, NULL),
(5, 'lolo', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'lolo@gmail.com', 0, '\"[]\"', '\"[]\"', NULL, 0, NULL, 0, NULL),
(9, 'lucas', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'sdkfnsfk@slfnks.com', 0, '\"[]\"', '\"[]\"', NULL, 0, NULL, 0, NULL),
(10, 'test2', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'test@test.com', 0, '\"[]\"', '\"[]\"', NULL, 0, NULL, 0, NULL),
(11, 'demo', '2a97516c354b68848cdbd8f54a226a0a55b21ed138e207ad6c5cbb9c00aa5aea', 'demo@demo.com', 0, '\"[]\"', '\"[]\"', '6K6JAMTJIHSJUKBU', 0, NULL, 0, NULL),
(12, 'vins', '8770721234605af7a31cb902253e7990c5d5a3adecfd04429df291a5206d277d', 'vins@gmail.com', 0, '\"[]\"', '\"[38]\"', 'DXXIY5XJNLLB6YUJ', 0, '2024-04-17 13:19:42', 1, NULL),
(13, 'theo2', 'e9058ab198f6908f702111b0c0fb5b36f99d00554521886c40e2891b349dc7a1', 'theo.chabrolles@gmail.com', 0, '\"[]\"', '\"[]\"', NULL, 0, NULL, 0, NULL),
(14, 'theo3', '5bff5368b46fd33b80fea8328ba89394fdbf2b6b212b2036f46af3f3e5a304b0', 'theo.chabrolles@gmail.com', 0, '\"[]\"', '\"[]\"', NULL, NULL, NULL, NULL, NULL),
(15, 'B3stadmin', '549fb701b788042620506e36ad061031af166d68e77bbe9f5d975052aeb6be1d', 'bestadmin@admin.com', 1, '\"[]\"', '\"[]\"', NULL, 0, NULL, 0, NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
