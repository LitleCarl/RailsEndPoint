json.partial! 'api/common/status', response: @response
json.data do
  json.rooms do
    json.array! @rooms do |room|
      json.partial! 'api/common/room', room: room
    end
  end
end