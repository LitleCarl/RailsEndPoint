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
end