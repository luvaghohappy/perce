-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mer. 28 août 2024 à 16:33
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `formation`
--

-- --------------------------------------------------------

--
-- Structure de la table `administrateur`
--

CREATE TABLE `administrateur` (
  `id` int(11) NOT NULL,
  `email` varchar(200) NOT NULL,
  `passwords` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `administrateur`
--

INSERT INTO `administrateur` (`id`, `email`, `passwords`) VALUES
(2, 'perce@gmail.com', '1234'),
(3, 'perce@gmail.com ', '123456');

-- --------------------------------------------------------

--
-- Structure de la table `archive`
--

CREATE TABLE `archive` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `postnom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `sexe` varchar(100) NOT NULL,
  `org_privee` varchar(100) NOT NULL,
  `Formation` varchar(100) NOT NULL,
  `paiement` varchar(100) NOT NULL,
  `Date_debut` date NOT NULL,
  `Date_fin` date NOT NULL,
  `Lieu` varchar(100) NOT NULL,
  `Telephone` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `archive`
--

INSERT INTO `archive` (`id`, `nom`, `postnom`, `prenom`, `sexe`, `org_privee`, `Formation`, `paiement`, `Date_debut`, `Date_fin`, `Lieu`, `Telephone`, `Email`, `created_at`) VALUES
(1, 'kasoki ', 'luvagho ', 'furaha ', 'Feminin', 'Privée', 'Excel', 'Solde', '2024-08-27', '2024-08-28', 'MRG', '0999582152', 'happyluvagho@gmail.com', '2024-08-28'),
(2, 'moise ', 'MUHINDO ', 'musa', 'Masculin', 'Organisation', 'Word', 'Avance', '2024-08-28', '2024-08-31', 'Mutinga', '0999582152', 'ngabwe2023@gmail.com', '2024-08-28');

-- --------------------------------------------------------

--
-- Structure de la table `formations`
--

CREATE TABLE `formations` (
  `id` int(11) NOT NULL,
  `designation` varchar(500) NOT NULL,
  `descriptions` varchar(500) NOT NULL,
  `prix_inscription` varchar(100) NOT NULL,
  `prix_participation` varchar(100) NOT NULL,
  `Date_debut` date NOT NULL,
  `Date_Fin` date NOT NULL,
  `image_path` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `formations`
--

INSERT INTO `formations` (`id`, `designation`, `descriptions`, `prix_inscription`, `prix_participation`, `Date_debut`, `Date_Fin`, `image_path`) VALUES
(1, 'Excel', 'une formation bien ', '10 $', '20 $', '2024-08-27', '2024-08-29', 'uploads/log.jpg'),
(3, 'Word', 'formation importante', '10 $', '20 $', '2024-08-28', '2024-08-30', 'uploads/perce.png');

--
-- Déclencheurs `formations`
--
DELIMITER $$
CREATE TRIGGER `after_insert_formations` AFTER INSERT ON `formations` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'formations';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count + 1 WHERE table_names = 'formations';
    ELSE
        INSERT INTO states (table_names, record_count) VALUES ('formations', 1);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_formations` AFTER DELETE ON `formations` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'formations';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count - 1 WHERE table_names = 'formations';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `services`
--

CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `designation` varchar(250) NOT NULL,
  `descriptions` varchar(250) NOT NULL,
  `detaille` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `services`
--

INSERT INTO `services` (`id`, `designation`, `descriptions`, `detaille`) VALUES
(1, 'coaching', 'tres bien pour la vie professionnelle', 'Disposnible'),
(2, 'Audit', 'coaching', 'Disponible');

--
-- Déclencheurs `services`
--
DELIMITER $$
CREATE TRIGGER `after_insert_services` AFTER INSERT ON `services` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'services';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count + 1 WHERE table_names = 'services';
    ELSE
        INSERT INTO states (table_names, record_count) VALUES ('services', 1);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_services` AFTER DELETE ON `services` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'services';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count - 1 WHERE table_names = 'services';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `states`
--

CREATE TABLE `states` (
  `id` int(11) NOT NULL,
  `table_names` varchar(100) NOT NULL,
  `record_count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `states`
--

INSERT INTO `states` (`id`, `table_names`, `record_count`) VALUES
(1, 'formations', 2),
(2, 'services', 2),
(3, 'user', 2);

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `postnom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `sexe` varchar(50) NOT NULL,
  `org_privee` varchar(100) NOT NULL,
  `nom_organisation` varchar(100) NOT NULL,
  `Formation` varchar(100) NOT NULL,
  `paiement` varchar(150) NOT NULL,
  `Date_debut` date NOT NULL,
  `Date_fin` date NOT NULL,
  `Lieu` varchar(100) NOT NULL,
  `Telephone` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `nom`, `postnom`, `prenom`, `sexe`, `org_privee`, `nom_organisation`, `Formation`, `paiement`, `Date_debut`, `Date_fin`, `Lieu`, `Telephone`, `Email`, `created_at`) VALUES
(1, 'kasoki ', 'luvagho ', 'furaha ', 'Feminin', 'Privée', '', 'Excel', 'Solde', '2024-08-27', '2024-08-28', 'Entree President', '0999582152', 'happyluvagho@gmail.com', '2024-08-28'),
(2, 'moise ', 'MUHINDO ', 'musa', 'Masculin', 'Organisation', 'Save the Children', 'Word', 'Avance', '2024-08-28', '2024-08-31', 'Mutinga', '0999582152', 'ngabwe2023@gmail.com', '2024-08-28');

--
-- Déclencheurs `user`
--
DELIMITER $$
CREATE TRIGGER `after_insert_user` AFTER INSERT ON `user` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'user';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count + 1 WHERE table_names = 'user';
    ELSE
        INSERT INTO states (table_names, record_count) VALUES ('user', 1);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_user_insert` AFTER INSERT ON `user` FOR EACH ROW BEGIN
    INSERT INTO archive (
        nom, postnom, prenom, sexe, org_privee, 
        Formation, paiement, Date_debut, Date_fin, Lieu, 
        Telephone, Email
    ) 
    VALUES (
        NEW.nom, NEW.postnom, NEW.prenom, NEW.sexe, NEW.org_privee, 
        NEW.Formation, NEW.paiement, NEW.Date_debut, NEW.Date_fin, NEW.Lieu, 
        NEW.Telephone, NEW.Email
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_user_update` AFTER UPDATE ON `user` FOR EACH ROW BEGIN
    INSERT INTO archive (
        nom, postnom, prenom, sexe, org_privee, 
        Formation, paiement, Date_debut, Date_fin, Lieu, 
        Telephone, Email, modified_at
    ) 
    VALUES (
        OLD.nom, OLD.postnom, OLD.prenom, OLD.sexe, OLD.org_privee, 
        OLD.Formation, OLD.paiement, OLD.Date_debut, OLD.Date_fin, OLD.Lieu, 
        OLD.Telephone, OLD.Email, NOW()
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_user` AFTER DELETE ON `user` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'user';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count - 1 WHERE table_names = 'user';
    END IF;
END
$$
DELIMITER ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `administrateur`
--
ALTER TABLE `administrateur`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `archive`
--
ALTER TABLE `archive`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `formations`
--
ALTER TABLE `formations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `administrateur`
--
ALTER TABLE `administrateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `archive`
--
ALTER TABLE `archive`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `formations`
--
ALTER TABLE `formations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `services`
--
ALTER TABLE `services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `states`
--
ALTER TABLE `states`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
