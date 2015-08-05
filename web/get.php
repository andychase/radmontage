<?php

require('../vendor/autoload.php');

$redis = new Predis\Client([
    'host' => parse_url($_ENV['REDIS_URL'], PHP_URL_HOST),
    'port' => parse_url($_ENV['REDIS_URL'], PHP_URL_PORT),
    'password' => parse_url($_ENV['REDIS_URL'], PHP_URL_PASS),
]);

$id = $_GET['id'];
if ($id && is_numeric($id)) {
    $data = $redis->get($id);
    if ($data) {
        $data = array_slice(explode(":", $data), 1);
        header('Content-Type: application/json');
        echo(json_encode($data));
        return;
    } else {
        http_response_code(404);
        return;
    }
}

http_response_code(400);
