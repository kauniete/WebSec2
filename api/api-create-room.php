<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');


try{
  $q = $db->prepare('INSERT INTO rooms (roomId, roomOwnerFk, user2Fk, roomName, user2Avatar, user2Nick,roomOwnerNick,roomOwnerAvatar)
  VALUES (:roomId, :roomOwner, :user2, :roomName, :user2Avatar, :user2Nick,:roomOwnerNick, :roomOwnerAvatar)');
  $q->bindValue('roomId', null);
  $q->bindValue('roomOwner', $_SESSION['userId']);
  $q->bindValue('user2', htmlspecialchars($_GET['to']));
  $q->bindValue('roomName', null);
  $q->bindValue('user2Avatar', htmlspecialchars($_GET['img']));
  $q->bindValue('user2Nick', htmlspecialchars($_GET['nick']));
  $q->bindValue('roomOwnerNick', $_SESSION['userName']);
  $q->bindValue('roomOwnerAvatar', $_SESSION['userAvatar']);
  $q->execute();
  $iLastInsertedId = $db->lastInsertId();
  echo $iLastInsertedId;

}catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }
  