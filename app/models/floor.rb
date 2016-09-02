# == Schema Information
#
# Table name: floors
#
#  id         :integer          not null, primary key
#  name       :string(255)                            # 楼层名称
#  image      :text(65535)                            # 楼层cad图
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Floor < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 关联房间/走道
  has_many :rooms

  #
  # 楼道列表查询接口
  #
  # @param options [Hash]
  #
  # @return [Response, Array] 状态，楼道列表
  #
  def self.query_all_with_options_for_api(options = {})
    floors = []
    response = Response.__rescue__ do |res|
      floors = Floor.includes(:rooms)
    end

    return response, floors
  end

  #
  # 单个楼道查询接口
  #
  # @param options [Hash]
  #
  # @return [Response, Array] 状态，楼道对象
  #
  def self.query_show_for_api(options={})
    floor = nil
    response = Response.__rescue__ do |res|
      id = options[:id]
      floor = Floor.query_first_by_id id

      res.__raise__(Response::Code::ERROR, '楼层不存在') if floor.blank?

    end

    return response, floor
  end

  #
  # 为楼层添加走道/房间
  #
  # @param options [Hash]
  # option options [name] :名称
  # option options [location] :房间位置json
  #
  # @return [Response, Array] 状态，楼道对象
  #
  def self.create_room_with_options(options={})
    response = Response.__rescue__ do |res|
      id, name, location = options[:id], options[:name], options[:location]
      floor = Floor.query_first_by_id id

      res.__raise__(Response::Code::ERROR, '楼层不存在') if floor.blank?
      res.__raise__(Response::Code::ERROR, '参数错误') if name.blank? || location.blank?

      room = Room.new
      room.name = name
      room.location = location
      room.floor = floor
      room.save!
    end

    return response
  end
end
