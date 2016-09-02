# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)                            # 房间名称
#  location   :text(65535)                            # 房间坐标(相对楼层)
#  floor_id   :integer                                # 所属楼层id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 房间可能和班级关联(Optional)
  has_one :clazz

  # 所属楼层
  belongs_to :floor

  # 关联基站列表
  has_many :stations

  #
  # 为房间/走道添加基站
  #
  # @param options [Hash]
  # option options [device_id] :设备id
  # option options [location] :基站位置json
  # option options [group_number] :基站在房间内的编号
  #
  # @return [Response, Array] 状态，楼道对象
  #
  def self.create_station_of_room_for_api(options={})
    response = Response.__rescue__ do |res|
      id, device_id, location, group_number = options[:id], options[:device_id], options[:location], options[:group_number]
      res.__raise__(Response::Code::ERROR, '缺少房间id参数') if id.blank?

      room = Room.query_first_by_id id

      res.__raise__(Response::Code::ERROR, '房间不存在') if room.blank?
      res.__raise__(Response::Code::ERROR, '参数错误') if device_id.blank? || location.blank? || group_number.blank?

      station = Station.new
      station.device_id = device_id
      station.location = location
      station.room = room
      station.group_number = group_number
      station.save!
    end

    return response
  end
end
