<?php
$pass_error = '';
$username_error = '';
$validation_error = '';
$login_timeout = '';
$psst_error = '';
$verification_error = '';
$otp_error = '';
$dbHandler = require_once (__DIR__.'/../private/db.php');
require_once (__DIR__.'/../utils/sendError.php');
require_once (__DIR__.'/../utils/csrfHelper.php');

if(! csrfHelper::is_csrf_valid()) {
    $psst_error = 'Your session is invalid, but try to log in again here or from private browser window';
}

$username = htmlspecialchars($_POST['username']);
$password = htmlspecialchars($_POST['password']);
$otpcode = htmlspecialchars($_POST['otp_code']);

if( ! isset($username)  || empty($username )) { $username_error = 'Missing username'; }
if (! isset($password) || empty($password ) ) { $pass_error = 'Missing password'; }
if( strlen($username) > 50 ){ $username_error = 'Username cannot be longer than 50 characters'; }
if( strlen($password) > 50 ){ $pass_error = 'Password cannot be longer than 50 characters'; }
if (! isset($otpcode) || empty($otpcode) ) { $otp_error = 'Missing otp code'; }

else  {
    try{
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
        }    }}
    // check if the user exists
    $currentUser = LoginHandler::doGetUserByUsername($dbHandler, $username);
    if($currentUser === null) {
        $validation_error = 'Invalid login credentials, please try again';
    //return;
    } else {
    
    if($currentUser->userVeryfyCode != $otpcode)
    {$otp_error = 'Invalid otp code, please try again';}
else{

    // hash pepper to the password so it could match
    $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
    $pepper = $aData[0]->key;
    $pwd = $password;
    $pwd_peppered = hash_hmac("sha256", $pwd, $pepper);
    $pwd_hashed = $currentUser->userPassword;
    //If current user password and posted password do not match
    if( ! password_verify($pwd_peppered, $pwd_hashed) ) {
        //LoginHandler::doIncrementLoginAttempt($dbHandler, $currentUser->userUserName);
        $validation_error = 'Invalid login credentials, please try again';
    }
    else{
    $q = $dbHandler->prepare('SELECT * FROM users');
            $q->execute();
            $aUsers = $q->fetchAll();
            //print_r($aUsers);
            for ($i = 0; $i < count($aUsers); $i++) {
                if ($currentUser->userId == $aUsers[$i]->userId){
            $q = $dbHandler->prepare(
                'UPDATE `users` SET `userActive` = :newValue;'
            );
            $q->bindValue('newValue',1);
            $q->execute();  
        }
        }
        $_SESSION['userId'] = $currentUser->userId;
        $_SESSION['userName'] = $currentUser->userUserName;
        $_SESSION['password'] = $currentUser->userPassword;
        $_SESSION['userActive'] = $currentUser->userActive;
        $_SESSION['userAvatar'] = '';
        header('Location: https://localhost/home');
        exit();
     }}}}
    catch (Exception $ex) {
        //echo '{"message":"error '.$ex.'"}';
        $exception_error = 'Something went wrong';
    } }
    include (__DIR__.'/../email-verification.php');
   

