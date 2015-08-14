<?php

preg_match("#^/edit/(new|[0-9a-z]+)#", $_SERVER['REQUEST_URI'], $matches);
if (count($matches) > 0 && strlen($matches[1]) < 30) {
    require("edit.php");
    return true;
}

preg_match("#^/watch/([0-9a-z]+)#", $_SERVER['REQUEST_URI'], $matches);
if (count($matches) > 0 && strlen($matches[1]) < 30) {
    $_GET['m'] = $matches[1];
    require("watch.php");
    return true;
}

if ($_SERVER['REQUEST_URI'] == "/" || $_SERVER['REQUEST_URI'] == "") {
    require("edit.php");
    return true;
}

$development = strstr($_SERVER['SERVER_SOFTWARE'], " Development Server") != false;

if ($development)
    return false;
else
    require("404.html");
