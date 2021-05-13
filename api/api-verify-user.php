
<?php
    require_once (__DIR__.'/../utils/csrfHelper.php');
    if(! csrfHelper::is_csrf_valid()) {
        header('Content-Type: application/json');
        require_once (__DIR__.'/../utils/sendError.php');
        sendError(400, 'Invalid session', __LINE__);
    }


	if(isset($_POST['otp_code'])){
        $otp_num = $_SESSION['vKey'];
        $email = $_SESSION['email'];
        $otp = htmlspecialchars($_POST['otp_code']);
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
                header('Location: ../home.php');
                exit();
                ?>
            </script>
            <?php
        }
    }