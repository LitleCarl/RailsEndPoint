var BoardClazzShowController = function($scope, $http){

    // 初始化Socket.io
    var socket = io(window.appHost.replace(/:[0-9]{1,5}$/, '')+':3001/board');
    socket.on('NewComment', function (clazz_id) {
        $scope.GetComments()
    });

    $(document).on('turbolinks:before-visit', function(){
        socket.disconnect();
    });

    $scope.GetStudents = function(){
        $scope.isLoadingForGetStudents = true;

        RequestHandler({
            http: $http,
            path: '/board/clazzs/1/students_list.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.students = ApiResponse.GetData(response)['students'];
                $scope.online_count = ApiResponse.GetData(response)['online_count'];
            }
        }).finally(function () {
            $scope.isLoadingForGetStudents = false;
        });
    };

    $scope.GetComments = function(){
        $scope.isLoadingForGetComments = true;

        RequestHandler({
            http: $http,
            path: '/board/clazzs/1/comments.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.comments = ApiResponse.GetData(response)['comments'];
            }
        }).finally(function () {
            $scope.isLoadingForGetComments = false;
        });
    };

    // 初始化加载
    $scope.GetStudents();
    $scope.GetComments();
};