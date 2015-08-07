<?php

require_once('setup.php');

function id_to_img($id)
{
    return "https://i.ytimg.com/vi/$id/mqdefault.jpg";
}
function not_found()
{
    http_response_code(404);
    require("404.html");
    return 0;
}

$id = $_GET['m'];
if ($id && is_numeric($id)) {
    $data = $redis->get($id);
    if ($data) {
        $data = array_slice(explode(":", $data), 1);
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

?><!doctype html>
<html class="no-js" lang="">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Favicons -->
    <link rel="apple-touch-icon" sizes="57x57" href="/favicons/apple-touch-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="/favicons/apple-touch-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/favicons/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="/favicons/apple-touch-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/favicons/apple-touch-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="/favicons/apple-touch-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/favicons/apple-touch-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/favicons/apple-touch-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon-180x180.png">
    <link rel="icon" type="image/png" href="/favicons/favicon-32x32.png" sizes="32x32">
    <link rel="icon" type="image/png" href="/favicons/favicon-194x194.png" sizes="194x194">
    <link rel="icon" type="image/png" href="/favicons/favicon-96x96.png" sizes="96x96">
    <link rel="icon" type="image/png" href="/favicons/android-chrome-192x192.png" sizes="192x192">
    <link rel="icon" type="image/png" href="/favicons/favicon-16x16.png" sizes="16x16">
    <link rel="manifest" href="/favicons/manifest.json">
    <link rel="shortcut icon" href="/favicons/favicon.ico">
    <meta name="apple-mobile-web-app-title" content="RadMontage">
    <meta name="application-name" content="RadMontage">
    <meta name="msapplication-TileColor" content="#2b5797">
    <meta name="msapplication-TileImage" content="/favicons/mstile-144x144.png">
    <meta name="msapplication-config" content="/favicons/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">

    <!-- Open Graph -->
    <meta property="og:title" content="<?php echo($name); ?>">
    <meta property="og:site_name" content="RadMontage">
    <meta property="og:image" content="<?php echo(id_to_img($data[1])); ?>"/>
    <meta property="og:url" content="https://radmontage.com">
    <meta property="og:type" content="video.other">

    <link rel="stylesheet" href="/css/watch.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/js/vendor/jquery-1.11.3.min.js"><\/script>')</script>
    <script src="https://www.youtube.com/iframe_api"></script>
    <script type="text/javascript">
        window.videos = <?php echo($encoded); ?>;
    </script>
    <script src="/js/watch.js"></script>
</head>
<body>
<div id="container">
    <div id="player"></div>
    <div id="instructions">
        <div id="skip"><i class="fa fa-fast-forward"></i></div>
        <div id="pause"><i class="fa fa-pause"></i></div>
        <div id="video-info"><i class="fa fa-file-video-o"></i><span>&rarr;</span></div>
    </div>
    <div id="overlay"></div>
    <video autoplay loop muted id="bgvid" style="display: none;">
        <source src="/img/testCard.webm" type="video/webm">
        <source src="/img/testCard.mp4" type="video/mp4">
    </video>
</div>
<div id="end-splash" style="display:none;">
    <ins class="adsbygoogle"
         style="display:inline-block;width:300px;height:600px"
         data-ad-client="ca-pub-9628790143468004"
         data-ad-slot="8940858558"></ins>

    <div id="some-info" style="display:inline-block;width:300px;height:600px;vertical-align: top">
        <a href="/"><img src="/img/logo_notfound.svg" class="logo"/></a>
        <ul>
            <li><a href=""><i class="fa fa-repeat"></i>Watch again</a></li>
            <li><a href="/edit/<?php echo($id);?>"><i class="fa fa-film"></i>See the videos</a></li>
            <li><a href="/"><i class="fa fa-star"></i>Make your own montage</a></li>
        </ul>
    </div>
    <ins class="adsbygoogle"
         style="display:inline-block;width:300px;height:600px;vertical-align: top"
         data-ad-client="ca-pub-9628790143468004"
         data-ad-slot="1417591750"></ins>
</div>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
</body>
</html>
