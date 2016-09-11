// 用户详情页面
var MeDetailController = function($scope, $http){
    $scope.tempStickerConfig = {};

    // 新增配置
    $scope.CreateStickerConfig = function (sticker_config) {
        $scope.isCreatingStickerConfig = true;
        RequestHandler({
            http: $http,
            path: '/api/teachers/create_sticker_config.json',
            method: 'post',
            data: {
                sticker_config: sticker_config
            }
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    $scope.sticker_configs = $scope.sticker_configs || [];

                    console.log((response));

                    $scope.sticker_configs.push(ApiResponse.GetData(response)['sticker_config']);
                    $scope.tempStickerConfig = {};
                }
                else {
                    alert(response['status']['message'])
                }
            }
        ).finally(
            function () {
                $scope.isCreatingStickerConfig = false;
            }
        )
    };

    $scope.GetComments = function () {
        $scope.isGettingComments = true;
        RequestHandler({
            http: $http,
            path: '/api/teachers/comments.json',
            method: 'get'
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    $scope.comments = ApiResponse.GetData(response)['comments'];
                }
            }
        ).finally(
            function () {
                $scope.isGettingComments = false;
            }
        )
    };
    $scope.GetComments();

    // 获取魔法棒按键配置
    $scope.GetStickerConfig = function () {
        $scope.isGettingStickerConfig = true;
        RequestHandler({
            http: $http,
            path: '/api/teachers/sticker_configs.json',
            method: 'get'
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    $scope.sticker_configs = ApiResponse.GetData(response)['sticker_configs'];
                }
            }
        ).finally(
            function () {
                $scope.isGettingStickerConfig = false;
            }
        )
    };
    $scope.GetStickerConfig();

    // 保存配置
    $scope.UpdateStickerConfig = function (stickerConfig) {
        $scope.isUpdatingStickerConfig = true;
        RequestHandler({
            http: $http,
            path: '/api/teachers/update_sticker_config.json',
            method: 'post',
            data: {
                sticker_config: stickerConfig
            }
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    alert('保存成功');
                    stickerConfig.isEditing = false;
                }
                else {
                    alert('保存失败');
                }
            }
        ).finally(
            function () {
                $scope.isUpdatingStickerConfig = false;
            }
        )
    }

    // 获取语音消息,默认未读
    $scope.GetAudioMessages = function () {
        $scope.isGettingAudioMessages = true;
        RequestHandler({
            http: $http,
            path: '/api/teachers/audio_messages.json',
            method: 'get'
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    $scope.audio_messages = ApiResponse.GetData(response)['audio_messages'];
                }
            }
        ).finally(
            function () {
                $scope.isGettingAudioMessages = false;
            }
        )
    }
    $scope.GetAudioMessages();

    $scope.PlayAudio = function (audio_message) {
        if ($scope.isPlaying){
            alert('正在播放中,请稍等');
            return;
        }
        if (audio_message && audio_message['audio']){
            var au = document.createElement('audio');
            au.setAttribute('autoplay', 'true');
            au.controls = true;
            au.src = audio_message['audio'];
            $scope.isPlaying = true;

            au.addEventListener("timeupdate", function() {
                var currentTime = au.currentTime;
                var duration = au.duration;
                var ratio = (currentTime / duration) * 100;

                if (ratio >= 100){
                    $scope.isPlaying = false;
                    $scope.$apply();
                }
            });
        }
        else {
            alert('语音文件不存在')
        }
    }
    
    $scope.SetReaded = function (audio_message) {
        $scope.isSettingAudioMessagesReaded = true;
        RequestHandler({
            http: $http,
            path: '/api/audio_messages/'+audio_message.id+'/set_read.json',
            method: 'post'
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    $scope.audio_messages =  _.filter( $scope.audio_messages, function(au) {
                        return au != audio_message;
                    });
                }
                else {
                    alert('网络错误')
                }
            }
        ).finally(
            function () {
                $scope.isSettingAudioMessagesReaded = false;
            }
        )
    }
};