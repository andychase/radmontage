{extends 'base.tpl'}
{block 'title'}RadMontage: {$montage.title}{/block}
{block 'navbar_class'}navbar-watch-page{/block}
{block 'content'}
    <div class="container main-container">
        <div class="row">
            <div class="mainbar col-xs-12 col-md-10 col-md-offset-1">
                <div class="watch-montage-container">
                    <div class="embed-responsive embed-responsive-16by9">
                        <iframe allowfullscreen webkitallowfullscreen mozallowfullscreen class="embed-responsive-item"
                                src="/watch_fullscreen/{$montage.id}?iframe=true" id="watch-video-iframe"></iframe>
                    </div>
                    <div class="btn-group btn-group-justified watch–controls" role="group">
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default" id="watch-control-skip">Skip</button>
                        </div>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default" id="watch-control-play-pause">Pause/Play
                            </button>
                        </div>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default" id="watch-control-fullscreen">Fullscreen
                            </button>
                        </div>
                    </div>
                </div>
                <h2 class="watch-montage-header">{$montage.title}</h2>

                <h6>Share this Montage</h6>

                <div id="social-buttons-area">
                    <div class="social-button-twitter">
                        <a href="https://twitter.com/share" class="twitter-share-button" data-count="none"
                           data-dnt="true">Tweet</a>
                    </div>
                    <div class="fb-like" data-href="{$page_url}" data-width="190"
                         data-layout="button" data-action="like" data-show-faces="true" data-share="true"></div>
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
