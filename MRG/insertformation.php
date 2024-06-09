<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$design = htmlspecialchars($_POST["designation"]);
$descr = htmlspecialchars($_POST["descriptions"]);
$prix_inscr = htmlspecialchars($_POST["prix_inscription"]);
$prix_partic = htmlspecialchars($_POST["prix_participation"]);
$date_debut = htmlspecialchars($_POST["Date_debut"]);
$date_fin = htmlspecialchars($_POST["Date_Fin"]);

// Debugging information
error_log("designation: $design");
error_log("descriptions: $descr");
error_log("prix_inscription: $prix_inscr");
error_log("prix_participation: $prix_partic");
error_log("Date_debut: $date_debut");
error_log("Date_Fin: $date_fin");


// Requête SQL pour insérer les données dans la table 'formations'
$sql = "INSERT INTO formations (designation, descriptions,prix_inscription,prix_participation,Date_debut,Date_Fin ) 
VALUES ('$design', '$descr','$prix_inscr','$prix_partic','$date_debut','$date_fin')";

if (mysqli_query($connect, $sql)) {
    echo json_encode("success");
} else {
    echo json_encode("failed");
}
?>
