json.partial! 'api/common/status', response: @response
json.data do
  json.floor do
    if @floor
      json.partial! 'api/common/floor', floor: @floor
      json.rooms do
        json.partial! 'api/common/room', collection: @floor.rooms, as: :room
      end
    else
      json.nil!
    end

  end
end