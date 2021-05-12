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
        <form id="loginForm" method="post" action="api/login-action.php">
            <h3>Login</h3>
            <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf();
            ?>
            <input type="text" name="username" placeholder="username">
            <input type="password" name="password" placeholder="password">
            <button type="submit" form="loginForm">Log in</button>
        </form>
        <form id="signupForm" onsubmit="signup(); return false;">
            <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf();
            ?>  
            <h3>Signup</h3>
            <input type="text" name="username" placeholder="username">
            <input type="password" name="password" placeholder="password">
            <input type="text" name="email" placeholder="email">
            <button form="signupForm">Sign up</button>
        </form>
    </div>
</body>
<script src="app.js"></script>

</html>