class Api::ClazzsController < Api::ApiBaseController

  def index
    @response, @clazzs = Clazz.query_all_with_options_for_api(params)
  end

  def update
    @response = Clazz.update_with_options_for_api(params)
  end

  # 创建班级
  def create
    @response, @clazz = Clazz.create_with_options_for_api(params)
  end

end
