<?php

session_start();
$_SESSION['userId'] = 1; // For testing via postman, delete later

$db = require_once (__DIR__.'/../private/db.php');

try{
  $q = $db->prepare("SELECT * FROM view_users WHERE userId = :userId LIMIT 1");
  $q->bindValue(':userId', $_SESSION['userId']);
  $q->execute();
  $ajData = $q->fetchAll();
  header('Content-Type: application/json');
  echo json_encode($ajData);
    
  
  }catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }