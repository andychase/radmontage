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

$smarty->assign('page_description_short', "Explore and Create Captivating Youtube Montages");
$smarty->assign('page_url', "https://radmontage.com");
$smarty->assign('page_logo_card', "https://radmontage.com/img/logo_card.png");
$smarty->assign('page_title', "It's like an easy bake oven but for montages");
$smarty->assign('page_description_long', "Okay so the site won't make you cookies, but it will let you make montages quickly by just pasting Youtube links. Afterwards you can see them share them or whatever.");

function id_to_img($id)
{
    return "https://i.ytimg.com/vi/$id/mqdefault.jpg";
}

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

    static function get_montage_metadata($id)
    {
        $data = DB::get_montage($id);
        return [
            "id" => $id,
            "title" => $data[1],
            "first_video_image" => id_to_img($data[2]),
        ];
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

        $image_count = 0;
        $images_in_output = [];
        foreach ($montage_data as $i => $video) {
            $first = $i == 1;
            $already_seen = array_key_exists($video, $images_in_output);
            $has_enough_videos = $image_count >= DB::truncate_videos_at;
            $is_video_link = ($i - 2) % 3 == 0;
            if ($has_enough_videos) {
                break;
            } else if ($first) {
                $name = $video;
            } else if (!$already_seen && $is_video_link) {
                $output[] = $video;
                $images_in_output[$video] = 1;
                $image_count++;
            }
        }
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
        $explicits = [];
        $videos = [];
        if ($featured_montages) {
            $ids = json_decode($featured_montages);
            foreach (DB::get_montages($ids) as $i => $m) {
                $montage_name_and_videos = DB::get_montage_name_and_videos($m);
                if (substr($montage_name_and_videos[0], -7) == " [nsfw]") {
                    $explicits[$ids[$i]] = true;
                    $names[$ids[$i]] = substr($montage_name_and_videos[0], 0, -7);
                } else {
                    $explicits[$ids[$i]] = false;
                    $names[$ids[$i]] = $montage_name_and_videos[0];
                }
                $counts[$ids[$i]] = $montage_name_and_videos[1];
                $videos[$ids[$i]] = $montage_name_and_videos[2];
            }
        }
        return [$names, $counts, $explicits, $videos];
    }
}
