<?php

$db = require_once (__DIR__.'/../private/db.php');

try{
$q = $db->prepare('SELECT * FROM view_events LIMIT 10');
$q->execute();
$ajRows = $q->fetchAll();
echo json_encode($ajRows);
    
  
  }catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }