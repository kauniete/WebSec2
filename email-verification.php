<?php
require_once (__DIR__.'../utils/csrf.php');
if( isset($_SESSION['userId']) ){
    header('Location: home.php');
    exit();
}
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="shortcut icon" type="image/jpg" href="fotos_assets/favicon.png"/>
    <title>Verify email</title>
<link rel="stylesheet" href="https://localhost/app.css">
</head>
<body>
<div class="wrapper">
<section class="content">
    <div class="columns">
<aside class="sidebar-first"></aside>
    <div class="forms">
        <form id="verifyForm2" method="post" action="https://localhost/email-verification">
            <h1>Verify email</h1>
            <?php
                //require_once("utils/csrfHelper.php");
                //csrfHelper::set_csrf("verify_user");
                set_csrf();
                print_r($_SESSION);
            ?>
            <?php if(isset($verification_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$verification_error."</p>";}?>
            <?php if(isset($validation_error)){?>
                <p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $validation_error?></p>
                <?php } ?>
                <?php if(isset($psst_error)){?>
                <p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $psst_error?></p>
                <?php } ?>
            <input type="text" name="username" placeholder="username">
            <?php if(isset($username_error)){?>
                <p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $username_error?></p>
                <?php } ?>
            <input type="password" name="password" placeholder="password">
            <?php if(isset($pass_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$pass_error."</p>";}?>
            <input type="text" placeholder="OTP code" name="otp_code" id="code">
            <?php if(isset($otp_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$otp_error."</p>";}?> 
            <button type="submit" name="check-code" form="verifyForm2">Submit</button>
        </form>
        </div>
    <aside class="sidebar-second"></aside>
            </div>
  </section>
    </div>
</body>
<!--<script src="app.js"></script>-->

</html>