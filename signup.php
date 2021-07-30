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
    <!--api/signup-action.php-->
        <form id="signupForm" method="POST" action="api/signup-action.php">
            <h3>Signup</h3>
            <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf("signup");
            ?>
            <input type="text" name="username" placeholder="username">
            <input type="password" name="password" placeholder="password">
            <input type="email" name="email" placeholder="email">
            <button type="submit" form="signupForm">Sign up</button>
        </form>
    </div>
</body>
<!--<script src="app.js"></script>-->

</html>