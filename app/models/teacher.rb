# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null              # 关联用户
#  name       :string(255)      not null              # 名字
#  device_id  :string(255)      not null              # 教师手环设备号
#  subject    :string(255)                            # 学科
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Teacher < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联用户
  belongs_to :user
end
