<?php

if(!isset($_POST['upload'])){
    echo "You must upload in image";
}
require_once (__DIR__.'/../utils/csrfHelper.php');
require_once (__DIR__.'/../utils/sendError.php');

$db = require_once (__DIR__.'./../private/db.php');

try{
    $_SESSION['userId'] =1;
    $image = $_FILES['image']['name'];
    $imageInfo = filesize( $_FILES['image']['tmp_name'] );
    $imageType = $_FILES['image']['type'];
   
    if (is_uploaded_file($_FILE['image']['tmp_name'])) {
        
        $mime_type = mime_content_type($_FILE['image']['tmp_name']);
    
       
        $allowed_file_types = ['image/png', 'image/jpeg', 'image/jpg'];
        if (! in_array($mime_type, $allowed_file_types)) {
            echo 'File type is not allowed';
        }
    
        $target = "../images/".basename($image);
    
        // Now you move/upload your file
        if (move_uploaded_file ($_FILE['image']['tmp_name'] , $target)) {
            // File moved to the destination
        }
    }


    if (move_uploaded_file($_FILES['image']['tmp_name'], $target)) {
        $msg = "Image uploaded successfully";
    }else{
        $msg = "Failed to upload image";
    }
    $q=$db->prepare('INSERT INTO galeries (galeryId, galeryUserFk, galeryImage, galeryImgSize, galeryImgCount, galeryCreated)
    VALUES(:galeryId, :galeryUserFk, :galeryImage, :galeryImgSize, :galeryImgCount, current_timestamp())');

    $q->bindValue(':galeryId', null);
    $q->bindValue(':galeryUserFk', $_SESSION['userId']);
    $q->bindValue(':galeryImage', $image);
    $q->bindValue(':galeryImgSize', $imageInfo);
    $q->bindValue(':galeryImgCount', '23');
    
    $q->execute();





}catch(Exception $ex){
    header('Content-Type: application/json');
    echo '{"message":"error '.$ex.'"}';
}