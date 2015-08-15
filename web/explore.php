<?php
require("setup.php");

$featured = DB::get_featured_videos($_GET['p']);
$featured_names = $featured[0];
$featured_counts = $featured[1];
$featured_videos = $featured[2];

$smarty->assign('page_title', "It's like an easy bake oven but for montages");
$smarty->assign('page_description_long', "Okay so the site won't make you cookies, but it will let you make montages quickly by just pasting Youtube links. Afterwards you can see them share them or whatever. It's free so");

$smarty->assign('featured_names', $featured_names);
$smarty->assign('featured_counts', $featured_counts);
$smarty->assign('featured_videos', $featured_videos);
$smarty->assign('featured_videos_encoded', json_encode($featured_videos));
$smarty->display('explore.tpl');
