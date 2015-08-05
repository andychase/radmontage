<?php


$redis = new Predis\Client([
    'host' => parse_url($_ENV['REDIS_URL'], PHP_URL_HOST),
    'port' => parse_url($_ENV['REDIS_URL'], PHP_URL_PORT),
    'password' => parse_url($_ENV['REDIS_URL'], PHP_URL_PASS),
]);

$id = $client->incr('id_index');
$id = 1;
$password = substr(hash('sha256', uniqid($more_entropy = true) . $id), 0, 30);
$client->set($id, $password);

header('Content-Type: application/json');

echo json_encode([
    'id' => $id,
    'password' => $password,
]);

