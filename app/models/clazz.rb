# == Schema Information
#
# Table name: clazzs
#
#  id         :integer          not null, primary key
#  grade      :string(255)                            # 年级
#  number     :string(255)                            # 班级号
#  room_id    :integer                                # 班级所在的房间id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Clazz < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # mixin 班牌
  include Concerns::Board::ClazzConcern

  # 关联学生
  has_many :students

  # 属于的房间
  belongs_to :room

  #
  # 创建班级
  #
  # @param options [Hash]
  # option options [teacher] :教师
  # option options [grade] :年级
  # option options [number] :班级号
  # option options [room_id] :房间号
  #
  # @return [Response, Array] 状态，基站列表
  #
  def self.create_with_options_for_api(options={})
    clazz = nil
    response = Response.__rescue__ do |res|
      grade, number, room_id, teacher = options[:grade], options[:number], options[:room_id], options[:teacher]

      res.__raise__(Response::Code::ERROR, '参数错误') if grade.blank? || number.blank? || room_id.blank? || teacher.blank?

      room = Room.query_first_by_id room_id
      res.__raise__(Response::Code::ERROR, '房间不存在') if room.blank?

      clazz_exist = Clazz.query_first_by_options(grade: grade, number: number)

      res.__raise__(Response::Code::ERROR, '此班级已经存在') if clazz_exist.present?

      clazz = Clazz.new
      clazz.grade = grade
      clazz.number = number
      clazz.room_id = room_id
      clazz.save!
    end

    return response, clazz
  end

  #
  # 班级Index数据api
  #
  # @param options [Hash]
  #
  # @return [Response, Array] 状态，基站列表
  #
  def self.query_all_with_options_for_api(options={})
    clazzs = []
    response = Response.__rescue__ do |res|
      clazzs = Clazz.includes(:students).all
    end

    return response, clazzs
  end

  #
  # 更新班级信息
  #
  # @param options [Hash] options
  # option options [grade] :年级
  # option options [number] :班号
  # option options [room_id] :房间id
  # option options [id] :班级id
  #
  # @return [Response, Array] 状态，基站列表
  #
  def self.update_with_options_for_api(options={})
    response = Response.__rescue__ do |res|
      grade, number, room_id, clazz_id = options[:grade], options[:number], options[:room_id], options[:id]

      res.__raise__(Response::Code::ERROR, '参数错误') if clazz_id.blank?

      clazz = Clazz.query_first_by_id clazz_id

      res.__raise__(Response::Code::ERROR, '班级不存在') if clazz.blank?

      clazz.grade = grade if grade.present?
      clazz.number = number if number.present?
      clazz.room_id = room_id if room_id.present?

      clazz.save!
    end

    return response
  end
end
