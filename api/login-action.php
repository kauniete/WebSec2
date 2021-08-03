<?php
$pass_error = '';
$username_error = '';
$validation_error = '';
$login_timeout = '';
$psst_error = '';
$verification_error = '';
$exception_error = '';
require_once (__DIR__.'/../utils/sendError.php');
//require_once (__DIR__.'/../utils/csrfHelper.php');
require_once (__DIR__.'/../utils/csrf.php');

if ($_POST){
    if(! is_csrf_valid()) {
    $psst_error = 'Your session is invalid, but try to log in again here or from private browser window';
}

$username = htmlspecialchars($_POST['username']);
$password = htmlspecialchars($_POST['password']);

if( ! isset($username)  || empty($username )) { $username_error = 'Missing username'; }
if (! isset($password) || empty($password ) ) { $pass_error = 'Missing password'; }
if( strlen($username) > 50 ){ $username_error = 'Username cannot be longer than 50 characters'; }
if( strlen($password) > 50 ){ $pass_error = 'Password cannot be longer than 50 characters'; }

else{
    
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
}
//removed timeout for now.indre
    // check if the user exists
    $currentUser = LoginHandler::doGetUserByUsername($dbHandler, $username);
    if($currentUser === null) {
        $validation_error = 'Invalid login credentials, please try again';
        //return;
    } else{
    
    // hash pepper to the password so it could match
    $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
    $pepper = $aData[0]->key;
    $pwd = $password;
    $pwd_peppered = hash_hmac("sha256", $pwd, $pepper);
    $pwd_hashed = $currentUser->userPassword;

    //If current user password and posted password do not match
    if( ! password_verify($pwd_peppered, $pwd_hashed) ) {
        //LoginHandler::doIncrementLoginAttempt($dbHandler, $currentUser->userUserName);
        $validation_error = 'Invalid login credentials, please try again';}
        
    else{
    if($currentUser->userActive == 1){
        $_SESSION['userId'] = $currentUser->userId;
        $_SESSION['userName'] = $currentUser->userUserName;
        //$_SESSION['password'] = $currentUser->userPassword;
        $_SESSION['userActive'] = $currentUser->userActive;
        $_SESSION['userAvatar'] = '';
        header('Location: /../home.php');
    } else {
        $verification_error = 'Please verify your email via this link';
        
    }
}}} catch (Exception $ex) {
    //echo '{"message":"error '.$ex.'"}';
    $exception_error = 'Something went wrong';
} }
    // http_response_code(200); // default is this line
// ############################################################
// ############################################################

}
include (__DIR__.'/../index.php');

