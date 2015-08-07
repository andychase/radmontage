<?php

require_once('setup.php');

function clean($string)
{
    return preg_replace('/[^A-Za-z0-9_\- :]/', '', $string); // Removes special chars.
}

$post_data = clean($_POST['data']);
$id = $_POST['id'];

if ($post_data && $id && strlen($post_data) < 20010) {
    if ($id && is_numeric($id)) {
        $db_data = explode(":", $redis->get($id));
        $user_data = explode(":", $post_data);
        if (count($user_data) > 0 && hash_equals($user_data[0], $db_data[0])) {
            $redis->set($id, $post_data);
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
