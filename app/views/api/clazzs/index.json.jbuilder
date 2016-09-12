json.partial! 'api/common/status', response: @response
json.data do
  json.clazzs do
    json.array! @clazzs do |clazz|
      json.partial! 'api/common/clazz', clazz: clazz
      # 人数
      json.student_count clazz.students.count
      # 房间
      json.room do
        json.partial! 'api/common/room', room: clazz.room
      end
      # 楼层
      json.floor do
        json.partial! 'api/common/floor', floor: clazz.room.floor
      end
    end
  end
end