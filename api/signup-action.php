<?php

$username = $_POST['username'];
$password = $_POST['password'];
$email = $_POST['email'];
$emailTest = 'adi_george@outlook.com';

if(! (isset($username)) ) { sendError(400, 'Missing username or password', __LINE__); }
if(! (isset($password)) ) { sendError(400, 'Missing username or password', __LINE__); }
if( strlen($_POST['username']) < 4 ){ sendError(400, 'Username must be at least 4 characters long', __LINE__); }
if( strlen($_POST['password']) < 10 ){ sendError(400, 'Password must be at least 10 characters long', __LINE__); }
if( strlen($_POST['username']) > 50 ){ sendError(400, 'Username cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['password']) > 50 ){ sendError(400, 'Password cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['email']) > 50 ){ sendError(400, 'Email cannot be longer than 50 characters', __LINE__); }
if( strlen($_POST['email']) < 3 ){ sendError(400, 'Email must be at least 3 characters long', __LINE__); }

$vKey = md5(time());
echo $vKey;
require_once (__DIR__.'/../private/db.php');

try {
    // check if the credentials exist
    $q = $db->prepare("
        SELECT *
        FROM users
        WHERE users.username = :username LIMIT 1
        ");
    $q->bindValue(':username', $_POST['username']);
    $q->execute();
    $aRow = $q->fetchAll();

    if($q->rowCount() === 1) {
        header('Content-Type: application/json');
        sendError(400, 'Username is taken', __LINE__);
        return;
    }


    $q = $db->prepare("  
        INSERT INTO users
        VALUES(null, :username, :password, :email, :vKey)
        ");

    // adding hash, salt and pepper to the password
    $aData = json_decode(file_get_contents(__DIR__.'./../private/data.txt'));
    $pepper = $aData[0]->key;
    $pwd = $_POST['password'];
    $pwd_peppered = hash_hmac("sha256", $pwd, $pepper); // hashing the password and adding a pepper
    $pwd_hashed = password_hash($pwd_peppered, PASSWORD_ARGON2ID); // hashing again and keep in mind that salt is now added by default with password_hash

    $q->bindValue(':username', $_POST['username']);
    $q->bindValue(':email', $_POST['email']);
    $q->bindValue(':vKey', $vKey);
    $q->bindValue(':password', $pwd_hashed);

    $url = 'http://'.$_SERVER['SERVER_NAME'].'/forgetpass-recover-tutorial/changepass.php?id='.$data['id'].'&email='.$email;                                // Set email format to HTML
		
    $output = '<div>Thanks, Please click this link to change your password <br>'.$url.'</div>';

    $q->execute();
    if($q){
        require_once('api-send-email.php');
    }

    echo 'you are signed up now!';

} catch (Exception $ex) {
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
}

// ############################################################
// ############################################################
function sendError($iErrorCode, $sMessage, $iLine){
    http_response_code($iErrorCode);
    header('Content-Type: application/json');
    echo '{"message":"'.$sMessage.'", "error":"'.$iLine.'"}';
    exit();
}

function doCheckTimeDiff(DateTime $dateTime) {
    $secondDate = new \DateTime();

    $diff = $dateTime->diff($secondDate);

    $hours   = intval($diff->format('%h'));
    $minutes = intval($diff->format('%i'));
    $diffInMin = ($hours * 60 + $minutes);

    return $diffInMin >= 5;
}