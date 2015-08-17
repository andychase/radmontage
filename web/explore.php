<?php
require("setup.php");

$featured = DB::get_featured_videos($_GET['p']);
$featured_names = $featured[0];
$featured_counts = $featured[1];
$featured_explicits = $featured[2];
$featured_videos = $featured[3];

$smarty->assign('featured_names', $featured_names);
$smarty->assign('featured_counts', $featured_counts);
$smarty->assign('featured_explicits', $featured_explicits);
$smarty->assign('featured_videos', $featured_videos);
$smarty->assign('featured_videos_encoded', json_encode($featured_videos));
$smarty->display('explore.tpl');
