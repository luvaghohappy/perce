<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$email = mysqli_real_escape_string($connect, htmlspecialchars($_POST["email"]));
$password = mysqli_real_escape_string($connect, htmlspecialchars($_POST["passwords"]));

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
// Debugging information
error_log("email: $email");
error_log("passwords: $password");

// Requête SQL pour insérer les données dans la table 'formations'
$sql = "INSERT INTO administrateur (email, passwords) VALUES ('$email', '$password')";

if (mysqli_query($connect, $sql)) {
    echo json_encode("success");
} else {
    echo json_encode("failed: " . mysqli_error($connect));
}
?>
