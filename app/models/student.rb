# == Schema Information
#
# Table name: students
#
#  id         :integer          not null, primary key
#  name       :string(255)                            # 学生姓名
#  number     :string(255)                            # 学号
#  device_id  :string(255)                            # 手环设备号
#  clazz_id   :integer                                # 所属班级id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  gender     :string(255)                            # 性别
#  avatar     :string(255)                            # 头像
#

class Student < ActiveRecord::Base

  # 挂载头像
  mount_uploader :avatar, CadUploader

  # 通用查询方法
  include Concerns::Query::Methods

  # 所属班级
  belongs_to :clazz
end
