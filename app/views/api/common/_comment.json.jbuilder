render_json_attrs(json, comment, [:id, :content])

json.show_time comment.created_at.strftime("%H:%M").to_s

json.teacher do
  json.partial! 'api/common/teacher', teacher: comment.teacher
end

json.student do
  json.partial! 'api/common/student', student: comment.student
end
