<?php
$username = $_POST['username'];
$password = $_POST['password'];

if(! (isset($username)) ) { sendError(400, 'Missing username or password', __LINE__); }
if(! (isset($password)) ) { sendError(400, 'Missing username or password', __LINE__); }
if( strlen($_POST['username']) > 50 ){ sendError(400, 'Username cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['password']) > 50 ){ sendError(400, 'Password cannot be longer than 50 characters', __LINE__); }

$dbHandler = require_once (__DIR__.'/../private/db.php');

class LoginHandler {
    static function doGetUserByUsername($db, $userUserName) {
        $q = $db->prepare("
        SELECT *
        FROM users
        WHERE users.userUserName = :userUserName LIMIT 1
        ");
        $q->bindValue(':userUserName', $userUserName);
        $q->execute();
        $aRow = $q->fetchAll();
        if(is_array($aRow) && count($aRow)) {
            return $aRow[0];
        } else {
            return null;
        }
    }

    static function doGetLoginActivity($db, $userUserName) {
        /** @var PDO $db */
        $q = $db->prepare("
        SELECT *
        FROM logtry
        WHERE logtry.userName = :userName LIMIT 1
        ");
        $q->bindValue(':userName', $userUserName);
        $q->execute();
        $aRow = $q->fetchAll();
        if(is_array($aRow) && count($aRow)) {
            return $aRow[0];
        } else {
            return null;
        }
    }

    static function doUnblockUser($db) {
        $tmpDate = new DateTime();
        $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
        /** @var PDO $db */
        $q = $db->prepare("
                    UPDATE logtry
                    SET logtry.logCount = 0, logtry.lastLog = :timeNow
                    WHERE logtry.userName = :userName LIMIT 1
                ");
        $q->bindValue(':userName', $_POST['username']);
        $q->bindValue(':timeNow', $now);
        $q->execute();
    }
    static function doIncrementLoginAttempt($db, $userUserName) {
        $tmpDate = new DateTime();
        $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
        /** @var PDO $db */
        $q = $db->prepare("
                UPDATE logtry
                SET logtry.logCount = logtry.logCount + 1, logtry.lastLog = :timeNow
                WHERE logtry.userName = :userName LIMIT 1
            ");
        $q->bindValue(':userName', $userUserName);
        $q->bindValue(':timeNow', $now);
        $q->execute();
    }
    static function doCreateLoginActivity($db, $userId) {
        $tmpDate = new DateTime();
        $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
        /** @var PDO $db */
        $q = $db->prepare("
                INSERT INTO loggs VALUES(null, :userId, 0, :timeNow);
            ");
        $q->bindValue(':userId', $userId);
        $q->bindValue(':timeNow', $now);
        $q->execute();
    }
}
try {
    // check if the user exists
    $currentUser = LoginHandler::doGetUserByUsername($dbHandler, $_POST['username']);
    if($currentUser === null) {
        header('Content-Type: application/json');
        sendError(400, 'Invalid email or password', __LINE__);
        return;
    }

    $logActivityResults = LoginHandler::doGetLoginActivity($dbHandler, $currentUser->userUserName);

    // If this user never logged in an activity log entry is created
    if($logActivityResults === null) {
        LoginHandler::doCreateLoginActivity($dbHandler, $currentUser->userId);
    } else if (intval($logActivityResults->logCount) >= 3) {
        $lastLoginAttemptStr = $logActivityResults->lastLog;
        $lastLoginAttempt = new DateTime($lastLoginAttemptStr);

        // check if 5 minutes passed since last attempt
        if(!doCheckTimeDiff($lastLoginAttempt)) {
            // send error that the user must wait 5 minutes
            header('Content-Type: application/json');
            sendError(400, 'You have to wait ~5 min, too many failed login attempts', __LINE__);
            return;
        } else {
            LoginHandler::doUnblockUser($dbHandler);
        }
    }

    // hash pepper to the password so it could match
    $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
    $pepper = $aData[0]->key;
    $pwd = $_POST['password'];
    $pwd_peppered = hash_hmac("sha256", $pwd, $pepper);
    $pwd_hashed = $currentUser->userPassword;

    //If current user password and posted password do not match
    if(! password_verify($pwd_peppered, $pwd_hashed) ) {
        LoginHandler::doIncrementLoginAttempt($dbHandler, $currentUser->userUserName);
        header('Content-Type: application/json');
        sendError(400, 'Invalid email or password', __LINE__);
    }

    session_start();
    $_SESSION['userId'] = $currentUser->userId;
    $_SESSION['username'] = $currentUser->userUserName;
    $_SESSION['password'] = $currentUser->userPassword;

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
    $secondDate = new DateTime();

    $diff = $dateTime->diff($secondDate);

    $hours   = intval($diff->format('%h'));
    $minutes = intval($diff->format('%i'));
    $diffInMin = ($hours * 60 + $minutes);

    return $diffInMin >= 5;
}
