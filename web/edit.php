<?php require('partials/header.html'); ?>
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
<?php require('partials/footer.html'); ?>

