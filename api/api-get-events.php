<?php

$db = require_once (__DIR__.'/../private/db.php');

try{
    
    
  
  }catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }