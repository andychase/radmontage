<?php

require('../vendor/autoload.php');

$redis = new Predis\Client([
    'host' => parse_url($_ENV['REDIS_URL'], PHP_URL_HOST),
    'port' => parse_url($_ENV['REDIS_URL'], PHP_URL_PORT),
    'password' => parse_url($_ENV['REDIS_URL'], PHP_URL_PASS),
]);

$id = $redis->incr('id_index');
$password = substr(hash('sha256', uniqid($more_entropy = true) . $id), 0, 30);
$redis->set($id, $password);

header('Content-Type: application/json');

echo json_encode([
    'id' => $id,
    'password' => $password,
]);
