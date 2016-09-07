class Api::StationsController < Api::ApiBaseController

  def update
    sleep(2)
    @response = Station.update_with_options_for_api(params)
  end

end
