var PortalController = function($scope, $http){
    $scope.GetStatistic = function () {
        $scope.isLoadingForOnLineCountOfFloor = true;
        return RequestHandler({
            http: $http,
            path: '/api/statistics.json',
            method: 'get'
        })
    };
    $scope.GetStatistic().success(function (response) {
        if (ApiResponse.Check(response)){
            //结构如下
            //[{"count":1,"floor":{"id":1,"name":"楼层一"}...]
            var data = ApiResponse.GetData(response);
            $scope.data = data;
            console.log('data:',data)
            var ctx = document.getElementById("pieChartForOnlineCountOfFloor");
            var chart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: _.map(data, function (item) {
                        return item['floor']['name'];
                    }),
                    datasets: [{
                        label: '楼层在线人数分布',
                        data: _.map(data, function (item) {
                            return item['count'];
                        }),
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.8)',
                            'rgba(54, 162, 235, 0.8)',
                            'rgba(255, 206, 86, 0.8)',
                            'rgba(75, 192, 192, 0.8)',
                            'rgba(153, 102, 255, 0.8)',
                            'rgba(255, 159, 64, 0.8)'
                        ],
                        borderColor: [
                            'rgba(255,99,132,1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 1
                    }]
                }

            });

            $("#pieChartForOnlineCountOfFloor").click(
                function(evt){
                    var activePoints = chart.getElementAtEvent(evt);
                    if (activePoints.length > 0){
                        var clickedFloorIndex = activePoints[0]._index;
                        //TODO: 跳转楼层链接
                        Turbolinks.visit('/floors/'+$scope.data[clickedFloorIndex]['floor'].id)
                    }
                }
            );
        }
    }).finally(function () {
        $scope.isLoadingForOnLineCountOfFloor = false;
    });
};
