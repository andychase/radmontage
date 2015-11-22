<?php
require_once('../vendor/autoload.php');

$url = parse_url(getenv("DATABASE_URL"));

$db_host = $url["host"];
$db_user = $url["user"];
$user_pw = $url["pass"];
$db_name = substr($url["path"], 1);

$_pdo = new PDO('pgsql:host=' . $db_host . '; dbname=' . $db_name, $db_user, $user_pw);


$PDO = new FluentPDO($_pdo);

class SQL
{
    public static function get($name)
    {
        global $PDO;
        return $PDO->from("montage")->where("name", $name)->fetch("data");
    }

    public static function set($name, $data)
    {
        global $PDO;
        $PDO->update("montage", array("data" => $data))->where("name", $name)->execute();
    }

    public static function incr()
    {
        global $PDO;
        $PDO->insertInto("montage", array("data" => "", "name" => ""))->execute();
        return $PDO->getPdo()->lastInsertId("montage_id_seq");
    }

    public static function set_name($numeric_id, $id, $secret)
    {
        global $PDO;
        $PDO->update("montage", array("data" => $secret, "name" => $id), $numeric_id)->execute();
    }
}
