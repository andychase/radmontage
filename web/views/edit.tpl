{block 'head' append}
    <link rel="canonical" href="https://radmontage.com/edit"/>
{/block}
{block 'title'}RadMontage: Montage Editor{/block}
{extends 'base.tpl'}
{block 'content'}
    <div class="container main-container">
        <div class="row">
            <div class="sidebar col-xs-12 col-md-3">
                <div class="row-container no-min-height">
                    <div class="row-box info-box-space">
                        <div class="form-group">
                            <a href="/edit/new" class="btn btn-default btn-sm" id="save-and-start-new">
                                Save & Start New
                            </a>
                        </div>
                        <div id="previous-montages">
                            <h6>Previously Made Montages</h6>
                            <ul class="dest list-unstyled">
                                <li><i>Saved Montages will appear here.</i></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div style="height: 10px">&nbsp;</div>
            </div>
            <div class="mainbar col-xs-12 col-md-9">
                <hr class="visible-xs-block visible-sm-block">
                <form id="montage-links-container">
                    <div class="row-container no-min-height">
                        <div class="form-group">
                            <label for="montageName">Montage Title:</label>
                            <input type="text" id="montageName" class="form-control" placeholder="Name Your Montage">
                        </div>

                        <div class="form-group">
                            <div id="montage-link">
                                <span id="montage-link-placeholder">A watch button and link will appear here once you've added a video</span>
                                <a class="" href="#"></a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="footer">

    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/js/vendor/jquery-1.11.3.min.js"><\/script>')</script>
    <script src="/js/vendor/jquery-ajax-localstorage-cache.js"></script>
    <script src="/js/make.js"></script>
{/block}