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

require 'test_helper'

class StationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
