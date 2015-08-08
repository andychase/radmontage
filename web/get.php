<?php

require_once('setup.php');

$id = $_GET['id'];
if ($id) {
    $data = DB::get_montage($id);
    if ($data) {
        $data = array_slice($data, 1);
        header('Content-Type: application/json');
        echo(json_encode($data));
        return;
    } else {
        http_response_code(404);
        return;
    }
}

http_response_code(400);
