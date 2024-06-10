<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$design = mysqli_real_escape_string($connect, htmlspecialchars($_POST["designation"]));
$descr = mysqli_real_escape_string($connect, htmlspecialchars($_POST["descriptions"]));
$detaille = mysqli_real_escape_string($connect, htmlspecialchars($_POST["detaille"]));

// Debugging information
error_log("designation: $design");
error_log("descriptions: $descr");
error_log("detaille: $detaille");

// Requête SQL pour insérer les données dans la table 'formations'
$sql = "INSERT INTO services (designation, descriptions, detaille) VALUES ('$design', '$descr', '$detaille')";

if (mysqli_query($connect, $sql)) {
    echo json_encode("success");
} else {
    echo json_encode("failed: " . mysqli_error($connect));
}
?>
