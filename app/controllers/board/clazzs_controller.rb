class Board::ClazzsController < Board::BoardBaseController

  # 班牌
  def show
    @response, @clazz, @comments = Clazz.query_for_board_with_options(params)
  end

  # 所有评论信息
  def comments
    @response, @clazz, @comments = Clazz.query_for_board_with_options(params)
  end

  # 获取学生信息列表, 包含离线在线信息
  def students_list
    @response, @students, @online_ids =  Clazz.query_students_info_with_status(params)
  end

  # 创建评论
  def create_comment
    @response = Comment.create_with_options(params)
  end

  # 获取所有教师的接口
  def teachers
    @response, @teachers = Response.default_success, Teacher.all
  end

  # 创建语音消息
  def create_audio_message
    @response = AudioMessage.create_with_options(params)
  end

end
