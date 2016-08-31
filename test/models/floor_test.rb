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

require 'test_helper'

class FloorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
