<?php

require_once('setup.php');

function clean($string)
{
    return preg_replace('/[^A-Za-z0-9_\- :]/', '', $string); // Removes special chars.
}

function is_valid($string)
{
    return strlen(clean($string)) == strlen($string);
}

$post_data = clean($_POST['data']);
$id = $_POST['id'];

if ($post_data && $id && strlen($post_data) < 20010) {
    if ($id && is_valid($id)) {
        $user_data = explode(":", $post_data);
        $db_data = DB::get_montage($id);
        if (count($user_data) > 0 && hash_equals($user_data[0], $db_data[0])) {
            DB::set_montage($id, $post_data);
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
