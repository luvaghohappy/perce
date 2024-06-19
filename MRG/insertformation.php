<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

$design = htmlspecialchars($_POST["designation"]);
$descr = htmlspecialchars($_POST["descriptions"]);
$prix_inscr = htmlspecialchars($_POST["prix_inscription"]);
$prix_partic = htmlspecialchars($_POST["prix_participation"]);
$date_debut = htmlspecialchars($_POST["Date_debut"]);
$date_fin = htmlspecialchars($_POST["Date_Fin"]);

if (empty($design) || empty($descr) || empty($prix_inscr) || empty($prix_partic) || empty($date_debut) || empty($date_fin)) {
    echo json_encode(array("status" => "failed", "error" => "All fields are required."));
    exit;
}
$target_dir = "uploads/";
$target_file = $target_dir . basename($_FILES["image"]["name"]);
$imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

$check = getimagesize($_FILES["image"]["tmp_name"]);
if($check !== false) {
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        $stmt = $connect->prepare("INSERT INTO formations (designation, descriptions, prix_inscription, prix_participation, Date_debut, Date_Fin, image_path) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("sssssss", $design, $descr, $prix_inscr, $prix_partic, $date_debut, $date_fin, $target_file);

        if ($stmt->execute()) {
            echo json_encode(array("status" => "success"));
        } else {
            echo json_encode(array("status" => "failed", "error" => $stmt->error));
        }
        $stmt->close();
    } else {
        echo json_encode(array("status" => "failed", "error" => "Sorry, there was an error uploading your file."));
    }
} else {
    echo json_encode(array("status" => "failed", "error" => "File is not an image."));
}

$connect->close();
?>
