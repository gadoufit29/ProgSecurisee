-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : lun. 06 mai 2024 à 14:30
-- Version du serveur : 10.4.27-MariaDB
-- Version de PHP : 8.2.0

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
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Informatique'),
(2, 'Photo/Vidéo'),
(3, 'Smarthpone'),
(4, 'Téléviseur'),
(5, 'Montres connectées');

-- --------------------------------------------------------

--
-- Structure de la table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `content` varchar(250) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `status` varchar(45) NOT NULL,
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `date`, `status`, `price`) VALUES
(1, 1, '2024-02-16', 'ended', 10000),
(2, 1, '2024-02-16', 'error', 345),
(4, 1, '2024-02-16', 'pending', 1699.97),
(5, 1, '2024-02-17', 'pending', 599.99),
(6, 1, '2024-02-19', 'pending', 12),
(7, 1, '2024-02-20', 'pending', 129.99),
(8, 1, '2024-02-20', 'pending', 0),
(9, 1, '2024-02-20', 'pending', 129.99),
(10, 3, '2024-02-28', 'pending', 679.98),
(11, 1, '2024-02-29', 'pending', 0),
(12, 10, '2024-03-05', 'pending', 599.99),
(13, 3, '2024-03-28', 'pending', 129.99),
(14, 1, '2024-04-12', 'pending', 67.34),
(15, 1, '2024-04-15', 'pending', 1598.99),
(16, 12, '2024-04-17', 'pending', 1198.99),
(17, 3, '2024-04-23', 'pending', 1498.99);

-- --------------------------------------------------------

--
-- Structure de la table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` varchar(200) NOT NULL,
  `pic` varchar(45) NOT NULL,
  `supp_pic` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '"[]"',
  `price` float NOT NULL,
  `qte` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `pic`, `supp_pic`, `price`, `qte`, `category_id`) VALUES
(27, 'Samsung Galaxy Fold', 'Téléphone portable haut de gamme', 'HLME0T.jpg', '\"[\\\"F0TT00.jpeg\\\", \\\"8VPUQ2.jpeg\\\"]\"', 799.99, 100, 3),
(28, 'PC Portable LENOVO', 'Ordinateur portable avec processeur puissant', '70PCKY.jpeg', '\"[\\\"22S5EH.jpeg\\\"]\"', 1099.99, 34, 1),
(29, 'Camera Canon EOS', 'Caméra haute définition', 'U2X2VU.jpeg', '\"[\\\"47705C.jpeg\\\", \\\"KHZB6G.jpeg\\\"]\"', 699.99, 23, 2),
(30, 'Montre connectée Fitbit', 'Suivi de la condition physique et des activités', 'D9R0X0.jpeg', '\"[\\\"4462RO.jpeg\\\", \\\"ZV2BG4.jpeg\\\"]\"', 200, 56, 5),
(31, 'Casque audio Bose', 'Casque audio sans fil avec réduction de bruit', 'GZLALI.jpg', '\"[\\\"FA0AVI.jpeg\\\", \\\"BJINRU.jpeg\\\"]\"', 500, 30, 3),
(32, 'iPad', 'Tablette tactile avec écran Retina', 'JVE2XV.jpg', '\"[\\\"YNH4SY.jpg\\\", \\\"D5R45J.jpeg\\\"]\"', 799, 23, 1),
(33, 'SONY - PS5', 'Dernière console de jeux PlayStation', 'D8W17W.jpeg', '\"[\\\"CLNHEP.jpeg\\\"]\"', 499, 50, 1),
(35, 'Drone DJI Phantom', 'Drone professionnel avec caméra 4K', 'SUNHCE.jpg', '\"[\\\"Y4V3FY.png\\\", \\\"IMR3IN.png\\\"]\"', 1499, 3, 2),
(36, 'Enceinte Bluetooth JBL', 'Enceinte portable résistante à l\'eau', '7GD1G3.jpeg', '\"[\\\"24P9HW.jpeg\\\"]\"', 119, 50, 3),
(37, 'Cafetière Nespresso', 'Machine à café automatique', '14LY2I.jpg', '\"[\\\"BKY638.jpeg\\\", \\\"UTDHO1.jpeg\\\"]\"', 999, 45, 4),
(38, 'Trottinette électrique', 'Trottinette urbaine pliable et légère', 'YM4RAE.jpg', '\"[]\"', 599, 300, 3),
(39, 'Aspirateur robot Roomba', 'Aspirateur autonome pour le nettoyage de la maison', 'WYGDAG.jpg', '\"[\\\"FPGEYD.jpg\\\"]\"', 899, 4, 3),
(40, 'Appareil de fitness Peloton', 'Vélo d\'intérieur connecté avec abonnement', '76K5AH.jpeg', '\"[\\\"WKYZ3G.jpg\\\", \\\"8AJWXP.jpg\\\"]\"', 2499, 5, 3),
(41, 'Liseuse Kindle', 'Lecteur de livres électroniques', 'I8DCJI.jpg', '\"[\\\"69QA4W.jpeg\\\", \\\"7A7Y58.jpeg\\\"]\"', 200, 50, 1),
(42, 'Kit domotique', 'Ensemble de dispositifs pour la maison connectée', 'O1LWMN.jpeg', '\"[]\"', 100, 30, 3),
(43, 'Machine à glaçons', 'Appareil pour faire des glaçons rapidement', '7QFC0R.jpg', '\"[\\\"A0GONZ.jpg\\\", \\\"F3DCJJ.jpeg\\\"]\"', 79, 30, 3),
(44, 'Ecouteurs sans fil', 'Écouteurs intra-auriculaires Bluetooth', 'KP0FPP.png', '\"[]\"', 149.99, 50, 3),
(45, 'Imprimante laser HP', 'Imprimante rapide et de qualité', 'W812SX.jpeg', '\"[\\\"EAT9S0.jpeg\\\"]\"', 399.99, 5, 1),
(46, 'Barre de son Sonos', 'Système audio haute fidélité pour la maison', 'J15YNW.jpg', '\"[\\\"0CJTCE.jpg\\\", \\\"1H08BT.jpg\\\"]\"', 999.99, 45, 4);

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
(14, 'theo3', '5bff5368b46fd33b80fea8328ba89394fdbf2b6b212b2036f46af3f3e5a304b0', 'theo.chabrolles@gmail.com', 0, '\"[]\"', '\"[]\"', NULL, NULL, NULL, NULL, NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Index pour la table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Index pour la table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT pour la table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pour la table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
