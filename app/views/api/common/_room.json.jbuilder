render_json_attrs(json, room, [:id, :name, :location, :floor_id])
json.stations do
  json.array! room.stations, partial: 'api/common/station', as: :station
end

json.location_json do
  if room.location.present?
    json.array! JSON(room.location) do |point|
      json.x point[0]
      json.y point[1]
    end
  else
    json.array!
  end
end

