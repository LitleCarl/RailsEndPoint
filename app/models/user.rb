# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)      not null              # 用户名
#  password   :string(255)      not null              # 密码
#  permission :integer          default("0")          # 权限bit
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 默认统计时效
  module StatisticThreshold
    MIN = 5.minutes
    DAY = 2.days
  end

  # 用户的历史轨迹
  # 只返回每次数据中信号最强的数据
  def footprints (from_time=(Time.now - 5.minutes), limit=10)
    Payload.find_by_sql("SELECT p1.*,floor.*  FROM `payloads` p1 LEFT JOIN `payloads` p2 ON (p1.`student_id` = p2.`student_id` AND p1.`token` = p2.`token` AND p1.`strength` < p2.`strength` ) LEFT JOIN `stations` AS station ON ( station.`id` = p1.`station_id` ) LEFT JOIN `rooms` as room ON (room.`id` = station.`room_id` ) LEFT JOIN `floors` AS floor ON (floor.`id` = room.`floor_id` ) WHERE p1.created_at >= '#{from_time}' AND p2.`id` IS NULL AND floor.id IS NOT NULL AND p1.`student_id` = #{self.id}   ORDER BY p1.`created_at` DESC  LIMIT #{limit}")
  end

  #
  # 每层楼的在线用户数统计,按[{count:10, floor:{FLOOR OBJECT}]返回
  #
  # @param options [Hash]
  # option options [minute_threshold] :多少分钟内统计有效(默认:5, 表示5分钟以前的数据不计入统计)
  #
  # @return [Response, Array] 状态，[{count:10, floor:{FLOOR OBJECT}]
  #
  def self.statistics_for_online_count_of_floors (options = {})
    data = []
    response = Response.__rescue__ do |res|
      from_time= options[:minute_threshold] || (Time.now - StatisticThreshold::DAY)
      result = ActiveRecord::Base.connection.execute("SELECT COUNT(p1.id) as count, floor.id, floor.name  FROM `payloads` p1
                                                      LEFT JOIN `payloads` p2 ON (p1.`student_id` = p2.`student_id` AND p1.`id` < p2.`id` )
                                                      LEFT JOIN `stations` AS station ON ( station.`id` = p1.`station_id` )
                                                      LEFT JOIN `rooms` as room ON (room.`id` = station.`room_id` )
                                                      RIGHT JOIN `floors` AS floor ON (floor.`id` = room.`floor_id` )
                                                      WHERE  p2.`id` IS NULL AND (p1.created_at >= '#{from_time}' OR p1.id IS NULL)
                                                      GROUP BY floor.`id`")
      # row structure
      # [count, floor_id, floor_name]
      result.each do|row|
        data << {count: row[0], floor: {id: row[1], name: row[2]}}
      end
    end
    return response, data
  end

  #
  # 用户登录接口
  #
  # @param options [Hash]
  # option options [user] :用户hash
  # option user [username] :用户名
  # option user [password] :密码
  #
  # @return [Response, Array] 状态，基站列表
  #
  def self.sign_in_for_api(options = {})
    user = nil
    response = Response.__rescue__ do |res|
      user = options[:user]

      res.__raise__(Response::Code::ERROR, '参数错误') if user.blank?

      username, password = user[:username], user[:password]

      res.__raise__(Response::Code::ERROR, '用户名和密码不能为空') if username.blank? || password.blank?


      user = self.query_first_by_options({username: username, password: password})

      res.__raise__(Response::Code::ERROR, '用户名或者密码错误') if user.blank?
    end

    return response, user
  end
end
