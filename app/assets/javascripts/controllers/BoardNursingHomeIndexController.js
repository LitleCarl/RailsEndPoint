var BoardNursingHomeIndexController = function($scope, $http, $interval) {
    $scope.showTracks = false;
    var stop;
    (function() {
        // Don't start a new fight if we are already fighting
        if ( angular.isDefined(stop) ) return;

        $scope.isLoadingForGeoData = true;
        function LoadForGeoData(){
            RequestHandler({
                http: $http,
                path: '/board/nursing_home/realtime_geo_data.json',
                method: 'get'
            }).success(function (response) {
                if (ApiResponse.Check(response)) {
                    $scope.tracks = ApiResponse.GetData(response)['tracks'];
                    redraw();
                }
            }).finally(function () {
                $scope.isLoadingForGeoData = false;
            });
        }

        stop = $interval(function() {
            // 拉去用户位置信息
            LoadForGeoData();
            $scope.GetData();
        }, 1000 * 30); // 30秒更新一次
        LoadForGeoData();// 初始化加载一次
    })();

    // 控制器销毁时停止用户地理位置数据更新
    $scope.$on('$destroy', function() {
        // Make sure that the interval is destroyed too
        if (angular.isDefined(stop)) {
            $interval.cancel(stop);
            stop = undefined;
        }
    });

    // 获取数据
    $scope.GetData = function () {
        $scope.isLoadingForGettingData = true;

        RequestHandler({
            http: $http,
            path: '/board/nursing_home/page_data.json',
            method: 'get'
        }).success(function (response) {
            if (ApiResponse.Check(response)) {
                $scope.floors = ApiResponse.GetData(response)['floors'];
                $scope.students = _.orderBy(ApiResponse.GetData(response)['students'], ['online'], ['desc']);
                $scope.online_ids = ApiResponse.GetData(response)['online_ids'];

                if ($scope.floors.length > 0 && $scope.selectedFloor == null){
                    $scope.SelectFloor($scope.floors[0]);
                }

            }
        }).finally(function () {
            $scope.isLoadingForGettingData = false;
        });
    };

    // 选择楼层
    $scope.SelectFloor = function (floor) {
        $scope.selectedFloor = floor;
        redraw()
    };

    $scope.GetData();

    // 重新计算Canvas大小
    $scope.ResizeCanvas = function resizeCanvas() {
        redraw();
    };

    // 监听窗口resize事件
    window.addEventListener('resize', function () {
        $scope.ResizeCanvas();
    }, false);

    var canvas = document.getElementById("canvas");
    canvas.width = $('body').width();
    var ctx = canvas.getContext("2d");
    var $canvas = $("#canvas");
    var canvasOffset = $canvas.offset();
    var offsetX = canvasOffset.left;
    var offsetY = canvasOffset.top;

    function redraw(options) {
        options = options || {};
        var floor = $scope.selectedFloor;
        if (!floor){
            return;
        }
        var rooms = floor.rooms;

        document.getElementById('canvas').width = $('#canvas-wrapper').width();
        document.getElementById('canvas').height = $('#canvas-wrapper').height();

        var canvasOffset = $canvas.offset();
        offsetX = canvasOffset.left;
        offsetY = canvasOffset.top;

        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // 画出房间轮廓
        rooms.forEach(function (room, idx) {
            var points = eval(room.location);

            if (points && points.length > 0) {
                DrawPaths(room, ctx);

                var centroid = d3.polygonCentroid(points);
                if (centroid && centroid[0] && centroid[1]) {
                    ctx.textAlign = 'center';
                    ctx.fillStyle = 'rgba(0,0,0,1)';

                    ctx.fillText(rooms[idx].name || '未命名', centroid[0] * $('#canvas').width(), centroid[1] * $('#canvas').height());
                }
            }

        });

        // 画出人员位置
        // 1.过滤该楼层的tracks
        var tracks = $scope.tracks;
        if (tracks && tracks.length){
            var tracksOfFloor = _.filter(tracks, {floor_id: floor.id});
            _.each(tracksOfFloor, function (track) {
                ctx.fillStyle = "#1abc9c";
                if ($scope.selectTrack && track == $scope.selectTrack){
                    ctx.fillStyle = "steelblue";
                }
                var point = eval(track.location);
                ctx.beginPath();
                ctx.arc(point[0] * $('#canvas').width(), point[1] * $('#canvas').height(), 10, 0, Math.PI * 2);

                ctx.closePath();
                ctx.fill();

                ctx.textAlign = 'center';
                ctx.textBaseline = "middle";
                ctx.fillStyle = '#ffffff';
                var name = 'N/A';
                if (track.student && track.student.name && track.student.name.length > 0){
                    name = track.student.name[0];
                }
                ctx.fillText(name, point[0] * $('#canvas').width(), point[1] * $('#canvas').height());
            });
        }
    }

    // 鼠标移动
    // 1.检测鼠标是否停放在paths中的某一区域,是则高亮
    function handleMouseMove(e) {
        e.preventDefault();
        e.stopPropagation();

        var floor = $scope.selectedFloor;
        if (!floor){
            return;
        }
        var rooms = floor.rooms;

        var paths = _.map(rooms, function(room){
            return eval(room.location);
        });

        var mouseX = parseInt(e.pageX - offsetX);
        var mouseY = parseInt(e.pageY - offsetY);

        // 1.检测鼠标是否停放在paths中的某一区域,是则高亮
        rooms.forEach(function (room) {
            var points = eval(room.location);
            if (points && points.length > 0){
                room.highLighted = d3.polygonContains(_.map(points, function (point) {
                    return [point[0] * $('#canvas').width(), point[1] * $('#canvas').height()];
                }), [mouseX, mouseY]);
            }
        });
        redraw();
    }

    // 鼠标点击
    function handleMouseClick(e) {
        e.preventDefault();
        e.stopPropagation();

        mouseX = parseInt(e.pageX - offsetX);
        mouseY = parseInt(e.pageY - offsetY);

        //var clickPosition = [mouseX / $('#canvas').width(), mouseY / $('#canvas').height()];
        var tracks = $scope.tracks;
        if (tracks && tracks.length > 0){
            var trackSelected = null;

            _.each(tracks, function (track) {
                var location = eval(track['location']);
                track.highLighted = false;

                var closeToClick = location != null && testOriginPointDistance([location[0]*$('#canvas').width(),location[1]*$('#canvas').height()], mouseX, mouseY, 10);
                if (closeToClick){
                    // 点击了地图上的人员
                    $scope.selectTrack = track;
                    $scope.showTracks = true;
                    track.highLighted = true;
                    trackSelected = track;
                    $scope.$apply();
                }
            });
            if (trackSelected){
                redraw()
            }
        }
    }

    $scope.HideTrack = function (track) {
        $scope.showTracks = false;
    }

    // 鼠标移动事件
    $("#canvas").mousemove(handleMouseMove);
    // 鼠标点击事件
    $("#canvas").click(handleMouseClick);

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

    function DrawPaths(room, ctx) {
        var points = eval(room.location);
        if (points != null && points.length > 0) {
            points.forEach(function (point, index) {
                if (index == 0) {
                    ctx.beginPath();
                    ctx.moveTo(point[0] * $('#canvas').width(), point[1] * $('#canvas').height());
                }
                else {
                    ctx.lineTo(point[0] * $('#canvas').width(), point[1] * $('#canvas').height());
                }
            });
            ctx.closePath();

            ctx.stroke();
            ctx.fillStyle = room.highLighted ? 'rgba(52, 152, 219, 0.3)' : 'rgba(255,165,0,0.3)';
            ctx.fill();
        }
     }

    // 计算离起点的距离
    function testOriginPointDistance(origin, x, y, threshold) {
        threshold = threshold || 5;
        var length = Math.sqrt(Math.pow((origin[0] - x), 2) + Math.pow((origin[1] - y), 2));
        return length <= threshold;
    }

    $scope.$watch('selectTrack', function(newVal, oldVal){
        if (newVal){
            $scope.isLoadingForFootprints = true;
            RequestHandler({
                http: $http,
                path: '/board/nursing_home/footprints.json?student_id='+newVal.student_id,
                method: 'get'
            }).success(function (response) {
                if (ApiResponse.Check(response)) {
                    $scope.footprints = ApiResponse.GetData(response)['tracks'];
                    _.each($scope.footprints, function (footprint) {
                        footprint.created_at = new Date(footprint.created_at);
                    });
                    drawTimeLine()
                }
            }).finally(function () {
                $scope.isLoadingForFootprints = false;
            });

        }
    }, true);

    function drawTimeLine(){
        var data = $scope.footprints;

        var formatDate = d3.timeFormat('%H时%M分');

        var options =   {
            margin: {left: 20, right: 20, top: 20, bottom: 20},
            initialWidth: $("#tracks-view").width(),
            initialHeight: 800
        };

        var innerWidth =  options.initialWidth - options.margin.left - options.margin.right;
        var innerHeight = options.initialHeight - options.margin.top - options.margin.bottom;
        var colorScale = d3.schemeCategory20;

        var vis = d3.select('#timeline')
        vis.html('');
        vis = vis.append('svg')
        .attr('width',  options.initialWidth)
        .attr('height', options.initialHeight)
        .append('g')
        .attr('transform', 'translate('+(options.margin.left)+','+(options.margin.top)+')');

        function labelText(d){
            return formatDate(d['created_at']) + ' - ' + d['room']['name'];
        }

        // compute labels dimension
        var dummyText = vis.append('text');

        var timeScale = d3.scaleLinear()
            .domain(d3.extent(data, function(d){return d['created_at'];}))
            .range([0, innerWidth])
            .nice();

        var nodes = data.map(function(movie){
            var bbox = dummyText.text(labelText(movie)).node().getBBox();
            movie.h = bbox.height;
            movie.w = bbox.width;
            return new labella.Node(timeScale(movie['created_at']), movie.w + 9, movie);
        });

        dummyText.remove();

        // ---------------------------------------------------
        // Draw dots on the timeline
        // ---------------------------------------------------

        vis.append('line')
            .classed('timeline', true)
            .attr('x2', innerWidth);

        var linkLayer = vis.append('g');
        var labelLayer = vis.append('g');
        var dotLayer = vis.append('g');

        dotLayer.selectAll('circle.dot')
            .data(nodes)
            .enter().append('circle')
            .classed('dot', true)
            .attr('r', 3)
            .attr('cx', function(d){return d.getRoot().idealPos;});

        function color(d,i){
            return '#888';
        }

        //---------------------------------------------------
        // Labella has utility to help rendering
        //---------------------------------------------------

        var renderer = new labella.Renderer({
            layerGap: 60,
            nodeHeight: nodes[0].data.h,
            direction: 'bottom'
        });

        function draw(nodes){
            // Add x,y,dx,dy to node
            renderer.layout(nodes);

            // Draw label rectangles
            var sEnter = labelLayer.selectAll('rect.flag')
                .data(nodes)
                .enter().append('g')
                .attr('transform', function(d){return 'translate('+(d.x-d.width/2)+','+(d.y)+')';});

            sEnter
                .append('rect')
                .classed('flag', true)
                .attr('width', function(d){ return d.data.w + 9; })
                .attr('height', function(d){ return d.data.h + 4; })
                .attr('rx', 2)
                .attr('ry', 2)
                .style('fill', color);

            sEnter.append('text')
                .attr('x', 4)
                .attr('y', 15)
                .style('fill', '#fff')
                .text(function(d){return labelText(d.data);});

            // Draw path from point on the timeline to the label rectangle
            linkLayer.selectAll('path.link')
                .data(nodes)
                .enter().append('path')
                .classed('link', true)
                .attr('d', function(d){return renderer.generatePath(d);})
                .style('stroke', color)
                .style('stroke-width',2)
                .style('opacity', 0.6)
                .style('fill', 'none');
        }

        //---------------------------------------------------
        // Use labella.Force to place the labels
        //---------------------------------------------------

        var force = new labella.Force({
            minPos: -10,
            maxPos: innerWidth
        })
            .nodes(nodes)
            .compute();

        draw(force.nodes());
    }
};