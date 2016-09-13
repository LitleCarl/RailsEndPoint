var ClazzNewController = function($scope, $http){
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

    $scope.SelectFloor = function (floor) {
        if ($scope.selectedFloor == floor){
            return;
        }
        $scope.selectedFloor = floor;
        $scope.selectedRoom = null;

        $scope.rooms = [];

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

    $scope.SelectRoom = function (room) {
        $scope.selectedRoom = room;
    };

    // 添加班级
    $scope.AddClazz = function () {
        $scope.isSubmitting = true;
        RequestHandler({
            http: $http,
            path: '/api/clazzs.json',
            method: 'post',
            data: {
                grade: $scope.grade,
                number: $scope.number,
                room_id: $scope.selectedRoom.id
            }
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.grade = null;
                $scope.number = null;
                $scope.selectedRoom = null;
                $scope.selectedFloor = null;
                alert('添加成功');
            }
        }).finally(function () {
            $scope.isSubmitting = false;
        });
    }

};