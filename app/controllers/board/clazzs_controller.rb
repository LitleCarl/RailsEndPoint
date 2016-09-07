class Board::ClazzsController < Board::BoardBaseController

  # 显示所有班级给班牌选择
  def show
    @response, @clazz, @comments = Clazz.query_for_board_with_options(params)
  end

  # 所有评论信息
  def comments
    @response, xx, @comments = Clazz.query_for_board_with_options(params)
  end

  # 获取学生信息列表, 包含离线在线信息
  def students_list
    @response, @students, @online_ids =  Clazz.query_students_info_with_status(params)
  end

  def create_comment
    @response = Comment.create_with_options(params)
  end

end
