//Copyright 2011 Nectify
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
/**
 * https://github.com/SaneMethod/jquery-ajax-localstorage-cache
 */
; (function($){
    /**
     * Generate the cache key under which to store the local data - either the cache key supplied,
     * or one generated from the url, the type and, if present, the data.
     */
    var genCacheKey = function (options) {
        var url = options.url.replace(/jQuery.*/, '');

        // Strip _={timestamp}, if cache is set to false
        if (options.cache === false) {
            url = url.replace(/([?&])_=[^&]*/, '');
        }

        return options.cacheKey || url + options.type + (options.data || '');
    };
    /**
     * Prefilter for caching ajax calls.
     * See also $.ajaxTransport for the elements that make this compatible with jQuery Deferred.
     * New parameters available on the ajax call:
     * localCache   : true // required - either a boolean (in which case localStorage is used), or an object
     * implementing the Storage interface, in which case that object is used instead.
     * cacheTTL     : 5,           // optional - cache time in hours, default is 5.
     * cacheKey     : 'post',      // optional - key under which cached string will be stored
     * isCacheValid : function  // optional - return true for valid, false for invalid
     * @method $.ajaxPrefilter
     * @param options {Object} Options for the ajax call, modified with ajax standard settings
     */
    $.ajaxPrefilter(function(options){
        var storage = (options.localCache === true) ? window.localStorage : options.localCache,
            hourstl = options.cacheTTL || 5,
            cacheKey = genCacheKey(options),
            cacheValid = options.isCacheValid,
            ttl,
            value;

        if (!storage) return;
        ttl = storage.getItem(cacheKey + 'cachettl');

        if (cacheValid && typeof cacheValid === 'function' && !cacheValid()){
            storage.removeItem(cacheKey);
        }

        if (ttl && ttl < +new Date()){
            storage.removeItem(cacheKey);
            storage.removeItem(cacheKey + 'cachettl');
            ttl = 0;
        }

        value = storage.getItem(cacheKey);
        if (!value){
            // If it not in the cache, we store the data, add success callback - normal callback will proceed
            if (options.success) {
                options.realsuccess = options.success;
            }
            options.success = function(data) {
                var strdata = data;
                if (this.dataType.toLowerCase().indexOf('json') === 0) strdata = JSON.stringify(data);

                // Save the data to storage catching exceptions (possibly QUOTA_EXCEEDED_ERR)
                try {
                    storage.setItem(cacheKey, strdata);
                } catch (e) {
                    // Remove any incomplete data that may have been saved before the exception was caught
                    storage.removeItem(cacheKey);
                    storage.removeItem(cacheKey + 'cachettl');
                    console.log('Cache Error:'+e, cacheKey, strdata );
                }

                if (options.realsuccess) options.realsuccess(data);
            };

            // store timestamp
            if (!ttl){
                storage.setItem(cacheKey + 'cachettl', +new Date() + 1000 * 60 * 60 * hourstl);
            }
        }
    });

    /**
     * This function performs the fetch from cache portion of the functionality needed to cache ajax
     * calls and still fulfill the jqXHR Deferred Promise interface.
     * See also $.ajaxPrefilter
     * @method $.ajaxTransport
     * @params options {Object} Options for the ajax call, modified with ajax standard settings
     */
    $.ajaxTransport("+*", function(options){
        if (options.localCache)
        {
            var cacheKey = genCacheKey(options),
                storage = (options.localCache === true) ? window.localStorage : options.localCache,
                value = (storage) ? storage.getItem(cacheKey) : false;

            if (value){
                // In the cache? Get it, parse it to json if the dataType is JSON,
                // and call the completeCallback with the fetched value.
                if (options.dataType.toLowerCase().indexOf('json') === 0) value = JSON.parse(value);
                return {
                    send: function(headers, completeCallback) {
                        var response = {};
                        response[options.dataType] = value;
                        completeCallback(200, 'success', response, '');
                    },
                    abort: function() {
                        console.log("Aborted ajax transport for json cache.");
                    }
                };
            }
        }
    });
})(jQuery);