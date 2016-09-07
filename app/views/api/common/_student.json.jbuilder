render_json_attrs(json, student, [:id, :name, :number, :device_id, :gender])
json.avatar student.avatar.file.present? ? student.avatar_url : ''
