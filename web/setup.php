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

date_default_timezone_set('UTC');
$smarty = new Smarty();

$smarty->setTemplateDir('views');
$smarty->setCompileDir('views/compile');
$smarty->setCacheDir('views/cache');

class DB
{
    const id_index = 'id_index';
    const truncate_videos_at = 6;

    static function get_next_id()
    {
        global $redis;
        return intval($redis->incr(DB::id_index));
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

    static function get_montages($ids)
    {
        global $redis;
        $responses = $redis->pipeline(function (Predis\Pipeline\Pipeline $pipe) use ($ids) {
            foreach ($ids as $id) {
                $pipe->get($id);
            }
        });
        return array_map(function ($item) {
            return explode(":", $item);
        }, $responses);
    }

    static function get_montage_name_and_videos($montage_data)
    {
        $montage_video_count = (count($montage_data) - 2) / 3;
        $output = [];
        $name = "";

        foreach ($montage_data as $i => $video)
            if ($i == 1)
                $name = $video;
            else if ($i > 1 && $i < DB::truncate_videos_at * 3 && ($i - 2) % 3 == 0)
                $output[] = $video;
        return [$name, $montage_video_count, $output];
    }

    static function set_montage($id, $data)
    {
        global $redis;
        return $redis->set($id, $data);
    }

    static function get_featured_videos($page)
    {
        global $redis;
        $featured_montages = $redis->get("featured:$page");
        $names = [];
        $counts = [];
        $videos = [];
        if ($featured_montages) {
            $ids = json_decode($featured_montages);
            foreach (DB::get_montages($ids) as $i => $m) {
                $montage_name_and_videos = DB::get_montage_name_and_videos($m);
                $names[$ids[$i]] = $montage_name_and_videos[0];
                $counts[$ids[$i]] = $montage_name_and_videos[1];
                $videos[$ids[$i]] = $montage_name_and_videos[2];
            }
        }
        return [$names, $counts, $videos];
    }
}
