<?php

require('../vendor/autoload.php');

$max_data_length = 20010;
// ^ Calculated like so: len("789cae03b53fe955bc6746e7ee0663" + (":o331HlIeYrw:999:999"*999))

$redis = new Predis\Client([
    'host' => parse_url($_ENV['REDIS_URL'], PHP_URL_HOST),
    'port' => parse_url($_ENV['REDIS_URL'], PHP_URL_PORT),
    'password' => parse_url($_ENV['REDIS_URL'], PHP_URL_PASS),
]);

function clean($string)
{
    return preg_replace('/[^A-Za-z0-9_:]/', '', $string); // Removes special chars.
}

$post_data = clean($_POST['data']);
if ($post_data && $_POST['id'] && $_POST['secret'] && strlen($post_data) < 20010) {
    $post_data = json_decode($post_data);
    if ($_POST['id'] && is_int($_POST['id'])) {
        $db_data = explode(":", $client->get($id));
        if (hash_equals($_POST['secret'], $db_data[0])) {
            $client->set($id, $_POST['secret'] . ":" . $post_data);
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
