<?php

require_once('setup.php');

function id_to_img($id)
{
    return "https://i.ytimg.com/vi/$id/mqdefault.jpg";
}
function not_found()
{
    http_response_code(404);
    require("404_montage.html");
    return 0;
}

$id = $_GET['m'];
if ($id) {
    $data = DB::get_montage($id);
    if ($data) {
        $data = array_slice($data, 1);
        if (count($data) < 3)
            return not_found();

        $encoded = json_encode($data);
    } else {
        return not_found();
    }
} else {
    return not_found();
}

$name = $data[0];
if ($name == "")
    $name = "My Montage";

$smarty->assign("montage_name", $name);
$smarty->assign("montage_encoded", $encoded);
$smarty->assign("montage_id", $id);
$smarty->assign("montage_thumb", id_to_img($data[1]));
$smarty->display("watch_fullscreen.tpl");
