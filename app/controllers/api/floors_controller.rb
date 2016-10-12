class Api::FloorsController < Api::ApiBaseController
  skip_before_filter :user_authenticate, only:[:station_mapping]
  def index
    @response, @floors = Floor.query_all_with_options_for_api(params)
  end

  def show
    @response, @floor = Floor.query_show_for_api(params)
  end

  def create_room
    @response = Floor.create_room_with_options(params)
  end

  def rooms
    @response, @rooms = Floor.query_rooms_in_floor_for_api(params)
  end

  # 获取每个楼层下的蓝牙基站信息 floors:[{name: '楼层一', rooms: [{name:'102', stations: [{...}]}]}]
  def station_mapping
    @response, @floors = Floor.query_all_with_options_for_api(params)
    @floors = @floors.includes({rooms: :stations})
  end

end
