class Api::ClazzsController < Api::ApiBaseController

  def index
    @response, @clazzs = Clazz.query_all_with_options_for_api(params)
  end

end
