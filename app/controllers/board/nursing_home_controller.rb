class Board::NursingHomeController < Board::BoardBaseController
  # 养老院公告牌
  def index
  end

  # 获取养老院页面数据
  def page_data
    @response, @floors, @students, @online_ids = NursingHome.query_page_data_for_board(params)
  end
end