<?php
try{
  $dbUserName = 'admin';
  $dbPassword = 's-fg-G*_9.U]VHeA'; // root | admin
//  $dbUserName = 'root';
//  $dbPassword = ''; // root | admin
  $dbConnection = 'mysql:host=localhost; dbname=websec; charset=utf8mb4';
  $options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // try-catch
    // PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC 
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ
    // PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_NUM // [[],[],[]]
  ];
    return new PDO(  $dbConnection,
                    $dbUserName,
                    $dbPassword ,
                    $options );
}catch(PDOException $ex){
  echo $ex;
  echo 'error';
  exit();
}














