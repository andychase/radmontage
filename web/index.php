<?php

preg_match("#^/edit(/new|/[0-9a-z]+)?$#", $_SERVER['REQUEST_URI'], $matches);
if (count($matches) > 0) {
    require("edit.php");
    return true;
}

preg_match("#^/watch/([0-9a-z]+)#", $_SERVER['REQUEST_URI'], $matches);
if (count($matches) > 0 && strlen($matches[1]) < 30) {
    $_GET['m'] = $matches[1];
    require("watch.php");
    return true;
}

preg_match("#^/watch_fullscreen/([0-9a-z]+)#", $_SERVER['REQUEST_URI'], $matches);
if (count($matches) > 0 && strlen($matches[1]) < 30) {
    $_GET['m'] = $matches[1];
    require("watch_fullscreen.php");
    return true;
}

preg_match("#^/explore/([0-9a-zA-Z\\- ]+)?$#", $_SERVER['REQUEST_URI'], $matches);
if ($_SERVER['REQUEST_URI'] == "/" || $_SERVER['REQUEST_URI'] == ""  ||
    $_SERVER['REQUEST_URI'] == "/explore" || count($matches) > 0) {
    if (count($matches) > 1 && $matches[1] != "featured")
        $_GET['p'] = $matches[1];
    else
        $_GET['p'] = "";
    require("explore.php");
    return true;
}

if ($_SERVER['REQUEST_URI'] == "/feedback/" || $_SERVER['REQUEST_URI'] == "/feedback"
    || $_SERVER['REQUEST_URI'] == "/beta.html") {
    require('feedback.php');
    return true;
}

$development = strstr($_SERVER['SERVER_SOFTWARE'], " Development Server") != false;

if ($development)
    return false;
else
    require("404.html");
