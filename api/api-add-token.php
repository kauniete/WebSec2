<?php

if(session_status() == 1){ session_start(); }
$csrf_token = bin2hex(random_bytes(25));
$_SESSION['csrf'] = $csrf_token;
header('Content-Type: application/json');
echo '{"id": "'.$csrf_token.'"}';
exit();
