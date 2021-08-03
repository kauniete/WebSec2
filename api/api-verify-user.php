
<?php
$verification_error = '';
$psst_error = '';
$exception_error = '';
    //require_once (__DIR__.'/../utils/csrfHelper.php');
    require_once (__DIR__.'/../utils/csrf.php');

    if ($_POST){
        if(! is_csrf_valid()) {
        //require_once (__DIR__.'/../utils/sendError.php');
        $psst_error ='Your session is invalid, but try to log in again here or from private browser window';
    }
    $otpcode = htmlspecialchars($_POST['otp_code']);
    if(! isset($otpcode) || empty($otpcode) ) { $verification_error = 'Missing OTP code'; } 
    else{
        try{
        $otp_num = $_SESSION['vKey'];
        $email = $_SESSION['email'];
        $otp = htmlspecialchars($_POST['otp_code']);
        if($otp_num != $otp){
            $verification_error = 'Invalid token. Please try again';}
            else {
            $db = require_once (__DIR__.'./../private/db.php');
            $q = $db->prepare(
                'SELECT * FROM users'
            );
            $q->execute();
            $aUsers = $q->fetchAll();
            //print_r($aUsers);
            for ($i = 0; $i < count($aUsers); $i++) {
                if ($_SESSION['userId'] == $aUsers[$i]->userId){
            $q = $db->prepare(
                'UPDATE `users` SET `userActive` = :newValue;'
            );
            $q->bindValue('newValue',1);
            $q->execute();
            //header('Location: /../home.php');
            header('Location: /../home');
            exit();}
        }}} 
        catch (Exception $ex) {
            //echo '{"message":"error '.$ex.'"}';
            $exception_error = 'Something went wrong';
        }}
    }
        include (__DIR__.'/../verify-user.php');