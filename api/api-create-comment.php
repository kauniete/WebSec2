<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: login.php');
}
$_SESSION['userId'] = 1; // For testing via postman, delete later

$db = require_once (__DIR__.'/../private/db.php');

try{
  if(!isset($_POST['commentText']) ){ http_status_code(400);  }
  if(strlen($_POST['commentText']) < 1 ){ http_status_code(400);  }
  if(strlen($_POST['commentText']) > 280 ){ http_status_code(400);  }

  $text = $_POST['commentText'];

  $q = $db->prepare("CALL createComment(:eventId, :userId, :commentText)");
  $q->bindValue(':eventId', htmlspecialchars($_POST['eventId']));
  $q->bindValue(':userId', $_SESSION['userId']);
  $q->bindValue(':commentText', htmlspecialchars($text));
  $q->execute();
  $iLastInsertedId = $db->lastInsertId();
  echo $iLastInsertedId;

}catch (Exception $ex) {
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}
