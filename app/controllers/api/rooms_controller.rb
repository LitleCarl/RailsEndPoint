class Api::RoomsController < Api::ApiBaseController

  def create_station
    @response = Room.create_station_of_room_for_api(params)
  end

end
