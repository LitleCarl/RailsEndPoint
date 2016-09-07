class Api::StatisticsController < Api::ApiBaseController

  # 统计所有楼层的在线用户数量
  def index
    sleep(2)
    @response, @data = User.statistics_for_online_count_of_floors(params)
  end

  # 统计某个楼层所有房间/走道的在线用户数量
  def floor
    sleep(2)
    @response, @data = User.statistics_for_online_count_of_rooms(params)
  end
end
