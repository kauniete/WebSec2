
<?php
    require_once (__DIR__.'/../utils/csrfHelper.php');
    if(! csrfHelper::is_csrf_valid()) {
        header('Content-Type: application/json');
        require_once (__DIR__.'/../utils/sendError.php');
        sendError(400, 'Invalid session', __LINE__);
    }

	if(isset($_POST['otp_code']) || ! empty($_POST['otp_code'])){
        $otp_num = $_SESSION['vKey'];
        $email = $_SESSION['email'];
        $otp = htmlspecialchars($_POST['otp_code']);

        if($otp_num != $otp){
            header('Location: ../index.php');
            exit();
            //add error msg for user here.indre

        }else{
            $db = require_once (__DIR__.'./../private/db.php');
            $q = $db->prepare(
                'SELECT * FROM users'
            );
            $q->execute();
            $aUsers = $q->fetchAll();
            //print_r($aUsers);
            for ($i = 0; $i < count($aUsers); $i++) {
                if ($_SESSION['userId'] == $aUsers[$i]->userId){
            $q = $db->prepare(
                'UPDATE `users` SET `userActive` = :newValue;'
            );
            $q->bindValue('newValue',1);
            $q->execute();
            header('Location: ../home.php');
            exit();
        }}}   
    } else {
            session_destroy();
header('Location: ../index.php');
        }
    