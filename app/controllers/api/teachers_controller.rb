class Api::TeachersController < Api::ApiBaseController

  # 获取教师的评论
  def comments
    sleep(2)
    @response, @comments = Teacher.query_comments_for_api(params)
  end

  # 获取魔法棒配置
  def sticker_configs
    sleep(2)
    @response, @sticker_configs = Teacher.query_sticker_configs_for_api(params)
  end

  # 更新魔法棒配置
  def update_sticker_config
    sleep(2)
    @response = Teacher.update_sticker_config_for_api(params)
  end

  # 添加魔法棒配置
  def create_sticker_config
    @response, @sticker_config = Teacher.create_sticker_config_for_api(params)
  end
end
