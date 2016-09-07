var FloorIndexController = function($scope, $http) {
    $scope.GetFloors = function () {
        $scope.isLoadingForGetFloors = true;
        return RequestHandler({
            http: $http,
            path: '/api/floors.json',
            method: 'get'
        })
    };

    $scope.GetFloors().success(function (response) {
        if (ApiResponse.Check(response)) {
            $scope.floors = ApiResponse.GetData(response)['floors'];
        }
    }).finally(function () {
        $scope.isLoadingForGetFloors = false;
    });
};