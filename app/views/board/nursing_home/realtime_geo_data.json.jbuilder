json.partial! 'api/common/status', response: @response
json.data do
  json.tracks do
    json.array! @tracks do |track|
      json.partial! 'api/common/track', track: track

      # 楼层id 用于前端过滤楼层用
      if track.room.present? && track.room.floor.present?
        json.floor_id track.room.floor.id
        json.room do
          json.partial! 'api/common/room', room: track.room
        end
      else
        json.floor_id nil
        json.room nil
      end

      json.student do
        if track.student
          json.partial! 'api/common/student', student: track.student
        else
          json.nil!
        end
      end
    end
  end

end