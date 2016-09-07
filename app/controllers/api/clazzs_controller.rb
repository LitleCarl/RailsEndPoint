class Api::ClazzsController < Api::ApiBaseController

  def index
    sleep(2)
    @response, @clazzs = Clazz.query_all_with_options_for_api(params)
  end

end
