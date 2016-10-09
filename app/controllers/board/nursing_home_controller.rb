class Board::NursingHomeController < Board::BoardBaseController
  # 养老院公告牌
  def index
  end

  # 获取养老院页面数据
  def page_data
    @response, @floors, @students, @online_ids = NursingHome.query_page_data_for_board(params)
  end

  # 获取在线人员即时位置信息
  def realtime_geo_data
    @response, @tracks = NursingHome.query_realtime_geo_data(params)
  end

  # 用户轨迹(一天的)
  def footprints
    @response, @tracks = NursingHome.query_footprints_for_api(params)
  end
end