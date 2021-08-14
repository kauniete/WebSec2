<?php
if( ! isset($_SESSION['userId']) ){
    header('Location: /');
  exit();
}

if(session_status() == 1){ session_start(); }
header('Content-Type: application/json');
echo '{"id": "'. $_SESSION['csrf'].'"}';
exit();
