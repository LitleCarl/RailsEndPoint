var ClazzIndexController = function($scope, $http){
    $scope.ShouldShowRightBar = false;

    $scope.floors = [{name: '楼层1'}]
    $scope.SelectedFloor = null;

    $scope.GetClazz = function () {
        $scope.isLoadingForGetClazzs = true;

        RequestHandler({
            http: $http,
            path: '/api/clazzs.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.clazzs = ApiResponse.GetData(response)['clazzs'];
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
        $scope.ShouldShowRightBar = true;
    }
};