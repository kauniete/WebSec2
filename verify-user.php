<?php
//print_r($_SESSION);
require_once (__DIR__.'../utils/csrf.php');
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="shortcut icon" type="image/jpg" href="fotos_assets/favicon.png"/>
     <title>Verify account</title>
     <link rel="stylesheet" href="https://localhost/app.css">
  </head>

<body>
<div class="wrapper">
<section class="content">
    <div class="columns">
<aside class="sidebar-first"></aside>
    <div class="forms">
    <!-- Recover password -->
    <!-- <div class="container">
      <div class="forms-container">
        <div class="reset-password"> -->
          <form id="emailVerifyForm" action="https://localhost/verify-user" class="sign-in-form" method="POST">
          <?php
                //require_once("utils/csrfHelper.php");
                //csrfHelper::set_csrf('verify_user');
                set_csrf();
                print_r($_SESSION);
            ?>
            <h2 class="title">Verify your Account</h2>
            <p>
                Kindly fill up your OTP code that you received by email.<br>
                This will help to verify your account ASAP.
            </p>
            <?php if(isset($psst_error)){?>
                <p style="color:#E0245E; font-size: 16px;margin-bottom: 4px;"><?php echo $psst_error?></p>
                <?php } ?>
                <?php if(isset($signup_flow_error)){echo "<a href='/../signup' style='color:#E0245E;  font-size: 16px;margin-bottom: 4px;'>".$signup_flow_error."</a>";}?>
                <?php if(isset($exception_error)){?>
                <p style="color:#E0245E; font-size: 16px;margin-bottom: 4px;"><?php echo $exception_error?></p>
                <?php } ?>
              <input type="text" placeholder="OTP code" name="otp_code" id="code">
              <?php if(isset($verification_error)){?>
                <p style="color:#E0245E; font-size: 16px;margin-bottom: 4px;"><?php echo $verification_error?></p>
                <?php } ?>
            <button type="submit" value="Verify"  name="check_code">Submit</button>
            <!-- <input type="submit" value="Verify" class="btn solid" name="check_code"> -->
          </form>
        <!-- </div>
        </div> -->
      
      <!-- left panel -->
      <!-- <div class="panels-container">
        <div class="panel left-panel">
          <div class="content"> -->
           
           
            </div>
    <aside class="sidebar-second"></aside>
            </div>
  </section>
    </div>
          <!-- </div>
        </div>
      </div>
  </div> -->
</body>
</html>
