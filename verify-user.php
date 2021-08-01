<?php
session_start();
print_r($_SESSION);
//?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
     <title>Verify account</title>
     
  </head>

<body>

    <!-- Recover password -->
    <div class="container">
      <div class="forms-container">
        <div class="reset-password">
          <form action="https://localhost/api/api-verify-user.php" class="sign-in-form" method="POST">
          <?php
                require_once("utils/csrfHelper.php");
                csrfHelper::set_csrf('verify_user');
            ?>
            <h2 class="title">Verify your Account</h2>
           	<div class="input-field">
              <!--<i class="fas fa-key"></i>-->
              <input type="text" placeholder="OTP code" name="otp_code" id="code">
            </div>   
            <input type="submit" value="Verify" class="btn solid" name="check_code">
          </form>
        </div>
        </div>
            
      <!-- left panel -->
      <div class="panels-container">
        <div class="panel left-panel">
          <div class="content">
           
            <p>
                Dear User, Kindly fill up your OTP code that you received by email.<br>
                We will help you to verify your account ASAP.
            </p>
          </div>
        </div>
      </div>
  </div>
</body>
</html>
