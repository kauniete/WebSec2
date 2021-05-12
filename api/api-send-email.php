<?php

// $sCorrectKey = 'fba53124-4851-40fa-88be-1b3e05df6443';

// if( $sCorrectKey != $_POST['secretKey'] ){
//     echo 'Wrong key';
// }

// if( ! filter_var($_POST['to'], FILTER_VALIDATE_EMAIL)  ){
//     echo 'Invalid email';
//     exit();
// }

// if( strlen($_POST['subject']) <= 1 ){
//     echo 'Subject must be at least 2 characters';
//     exit();
// }

// if( strlen($_POST['subject']) > 100 ){
//     echo 'Subject cannot be longer than 100 characters';
//     exit();
// }

// if( strlen($_POST['body']) < 25 ){
//     echo 'body must be at least 25 characters';
//     exit();
// }

// if( strlen($_POST['body']) > 5000 ){
//     echo 'body cannot be longer than 5000 characters';
//     exit();
// }



use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;
require '../PHPMailer/src/Exception.php';
require '../PHPMailer/src/PHPMailer.php';
require '../PHPMailer/src/SMTP.php';


// Import PHPMailer classes into the global namespace
// These must be at the top of your script, not inside a function


// Load Composer's autoloader
// require 'vendor/autoload.php';

// Instantiation and passing `true` enables exceptions
$mail = new PHPMailer(true);

try {
    //Server settings
    $mail->SMTPDebug = SMTP::DEBUG_SERVER;                      // Enable verbose debug output
    $mail->isSMTP();                                            // Send using SMTP
    $mail->Host       = 'smtp.gmail.com';                    // Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   // Enable SMTP authentication
    $mail->Username   = 'adigeorge652@gmail.com';                     // SMTP username
    $mail->Password   = 'Asdfghjkl111';                               // SMTP password
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;         // Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 587;                                    // TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above
    

    //Recipients
    $mail->setFrom('adigeorge652@gmail.com', 'Adi');
    $mail->addAddress('email', 'username');     // Add a recipient
    // $mail->addAddress('ellen@example.com');               // Name is optional
    // $mail->addReplyTo('info@example.com', 'Information');
    // $mail->addCC('cc@example.com');
    // $mail->addBCC('bcc@example.com');
    // exit();
    // Attachments
    // $mail->addAttachment('/var/tmp/file.tar.gz');         // Add attachments
    // $mail->addAttachment('/tmp/image.jpg', 'new.jpg');    // Optional name


    // Content
    $mail->isHTML(true);                               // Set email format to HTML
    
    $mail->Subject = 'Email verification';
    // $_POST['username'] = $_POST['username'] ?? 'A AA';
    $mail->Body    = 'Welcome '.$_POST['username'];
    // $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
    $mail->send();
    echo 'Message has been sent';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}