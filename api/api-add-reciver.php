<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

try{
  $q = $db->prepare("CALL addRecieverToRoom(:roomId, :toUserId)");
  $q->bindValue(':roomId', $_GET['room']);
  $q->bindValue(':toUserId', $_GET['to']);
  $q->execute();
  $ajData = $q->fetchAll();
  header('Content-Type: application/json');
  echo json_encode($ajData);

}catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }
