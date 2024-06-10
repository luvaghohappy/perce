-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 10 juin 2024 à 18:50
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
-- Structure de la table `archive`
--

CREATE TABLE `archive` (
  `id_user` int(11) NOT NULL,
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
  `Email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `Date_Fin` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `formations`
--

INSERT INTO `formations` (`id`, `designation`, `descriptions`, `prix_inscription`, `prix_participation`, `Date_debut`, `Date_Fin`) VALUES
(1, 'Excel', 'logiciel de traitement de tableaux', '10 $', '50 $', '2024-06-10', '2024-06-20'),
(2, 'Word', 'logiciel de saisi de texte', '5 $', '10 $', '2024-06-10', '2024-06-26');

--
-- Déclencheurs `formations`
--
DELIMITER $$
CREATE TRIGGER `after_formations_delete` AFTER DELETE ON `formations` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'formations';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count - 1, last_updated = CURRENT_TIMESTAMP WHERE table_names = 'formations';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_formations_insert` AFTER INSERT ON `formations` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'formations';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count + 1, last_updated = CURRENT_TIMESTAMP WHERE table_names = 'formations';
    ELSE
        INSERT INTO states (table_names, record_count) VALUES ('formations', 1);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `months`
--

CREATE TABLE `months` (
  `id` int(11) NOT NULL,
  `table_names` varchar(100) NOT NULL,
  `record_count` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 'Coaching', 'formation personnelle', 'disponible'),
(2, 'Soutien', 'formation personnelle', 'disponible');

--
-- Déclencheurs `services`
--
DELIMITER $$
CREATE TRIGGER `after_services_delete` AFTER DELETE ON `services` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'services';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count - 1, last_updated = CURRENT_TIMESTAMP WHERE table_names = 'services';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_services_insert` AFTER INSERT ON `services` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'services';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count + 1, last_updated = CURRENT_TIMESTAMP WHERE table_names = 'services';
    ELSE
        INSERT INTO states (table_names, record_count) VALUES ('services', 1);
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
  `table_names` varchar(250) DEFAULT NULL,
  `record_count` int(11) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `states`
--

INSERT INTO `states` (`id`, `table_names`, `record_count`, `last_updated`) VALUES
(1, 'user', 1, '2024-06-10 09:57:42'),
(2, 'formations', 2, '2024-06-10 10:47:34'),
(3, 'services', 2, '2024-06-10 12:05:57');

--
-- Déclencheurs `states`
--
DELIMITER $$
CREATE TRIGGER `end_of_month_trigger` AFTER INSERT ON `states` FOR EACH ROW BEGIN
    DECLARE end_of_month DATE;
    DECLARE table_name_value VARCHAR(250);
    DECLARE record_count_value INT;

    -- Récupération de la fin du mois
    SET end_of_month = LAST_DAY(CURRENT_DATE);

    -- Récupération des valeurs à insérer
    SELECT table_names, record_count INTO table_name_value, record_count_value
    FROM states
    WHERE id = NEW.id;

    -- Insertion dans la table month
    INSERT INTO months (table_names, record_count, last_updated)
    VALUES (table_name_value, record_count_value, end_of_month);
END
$$
DELIMITER ;

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
  `Email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `nom`, `postnom`, `prenom`, `sexe`, `org_privee`, `nom_organisation`, `Formation`, `paiement`, `Date_debut`, `Date_fin`, `Lieu`, `Telephone`, `Email`) VALUES
(2, 'happy', 'luvagho', 'furaha', 'Feminin', 'Privée', '', 'Excel', 'Solde', '2024-06-10', '2024-06-20', 'MRG', '+243999582152', 'happy@gmail.com');

--
-- Déclencheurs `user`
--
DELIMITER $$
CREATE TRIGGER `after_users_delete` AFTER DELETE ON `user` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'user';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count - 1, last_updated = CURRENT_TIMESTAMP WHERE table_names = 'user';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_users_insert` AFTER INSERT ON `user` FOR EACH ROW BEGIN
    DECLARE table_exists INT;
    SELECT COUNT(*) INTO table_exists FROM states WHERE table_names = 'user';
    
    IF table_exists > 0 THEN
        UPDATE states SET record_count = record_count + 1, last_updated = CURRENT_TIMESTAMP WHERE table_names = 'user';
    ELSE
        INSERT INTO states (table_names, record_count) VALUES ('user', 1);
    END IF;
END
$$
DELIMITER ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `archive`
--
ALTER TABLE `archive`
  ADD PRIMARY KEY (`id_user`);

--
-- Index pour la table `formations`
--
ALTER TABLE `formations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `months`
--
ALTER TABLE `months`
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
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `table_names` (`table_names`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `archive`
--
ALTER TABLE `archive`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `formations`
--
ALTER TABLE `formations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `months`
--
ALTER TABLE `months`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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

DELIMITER $$
--
-- Évènements
--
CREATE DEFINER=`root`@`localhost` EVENT `move_to_archive` ON SCHEDULE EVERY 1 DAY STARTS '2024-06-10 17:32:23' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_nom VARCHAR(100);
    DECLARE v_postnom VARCHAR(100);
    DECLARE v_prenom VARCHAR(100);
    DECLARE v_sexe VARCHAR(50);
    DECLARE v_org_privee VARCHAR(100);
    DECLARE v_nom_organisation VARCHAR(100);
    DECLARE v_Formation VARCHAR(100);
    DECLARE v_paiement VARCHAR(150);
    DECLARE v_Date_debut DATE;
    DECLARE v_Date_fin DATE;
    DECLARE v_Lieu VARCHAR(100);
    DECLARE v_Telephone VARCHAR(50);
    DECLARE v_Email VARCHAR(100);

    -- Curseur pour sélectionner les enregistrements à supprimer
    DECLARE cur CURSOR FOR 
        SELECT id, nom, postnom, prenom, sexe, org_privee, nom_organisation, Formation, paiement, Date_debut, Date_fin, Lieu, Telephone, Email 
        FROM user 
        WHERE Date_fin = CURRENT_DATE;

    -- Gestion des conditions de fin de curseur
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    -- Boucle pour traiter chaque ligne du curseur
    read_loop: LOOP
        FETCH cur INTO v_id, v_nom, v_postnom, v_prenom, v_sexe, v_org_privee, v_nom_organisation, v_Formation, v_paiement, v_Date_debut, v_Date_fin, v_Lieu, v_Telephone, v_Email;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insérer dans archive
        INSERT INTO archive (id, nom, postnom, prenom, sexe, org_privee, nom_organisation, Formation, paiement, Date_debut, Date_fin, Lieu, Telephone, Email) 
        VALUES (v_id, v_nom, v_postnom, v_prenom, v_sexe, v_org_privee, v_nom_organisation, v_Formation, v_paiement, v_Date_debut, v_Date_fin, v_Lieu, v_Telephone, v_Email);
        
        -- Supprimer de user
        DELETE FROM user WHERE id = v_id;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
