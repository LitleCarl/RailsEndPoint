# encoding: utf-8

module Concerns::Board::ClazzConcern

  extend ActiveSupport::Concern

  included do
    # 通用查询方法
    include Concerns::Query::Methods
  end

  # 类方法
  module ClassMethods

    # 班牌客户端获取班级显示所需信息(clazz, 点赞信息统计)
    #
    # @param options [Hash]
    # @option options [Integer] :id 班级id
    #
    # @return [Array] response, clazz, comments
    #
    def query_for_board_with_options(options = {})
      clazz = nil
      comments = []

      response = Response.__rescue__ do |res|
        clazz_id = options[:id]

        res.__raise__(Response::Code::ERROR, '参数错误') if clazz_id.blank?

        clazz = Clazz.query_first_by_id clazz_id

        res.__raise__(Response::Code::ERROR, '班级不存在') if clazz.blank?

        # 今日此班级的教师评论
        comments = Comment.includes({student: :clazz}).references(:clazzs).where("clazzs.id = ?", clazz.id).where("comments.created_at >= ?", Time.now.beginning_of_day).order('comments.created_at desc')
      end

      return response, clazz, comments
    end

    # 班牌客户端获取班级学生信息(包括在线离线信息)
    #
    # @param options [Hash]
    # @option options [Integer] :id 班级id
    #
    # @return [Array] response, coupon
    #
    def query_students_info_with_status(options={})
      students = []
      online_student_ids = []
      response = Response.__rescue__ do |res|
        clazz_id = options[:id]
        from_time= options[:minute_threshold] || (Time.now - User::StatisticThreshold::MIN)

        res.__raise__(Response::Code::ERROR, '参数错误') if clazz_id.blank?

        clazz = Clazz.query_first_by_id clazz_id

        res.__raise__(Response::Code::ERROR, '班级不存在') if clazz.blank?

        students = Student.query_by_options(clazz_id: clazz_id)

        result = ActiveRecord::Base.connection.execute("SELECT stu.id FROM `payloads` p1
                                                                    LEFT JOIN `payloads` p2 ON (p1.`student_id` = p2.`student_id` AND p1.`id` < p2.`id` )
                                                                    LEFT JOIN `students` stu ON (p1.`student_id` = stu.id)
                                                                    LEFT JOIN `clazzs` clazz ON (clazz.id = stu.`clazz_id`)
                                                                    WHERE  p2.`id` IS NULL AND stu.`id` IS NOT NULL AND clazz.id = #{clazz_id} AND p1.`created_at` >= '#{from_time}'")
        result.each do|row|
          online_student_ids << row[0]
        end
      end

      return response, students, online_student_ids
    end
  end
end
