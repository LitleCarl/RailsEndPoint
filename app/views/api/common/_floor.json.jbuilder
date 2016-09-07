render_json_attrs(json, floor, [:id, :name])

if floor.image.file.present?
  json.image floor.image_url
else
  json.image nil
end