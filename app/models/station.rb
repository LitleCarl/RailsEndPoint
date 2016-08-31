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
#

class Station < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 所属房间
  belongs_to :room
end
