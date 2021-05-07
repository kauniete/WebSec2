<?php

$db = require_once (__DIR__.'/../private/db.php');

$iLatestCommentId = $_GET['iLatestCommentId'] ?? 0;

try{
$q = $db->prepare('SELECT * FROM comments WHERE commentId > :iLatestCommentId LIMIT 25');
$q->bindValue(':iLatestCommentId', $iLatestCommentId);
$q->execute();
$ajRows = $q->fetchAll();
echo json_encode($ajRows);

}catch(Exeption $ex){
  header('Content-Type: application/json');
  echo '{"message":"error '.$ex.'"}';
}

//echo '[{"id":1, "message": "Hi"}, {"id":2, "message": "Hello"}]';
//echo '[[1, "Hi"], [2, "Hello"]]';