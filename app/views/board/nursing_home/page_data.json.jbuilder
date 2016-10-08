json.partial! 'api/common/status', response: @response
json.data do
  # 在线人员数量
  json.online_count @online_ids.count
  json.students do
    json.array! @students do |student|
      json.partial! 'api/common/student', student: student
      json.online @online_ids.include?(student.id)
    end
  end
  json.floors do
    json.array! @floors do |floor|
      json.partial! 'api/common/floor', floor: floor
      json.room_count floor.rooms.count
    end
  end
end