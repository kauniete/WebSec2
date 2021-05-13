<?php
class csrfHelper
{
    static function set_csrf($formName){
        // If no session is active then start one
        if(session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }
        $csrfFormName = 'csrf_'.$formName;
        $_SESSION[$csrfFormName] = bin2hex(random_bytes(25));;

        echo '
            <input type="hidden" name="csrf" value="'.$_SESSION[$csrfFormName].'">
            <input type="hidden" name="csrfFormName" value="'.$csrfFormName.'">
            ';
    }
    static function is_csrf_valid(){
        if(session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }
        if( ! isset($_POST['csrfFormName'])) {
            return false;
        }

        $csrfFormNameToCheck = $_POST['csrfFormName'];
        if( ! isset($_SESSION[$csrfFormNameToCheck]) || ! isset($_POST['csrf'])){ return false; }
        if( $_SESSION[$csrfFormNameToCheck] != $_POST['csrf']){ return false; }
        return true;
    }
}