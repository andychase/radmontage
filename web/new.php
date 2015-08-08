<?php

require_once('setup.php');

$numeric_id = DB::get_next_id();
$random_string = hash('sha256', uniqid($more_entropy = true) . $numeric_id);
$secret = substr($random_string, 0, 30);
$id = str_pad(base_convert($numeric_id, 10, 32), 4, "0", STR_PAD_LEFT) . strtolower(substr($random_string, 30, 7));
DB::db_initialize_id($id, $secret);

header('Content-Type: application/json');

echo json_encode([
    'id' => $id,
    'secret' => $secret,
]);
