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
<!--    <link rel="stylesheet" href="app.css">-->
</head>
<body>
    <div>
    <!--api/signup-action.php-->
    <form id="signupForm" method="POST" action="https://localhost/api/signup-action.php">
            <h3>Signup</h3>
            <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf("signup");
            ?>
            <?php if(isset($exception_error)){echo "<p style='background-color:pink'>".$exception_error."</p>";}?>
            <?php if(isset($login_timeout)){?><p style="background-color:pink"><?php echo $login_timeout?></p><?php } ?>
            <?php if(isset($psst_error)){?><p style="background-color:pink"><?php echo $psst_error?></p><?php } ?>
            <?php if(isset($validation_error) ){?><p style="background-color:pink"><?php echo $validation_error?></p><?php } ?>
            <input type="text" name="username" placeholder="username">
            <?php if(isset($username_error)){echo "<p style='background-color:pink'>".$username_error."</p>";}?>
            <input type="password" name="password" placeholder="password">
            <?php if(isset($pass_error)){echo "<p style='background-color:pink'>".$pass_error."</p>";}?>
            <?php if(isset($pass_validation_error)){echo "<p style='background-color:pink'>".$pass_validation_error."</p>";}?>
            <input type="email" name="email" placeholder="email">
            <?php if(isset($email_error)){echo "<p style='background-color:pink'>".$email_error."</p>";}?>
            <?php if(isset($email_validation_error)){echo "<p style='background-color:pink'>".$email_validation_error."</p>";}?>
            <button name="submit" type="submit" form="signupForm">Sign up</button>
        </form>
    </div>
</body>
<!--<script src="app.js"></script>-->

</html>