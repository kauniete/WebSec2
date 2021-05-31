<?php


require_once (__DIR__.'/../utils/csrfHelper.php');
require_once (__DIR__.'/../utils/sendError.php');




$db = require_once (__DIR__.'./../private/db.php');

try{
    $q=$db->prepare('SELECT * FROM galeries');
    $q->execute();
    
    $ajData = $q->fetchAll();
    echo json_encode($ajData);
    header('Content-Type: application/json');
  
  





}catch(Exception $ex){
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
}
