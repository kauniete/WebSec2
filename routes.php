<?php
//
require_once(__DIR__.'/router.php');
// #####################################
// #####################################
// #####################################
// #####################################
//get('/login', '/index.php');
//altering the below line so it also routes to the root reexam.indraja.dk, not only reexam.indraja.dk/index.php
get('/', 'index.php');
post('/login', '/api/login-action.php');
get('/login', '/api/login-action.php');
get('/verify-user', '/verify-user.php');
get('/home', '/home.php');
// #####################################
// #####################################


any('/404','/page_404.php');
