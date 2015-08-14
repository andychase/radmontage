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
                <iframe allowfullscreen webkitallowfullscreen mozallowfullscreen
                        src="/watch_fullscreen/{$montage_id}" id="watch-video-iframe"></iframe>
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
{/block}
