<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$nom = htmlspecialchars($_POST["nom"]);
$postnom = htmlspecialchars($_POST["postnom"]);
$prenom = htmlspecialchars($_POST["prenom"]);
$sexe = htmlspecialchars($_POST["sexe"]);
$org = htmlspecialchars($_POST["org_privee"]);
$nom_organisation = ($org === 'Organisation') ? htmlspecialchars($_POST["nom_organisation"]) : '';
$formation = htmlspecialchars($_POST["Formation"]);
$paiement = htmlspecialchars($_POST["paiement"]);
$datedebut = htmlspecialchars($_POST["Date_debut"]);
$datefin = htmlspecialchars($_POST["Date_fin"]);
$lieu = htmlspecialchars($_POST["Lieu"]);
$telephone = htmlspecialchars($_POST["Telephone"]);
$email = htmlspecialchars($_POST["Email"]);

// Requête SQL pour insérer les données dans la table 'users' 
$sql = "INSERT INTO users (nom, postnom, prenom, sexe, org_privee, nom_organisation, Formation, paiement, Date_debut, Date_fin, Lieu, Telephone, Email ) 
VALUES ('$nom', '$postnom', '$prenom', '$sexe', '$org', '$nom_organisation', '$formation', '$paiement', '$datedebut', '$datefin', '$lieu', '$telephone', '$email')";

if(mysqli_query($connect, $sql)){
    echo json_encode("success");
}else{
    echo json_encode("failed");
}
?>
