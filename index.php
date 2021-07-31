<?php
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
    
    <title>Login</title>
<!--    <link rel="stylesheet" href="app.css">-->
</head>
<body>
    <div>
        <form id="loginForm" method="post" action="https://localhost/login">
            <h3>Login</h3>
            <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf("login");
            ?>
            <?php if(isset($verification_error)){echo "<a href='email-verification.php' style='background-color:pink'>".$verification_error."</a>";}?>
            <?php if(isset($validation_error)){?>
                <p style="background-color:pink"><?php echo $validation_error?></p>
                <?php } ?>
                <?php if(isset($login_timeout)){?>
                <p style="background-color:pink"><?php echo $login_timeout?></p>
                <?php } ?>
                <?php if(isset($psst_error)){?>
                <p style="background-color:pink"><?php echo $psst_error?></p>
                <?php } ?>
            <input type="text" name="username" placeholder="username">
            <?php if(isset($username_error)){?>
                <p style="background-color:pink"><?php echo $username_error?></p>
                <?php } ?>
            <input type="password" name="password" placeholder="password">
            <?php if(isset($pass_error)){echo "<p style='background-color:pink'>".$pass_error."</p>";}?>
            <button name="submit" type="submit" form="loginForm">Log in</button>
        </form>
    </div>
    <a href="signup.php">Sign up</a> 
</body>
<!--<script src="app.js"></script>-->

</html>