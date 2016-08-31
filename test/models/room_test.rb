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

require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
