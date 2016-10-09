render_json_attrs(json, student, [:id, :name, :number, :device_id, :gender])
json.avatar student.avatar.file.present? ? student.avatar_url : student.gender == '女' ? 'http://7xnsaf.com1.z0.glb.clouddn.com/geo/avatar/female.png' : 'http://7xnsaf.com1.z0.glb.clouddn.com/geo/avatar/male.png'
