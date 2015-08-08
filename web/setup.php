<?php

require('../vendor/autoload.php');

$max_data_length = 20010;
// ^ Calculated like so: len("789cae03b53fe955bc6746e7ee0663" + (":o331HlIeYrw:999:999"*999))

$redis_url = getenv("REDIS_URL");
if (!isset($redis_url) || !$redis_url)
    $redis_url = "redis://h:@localhost:6379";

$redis = new Predis\Client([
    'host' => parse_url($redis_url, PHP_URL_HOST),
    'port' => parse_url($redis_url, PHP_URL_PORT),
    'password' => parse_url($redis_url, PHP_URL_PASS),
]);

class DB
{
    public $id_index = 'id_index';

    static function get_next_id()
    {
        global $redis;
        return intval($redis->incr('id_index'));
    }

    static function db_initialize_id($id, $secret)
    {
        global $redis;
        return $redis->set($id, $secret);
    }

    static function get_montage($id)
    {
        global $redis;
        return explode(":", $redis->get($id));
    }

    static function set_montage($id, $data)
    {
        global $redis;
        return $redis->set($id, $data);
    }
}
