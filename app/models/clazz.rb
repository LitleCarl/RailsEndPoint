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
