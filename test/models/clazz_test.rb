# == Schema Information
#
# Table name: clazzs
#
#  id         :integer          not null, primary key
#  grade      :string(255)                            # 年级
#  number     :string(255)                            # 班级号
#  room_id    :integer                                # 班级所在的房间id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ClazzTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
