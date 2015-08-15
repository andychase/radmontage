{extends 'base.tpl'}
{block 'title'}RadMontage: {$montage.title}{/block}
{block 'content'}
    <div class="container main-container">
        <div class="row">
            <div class="sidebar col-xs-12 col-md-3">
                {*<h6>Categories</h6>*}
                {*<ul class="nav nav-pills nav-stacked">*}
                    {*<li><a href="/explore/featured">Featured</a></li>*}
                    {*<li><a href="/explore/beyond-normal">Beyond Normal</a></li>*}
                {*</ul>*}
                <h6>Share this Montage</h6>

                <div id="social-buttons-area">
                    <div class="social-button-twitter">
                        <a href="https://twitter.com/share" class="twitter-share-button" data-count="none" data-dnt="true">Tweet</a>
                    </div>
                    <div class="fb-like" data-href="{$page_url}" data-width="190"
                         data-layout="button" data-action="like" data-show-faces="true" data-share="true"></div>
                </div>
            </div>
            <div class="mainbar col-xs-12 col-md-9">
                <hr class="visible-xs-block">
                <hr class="visible-sm-block">
                <iframe allowfullscreen webkitallowfullscreen mozallowfullscreen
                        src="/watch_fullscreen/{$montage.id}?iframe=true" id="watch-video-iframe"></iframe>
                <div class="btn-group watch–controls" role="group">
                    <button type="button" class="btn btn-default" id="watch-control-skip">Skip</button>
                    <button type="button" class="btn btn-default" id="watch-control-play-pause">Pause/Play</button>
                    <button type="button" class="btn btn-default" id="watch-control-fullscreen">Fullscreen</button>
                </div>
            </div>
        </div>
    </div>
    <div class="footer">

    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/js/vendor/jquery-1.11.3.min.js"><\/script>')</script>
    <script src="/js/explore.js"></script>
    {include '_social_code.tpl'}
{/block}
