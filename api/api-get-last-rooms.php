<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

$iLatestRoomId = $_GET['room'] ?? 0;

try{
$q = $db->prepare('CALL getLastRooms(:iLatestRoomId, :ownerId)');
$q->bindValue(':iLatestRoomId', $iLatestRoomId);
$q->bindValue(':ownerId', $_SESSION['userId']);
$q->execute();
$ajRows = $q->fetchAll();
echo json_encode($ajRows);

}catch(Exception $ex){
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}
