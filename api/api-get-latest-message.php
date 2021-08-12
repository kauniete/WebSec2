<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

$iLatestMessageId = $_GET['iLatestMessageId'] ?? 0;

try{
//$q = $db->prepare('CALL getLastMessages(:sendreId, :roomId, :iLatestMessageId)');
$q = $db->prepare('CALL getLastChatMessages(:messageToRoomFk, :iLatestMessageId)');
$q->bindValue(':messageToRoomFk', htmlspecialchars($_GET['room']));
$q->bindValue(':iLatestMessageId', htmlspecialchars($iLatestMessageId));
$q->execute();
$ajData = $q->fetchAll();
header('Content-Type: application/json');
echo json_encode($ajData);

}catch(Exception $ex){
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}

