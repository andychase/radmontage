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

    static function get_montage_name_and_videos($id)
    {
        $montage_data = DB::get_montage($id);
        $montage_video_count = (count($montage_data) - 2) / 3;
        $output = [];
        $name = "";

        foreach($montage_data as $i => $video)
            if($i == 1)
                $name = $video;
            else if($i > 1 && $i < DB::truncate_videos_at*3 && ($i-2) % 3 == 0)
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
        if ($featured_montages) {
            $names = [];
            $counts = [];
            $videos = [];
            foreach(json_decode($featured_montages) as $m) {
                $montage_name_and_videos = DB::get_montage_name_and_videos($m);
                $names[$m] = $montage_name_and_videos[0];
                $counts[$m] = $montage_name_and_videos[1];
                $videos[$m] = $montage_name_and_videos[2];
            }
            return [$names, $counts, $videos];
        }
        else
            return [[], [], []];
    }
}
