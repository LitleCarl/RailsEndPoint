# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)      not null              # 用户名
#  password   :string(255)      not null              # 密码
#  permission :integer          default("0")          # 权限bit
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar     :string(255)                            # 头像
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
