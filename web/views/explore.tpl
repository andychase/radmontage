{extends 'base.tpl'}
{block 'content'}
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
                {foreach $featured_videos as $video_id => $videos }
                <div class="explore-video-block">
                    <a href="/watch/{$video_id}">
                        <div class="explore-video-thumb" id="{$video_id}"></div>
                    </a>
                    <a href="/watch/{$video_id}">
                        <span class="explore-video-title">{$featured_names[$video_id]}</span></a>
                    <span class="explore-video-video-count">{$featured_counts[$video_id]} Videos</span>
                </div>
                {/foreach}
            <span class="explore-featured-howto">
                Made a cool montage and want it featured? Send it to us on <a href="/beta.html">our feedback page</a>!
            </span>
            </div>
        </div>
    </div>
    <div class="footer">

    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/js/vendor/jquery-1.11.3.min.js"><\/script>')</script>
    <script src="/js/vendor/jquery-ajax-localstorage-cache.js"></script>
    <script>
        window.montage_images = {$featured_videos_encoded};
    </script>
    <script src="/js/explore.js"></script>
{/block}