<?php
session_start();
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;
// $conn = new mysqli('localhost', 'root', '' , 'login-security');
// require '../vendor/autoload.php';
$username = $_POST['username'];
$password = $_POST['password'];
$email = $_POST['email'];
// // $conn = new mysqli("localhost", "root","","login-security");
// // echo $conn;
// // $emailTest = 'adi_george@outlook.com';

$username = htmlspecialchars($_POST['username']);
$password = htmlspecialchars($_POST['password']);
if(! (isset($_POST['username'])) ) { sendError(400, 'Missing username or password', __LINE__); }
if(! (isset($_POST['username'])) ) { sendError(400, 'Missing username or password', __LINE__); }
if( strlen($_POST['username']) < 4 ){ sendError(400, 'Username must be at least 4 characters long', __LINE__); }
if( strlen($_POST['password']) < 10 ){ sendError(400, 'Password must be at least 10 characters long', __LINE__); }
if( strlen($_POST['username']) > 50 ){ sendError(400, 'Username cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['password']) > 50 ){ sendError(400, 'Password cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['email']) > 50 ){ sendError(400, 'Email cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['email']) < 3 ){ sendError(400, 'Email must be at least 3 characters long', __LINE__); }

$db = require_once (__DIR__.'./../private/db.php');
$vKey = md5(time());

try {
    $q = $db->prepare("
        SELECT *
        FROM users
        WHERE users.userUserName = :userUserName LIMIT 1
        ");
    $q->bindValue(':userUserName', $username);
    $q->execute();
    $aRow = $q->fetchAll();
    
    if($q->rowCount() === 1) {
            header('Content-Type: application/json');
            sendError(400, 'Username is taken', __LINE__);
            return;
        }
        
        $q=$db->prepare('INSERT INTO users VALUES(:userId, :userFullName, :userUserName, :userEmail, :userPassword, :userAvatar, :userAbout, :userVerifyCode, :userActive, :userCity, :userLanguage, :userCreated, :userTotalMessages, :userTotalImg, :userTotalFollowers, :userTotalFollowees, :userTotalFollowing)');
        
        $q->bindValue(':userId', null);
        $q->bindValue(':userFullName', 'test');
        $q->bindValue(':userUserName', $_POST['username']);
        $q->bindValue(':userEmail', $_POST['email']);
        $q->bindValue(':userPassword', $_POST['password']);
        $q->bindValue(':userAvatar','testasd');
        $q->bindValue(':userAbout', 'about me');
        $q->bindValue(':userVerifyCode', $vKey);
        $q->bindValue(':userActive', 1);
        $q->bindValue(':userCity', 'test');
        $q->bindValue(':userLanguage', 'test');
        $q->bindValue(':userCreated', '2021-05-10 00:12:18');
        $q->bindValue(':userTotalMessages', '20');
        $q->bindValue(':userTotalImg', '20');
        $q->bindValue(':userTotalFollowers', '20');
        $q->bindValue(':userTotalFollowees', '20');
        $q->bindValue(':userTotalFollowing', '20');
        
        // adding hash, salt and pepper to the password
        $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
        $pepper = $aData[0]->key;
        $pwd = $_POST['password'];
        $pwd_peppered = hash_hmac("sha256", $pwd, $pepper); // hashing the password and adding a pepper
        $pwd_hashed = password_hash($pwd_peppered, PASSWORD_ARGON2ID); // hashing again and keep in mind that salt is now added by default with password_hash
        // echo $last_id;
        // $last_id= mysqli_insert_id($conn);
        // $url = 'https://localhost/Second Semester/WebSec/ExamProject/api/signup-action.php?id='.$last_id.'$token='.$vKey;
        // $output = '<div>Please click the link'.$url.'</div>';
        
        $q->execute();


// require_once ("../PHPMailer/class.phpmailer.php");

require '../PHPMailer/src/Exception.php';
require '../PHPMailer/src/PHPMailer.php';
require '../PHPMailer/src/SMTP.php';
$last_id = $db->lastInsertid();

try {
          $mail = new PHPMailer(true);
          //Server settings
          $mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
          $mail->isSMTP(true);                                            //Send using SMTP
          $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
          $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
          $mail->Username   = 'adigeorge652@gmail.com';                 //SMTP username
          $mail->Password   = 'Asdfghjkl111';                               //SMTP password
          $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
          $mail->Port       = 587;                                    //TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above
         
       
          //Recipients
          $mail->setFrom('adigeorge652@gmail.com', 'Adi');
          //replace with $email, $name;
          $mail->addAddress('adi_george@outlook.com', 'username');   //Add a recipient
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
          $mail->Subject = 'test';
          $mail->Body    = $vKey;
          // $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
      
          if($mail->send()){
            ?>
              <script>
                alert("<?php echo "OTP code has been sending to " . $email ?>");
                window.location.replace("./../verify-user.php");
             </script> 
            <?php
          }
      } catch (Exception $e) {
          echo $e;
          echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
      }
    
        
        $result = $q->rowCount();
       
        $_SESSION['username'] = $_POST['username'];
        $_SESSION['email'] = $_POST['email'];
        $_SESSION['vKey'] = $vKey;
     

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
    $secondDate = new DateTime();

    $diff = $dateTime->diff($secondDate);

    $hours   = intval($diff->format('%h'));
    $minutes = intval($diff->format('%i'));
    $diffInMin = ($hours * 60 + $minutes);

    return $diffInMin >= 5;
}


//IF NEW.username LIKE'%jpg%' THEN
//signal sqlstate '45000';
//END IF