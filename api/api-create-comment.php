<?php

session_start();
$_SESSION['userId'] = 1; // For testing via postman, delete later

$db = require_once (__DIR__.'/../private/db.php');

try{
  if(!isset($_POST['comment']) ){ http_status_code(400);  }
  if(strlen($_POST['comment']) < 1 ){ http_status_code(400);  }
  if(strlen($_POST['comment']) > 280 ){ http_status_code(400);  }

  $text = $_POST['comment'];

  $q = $db->prepare("INSERT INTO comments (commentEventFk, commentUserFk, commentText) 
  VALUES (:commentEventFk, :commentUserFk, :commentText)");
  $q->bindValue(':commentEventFk', 1);
  $q->bindValue(':commentUserFk', $_SESSION['userId']);
  $q->bindValue(':commentText', htmlspecialchars($text));
  $q->execute();
  $iLastInsertedId = $db->lastInsertId();
  echo $iLastInsertedId;

}catch (Exception $ex) {
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}
