<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

$iLatestCommentId = $_GET['iLatestCommentId'] ?? 0;

try{
$q = $db->prepare('CALL getLastComments(:iLatestCommentId)');
$q->bindValue(':iLatestCommentId', $iLatestCommentId);
$q->execute();
$ajRows = $q->fetchAll();
echo json_encode($ajRows);

}catch(Exception $ex){
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}
