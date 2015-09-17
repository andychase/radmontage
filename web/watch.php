<?php
require("setup.php");

$montage_data = DB::get_montage_metadata($_GET['m']);

$smarty->assign('page_title', "Watch this Montage: {$montage_data['title']}");
$smarty->assign('page_url', "https://radmontage.com/watch/{$montage_data['id']}");
$smarty->assign('page_logo_card', $montage_data['first_video_image']);
$smarty->assign('page_description_long', "Check out this crazy cool montage");

$smarty->assign("montage", $montage_data);
if ($_GET['slow']) {
    $smarty->assign("slow", "true");
} else {
    $smarty->assign("slow", "false");
}
$smarty->display("watch.tpl");
