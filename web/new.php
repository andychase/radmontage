<?php

require_once('setup.php');

$id = $redis->incr('id_index');
$secret = substr(hash('sha256', uniqid($more_entropy = true) . $id), 0, 30);
$redis->set($id, $secret);

header('Content-Type: application/json');

echo json_encode([
    'id' => $id,
    'secret' => $secret,
]);
