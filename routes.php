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
post('/', 'index.php');
post('/login', '/api/login-action.php');
get('/login', '/api/login-action.php');
post('/signup', '/api/signup-action.php');
get('/signup', '/api/signup-action.php');
post('/verify-user', '/api/api-verify-user.php');
get('/verify-user', '/api/api-verify-user.php');
get('/email-verification', '/api/api-email-verification-action.php');
post('/email-verification', '/api/api-email-verification-action.php');
get('/home', '/home.php');
post('/home', '/home.php');
get('/logout', '/api/logout-action.php');
// #####################################
// #####################################
any('/404','/page_404.php');
