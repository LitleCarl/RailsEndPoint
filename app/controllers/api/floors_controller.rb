class Api::FloorsController < Api::ApiBaseController

  def index
    @response, @floors = Floor.query_all_with_options_for_api(params)
  end

  def show
    @response, @floor = Floor.query_show_for_api(params)
  end

  def create_room
    @response = Floor.create_room_with_options(params)
  end

end
