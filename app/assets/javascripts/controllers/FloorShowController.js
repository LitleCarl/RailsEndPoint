var FloorShowController = function($scope, $http, $attrs) {

    $scope.floorID = $attrs.floorid;

    $scope.tempPath = null;

    // 取消选择蓝牙基站
    $scope.CancelSelectStation = function(){
        $scope.selectedStation = null;
        redraw();
    };

    // 检测创建房间按钮是否可用
    $scope.CreateRoomBtnEnabled = function () {
      return $scope.tempPathName && $scope.tempPathName.length > 0;
    };
    $scope.$watch('tempBlueToothStation', function() {
        redraw();
    });

    // 创建基站
    $scope.CreateStationForRoom = function () {
        $scope.isCreatingStation = true;
        RequestHandler({
            http: $http,
            path: '/api/rooms/'+ $scope.tempBlueToothStation.room.id +'/create_station.json',
            method: 'post',
            data: {
                device_id: $scope.tempBlueToothStation.device_id,
                location: JSON.stringify($scope.tempBlueToothStation.point),
                group_number: $scope.tempBlueToothStation.group_number
            }
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    // 添加成功,置空变量
                    $scope.tempBlueToothStation = null;
                    $scope.GetFloorShow();
                }
            }
        ).finally(
            function () {
                $scope.isCreatingStation = false;
            }
        )
    };

    // 更新基站信息
    $scope.UpdateStationForRoom = function () {
        $scope.isUpdatingStationForRoom = true;
        RequestHandler({
            http: $http,
            path: '/api/stations/'+ $scope.selectedStation.station.id +'.json',
            method: 'put',
            data: {
                device_id: $scope.selectedStation.device_id,
                location: JSON.stringify($scope.selectedStation.location),
                group_number: $scope.selectedStation.group_number
            }
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    // 添加成功,置空变量
                    $scope.selectedStation = null;
                    $scope.GetFloorShow();
                }
            }
        ).finally(
            function () {
                $scope.isUpdatingStationForRoom = false;
            }
        )
    };

    // 创建房间
    $scope.CreateRoom = function () {
        $scope.isLoadingForGetFloorShow = true;
        RequestHandler({
            http: $http,
            path: '/api/floors/'+ $scope.floorID +'/create_room.json',
            method: 'post',
            data: {
                name: $scope.tempPathName,
                location: JSON.stringify($scope.tempPath)
            }
        }).success(
            function (response) {
                if (ApiResponse.Check(response)) {
                    // 添加成功,置空变量
                    $scope.tempPathName = null;
                    $scope.tempPath = null;
                    $scope.GetFloorShow();
                }
            }
        ).finally(
            function () {
                $scope.isLoadingForGetFloorShow = false;
            }
        )
    };

    // 获取楼层数据
    $scope.GetFloorShow = function () {
        $scope.isLoadingForGetFloorShow = true;

        // 统计数据
        RequestHandler({
            http: $http,
            path: '/api/statistics/floor.json',
            method: 'post',
            data: {
                floor_id: $scope.floorID
            }
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.statistics = ApiResponse.GetData(response);
                console.log('statistics:',$scope.statistics);
                redraw();
            }
        });

        return RequestHandler({
            http: $http,
            path: '/api/floors/'+ $scope.floorID +'.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.floor = ApiResponse.GetData(response)['floor'];

                rooms = $scope.floor.rooms;

                paths = _.map(rooms, function(room){
                    return eval(room.location);
                });

                redraw();
            }
        }).finally(function () {
            $scope.isLoadingForGetFloorShow = false;
        });

    };

    // 初始化执行一遍
    $scope.GetFloorShow();

    $scope.SelectRoom = function (index) {
        var room = $scope.floor.rooms[index]
    };

    // 重新计算Canvas大小
    $scope.ResizeCanvas = function resizeCanvas() {
        redraw();
    };

    // 监听窗口resize事件
    window.addEventListener('resize', function () {
        $scope.ResizeCanvas();
    }, false);

    // 房间路径数组
    var paths = []; // 元素:二维数组[[0,0], [1,4]]
    var tempPoints = [];
    var rooms = [];

    // canvas related variables
    var canvas = document.getElementById("canvas");
    canvas.width = $('body').width();
    var ctx = canvas.getContext("2d");
    var $canvas = $("#canvas");
    var canvasOffset = $canvas.offset();
    var offsetX = canvasOffset.left;
    var offsetY = canvasOffset.top;

    function redraw() {
        document.getElementById('canvas').width = $('#canvas-wrapper').width();
        document.getElementById('canvas').height = $('#canvas-wrapper').height();

        var canvasOffset = $canvas.offset();
        offsetX = canvasOffset.left;
        offsetY = canvasOffset.top;

        ctx.clearRect(0, 0, canvas.width, canvas.height);
        // 画出已有的封闭路径
        paths.forEach(function (points, idx) {
            var path2d = ConvertPointsToPath2D(points);
            ctx.stroke(path2d);
            ctx.fillStyle = points.highLighted ? 'rgba(52, 152, 219, 0.3)' : 'rgba(255,165,0,0.3)';
            ctx.fill(path2d);

            var centroid = d3.polygonCentroid(points);
            if (centroid && centroid[0] && centroid[1]) {
                ctx.textAlign = 'center';
                ctx.fillStyle = 'rgba(0,0,0,1)';

                var onLineCount = 0, roomStatistics = $scope.statistics;
                if (roomStatistics){
                    var filteredStatistic = _.filter(roomStatistics, function (statistic) {
                        return statistic.room.id == rooms[idx].id
                    });
                    if (filteredStatistic[0]){
                        onLineCount = filteredStatistic[0]['count'];
                    }
                }
                ctx.fillText((rooms[idx].name || '未命名') + ' (' + onLineCount + '人在线)', centroid[0] * $('#canvas').width(), centroid[1] * $('#canvas').height());
            }

        });

        // 画出临时路径
        if (tempPoints && tempPoints.length > 0) {
            tempPoints.forEach(function (point, index) {
                ctx.fillStyle = point.highLighted ? "green" : "red";

                ctx.beginPath();
                ctx.arc(point[0] * $('#canvas').width(), point[1] * $('#canvas').height(), 5, 0, Math.PI * 2);
                ctx.closePath();
                ctx.fill();

                if (index != 0) {
                    var lastPoint = tempPoints[index - 1];
                    ctx.beginPath();
                    ctx.moveTo(lastPoint[0] * $('#canvas').width(), lastPoint[1] * $('#canvas').height());
                    ctx.lineTo(point[0] * $('#canvas').width(), point[1] * $('#canvas').height());
                    ctx.closePath();
                    ctx.stroke();
                }
            });
        }

        // 画出已有的蓝牙基站
        rooms.forEach(function (room) {
            if (room && room['stations']){
                room['stations'].forEach(function (station) {
                    ctx.fillStyle = "steelblue";
                    if ($scope.selectedStation && station == $scope.selectedStation.station){
                        ctx.fillStyle = "red";
                        station = $scope.selectedStation;
                    }

                    var point = eval(station.location);
                    ctx.beginPath();
                    ctx.arc(point[0] * $('#canvas').width(), point[1] * $('#canvas').height(), 10, 0, Math.PI * 2);
                    ctx.closePath();
                    ctx.fill();
                });
            }
        });


        // 画出临时蓝牙基站
        if ($scope.tempBlueToothStation && $scope.tempBlueToothStation.point) {
            ctx.fillStyle = "skyblue";
            var point = $scope.tempBlueToothStation.point;
            ctx.beginPath();
            ctx.arc(point[0] * $('#canvas').width(), point[1] * $('#canvas').height(), 10, 0, Math.PI * 2);
            ctx.closePath();
            ctx.fill();

        }
    }

    // 鼠标移动
    // 1.检测是否处于锚点编辑状态,是的话处理鼠标是否回到初始起点
    // 2.检测鼠标是否停放在paths中的某一区域,是则高亮
    function handleMouseMove(e) {
        e.preventDefault();
        e.stopPropagation();

        // 1.检测是否处于锚点编辑状态,是的话处理鼠标是否回到初始起点
        var mouseX = parseInt(e.pageX - offsetX);
        var mouseY = parseInt(e.pageY - offsetY);
        // 检测是否离起始点位置很近
        if (tempPoints[0] && testOriginPointDistance([tempPoints[0][0] *  $('#canvas').width(), tempPoints[0][1] *  $('#canvas').height()], mouseX, mouseY, 15)) {
            tempPoints[0].highLighted = true;
        }
        else if (tempPoints[0]) {
            tempPoints[0].highLighted = false;

        }

        // 2.检测鼠标是否停放在paths中的某一区域,是则高亮
        paths.forEach(function (points) {
            points.highLighted = d3.polygonContains(_.map(points, function (point) {
                return [point[0] * $('#canvas').width(), point[1] * $('#canvas').height()];
            }), [mouseX, mouseY]);
        });
        redraw();
    }

    // 鼠标点击
    function handleMouseClick(e) {
        e.preventDefault();
        e.stopPropagation();

        mouseX = parseInt(e.pageX - offsetX);
        mouseY = parseInt(e.pageY - offsetY);

        console.log('#mouseY:', e.clientY);

        // 选中了某个蓝牙基站,需要重新调换位置
        if ($scope.selectedStation) {
            var roomCoverMouse = null;
            paths.forEach(function (points, idx) {
                if (d3.polygonContains(_.map(points, function (point) {
                        return [point[0] * $('#canvas').width(), point[1] * $('#canvas').height()]
                    }), [mouseX, mouseY])) {
                    roomCoverMouse = rooms[idx];
                }
            });

            if ($scope.selectedStation.room != roomCoverMouse){
                console.log('非法操作');
                alert('不能移动到房间以外');
            }
            else{
                $scope.selectedStation.location = [mouseX / $('#canvas').width(), mouseY / $('#canvas').height()];
                $scope.$apply();
                redraw();
            }
            return;
        }

        var intersect = false;
        var intersectRoomIndex = -1;
        // 禁止点击的point交叉现有的path
        paths.forEach(function (points, idx) {
            if (d3.polygonContains(_.map(points, function (point) {
                    return [point[0] * $('#canvas').width(), point[1] * $('#canvas').height()]
                }), [mouseX, mouseY])) {
                intersect = true;
                intersectRoomIndex = idx;
            }
        });

        // 如果点击了已有的区域
        if (intersect) {
            // 当前已经有未完成的房间勾画,不能继续如下操作
            if (tempPoints.length < 1) {
                // 检测点击是否落在蓝牙基站上,
                // 是的话显示已有的基站信息,
                // 否则添加蓝牙基站

                // 检测是否与已有的基站重合
                var stations = [];
                _.each(rooms, function (room) {
                    stations = _.concat(stations, room.stations)
                });
                _.each(stations, function (station) {
                    var point = eval(station.location);
                    if (point){
                        if (testOriginPointDistance([point[0] * $('#canvas').width(), point[1] * $('#canvas').height()], mouseX, mouseY, 15)){
                            $scope.selectedStation = {
                                station: station,
                                location: eval(station.location),
                                device_id: station['device_id'],
                                group_number: station['group_number'],
                            };
                            var roomOfStation = null;
                            _.each(rooms, function (room) {
                                var index = _.indexOf(room.stations||[], station);
                                if (index >= 0){
                                    roomOfStation = room;
                                }
                            });
                            $scope.selectedStation.room = roomOfStation;
                            $scope.$apply();
                        }
                    }
                });

                if ($scope.selectedStation) {
                    redraw();

                    return;
                }

                // 添加蓝牙基站操作
                $scope.tempBlueToothStation = {
                    point: [mouseX / $('#canvas').width(), mouseY / $('#canvas').height()],
                    room: rooms[intersectRoomIndex]
                };
                $scope.$apply();
                return;
            } else {
                return;
            }
        }

        tempPoints = tempPoints || [];

        // 检测是否点击了起始点位置
        if (tempPoints[0] && testOriginPointDistance([tempPoints[0][0] *  $('#canvas').width(), tempPoints[0][1] *  $('#canvas').height(), ], mouseX, mouseY, 15)) {
            //paths.push(tempPoints);
            $scope.tempPath = tempPoints;
            $scope.$apply();
            //console.log('paths:', JSON.stringify(tempPoints));

            tempPoints = [];
            redraw();
            return;
        }

        // 如果正在编辑添加基站则不添加path
        if (!$scope.tempBlueToothStation){
            tempPoints.push([mouseX/$('#canvas').width(), mouseY/$('#canvas').height()]);
        }

        redraw();
    }

    // tell the browser to call handleMousedown
    // whenever the mouse moves
    $("#canvas").click(function (e) {
        handleMouseClick(e);
    });
    $("#canvas").mousemove(function (e) {
        handleMouseMove(e);
    });
    // 撤销操作
    $(document).keydown(function (e) {

        if (e.which === 90 && e.ctrlKey) {
            tempPoints.pop();
            redraw();
        }
    });

    function ConvertPointsToPath2D(points) {
        var tempPath2d = new Path2D();

        points.forEach(function (point, index) {
            if (index == 0) {
                tempPath2d.moveTo(point[0] * $('#canvas').width(), point[1] * $('#canvas').height());
            }
            else {
                tempPath2d.lineTo(point[0] * $('#canvas').width(), point[1] * $('#canvas').height());
            }
        });
        tempPath2d.closePath();
        return tempPath2d;
    }
    // 计算离起点的距离
    function testOriginPointDistance(origin, x, y, threshold) {
        threshold = threshold || 5;
        var length = Math.sqrt(Math.pow((origin[0] - x), 2) + Math.pow((origin[1] - y), 2));
        return length <= threshold;
    }
};