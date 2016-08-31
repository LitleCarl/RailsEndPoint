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

require 'test_helper'

class PayloadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
