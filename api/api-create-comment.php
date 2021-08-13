<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');
function is_csrf_valid(){
  if(session_status() == 1){ session_start(); }
  if( ! isset($_SESSION['csrf']) || ! isset($_POST['csrf'])){ return false; }
  if( $_SESSION['csrf'] != $_POST['csrf']){  return false; }
  return true;
}
if ($_POST){
if(! is_csrf_valid()) {
  http_response_code(400);}

try{
  if(!isset($_POST['commentText']) ){ http_response_code(400);  }
  if(strlen($_POST['commentText']) < 1 ){ http_response_code(400);  }
  if(strlen($_POST['commentText']) > 280 ){ http_response_code(400);  }
  

  $eventId = $_POST['eventId'];
  $text = $_POST['commentText'];

  $q = $db->prepare("INSERT INTO comments (commentEventFk, commentUserFk, commentText) 
  VALUES (:eventId, :userId, :commentText)");
  $q->bindValue(':eventId', htmlspecialchars($eventId));
  $q->bindValue(':userId', $_SESSION['userId']);
  $q->bindValue(':commentText', htmlspecialchars($text));
  $q->execute();
  $iLastInsertedId = $db->lastInsertId();
  echo $iLastInsertedId;

}catch (Exception $ex) {
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}}