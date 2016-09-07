// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require angular
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-angular
//= require Chart.bundle.min
//= require lodash
//= require_tree .

var mainModule;
var loadOnce = true;

var ApiResponse = {
    Check: function(response){
        return response && response['status'] && response['status']['code'] == 200
    },
    GetMessage: function(response){
        if (response && response['status'] && response['status']['message']){
            return response['status']['message'];
        }
        else {
            return 'Unknown Error';
        }
    },
    GetData: function (response) {
        return response['data'];
    }
};
var RequestHandler = function(options){
        //options = {
        //    http: $http,
        //    method: 'get',
        //    data: {},
        //    path: '',
        //    host: ''
        //};
        var host = options['host'] || 'http://edu.zaocan84.com';
        var url = host + (options['path'] || '');
        var data = options['data'] || {}

        return options['http'][options['method']](url, data);
            //.success(function (data, status, headers, config) {
            //})
            //.error(function (data, status, header, config) {
            //});
};

var moduleName = 'TsaoAppMoudle';

$(document).on('turbolinks:load', function () {
    if (loadOnce){
        loadOnce = false;
        //moduleName = 'TsaoAppMoudle';// + Math.random().toString(36).substring(20);
        mainModule = angular.module(moduleName, ['nprogress-rails']);

        // 控制器配置
        mainModule.controller('PortalController', ['$scope', '$http', PortalController]);
        mainModule.controller('FloorIndexController', ['$scope', '$http', FloorIndexController]);
        mainModule.controller('FloorShowController', ['$scope', '$http', '$attrs', FloorShowController]);
        mainModule.controller('ClazzIndexController', ['$scope', '$http', ClazzIndexController]);
        mainModule.controller('BoardClazzShowController', ['$scope', '$http', BoardClazzShowController]);

        // 自定义功能
        // ng-src图片加载完成
        mainModule.directive('imageonload', function() {
            return {
                restrict: 'A',
                link: function(scope, element, attrs) {
                    element.bind('load', function() {
                        //call the function that was passed
                        scope.$apply(attrs.imageonload);
                    });
                }
            };
        });
    }

});

// Fix样式问题
$(document).on('turbolinks:load', function () {
    $.AdminLTE.layout.fix();

    $('input').iCheck({
        checkboxClass: 'icheckbox_flat-blue',
        radioClass: 'iradio_square-blue',
        increaseArea: '20%' // optional
    });

});



$(document).on('turbolinks:load', function () {
    Turbolinks.clearCache();
    angular.bootstrap("body", [moduleName]);
});

