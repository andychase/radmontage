<?php require('partials/header.html'); ?>
<div class="container main-container">
    <div class="row">
        <div class="sidebar col-xs-12 col-md-3">
            <h6>Categories</h6>
            <ul class="nav nav-pills nav-stacked">
                <li><a href="/explore/featured">Featured</a></li>
                <li><a href="/explore/beyond-normal">Beyond Normal</a></li>
            </ul>
            <h6>Share RadMontage</h6>

            <div id="social-buttons-area">
                <div class="social-button-twitter">
                    <a href="https://twitter.com/share" class="twitter-share-button" data-via="techstoreclub"
                       data-count="none" data-dnt="true">Tweet</a>
                </div>
                <div class="fb-like" data-href="https://radmontage.com" data-width="212"
                     data-layout="standard" data-action="like" data-show-faces="true" data-share="true"></div>
            </div>
        </div>
        <div class="mainbar col-xs-12 col-md-9">
            <hr class="visible-xs-block">
            <hr class="visible-sm-block">
            <div class="explore-intro-text">Explore and Create Captivating Youtube Montages</div>
            <div class="explore-video-block">
                <a href="/watch/000jc473050">
                <div class="explore-video-thumb" id="000jc473050"></div>
                </a>
                <a href="/watch/000jc473050"><span class="explore-video-title">Deep Into Youtube: Introduction</span></a>
                <span class="explore-video-video-count">7 Videos</span>
            </div>
        </div>
    </div>
</div>
<div class="footer">

</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="/js/vendor/jquery-1.11.3.min.js"><\/script>')</script>
<script src="/js/vendor/jquery-ajax-localstorage-cache.js"></script>
<script>
window.montage_images = {
    "000jc473050": [
            "n7IseFHySIg",
            "smycGG2Dsa8",
            "e79PU5bEl_8",
            "p9zcfow3AcU",
            "iZ8nN6hTnmM",
            "71-nhNpXi_I",
            "q6EoRBvdVPQ",
            "qSqJOj-g5yY"
    ]
}
</script>
<script src="/js/explore.js"></script>
<?php require('partials/footer.html'); ?>
