<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération de la valeur de 'id' et protection contre les attaques XSS
$id = htmlspecialchars($_POST['id']);

// Requête pour récupérer le chemin de l'image
$image_query = "SELECT image_path FROM formations WHERE id = ?";
$stmt = $connect->prepare($image_query);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();
$image_path = $row['image_path'];

// Vérifier si l'image existe et la supprimer
if ($image_path && file_exists($image_path)) {
    unlink($image_path);
}

// Requête de suppression dans la table 'formations' où 'id' correspond à la valeur récupérée
$sql = "DELETE FROM formations WHERE id = ?";
$stmt = $connect->prepare($sql);
$stmt->bind_param("i", $id);

// Exécution de la requête de suppression
if ($stmt->execute()) {
    echo json_encode(array("status" => "success", "message" => "Suppression réussie."));
} else {
    echo json_encode(array("status" => "failed", "error" => "Erreur lors de la suppression : " . $connect->error));
}

$stmt->close();
$connect->close();
?>
