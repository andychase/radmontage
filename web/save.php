<?php

require_once('setup.php');

function clean($string)
{
    return preg_replace('/[^A-Za-z0-9_:]/', '', $string); // Removes special chars.
}

$post_data = clean($_POST['data']);
$id = $_POST['id'];
$secret = $_POST['secret'];

if ($post_data && $id && $secret && strlen($post_data) < 20010) {
    if ($id && is_numeric($id)) {
        $db_data = explode(":", $redis->get($id));
        if (hash_equals($secret, $db_data[0])) {
            $redis->set($id, $secret . ":" . $post_data);
            http_response_code(200);
            header('Content-Type: application/json');
            echo(json_encode(["ok"]));
            return;
        } else {
            http_response_code(403);
            return;
        }
    }
}

http_response_code(400);
