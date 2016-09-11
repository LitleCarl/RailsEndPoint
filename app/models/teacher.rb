# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null              # 关联用户
#  name       :string(255)      not null              # 名字
#  device_id  :string(255)      not null              # 教师手环设备号
#  subject    :string(255)                            # 学科
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Teacher < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联用户
  belongs_to :user

  # 关联评论
  has_many :comments

  # 关联魔法棒配置
  has_many :sticker_configs

  # 关联语音消息
  has_many :audio_messages

  #
  # 获取教师的今日评论
  #
  # @param options [Hash]
  # option options [teacher] :教师
  # option options [page] :页数
  # option options [limit] :每页数量
  #
  # @return [Response, Array] 状态，评论数组
  #
  def self.query_comments_for_api(options={})
    comments = []
    response = Response.__rescue__ do |res|
      teacher, page, limit = options[:teacher], options[:page], options[:limit]

      res.__raise__(Response::Code::ERROR, '参数错误') if teacher.blank?

      comments = teacher.comments.where('created_at >= ?', Time.now.beginning_of_day).order('created_at DESC').page(page).per(limit)
    end
    return response, comments
  end

  #
  # 获取教师的魔法棒配置
  #
  # @param options [Hash]
  # option options [teacher] :教师
  #
  # @return [Response, Array] 状态，评论数组
  #
  def self.query_sticker_configs_for_api(options={})
    sticker_configs = []
    response = Response.__rescue__ do |res|
      teacher = options[:teacher]

      res.__raise__(Response::Code::ERROR, '参数错误') if teacher.blank?

      sticker_configs = teacher.sticker_configs.order('sticker_configs.sticker_key ASC')
    end
    return response, sticker_configs
  end

  #
  # 更新教师的魔法棒配置
  #
  # @param options [Hash]
  # option options [teacher] :教师
  # option options [sticker_config] :配置
  #
  # @return [Response, Array] 状态，评论数组
  #
  def self.update_sticker_config_for_api(options={})
    response = Response.__rescue__ do |res|
      teacher, sticker_config = options[:teacher], options[:sticker_config]

      res.__raise__(Response::Code::ERROR, '权限错误') if teacher.blank?
      res.__raise__(Response::Code::ERROR, '配置错误') if sticker_config.blank?

      sticker_config_model = StickerConfig.query_first_by_id(sticker_config[:id])

      res.__raise__(Response::Code::ERROR, '配置不存在') if sticker_config_model.blank?

      sticker_config_model.sticker_key = sticker_config[:sticker_key]
      sticker_config_model.value = sticker_config[:value]
      sticker_config_model.save!
    end
    return response
  end

  #
  # 添加教师的魔法棒配置
  #
  # @param options [Hash]
  # option options [teacher] :教师
  # option options [sticker_config] :配置
  #
  # @return [Response, Array] 状态，评论数组
  #
  def self.create_sticker_config_for_api(options={})
    sticker_config_model = nil
    response = Response.__rescue__ do |res|
      teacher, sticker_config = options[:teacher], options[:sticker_config]


      res.__raise__(Response::Code::ERROR, '权限错误') if teacher.blank?
      res.__raise__(Response::Code::ERROR, '配置错误') if sticker_config.blank?

      sticker_key = sticker_config[:sticker_key]
      value = sticker_config[:value]

      res.__raise__(Response::Code::ERROR, '配置数据缺失') if sticker_key.blank? || value.blank?

      sticker_exist = StickerConfig.query_first_by_options(teacher: teacher, sticker_key:sticker_key)

      res.__raise__(Response::Code::ERROR, '按键已存在') if sticker_exist.present?

      sticker_config_model = StickerConfig.new
      sticker_config_model.teacher = teacher
      sticker_config_model.sticker_key = sticker_key
      sticker_config_model.value = value

      sticker_config_model.save!
    end
    return response, sticker_config_model
  end

  #
  # 获取教师的语音消息
  #
  # @param options [Hash]
  # option options [teacher] :教师
  # option options [unread] :是否已读, 可选,默认为true
  # option options [page] :页数,可选
  # option options [limit] :每页数量,可选
  #
  # @return [Response, Array] 状态，评论数组
  #
  def self.query_audio_messages_with_options(options={})
    audio_messages = []
    response = Response.__rescue__ do |res|
      teacher, unread, page, limit = options[:teacher], options[:unread], options[:page], options[:limit]

      res.__raise__(Response::Code::ERROR, '参数错误') if teacher.blank?

      unread = true if unread.blank?

      audio_messages = teacher.audio_messages.where(readed: !unread).order('created_at DESC').page(page).limit(limit)
    end
    return response, audio_messages
  end
end
