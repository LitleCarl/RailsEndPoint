class NursingHome

  #
  # 查询养老院的显示数据,包括所有floors/students/online_ids
  #
  # @param options [Hash]
  #
  # @return [Response, Array] 状态
  #
  def self.query_page_data_for_board(options={})
    floors, students, online_ids = [], [], []
    from_time= options[:minute_threshold] || (Time.now - User::StatisticThreshold::DAY)

    response = Response.__rescue__ do |res|
      students = Student.all
      floors = Floor.all

      result = ActiveRecord::Base.connection.execute("SELECT stu.id FROM `payloads` p1
                                                                    LEFT JOIN `payloads` p2 ON (p1.`student_id` = p2.`student_id` AND p1.`id` < p2.`id` )
                                                                    LEFT JOIN `students` stu ON (p1.`student_id` = stu.id)
                                                                    WHERE  p2.`id` IS NULL AND stu.`id` IS NOT NULL AND p1.`created_at` >= '#{from_time}'")
      result.each do|row|
        online_ids << row[0]
      end
    end
    return response, floors, students, online_ids
  end

  #
  # 查询养老院的人员地理位置信息(RealTime)
  #
  # @param options [Hash]
  #
  # @return [Response, Array] 状态, Tracks
  #
  def self.query_realtime_geo_data(options={})
    tracks = []
    response = Response.__rescue__ do |res|
      from_time= options[:minute_threshold] || (Time.now - User::StatisticThreshold::DAY)

      tracks = Track.find_by_sql("SELECT t1.* FROM `tracks` t1
                                                                        LEFT JOIN `tracks` t2 ON (t1.`student_id` = t2.`student_id` AND t1.`id` < t2.`id` )
                                                                        LEFT JOIN `students` stu ON (t1.`student_id` = stu.id)
                                                                        WHERE  t2.`id` IS NULL AND stu.`id` IS NOT NULL  AND t1.`created_at` >= '#{from_time}'")
    end
    return response, tracks
  end

  #
  # 获取某用户一天的行走轨迹
  #
  # @param options [Hash]
  # option options [student_id] :学生id
  #
  # @return [Response, Array] 状态, Tracks
  #
  def self.query_footprints_for_api(options={})
    tracks = []
    response = Response.__rescue__ do |res|
      student_id = options[:student_id]
      res.__raise__(Response::Code::ERROR, '参数错误') if student_id.blank?

      student = Student.query_first_by_id student_id
      res.__raise__(Response::Code::ERROR, '学生不存在') if student.blank?

      tracks = student.tracks.where('created_at > ?', Time.now.beginning_of_day)
    end
    return response, tracks
  end
end