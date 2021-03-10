<?php

$username = $_POST['username'];
$password = $_POST['password'];

if(! (isset($username)) ) { sendError(400, 'Missing username or password', __LINE__); }
if(! (isset($password)) ) { sendError(400, 'Missing username or password', __LINE__); }
if( strlen($_POST['username']) < 4 ){ sendError(400, 'Username must be at least 4 characters long', __LINE__); }
if( strlen($_POST['password']) < 10 ){ sendError(400, 'Password must be at least 10 characters long', __LINE__); }
if( strlen($_POST['username']) > 50 ){ sendError(400, 'Username cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['password']) > 50 ){ sendError(400, 'Password cannot be longer than 50 characters', __LINE__); }

require_once (__DIR__.'/../private/db.php');

try {
    // check if the credentials exist
    $q = $db->prepare("
        SELECT *
        FROM users
        WHERE users.username = :username LIMIT 1
        ");
    $q->bindValue(':username', $_POST['username']);
    $q->execute();
    $aRow = $q->fetchAll();

    if($q->rowCount() === 1) {
        header('Content-Type: application/json');
        sendError(400, 'Username is taken', __LINE__);
        return;
    }


    $q = $db->prepare('
        INSERT INTO users
        VALUES(null, :username, :password)
        ');
    $q->bindValue(':username', $_POST['username']);
    $q->bindValue(':password', password_hash($_POST['password'], PASSWORD_DEFAULT));

    $q->execute();

    echo 'you are signed up now!';

} catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
}

// ############################################################
// ############################################################
function sendError($iErrorCode, $sMessage, $iLine){
    http_response_code($iErrorCode);
    header('Content-Type: application/json');
    echo '{"message":"'.$sMessage.'", "error":"'.$iLine.'"}';
    exit();
}

function doCheckTimeDiff(DateTime $dateTime) {
    $secondDate = new \DateTime();

    $diff = $dateTime->diff($secondDate);

    $hours   = intval($diff->format('%h'));
    $minutes = intval($diff->format('%i'));
    $diffInMin = ($hours * 60 + $minutes);

    return $diffInMin >= 5;
}