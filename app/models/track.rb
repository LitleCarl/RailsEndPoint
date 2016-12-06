# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  location   :text(65535)      not null              # 定位坐标json,比如[0.331, 0.455], 相对于room所属的floor
#  student_id :integer          not null              # 学生id
#  room_id    :integer                                # 定位所在房间
#  extra      :text(65535)                            # 其他信息(JSON)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Track < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 所属房间
  belongs_to :room

  # 所属学生
  belongs_to :student

  #
  # 定位数据添加接口
  #
  # @param options [Hash]
  # option options [station_device_id] :基站设备id
  # option options [bracelet_device_id] :手环设备id
  # option options [location] :基站新的坐标
  # option options [extra] :额外信息, 可选
  #
  # @return [Response] 状态
  #
  def self.create_with_options(options={})
    response = Response.__rescue__ do |res|
      station_device_id, bracelet_device_id, location, extra, created_at = options[:station_device_id], options[:bracelet_device_id], options[:location], options[:extra], options[:created_at]

      res.__raise__(Response::Code::ERROR, '参数错误') if station_device_id.blank? || bracelet_device_id.blank? || location.blank?

      station = Station.query_first_by_options(device_id: station_device_id)
      student = Student.query_first_by_options(device_id: bracelet_device_id)

      res.__raise__(Response::Code::ERROR, '基站不存在') if station.blank?
      res.__raise__(Response::Code::ERROR, '学生不存在') if student.blank?
      res.__raise__(Response::Code::ERROR, '房间不存在') if station.room.blank?

      track = Track.new
      track.room = station.room
      track.student = student
      track.location = location
      track.extra = extra if extra.present?
      track.created_at = created_at if created_at.present?
      track.save!

      # 创建Payload
      # Rollback方案, payload全由Track生成, 有且一次只有一条payload
      data = [{
                  bracelet_device_id: bracelet_device_id,
                  station_device_id: station_device_id
              }]

      Payload.create_with_options(data: data)
    end
  end

end
