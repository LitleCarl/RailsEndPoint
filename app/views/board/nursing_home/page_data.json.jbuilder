json.partial! 'api/common/status', response: @response
json.data do
  # 在线人员数量
  json.online_ids @online_ids
  json.students do
    json.array! @students do |student|
      json.partial! 'api/common/student', student: student
      json.online @online_ids.include?(student.id)
    end
  end
  json.floors do
    json.array! @floors do |floor|
      json.partial! 'api/common/floor', floor: floor
      json.rooms do
        json.array! floor.rooms do |room|
          json.partial! 'api/common/room', room: room
        end
      end
    end
  end
end