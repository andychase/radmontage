<?php
require("setup.php");

$featured = DB::get_featured_videos($_GET['p']);
$featured_names = $featured[0];
$featured_videos = $featured[1];

$smarty->assign('featured_names', $featured_names);
$smarty->assign('featured_videos', $featured_videos);
$smarty->assign('featured_videos_encoded', json_encode($featured_videos));
$smarty->display('explore.tpl');
