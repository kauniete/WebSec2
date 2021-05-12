<?php
session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: login.php');
}
$_SESSION['userId'] = 1; // For testing via postman, delete later

$db = require_once (__DIR__.'/../private/db.php');

try{

  $q = $db->prepare('CALL deleteComment(:commentId, :userId)');
  $q->bindValue(':userId', $_SESSION['userId']);
  $q->bindValue(':commentId', $_GET['commentId']);
  $q->execute();
  if($q->rowCount() == 0){
    sendError(500, 'comment cannot be deleted', __LINE__);
}
    header('Content-Type: application/json');
    echo '{"message":"comment deleted", "id": "'.$_GET['commentId'].'"}';
    exit();
  
  }catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }

