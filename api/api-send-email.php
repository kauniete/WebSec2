<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;
// require_once ("../PHPMailer/class.phpmailer.php");

require '../PHPMailer/src/Exception.php';
require '../PHPMailer/src/PHPMailer.php';
require '../PHPMailer/src/SMTP.php';
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
          $mail->Body    = $output;
          // $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
      
          $mail->send();
      } catch (Exception $e) {
          echo $e;
          echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
      }