render_json_attrs(json, room, [:id, :name, :location, :floor_id])
json.stations do
  json.array! room.stations, partial: 'api/common/station', as: :station
end