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
    
    <title>Verify email</title>
<!--    <link rel="stylesheet" href="app.css">-->
</head>
<body>
    <div>
        <form id="verifyForm" method="post" action="https://localhost/api/api-email-verification-action.php">
            <h3>Verify email</h3>
            <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf("verify_user");
            ?>
            <?php if(isset($verification_error)){echo "<p style='background-color:pink'>".$verification_error."</p>";}?>
            <?php if(isset($validation_error)){?>
                <p style="background-color:pink"><?php echo $validation_error?></p>
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
            <input type="text" placeholder="OTP code" name="otp_code" id="code">
            <?php if(isset($otp_error)){echo "<p style='background-color:pink'>".$otp_error."</p>";}?>
            </div>   
            <button type="submit" form="verifyForm">Submit</button>
        </form>
    </div>
</body>
<!--<script src="app.js"></script>-->

</html>