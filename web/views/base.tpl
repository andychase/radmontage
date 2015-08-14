<!doctype html>
<html prefix="og: http://ogp.me/ns#">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>RadMontage: Make A Youtube Montage Today</title>
    <meta name="description" content="Make montages by pasting Youtube links">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="canonical" href="https://radmontage.com/"/>

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
    <meta property="og:url" content="https://radmontage.com"/>
    <meta property="og:type" content="website"/>
    <meta property="og:title" content="It's like an easy bake oven but for montages"/>
    <meta property="og:site_name" content="RadMontage"/>
    <meta property="og:description"
          content="Okay so the site won't make you cookies, but it will let you make montages quickly by just pasting Youtube links. Afterwards you can see them share them or whatever. It's free so">
    <meta property="og:image" content="https://radmontage.com/img/logo_card.png"/>
    <meta property="fb:app_id" content="902780833133901"/>
    <!-- Twitter -->
    <meta name="twitter:card" content="summary"/>
    <meta name="twitter:site" content="@techstoreclub"/>
    <meta property="twitter:url" content="https://radmontage.com"/>
    <meta property="twitter:title" content="It's like an easy bake oven but for montages"/>
    <meta property="twitter:description"
          content="Okay so the site won't make you cookies, but it will let you make montages quickly by just pasting Youtube links. Afterwards you can see them share them or whatever. It's free so"/>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="/css/make.css">
</head>
<body>
<!--[if lt IE 8]>
<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade
    your browser</a> to improve your experience.</p>
<![endif]-->

<nav class="navbar navbar-default">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand navbar-main-logo" href="/"><img src="/img/logo.svg" class="logo" alt="RadMontage"/></a>
        </div>
        <div class="navbar-header">
            <a class="navbar-brand navbar-header-text" href="/"><span id="rad-montage-main-header">RadMontage</span></a>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="/explore">Explore</a></li>
            <li><a href="/edit">Make</a></li>
            <li><a href="/feedback">Feedback</a></li>
        </ul>
        <p class="navbar-text navbar-right nav-about-text">Make Youtube Montages</p>
    </div>
</nav>
{block 'content'}{/block}
<script src="//use.typekit.net/wrp3oee.js"></script>
<script>try {
        Typekit.load({ async: true});
    } catch (e) {
    }</script>
<script>
    window.fbAsyncInit = function () {
        FB.init({
            appId: '902780833133901',
            xfbml: true,
            version: 'v2.4'
        });
    };

    (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {
            return;
        }
        js = d.createElement(s);
        js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
</script>
<script>!function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https';
        if (!d.getElementById(id)) {
            js = d.createElement(s);
            js.id = id;
            js.src = p + '://platform.twitter.com/widgets.js';
            fjs.parentNode.insertBefore(js, fjs);
        }
    }(document, 'script', 'twitter-wjs');</script>
<script>
    (function (i, s, o, g, r, a, m) {
        i['GoogleAnalyticsObject'] = r;
        i[r] = i[r] || function () {
                    (i[r].q = i[r].q || []).push(arguments)
                }, i[r].l = 1 * new Date();
        a = s.createElement(o),
                m = s.getElementsByTagName(o)[0];
        a.async = 1;
        a.src = g;
        m.parentNode.insertBefore(a, m)
    })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

    ga('create', 'UA-58719971-2', 'auto');
    ga('send', 'pageview');

</script>
</body>
</html>
