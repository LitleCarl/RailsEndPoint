# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  teacher_id :integer          not null              # 关联教师
#  student_id :integer          not null              # 关联学生
#  content    :string(255)      not null              # 评论内容
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 关联老师
  belongs_to :teacher

  # 关联学生
  belongs_to :student

  after_create :push_to_web

  def self.create_with_options(options = {})
    response = Response.__rescue__ do |res|

      teacher_device_id = options[:teacher_device_id]
      student_device_id = options[:student_device_id]
      key = options[:key]
      student = Student.query_first_by_options(device_id: student_device_id)
      teacher = Teacher.query_first_by_options(device_id: teacher_device_id)

      res.__raise__(Response::Code::ERROR, '学生不存在') if student.blank?
      res.__raise__(Response::Code::ERROR, '老师不存在') if teacher.blank?

      stick_config = StickerConfig.query_first_by_options(teacher_id: teacher.id, key: key)

      content = stick_config.present? ? stick_config.value : '课堂表现良好'

      comment = Comment.new
      comment.teacher = teacher
      comment.student = student
      comment.content = content
      comment.save!
    end
    return response
  end

  # 保存之后经过node推送至web公告牌
  def push_to_web
    if self.student.present? && self.student.clazz.present?
      url = URI.parse("#{::NodeServerSetting.host}/comments?clazz_id=#{self.student.clazz.id}")
      req = Net::HTTP::Get.new(url.to_s)
      Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
    end
  end
end
