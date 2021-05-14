<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

try{
$q = $db->prepare('CALL getAllUsers()');
$q->execute();
$ajRows = $q->fetchAll();
echo json_encode($ajRows); 
  
  }catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }