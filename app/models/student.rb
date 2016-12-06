# == Schema Information
#
# Table name: students
#
#  id         :integer          not null, primary key
#  name       :string(255)                            # 学生姓名
#  number     :string(255)                            # 学号
#  device_id  :string(255)                            # 手环设备号
#  clazz_id   :integer                                # 所属班级id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  gender     :string(255)                            # 性别
#  avatar     :string(255)                            # 头像
#

class Student < ActiveRecord::Base

  # 挂载头像
  mount_uploader :avatar, CadUploader

  # 通用查询方法
  include Concerns::Query::Methods

  # 所属班级
  belongs_to :clazz

  # 轨迹
  has_many :tracks

  # 学生今日的轨迹
  def tracks_of_today(options={})
    today = Time.now.beginning_of_day
    duplicate = options[:duplicate] || false
    if duplicate
      return self.tracks.where('created_at > ?', today)
    else
      # return Track.find_by_sql("SELECT * FROM (SELECT * from `tracks` t1 WHERE t1.`student_id` = #{self.id} AND t1.created_at > '#{today}')  n
      #                             WHERE NOT
      #                                   (
      #                                   SELECT  room_id
      #                                   FROM  (SELECT * from `tracks` t2 WHERE t2.`student_id` = #{self.id} AND t2.created_at > '#{today}')  ni
      #                                   WHERE   ni.id < n.id
      #                                   ORDER BY
      #                                           id DESC
      #                                   LIMIT 1
      #                                   ) <=> room_id")
      result = Track.find_by_sql("SELECT * FROM (
                                  SELECT IF (@lastRoom = t.room_id, 1, 0) AS equ,
                                  @lastRoom:=t.room_id AS just_for_internal, t.* FROM (
                                      SELECT * FROM `tracks` t1 WHERE t1.`student_id` = #{self.id} AND t1.`created_at` > '#{today}' ORDER BY t1.`created_at` ASC )
                                  AS t ,(SELECT @lastRoom := 0) AS r
                              ) result WHERE result.equ = 0")
      if result.count > 100
        result = result.last(80)
      end
      return result
    end

  end
end
