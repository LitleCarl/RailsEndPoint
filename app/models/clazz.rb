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

class Clazz < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 关联学生
  has_many :students

  # 属于的房间
  belongs_to :room
end
