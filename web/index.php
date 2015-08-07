<?php

preg_match("#^/edit/([0-9]+)#" , $_SERVER['REQUEST_URI'], $matches);
if (count($matches) > 0 && strlen($matches[1]) < 30) {
    require("index.html");
    return true;
}

preg_match("#^/watch/([0-9]+)#" , $_SERVER['REQUEST_URI'], $matches);
if (count($matches) > 0 && strlen($matches[1]) < 30) {
    $_GET['m'] = $matches[1];
    require("watch.php");
    return true;
}

if ($_SERVER['REQUEST_URI'] == "/" || $_SERVER['REQUEST_URI'] == "") {
    require("index.html");
    return true;
}

$development = strstr($_SERVER['SERVER_SOFTWARE'], " Development Server") != false;

if ($development)
    return false;
else
    require("404.html");
