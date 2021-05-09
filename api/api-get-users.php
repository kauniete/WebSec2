<?php

$db = require_once (__DIR__.'/../private/db.php');

try{
$q = $db->prepare('SELECT userId, userUserName, userAvatar, userAbout, userActive, userCity, userLanguage  
                   FROM view_users LIMIT 10');
$q->execute();
$ajRows = $q->fetchAll();
echo json_encode($ajRows); 
  
  }catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }