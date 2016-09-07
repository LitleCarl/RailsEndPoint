# == Schema Information
#
# Table name: stations
#
#  id           :integer          not null, primary key
#  device_id    :string(255)                            # 基站设备id
#  room_id      :integer                                # 所属房间/走道id
#  group_number :string(255)                            # 同一房间内的基站编号
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location     :text(65535)                            # 基站坐标
#

class Station < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 所属房间
  belongs_to :room

  #
  # 基站数据更新接口
  #
  # @param options [Hash]
  # option options [id] :基站id
  # option options [device_id] :基站设备id,可选
  # option options [group_number] :基站组编号,可选
  # option options [location] :基站新的坐标,可选
  #
  # @return [Response, Array] 状态，基站列表
  #
  def self.update_with_options_for_api(options={})
    response = Response.__rescue__ do |res|
      id, device_id, group_number, location = options[:id], options[:device_id], options[:group_number], options[:location]


      res.__raise__(Response::Code::ERROR, '基站id不能为空') if id.blank?

      res.__raise__(Response::Code::ERROR, '参数错误') if device_id.blank? && group_number.blank? && location.blank?

      station = Station.query_first_by_id id

      res.__raise__(Response::Code::ERROR, '基站不存在') if station.blank?


      station.device_id = device_id if device_id.present?
      station.group_number = group_number if group_number.present?
      station.location = location if location.present?

      station.save!
    end

    return response
  end
end
