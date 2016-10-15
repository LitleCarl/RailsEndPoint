render_json_attrs(json, station, [:id, :device_id, :room_id, :group_number, :location])

json.location_json do
  if station.location.present?
    point = JSON(station.location)
    json.x point[0]
    json.y point[1]
  else
    json.nil!
  end
end