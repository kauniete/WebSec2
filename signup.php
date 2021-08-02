<?php
//if( isset($_SESSION['userId']) ){
    //header('Location: ../home.php');
    //exit();
//}

?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    
    <title>Signup</title>
<link rel="stylesheet" href="https://localhost/app.css">
</head>
<body>
<div class="wrapper">
<section class="content">
    <div class="columns">
<aside class="sidebar-first"></aside>
    <div class="forms">
    <!--api/signup-action.php-->
    <form id="signupForm" method="POST" action="https://localhost/api/signup-action.php">
            <h1>Signup</h1>
            <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf("signup");
            ?>
            <?php if(isset($exception_error)){echo "<p style='color:#E0245E; font-size: 16px;margin-bottom: 4px;'>".$exception_error."</p>";}?>
            <?php if(isset($login_timeout)){?><p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $login_timeout?></p><?php } ?>
            <?php if(isset($psst_error)){?><p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $psst_error?></p><?php } ?>
            <?php if(isset($validation_error) ){?><p style="color:#E0245E;  font-size: 16px;margin-bottom: 4px;"><?php echo $validation_error?></p><?php } ?>
            <input type="text" name="username" placeholder="username">
            <?php if(isset($username_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$username_error."</p>";}?>
            <input type="password" name="password" placeholder="password">
            <?php if(isset($pass_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$pass_error."</p>";}?>
            <?php if(isset($pass_validation_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$pass_validation_error."</p>";}?>
            <input type="email" name="email" placeholder="email">
            <?php if(isset($email_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$email_error."</p>";}?>
            <?php if(isset($email_validation_error)){echo "<p style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$email_validation_error."</p>";}?>
            <button name="submit" type="submit" form="signupForm">Sign up</button>
        </form>
        <a class="login-link" href="/../index.php">Login</a> 
        </div>
    <aside class="sidebar-second"></aside>
            </div>
  </section>
    </div>
</body>
<!--<script src="app.js"></script>-->

</html>