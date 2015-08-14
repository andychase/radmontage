<?php
require("setup.php");

$smarty->assign("montage_id", $_GET['m']);
$smarty->display("watch.tpl");