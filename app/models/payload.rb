# == Schema Information
#
# Table name: payloads
#
#  id         :integer          not null, primary key
#  student_id :integer          not null              # 所属学生
#  station_id :integer          not null              # 所属基站
#  strength   :integer          default("0")          # 信号强度
#  token      :integer                                # 当前数据组token
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Payload < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 所属学生
  belongs_to :student

  # 属于的基站
  belongs_to :station

  #
  # 新增Payload接口
  #
  # @param options [Hash]
  # option options [data] :手环\蓝牙基站\信号强度 数据数组
  # option data [bracelet_device_id] :数组元素对象元素->手环设备号
  # option data [station_device_id]  :数组元素对象元素->蓝牙基站设备号
  # option data [strength]  :数组元素对象元素->信号强度
  #
  # @return [Response] 状态
  #
  def self.create_with_options(options={})
    response = Response.__rescue__ do |res|
      arr = options[:data]
      res.__raise__(Response::Code::ERROR, '参数错误') if arr.blank?

      arr.each do |data|
        bracelet_device_id, station_device_id, strength = data[:bracelet_device_id], data[:station_device_id], data[:strength] || 0

        res.__raise__(Response::Code::ERROR, 'bracelet_device_id/station_device_id/strength缺失') if bracelet_device_id.blank? || station_device_id.blank? || strength.blank?

        student = Student.query_first_by_options(device_id: bracelet_device_id)
        station = Station.query_first_by_options(device_id: station_device_id)

        res.__raise__(Response::Code::ERROR, "bracelet_device_id:#{bracelet_device_id} 对应的学生信息未录入") if student.blank?
        res.__raise__(Response::Code::ERROR, "station_device_id:#{station_device_id} 对应的蓝牙基站信息未录入") if station.blank?

        token = Time.now.to_i.to_s
        payload = Payload.new
        payload.student = student
        payload.station = station
        payload.strength = strength
        payload.token = token
        payload.save!
      end
    end

    return response
  end

  # #
  # # 统计当前在线学生数,返回以hash形式 楼层:人数
  # #
  # # @param options [Hash]
  # # option options [minute] :有效分钟(默认为5,即5分钟以前的数据不会统计入内)
  # #
  # # @return [Response] 状态
  # #
  # def self.statistic_for_online_students_count(options={})
  #   response = Response.__rescue__ do |res|
  #     minute = options[:minute] || 5
  #
  #   end
  # end
end
