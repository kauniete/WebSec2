<?php
 session_start();
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.13.0/css/all.css">
    <title>H-hotel verify account</title>
    <!-- Social media CDN -->
    <script src='https://kit.fontawesome.com/a076d05399.js'></script>
    <!-- favicon icon -->
    <link rel="shortcut icon" type="image/png" href="../images/favicon.png">
    <!-- css -->
  </head>

<body>

    <!-- Recover password -->
    <div class="container">
      <div class="forms-container">
        <div class="reset-password">
          <form action="#" class="sign-in-form" method="POST">
            <h2 class="title">Verify your Account</h2>
           	<div class="input-field">
              <i class="fas fa-key"></i>
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
            <h3>Verify Your Account?</h3>
            <p>
                Dear User, Kindly fill up your OTP code that you received by email<br>
                We will help you to verify your account ASAP.
            </p>
          </div>
        </div>
      </div>
  </div>
</body>
</html>

<?php
	

	if(isset($_POST['check_code'])){
    	 $otp_num = $_SESSION['vKey'];
         $email = $_SESSION['email'];
      	 $otp = $_POST['otp_code'];
      	 if($otp_num != $otp){
         	?>
            <script>
                alert("Invalid OTP code");
            </script>
            <?php
         }else{
         	
             ?>
              <script>
                  alert("Verfiy account done, you may sign in now");
                	<?php
                    header('Location: home.php');
                    exit();
                    ?>
              </script>
              <?php
         }
    }
?>