class Api::RoomsController < Api::ApiBaseController

  def create_station
    @response = Room.create_station_of_room_for_api(params)
  end

  def update
    @response = Room.update_with_options(params)
  end
end
