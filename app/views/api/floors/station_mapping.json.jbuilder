json.partial! 'api/common/status', response: @response
json.data do
  json.floors do
    json.array! @floors do |floor|
      json.partial! 'api/common/floor', floor: floor
      json.rooms do
        json.array! floor.rooms do |room|
          json.partial! 'api/common/room', room: room
        end
      end
    end
  end
end