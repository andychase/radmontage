{extends 'base.tpl'}
{block 'head' append}
    <link rel="canonical" href="https://radmontage.com"/>
{/block}
{block 'content'}
    <div class="container main-container">
        <div class="row">
            {*<div class="sidebar col-xs-12 col-md-3">*}
                {*<h6>Categories</h6>*}
                {*<ul class="nav nav-pills nav-stacked">*}
                    {*<li><a href="/explore/featured">Featured</a></li>*}
                    {*<li><a href="/explore/beyond-normal">Beyond Normal</a></li>*}
                {*</ul>*}
            {*</div>*}
            <div class="mainbar col-xs-12 col-md-11 col-md-offset-1">
                <div class="explore-intro-text">Explore and Create Captivating YouTube Playlists</div>
                {foreach $featured_videos as $video_id => $videos}
                <div class="explore-video-block">
                    <a href="/watch/{$video_id}">
                        <div class="explore-video-thumb" id="{$video_id}"></div>
                    </a>
                    <a href="/watch/{$video_id}">
                        <span class="explore-video-title">{$featured_names[$video_id]}</span>
                    </a>
                    <span class="explore-video-video-count">{$featured_counts[$video_id]} Videos</span>
                    {if $featured_explicits[$video_id]}
                        <span class="explore-explicit-warning">explicit</span>
                    {/if}
                </div>
                {/foreach}
            <span class="explore-featured-howto">
                Made a cool montage and want it featured? Send it to us on <a href="/beta.html">our feedback page</a>!
            </span>
            </div>
        </div>
    </div>
    <div class="footer"></div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/js/vendor/jquery-1.11.3.min.js"><\/script>')</script>
    <script>
        window.montage_images = {$featured_videos_encoded};
    </script>
    <script src="/js/explore.js"></script>
{/block}