<?php

session_start();
if( ! isset($_SESSION['userId']) ){
  header('Location: ../index.php');
}

$db = require_once (__DIR__.'/../private/db.php');

function is_csrf_valid(){
  if(session_status() == 1){ session_start(); }
  if( ! isset($_SESSION['csrf']) || ! isset($_POST['csrf'])){ return false; }
  if( $_SESSION['csrf'] != $_POST['csrf']){ return false; }
  return true;
}

try{
  if(!isset($_POST['messageText']) ){ http_response_code(400);  }
  if(strlen($_POST['messageText']) < 1 ){ http_response_code(400);  }
  if(strlen($_POST['messageText']) > 640 ){ http_response_code(400);  }

  $q = $db->prepare("INSERT INTO messages (messageFromUserFk, messageToRoomFk, messageText, messageImg)
  VALUES (:senderId, :roomId, :messageText, :messageImg)");
  $q->bindValue(':senderId', $_SESSION['userId']);
  $q->bindValue(':roomId', htmlspecialchars($_POST['roomId']));
  $q->bindValue(':messageText', htmlspecialchars($_POST['messageText']));
  $q->bindValue(':messageImg', 'default_profile_reasonably_small');
  $q->execute();
  $iLastInsertedId = $db->lastInsertId();
  echo $iLastInsertedId;
  


}catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
  }
