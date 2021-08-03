<?php 
function set_csrf(){
    if(session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
    }
  $csrf_token = bin2hex(random_bytes(25));
  $_SESSION['csrf'] = $csrf_token;
  echo '<input type="hidden" name="csrf" value="'.$csrf_token.'">';
}
function is_csrf_valid(){
   if(session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
   }
  if( ! isset($_SESSION['csrf']) || ! isset($_POST['csrf'])){ return false; }
  if( $_SESSION['csrf'] != $_POST['csrf']){ return false; }
  return true;
}