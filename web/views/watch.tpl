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
                                src="/watch_fullscreen/{$montage.id}?iframe=true&slow={$slow}" id="watch-video-iframe"></iframe>
                    </div>
                    <div class="btn-group btn-group-justified watch–controls" role="group">
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default" id="watch-control-previous"><i class="fa fa-arrow-left"></i></button>
                        </div>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default" id="watch-control-play-pause"><i class="fa fa-pause"></i></button>
                        </div>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-default" id="watch-control-skip"><i class="fa fa-arrow-right"></i></button>
                        </div>
                    </div>
                </div>
                <h2 class="watch-montage-header">{$montage.title}</h2>

                <div class="addthis_sharing_toolbox"></div>
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
