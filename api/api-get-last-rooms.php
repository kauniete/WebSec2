<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

//$iLatestRoomId = $_GET['room'] ?? 0;

try{
//$q = $db->prepare('CALL getLastRooms(:iLatestRoomId, :ownerId)');
//$q = $db->prepare('SELECT * FROM rooms WHERE roomId=:iLatestRoomId AND roomOwnerFk=:ownerId');
$q = $db->prepare('SELECT * FROM rooms WHERE roomOwnerFk=:chatter OR user2Fk=:chatter');
//$q->bindValue(':iLatestRoomId', $iLatestRoomId);
$q->bindValue(':chatter', $_SESSION['userId']);
$q->execute();
$ajRows = $q->fetchAll();
header('Content-Type: application/json');
echo json_encode($ajRows);

}catch(Exception $ex){
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}



// $q = $db->prepare('INSERT INTO rooms (roomId, roomOwnerFk, user2, roomName, user2Avatar, user2Nick)
// VALUES (:roomId, :roomOwner, :user2, :roomName, :user2Avatar, :user2Nick)');
// $q->bindValue('roomId', null);