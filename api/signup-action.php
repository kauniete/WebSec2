<?php
$pass_error = '';
$username_error = '';
$validation_error = '';
$email_error = '';
$login_timeout = '';
$psst_error = '';
$verification_error = '';
$exception_error = '';
$pass_validation_error ='';
$email_validation_error ='';
//require_once (__DIR__.'/../utils/csrfHelper.php');
require_once (__DIR__.'/../utils/csrf.php');
require_once (__DIR__.'/../utils/sendError.php');
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

if ($_POST){
if(! is_csrf_valid()) {
  $psst_error ='Your session is invalid, but try to sign up again here';}


///if (isset($_POST['submit'])){
$username = htmlspecialchars($_POST['username']);
$password = htmlspecialchars($_POST['password']);
$email = htmlspecialchars($_POST['email']);

if(! isset($username) || empty($username) ) { $username_error = 'Missing username'; }
if(! isset($password) || empty($password) ) { $pass_error = 'Missing password'; }
if( strlen($username) < 4 ){ $username_error ='Username must be at least 4 characters long'; }
if( strlen($password) < 10 ){  $pass_error ='Password must be at least 10 characters long'; }
if( strlen($username) > 50 ){ $username_error = 'Username cannot be longer than 50 characters'; }
if( strlen($password) > 50 ){  $pass_error = 'Password cannot be longer than 50 characters'; }
if( strlen($email) > 50 ){ $email_error ='Email cannot be longer than 50 characters'; }
if( strlen($email) < 3 ){ $email_error = 'Email must be at least 3 characters long'; }
// Check email format
if( ! filter_var(  $_POST['email'],  FILTER_VALIDATE_EMAIL  )){ 
    $email_error = 'Email is not valid';
    //exit();
}
    
// Check password format
if(! $password == preg_match('/(?=.*\d)(?=.*[A-Z])(?=.*[a-z]).{10,}/', $password)){
    $pass_error = 'Password need to contain at least 10 characters, 1 uppercase letter, 1 lowercase letter and 1 digit';
    //exit();
} 
else{
try {  
    $db = require_once (__DIR__.'./../private/db.php');
    $q = $db->prepare("CALL getUserByEmail(:userEmail)");
    $q->bindValue(':userEmail', $email);
    $q->execute();
    $aRow = $q->fetchAll();
    if($q->rowCount() === 1) {
        $validation_error = 'Invalid signup credentials, please try again';
        //return;
    } else {
        $q = $db->prepare("CALL getUserByUserName(:userUserName)");
    $q->bindValue(':userUserName', $username);
    $q->execute();
    $aRow = $q->fetchAll();
    
    if($q->rowCount() === 1) {
        $validation_error = 'Invalid signup credentials, please try again';
        //return;
    }else {
    if ( ! empty($username)  &&  ! empty ($password)  &&  strlen($username) >= 4 &&  strlen($password) >= 10 && strlen($username) <= 50 && strlen($password) <= 50 && filter_var(  $_POST['email'],  FILTER_VALIDATE_EMAIL) ){
    $vKey = md5(time());
    // adding hash, salt and pepper to the password
    $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
    $pepper = $aData[0]->key;
    $pwd = htmlspecialchars($_POST['password']);
    $pwd_peppered = hash_hmac("sha256", $pwd, $pepper); // hashing the password and adding a pepper
    $pwd_hashed = password_hash($pwd_peppered, PASSWORD_BCRYPT); // hashing again and keep in mind that salt is now added by default with password_hash

    $q=$db->prepare('INSERT INTO users (userId, userFullName, userUserName, userEmail, userPassword, userVeryfyCode, userActive,userAvatar)
    VALUES(:userId, :userFullName, :userUserName, :userEmail, :userPassword, :userVerifyCode, :userActive, :userAvatar)');

    $q->bindValue(':userId', null);
    $q->bindValue(':userFullName', 'test');
    $q->bindValue(':userUserName', $username);
    $q->bindValue(':userEmail', $email);
    $q->bindValue(':userPassword', $pwd_hashed);
    $q->bindValue(':userVerifyCode', $vKey);
    $q->bindValue(':userActive', 0);
    $q->bindValue(':userAvatar', 'default_profile_reasonably_small');

    // echo $last_id;
    // $last_id= mysqli_insert_id($conn);
    // $url = 'https://localhost/Second Semester/WebSec/ExamProject/api/signup-action.php?id='.$last_id.'$token='.$vKey;
    // $output = '<div>Please click the link'.$url.'</div>';

   $q->execute();

// require_once ("../PHPMailer/class.phpmailer.php");

require (__DIR__.'/../PHPMailer/src/Exception.php');
require (__DIR__.'/../PHPMailer/src/PHPMailer.php');
require (__DIR__.'/../PHPMailer/src/SMTP.php');
$last_id = $db->lastInsertid();

try {
    $mail = new PHPMailer(true);
    //Server settings
    $mail->SMTPDebug = false;     // = SMTP::DEBUG_SERVER;                     //Enable verbose debug output
    $mail->isSMTP(true);                                            //Send using SMTP
    $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'adigeorge652@gmail.com';                 //SMTP username
    $mail->Password   = 'Asdfghjkl111';                               //SMTP password
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 587;                                    //TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above


    //Recipients
    $mail->setFrom('adigeorge652@gmail.com', 'YellowMellow');
    //replace with $email, $name;
    $mail->addAddress($email, $username);   //Add a recipient
    // $mail->addAddress('ellen@example.com');               //Name is optional
    // $mail->addReplyTo('info@example.com', 'Information');
    // $mail->addCC('cc@example.com');
    // $mail->addBCC('bcc@example.com');

    // //Attachments
    // $mail->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
    // $mail->addAttachment('/tmp/image.jpg', 'new.jpg');    //Optional name

    //Content
    $mail->isHTML(true);

    //Set email format to HTML
    $mail->Subject = 'Welcome to YellowMellow. We sent you a verification code';
    $mail->Body    = $vKey;
    // $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

    $q = $db->prepare("CALL getUserByUserName(:userUserName)");
    $q->bindValue(':userUserName', $username);
    $q->execute();
    $aRow = $q->fetchAll();
    $sUserId = $aRow[0]->userId;
    $ifActive = $aRow[0]->userActive;

    $_SESSION['userId'] = $sUserId;
    $_SESSION['userName'] = $username;
    $_SESSION['userAvatar'] = '';
    $_SESSION['email'] = $email;
    $_SESSION['vKey'] = $vKey;
    $_SESSION['userActive'] = $ifActive;

    if($mail->send()){
        header('Location: /../verify-user');
        
    }
} catch (Exception $e) {
    //echo $e;
    //echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
    $email_error = 'Message could not be sent. Mailer Error: {$mail->ErrorInfo}';
}            
        
//$result = $q->rowCount();
//
//echo 'you are signed up now!';

}}}} catch (Exception $ex) {
    //header('Content-Type: application/json');
    //echo '{"message":"error '.$ex.'"}';
    $exception_error = 'Something went wrong';
}

//}
}
}
include (__DIR__.'/../signup.php');