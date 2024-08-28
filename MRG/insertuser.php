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

error_log("nom: $nom");
error_log("postnom: $postnom");
error_log("prenom: $prenom");
error_log("sexe: $sexe");
error_log("org_privee: $org");
error_log("nom_organisation: $nom_organisation");
error_log("Formation: $formation");
error_log("paiement: $paiement");
error_log("Date_debut: $datedebut");
error_log("Date_fin: $datefin");
error_log("Lieu: $lieu");
error_log("Telephone: $telephone");
error_log("Email: $email");

// Requête SQL pour insérer les données dans la table 'users' 
$sql = "INSERT INTO user (nom, postnom, prenom, sexe, org_privee, nom_organisation, Formation, paiement, Date_debut, Date_fin, Lieu, Telephone, Email ) 
VALUES ('$nom', '$postnom', '$prenom', '$sexe', '$org', '$nom_organisation', '$formation', '$paiement', '$datedebut', '$datefin', '$lieu', '$telephone', '$email')";

if(mysqli_query($connect, $sql)){
    echo json_encode("success");
}else{
    echo json_encode("failed");
}
?>
