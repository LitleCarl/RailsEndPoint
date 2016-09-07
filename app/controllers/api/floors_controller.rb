class Api::FloorsController < Api::ApiBaseController

  def index
    sleep(2)
    @response, @floors = Floor.query_all_with_options_for_api(params)
  end

  def show
    sleep(2)
    @response, @floor = Floor.query_show_for_api(params)
  end

  def create_room
    sleep(2)
    @response = Floor.create_room_with_options(params)
  end

end
