<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

try{
  $q = $db->prepare("CALL getUserById(:userId)");
  $q->bindValue(':userId', $_SESSION['userId']);
  $q->execute();
  $ajData = $q->fetchAll();
  header('Content-Type: application/json');
  echo json_encode($ajData);
    
  
  }catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }