render_json_attrs(json, audio_message, [:id, :teacher_id, :student_id])
  json.audio audio_message.audio.file.present? ? audio_message.audio_url : ''

  json.teacher do
    json.partial! 'api/common/teacher', teacher: audio_message.teacher
  end

  json.student do
    json.partial! 'api/common/student', student: audio_message.student
  end