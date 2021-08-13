<?php
require_once (__DIR__.'/../utils/sendError.php');
//require_once (__DIR__.'/../utils/csrfHelper.php');
$db = require_once (__DIR__.'./../private/db.php');


if(isset($_POST['submit'])){
    if( ! isset($_SESSION['userId']) ){
        header('Location: ../index.php');
      }
//session_start();
$img_error = '';
$img_success = '';
if (!isset( $_FILES["image"] ) xor empty( $_FILES["image"]["name"] )){
    $img_error = "You must upload an image";
}

   else 
{
try{
    $dir = 'images/';
    $target = $dir . basename($_FILES["image"]["name"]);
    $image = $_FILES['image']['name'];
    $imageInfo = $_FILES["image"]["size"];
    $upLoadOk = true;
    $imageType = strtolower(pathinfo($target,PATHINFO_EXTENSION));
    $mimeType = (mime_content_type($_FILES['image']['tmp_name']));
    $allowedTypes = ['png', 'jpeg', 'jpg'];
    $allowedMime = ['image/png', 'image/jpeg', 'image/jpg'];

    if ( in_array($imageType, $allowedTypes) and in_array($mimeType, $allowedMime)){
        $uploadOk = true;
    } else {
        //echo 'File type is not allowed';
        $img_error = 'File type is not allowed';
        $uploadOk = false;    
    }
    if (file_exists($target) and $uploadOk == true) {
        //echo "File already exists";
        $img_error = 'File already exists';
        $uploadOk = false;
    }
// size was 100000
    if ($_FILES["image"]["size"] > 1000000 and $uploadOk == true) {
        //echo "File is too big";
        $img_error = 'File is too big';
        $uploadOk = false;
    }
    if ($uploadOk == true){
        if (move_uploaded_file($_FILES['image']['tmp_name'],$target)){
            //echo "Image uploaded successfully";
            $img_success = 'Image uploaded successfully';
            
            $q=$db->prepare('INSERT INTO galeries (galeryUserFk, galeryImage, galeryImgSize)
            VALUES(:galeryUserFk, :galeryImage, :galeryImgSize)');
            $q->bindValue(':galeryUserFk', $_SESSION['userId']);
            $q->bindValue(':galeryImage', $image);
            $q->bindValue(':galeryImgSize', $imageInfo);
            $q->execute();
        } else {
            //echo "Failed to upload image";
            $img_error = 'Failed to upload image';
            $uploadOk = false;
        }
    }
}catch(Exception $ex){
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
}}
} 