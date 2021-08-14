<?php

require_once (__DIR__.'../utils/csrf.php');
if( isset($_SESSION['userId']) ){
    header('Location: home');
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
    
    <title>Login</title>
    <link rel="shortcut icon" type="image/jpg" href="fotos_assets/favicon.png"/>
<link rel="stylesheet" href="app.css">
</head>
<body>
<div class="wrapper">
<section class="content">
    <div class="columns">
<aside class="sidebar-first"></aside>
    <div class="forms">
    
        <form id="loginForm" method="post" action="https://localhost/login">
            <h1>Login</h1>
            <?php
                //require_once("utils/csrfHelper.php");
                //csrfHelper::set_csrf("login");
                set_csrf();
                print_r($_SESSION);
            ?>
            <?php if(isset($verification_error)){echo "<a href='/../email-verification' style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$verification_error."</a>";}?>
            <?php if(isset($exception_error)){?>
                <p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $exception_error?></p>
                <?php } ?>
            <?php if(isset($validation_error)){?>
                <p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $validation_error?></p>
                <?php } ?>
                <?php if(isset($login_timeout)){?>
                <p style="color:#E0245E; font-size: 16px;margin-bottom: 4px;"><?php echo $login_timeout?></p>
                <?php } ?>
                <?php if(isset($psst_error)){?>
                <p style="color:#E0245E; font-size: 16px;margin-bottom: 4px;"><?php echo $psst_error?></p>
                <?php } ?>
            <input type="text" name="username" placeholder="username" maxlength="50">
            <?php if(isset($username_error)){?>
                <p style="color:#E0245E; font-size: 16px;margin-bottom: 4px;"><?php echo $username_error?></p>
                <?php } ?>
            <input type="password" name="password" placeholder="password" maxlength="50">
            <?php if(isset($pass_error)){echo "<p style='color:#E0245E; font-size: 16px;margin-bottom: 4px;'>".$pass_error."</p>";}?>
            <button name="submit" type="submit" form="loginForm">Log in</button>
        </form>
    <a class="signup-link" href="/../signup">Sign up</a> 
    </div>
    <aside class="sidebar-second"></aside>
            </div>
  </section>
    </div>
</body>


</html>
