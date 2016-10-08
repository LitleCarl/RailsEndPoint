var ClazzIndexController = function($scope, $http){
    $scope.SelectedFloor = null;

    // 过滤规则
    $scope.ClazzFilter = {grade: null};

    // 获取楼层
    $scope.GetFloors = function () {
        $scope.isLoadingForGetFloors = true;
        RequestHandler({
            http: $http,
            path: '/api/floors.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.floors = ApiResponse.GetData(response)['floors'];
            }
        }).finally(function () {
            $scope.isLoadingForGetFloors = false;
        });
    };
    $scope.GetFloors();

    $scope.GetClazz = function () {
        $scope.isLoadingForGetClazzs = true;
        RequestHandler({
            http: $http,
            path: '/api/clazzs.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.clazzs = ApiResponse.GetData(response)['clazzs'];

                (function () {
                    var clazzs = $scope.clazzs || [];
                    var grades = [];

                    _.forEach(clazzs, function (clazz) {
                        if (!_.includes(grades, clazz.grade)){

                            grades.push(clazz.grade);
                        }
                    });

                    $scope.MapClazzsGrades = grades;
                })();
            }
        }).finally(function () {
            $scope.isLoadingForGetClazzs = false;
        });
    };
    // 初始化加载
    $scope.GetClazz();

    // 显示班级详情
    $scope.ShowClazz = function (clazz) {
        $scope.SelectedClazz = clazz;
        $scope.SelectedClazz.copyClazz = {
            floor: clazz.floor,
            room: clazz.room,
            grade: clazz.grade,
            number: clazz.number
        };

        $scope.GetStudents(clazz);
    };

    // 班级更换楼层
    $scope.SetFloorIDForClazz = function (floor) {
        if (floor == $scope.SelectedClazz.copyClazz.floor){
            return;
        }

        // 设置floor并且清楚rooms
        $scope.SelectedClazz.copyClazz.floor = floor;
        $scope.rooms = [];
        $scope.SelectedClazz.copyClazz.room = null;

        // 获取该楼层下的房间
        $scope.isLoadingForGetRooms = true;
        RequestHandler({
            http: $http,
            path: '/api/floors/' + floor.id +'/rooms.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.rooms = ApiResponse.GetData(response)['rooms'];
            }
        }).finally(function () {
            $scope.isLoadingForGetRooms = false;
        });
    };

    // 选择房间
    $scope.SelectRoomForClazz = function (room) {
        $scope.SelectedClazz.copyClazz.room = room;
    };

    // 更新班级信息
    $scope.UpdateClazz = function () {
        var currentClazz = $scope.SelectedClazz;

        var clazzCopy = currentClazz.copyClazz;

        var data = {
                grade: currentClazz.copyClazz.grade,
                number: currentClazz.copyClazz.number,
                room_id: currentClazz.copyClazz.room.id
        };

        $scope.isUpdatingClazz = true;
        RequestHandler({
            http: $http,
            path: '/api/clazzs/'+ currentClazz.id +'.json',
            method: 'put',
            data: data
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.GetClazz();
                $scope.SelectedClazz = null;
                alert('保存成功');
            }
        }).finally(function () {
            $scope.isUpdatingClazz = false;
        });
    };

    // 获取班级下的学生
    $scope.GetStudents = function(clazz){
        $scope.students = [];
        $scope.isLoadingForGetStudents = true;
        RequestHandler({
            http: $http,
            path: '/board/clazzs/'+clazz.id+'/students_list.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.students = ApiResponse.GetData(response)['students'];
            }
        }).finally(function () {
            $scope.isLoadingForGetStudents = false;
        });
    };
};