<?php
$pass_error = '';
$username_error = '';
$validation_error = '';
$login_timeout = '';
$psst_error = '';
$verification_error = '';
$exception_error = '';
$login_success = '';
require_once (__DIR__.'/../utils/sendError.php');
//require_once (__DIR__.'/../utils/csrfHelper.php');
require_once (__DIR__.'/../utils/csrf.php');

if ($_POST){
    if(! is_csrf_valid()) {
    $psst_error = 'Your session is invalid, but try to log in again here';
}

$username = htmlspecialchars($_POST['username']);
$password = htmlspecialchars($_POST['password']);

if( ! isset($username)  || empty($username )) { $username_error = 'Missing username'; }
if (! isset($password) || empty($password ) ) { $pass_error = 'Missing password'; }
if( strlen($username) > 50 ){ $username_error = 'Username cannot be longer than 50 characters'; }
if( strlen($password) > 50 ){ $pass_error = 'Password cannot be longer than 50 characters'; }

else { if (! empty($username) && ! empty($password)){
    
    try{
        $dbHandler = require_once (__DIR__.'/../private/db.php');
class LoginHandler {
    static function doGetUserByUsername($db, $userUserName) {
        $q = $db->prepare("CALL getUserByUserName(:userUserName)");
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
        $q = $db->prepare("CALL getUserLog(:userName)");
        $q->bindValue(':userName', $userUserName);
        $q->execute();
        $aRow = $q->fetchAll();
        if(is_array($aRow) && count($aRow)) {
            return $aRow[0];
        } else {
            return null;
        }
    }

    static function doUnblockUser($db, $username) {
        $tmpDate = new DateTime();
        $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
        /** @var PDO $db */
        $q = $db->prepare("CALL updateLogToUnblock(:timeNow, :userName)");
        $q->bindValue(':userName', $username);
        $q->bindValue(':timeNow', $now);
        $q->execute();
    }
    static function doIncrementLoginAttempt($db, $userUserName) {
        $tmpDate = new DateTime();
        $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
        /** @var PDO $db */
        $q = $db->prepare("CALL updateLogToIncrement(:timeNow, :userName)");
        $q->bindValue(':userName', $userUserName);
        $q->bindValue(':timeNow', $now);
        $q->execute();
    }
    static function doCreateLoginActivity($db, $userId) {
        $tmpDate = new DateTime();
        $now = date ('Y-m-d H:i:s', $tmpDate->getTimestamp());
        /** @var PDO $db */
        $q = $db->prepare("CALL createLogs(:userId, :timeNow)");
        $q->bindValue(':userId', $userId);
        $q->bindValue(':timeNow', $now);
        $q->execute();
    }
}

    // check if the user exists
    $currentUser = LoginHandler::doGetUserByUsername($dbHandler, $username);
    if($currentUser === null) {
        $validation_error = 'Invalid login credentials, please try again';
        //return;
    }   else {
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
            //header('Content-Type: application/json');
            //sendError(400, 'You have to wait ~5 min, too many failed login attempts', __LINE__);
            //return;
            $login_timeout = 'You have to wait ~5 min, too many failed login attempts';
        } else {
            LoginHandler::doUnblockUser($dbHandler, $username);
            $login_success = 'You are now allowed to login again!';
        }
    }
    
    else{
    
    // hash pepper to the password so it could match
    $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
    $pepper = $aData[0]->key;
    $pwd = $password;
    $pwd_peppered = hash_hmac("sha256", $pwd, $pepper);
    $pwd_hashed = $currentUser->userPassword;

    //If current user password and posted password do not match
    if( ! password_verify($pwd_peppered, $pwd_hashed) ) {
        LoginHandler::doIncrementLoginAttempt($dbHandler, $currentUser->userUserName);
        $validation_error = 'Invalid login credentials, please try again';}
        
    else{
    if($currentUser->userActive == 1){
        $_SESSION['userId'] = $currentUser->userId;
        $_SESSION['userName'] = $currentUser->userUserName;
        //$_SESSION['password'] = $currentUser->userPassword;
        $_SESSION['userActive'] = $currentUser->userActive;
        $_SESSION['userAvatar'] = $currentUser->userAvatar;
        header('Location: /../home');
    } else {
        $verification_error = 'Please verify your email via this link';
        
    }
}}}} catch (Exception $ex) {
    //echo '{"message":"error '.$ex.'"}';
    $exception_error = 'Something went wrong ';
} }}
    // http_response_code(200); // default is this line
// ############################################################
// ############################################################

}
function doCheckTimeDiff(DateTime $dateTime) {
    $secondDate = new DateTime();

    $diff = $dateTime->diff($secondDate);

    $hours   = intval($diff->format('%h'));
    $minutes = intval($diff->format('%i'));
    $diffInMin = ($hours * 60 + $minutes);

    return $diffInMin >= 5;
}
include (__DIR__.'/../index.php');

