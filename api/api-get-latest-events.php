<?php

$db = require_once (__DIR__.'/../private/db.php');

$iLatestEventId = $_GET['iLatestEventId'] ?? 0;

try{
    $q = $db->prepare('SELECT * FROM events WHERE eventId > :iLatestEventId LIMIT 25');
    $q->bindValue(':iLatestEventId', $iLatestEventId);
    $q->execute();
    $ajRows = $q->fetchAll();
    echo json_encode($ajRows);

}catch(Exception $ex){
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
}

//echo '[{"id":1, "message": "Hi"}, {"id":2, "message": "Hello"}]';
//echo '[[1, "Hi"], [2, "Hello"]]';