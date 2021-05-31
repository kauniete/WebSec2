<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

try{
  $q = $db->prepare('INSERT INTO rooms (roomId, roomOwnerFk, roomName)
  VALUES (:roomId, :roomOwner, :roomName)');
  $q->bindValue('roomId', null);
  $q->bindValue('roomOwner', $_SESSION['userId']);
  $q->bindValue('roomName', null);
  $q->execute();
  $iLastInsertedId = $db->lastInsertId();
  echo $iLastInsertedId;

}catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }
