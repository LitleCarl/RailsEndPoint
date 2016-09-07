json.partial! 'api/common/status', response: @response
json.data do
  json.floors do
    json.array! @floors do |floor|
      json.partial! 'api/common/floor', floor: floor
      json.room_count floor.rooms.count
    end
  end
end