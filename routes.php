<?php
//
require_once(__DIR__.'/router.php');
// #####################################
// #####################################
// #####################################
// #####################################
get('/login', '/index.php');
get('/signup', '/verify-user.php');
get('/home', '/home.php');


// #####################################
// #####################################
// #####################################
// #####################################


any('/404','/page_404.php');