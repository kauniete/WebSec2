<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: login.php');
}
$_SESSION['userId'] = 1; // For testing via postman, delete later

$db = require_once (__DIR__.'/../private/db.php');

$iLatestEventId = $_GET['iLatestEventId'] ?? 0;

try{
    $q = $db->prepare('CALL getLastEvents(:iLatestEventId)');
    $q->bindValue(':iLatestEventId', $iLatestEventId);
    $q->execute();
    $ajRows = $q->fetchAll();
    echo json_encode($ajRows);

}catch(Exception $ex){
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
}
