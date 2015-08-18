<!doctype html>
<html prefix="og: http://ogp.me/ns#">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>RadMontage: {$montage_name}</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base target="_parent" />

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
    <meta property="og:title" content="{$montage_name}">
    <meta property="og:site_name" content="RadMontage">
    <meta property="og:image" content="{$montage_thumb}"/>
    <meta property="og:url" content="https://radmontage.com/watch/{$montage_id}">
    <meta property="og:type" content="website">
    <meta property="og:description" content="Check out this crazy cool montage">
    <!-- Twitter -->
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:site" content="@techstoreclub" />
    <meta property="twitter:title" content="{$montage_name}" />
    <meta property="twitter:description" content="Check out this crazy cool montage" />
    <meta property="twitter:image" content="{$montage_thumb}"/>

    <link rel="stylesheet" href="/css/watch.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/js/vendor/jquery-1.11.3.min.js"><\/script>')</script>
    <script src="https://www.youtube.com/iframe_api"></script>
    <script type="text/javascript">
        window.videos = {$montage_encoded};
    </script>
    <script src="/js/watch.js"></script>
</head>
<body>
<div id="container">
    <div id="player"></div>
    <div id="player2"></div>
</div>
<div id="end-splash" style="display:none;">
    <div id="some-info">
        <a target="_parent" href="/"><img src="/img/logo_end.svg" class="logo" alt="Logo/PageNotFound"/></a>
        <ul>
            <li><a target="_parent" href="/watch{if !$in_iframe}_fullscreen{/if}/{$montage_id}"><i class="fa fa-repeat"></i>Watch again</a></li>
            <li><a target="_parent" href="/edit/{$montage_id}"><i class="fa fa-film"></i>See the videos</a></li>
            <li><a target="_parent" href="/edit/new"><i class="fa fa-star"></i>Make your own montage</a></li>
        </ul>
    </div>
    <ins class="adsbygoogle"
         style="display:block"
         data-ad-client="ca-pub-9628790143468004"
         data-ad-slot="5408322552"
         data-ad-format="auto"></ins>
</div>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<script>
    (function(i,s,o,g,r,a,m){ i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-58719971-2', 'auto');
    ga('send', 'pageview');

</script>
</body>
</html>
