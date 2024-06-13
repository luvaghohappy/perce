<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");

include('conn.php');

$rqt = "SELECT designation FROM formations ORDER BY id desc";
$rqt2 = mysqli_query($connect, $rqt) OR die("Erreur d'exécution de la requête : " . mysqli_error($connect));

$result = array();

while ($fetchData = $rqt2->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
?>
