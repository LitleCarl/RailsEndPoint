json.partial! 'api/common/status', response: @response
json.data do
  # 在线学生数量
  json.online_count @online_ids.count
  json.students do
    json.array! @students do |student|
      json.partial! 'api/common/student', student: student
      json.online @online_ids.include?(student.id)
    end
  end
end