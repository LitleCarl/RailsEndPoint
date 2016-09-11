var BoardClazzShowController = function($scope, $http, $attrs){

    // 初始化Socket.io
    var socket = io(window.appHost.replace(/:[0-9]{1,5}$/, '')+':3001/board');
    socket.on('NewComment', function (clazz_id) {
        $scope.GetComments()
    });

    $(document).on('turbolinks:before-visit', function(){
        socket.disconnect();
    });

    $scope.clazzId = $attrs.clazzid
    $scope.selectedStudent = null;

    $scope.SelectStudent = function (stu) {
        $scope.ResetRecordStatus();
        $scope.selectedStudent = stu;
        $scope.selectedTeacher = null;
    };
    $scope.SelectTeacher = function (teacher) {
        $scope.ResetRecordStatus();
        $scope.selectedTeacher = teacher;
    };

    $scope.BackToMainPage = function () {
        $scope.ResetRecordStatus();
        $scope.selectedTeacher = null;
        $scope.selectedStudent = null;
    }

    $scope.GetStudents = function(){
        $scope.isLoadingForGetStudents = true;

        RequestHandler({
            http: $http,
            path: '/board/clazzs/'+$scope.clazzId+'/students_list.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.students = ApiResponse.GetData(response)['students'];
                $scope.online_count = ApiResponse.GetData(response)['online_count'];
            }
        }).finally(function () {
            $scope.isLoadingForGetStudents = false;
            setTimeout(function () {
                $.AdminLTE.layout.fix();
            }, 1000);
        });
    };

    $scope.GetComments = function(){
        $scope.isLoadingForGetComments = true;

        RequestHandler({
            http: $http,
            path: '/board/clazzs/'+$scope.clazzId+'/comments.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.comments = ApiResponse.GetData(response)['comments'];
            }
        }).finally(function () {
            $scope.isLoadingForGetComments = false;
        });
    };

    // 获取教师接口
    $scope.GetTeachers = function(){
        $scope.isGettingTeachers = true;
        RequestHandler({
            http: $http,
            path: '/board/clazzs/teachers.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.teachers = ApiResponse.GetData(response)['teachers'];
            }
        }).finally(function () {
            $scope.isGettingTeachers = false;
        });
    };

    // 初始化加载
    $scope.GetStudents();
    $scope.GetComments();
    $scope.GetTeachers();

    // 录音相关
    var audio_context;
    var recorder;

    $scope.ResetRecordStatus = function () {
        $scope.recordStatus = {
            isRecording: false,
            wavBlob: null
        }
    };

    // 初始化重置
    $scope.ResetRecordStatus();

    try {
        // webkit shim
        window.AudioContext = window.AudioContext || window.webkitAudioContext;
        navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia;
        window.URL = window.URL || window.webkitURL;

        audio_context = new AudioContext;

        navigator.getUserMedia({audio: true}, function startUserMedia(stream) {
            var input = audio_context.createMediaStreamSource(stream);
            recorder = new Recorder(input);
        }, function(e) {
            alert('无音频输入设备');
        });
    } catch (e) {
        alert('为了使用语音录音功能,请切换Chrome浏览器获得最佳体验!');
    }

    $scope.StartRecording = function() {
        if (!navigator.getUserMedia){
            return alert('请切换Chrome浏览器');
        }

        recorder && recorder.record();
        $scope.recordStatus.isRecording = true;
        $scope.recordStatus.startTime = new Date();
        
        $scope.recordStatus.timer = setInterval(function () {
            $scope.recordStatus.currentTime = new Date();
            $scope.$apply();
        }, 1000)
    }

    // 获取录音时间
    $scope.GetRecordSeconds = function () {
        var status = $scope.recordStatus;
        if (status['startTime'] && status['currentTime']){
            return Math.round((status['currentTime'].getTime() - status['startTime'].getTime()) / 1000);
        }
        else {
            return 0;
        }
    }

    // 试听
    $scope.PlayWav = function () {
        var wav = $scope.recordStatus.wavBlob;
        var url = URL.createObjectURL(wav);
        var au = document.createElement('audio');
        au.setAttribute('autoplay', 'true');
        au.controls = true;
        au.src = url;

        // 正在播放
        $scope.recordStatus.isPlaying = true;

        var status = $scope.recordStatus;
        var totalMilliSeconds = Math.round((status['currentTime'].getTime() - status['startTime'].getTime()) );

        au.addEventListener("timeupdate", function() {
            var currentTime = au.currentTime;
            var duration = au.duration;
            var ratio = (currentTime / duration) * 100;
            $('#play_progress').css('width', ratio+'%')

            if (ratio >= 100){
                $scope.recordStatus.isPlaying = false;
                $('#play_progress').css('width', '0%');
                $scope.$apply();
            }
        });


    }

    $scope.StopRecording = function() {
        // 清除计时器
        clearInterval($scope.recordStatus.timer);

        recorder && recorder.stop();
        
        // 导出wav
        recorder && recorder.exportWAV(function (blob) {
            $scope.recordStatus.wavBlob = blob;
            $scope.recordStatus.isRecording = false;
            $scope.$apply();
            console.log('blob:', blob)
        });
        recorder.clear();
    }
    
    $scope.SendWavSound = function () {
        var fd = new FormData();
        var file = new File([$scope.recordStatus.wavBlob], "wavBlob.wav");
        fd.append('wav_blob', file);
        fd.append('teacher_id', $scope.selectedTeacher.id)
        fd.append('student_id', $scope.selectedStudent.id)

        $http.post('/board/clazzs/create_audio_message.json', fd, {
            withCredentials: true,
            headers: {'Content-Type': undefined },
            transformRequest: angular.identity
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.ResetRecordStatus();
                alert('发送成功');
            }
        });
    }
};