<?php

$username = $_POST['username'];
$password = $_POST['password'];

if(! (isset($username)) ) { sendError(400, 'Missing username or password', __LINE__); }
if(! (isset($password)) ) { sendError(400, 'Missing username or password', __LINE__); }
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

    // hash pepper to the password so it could match
    $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
    $pepper = $aData[0]->key;
    $pwd = $_POST['password'];
    $pwd_peppered = hash_hmac("sha256", $pwd, $pepper);
    $pwd_hashed = $aRow[0]->password;

    if(! password_verify($pwd_peppered, $pwd_hashed) ) {
        // check if the login failed 3 times
        $q = $db->prepare("
            SELECT loginattempts.attempts, loginattempts.lastLogin
            FROM users
            INNER JOIN loginattempts ON users.id = loginattempts.user_fk
            WHERE users.username = :username AND loginattempts.attempts = 3
        ");
        $q->bindValue(':username', $_POST['username']);
        $q->execute();
        $aRow = $q->fetchAll();

        if($q->rowCount() === 1) {
            // check if the login failed 3 times and 5 minutes passed since last attempt
            $lastLoginAttemptStr = $aRow[0]->lastLogin;
            $lastLoginAttempt = new DateTime($lastLoginAttemptStr);

            if(!doCheckTimeDiff($lastLoginAttempt)) {
                // send error that the user must wait 5 minutes
                header('Content-Type: application/json');
                sendError(400, 'You have to wait ~5 min, too many failed login attempts', __LINE__);
                return;
            } else {
                // if 5 minutes passed since the last update, reset the login attempts
                $tmpDate = new DateTime();
                $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
                $q = $db->prepare("
                    UPDATE users
                    INNER JOIN loginattempts ON users.id = loginattempts.user_fk
                    SET loginattempts.attempts = 0, loginattempts.lastLogin = :timeNow
                    WHERE users.username = :username LIMIT 1
                ");
                $q->bindValue(':username', $_POST['username']);
                $q->bindValue(':timeNow', $now);
                $q->execute();
            }
        } else {
            // if login fails, add to the user a failed login attempt
            $tmpDate = new DateTime();
            $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
            $q = $db->prepare("
                UPDATE users
                INNER JOIN loginattempts ON users.id = loginattempts.user_fk
                SET loginattempts.attempts = loginattempts.attempts + 1, loginattempts.lastLogin = :timeNow
                WHERE users.username = :username LIMIT 1
            ");
            $q->bindValue(':username', $_POST['username']);
            $q->bindValue(':timeNow', $now);
            $q->execute();
            header('Content-Type: application/json');
            echo json_encode($q->rowCount());
        }

        sendError(400, 'Invalid email or password', __LINE__);
    }

    session_start();
    $_SESSION['userId'] = $aRow[0]->id;
    $_SESSION['username'] = $aRow[0]->username;
    $_SESSION['password'] = $aRow[0]->password;

    http_response_code(200); // default is this line
    header('Content-Type: application/json');

    echo 'you are logged in!';

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
