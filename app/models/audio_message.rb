# == Schema Information
#
# Table name: audio_messages
#
#  id         :integer          not null, primary key
#  teacher_id :integer                                # 关联教师
#  student_id :integer                                # 关联学生
#  audio      :string(255)                            # 音频地址
#  readed     :boolean          default("0")          # 已读
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AudioMessage < ActiveRecord::Base

  # 挂载图片
  mount_uploader :audio, CadUploader

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联教师
  belongs_to :teacher

  # 关联学生
  belongs_to :student

  # 创建语音信息
  def self.create_with_options(options={})
    response = Response.__rescue__ do |res|
      teacher_id, student_id, wav_blob = options[:teacher_id], options[:student_id], options[:wav_blob]

      res.__raise__(Response::Code::ERROR, '参数错误') if teacher_id.blank? || student_id.blank? || wav_blob.blank?

      student = Student.query_first_by_id student_id
      teacher = Teacher.query_first_by_id teacher_id

      res.__raise__(Response::Code::ERROR, '参数错误') if student.blank? || teacher.blank?

      msg = AudioMessage.new
      msg.teacher = teacher
      msg.student = student
      msg.audio = wav_blob
      msg.save!
    end

    return response
  end

  # 设置已读
  def self.set_readed_with_options(options={})
    response = Response.__rescue__ do |res|
      teacher, audio_message_id = options[:teacher], options[:id]

      res.__raise__(Response::Code::ERROR, '参数错误') if teacher.blank? || audio_message_id.blank?

      audio_message = AudioMessage.query_first_by_id audio_message_id
      res.__raise__(Response::Code::ERROR, '消息不存在') if audio_message.blank?

      audio_message.readed = true
      audio_message.save!
    end
    return response
  end
end
