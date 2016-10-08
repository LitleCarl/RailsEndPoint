# == Schema Information
#
# Table name: tracks
#
#  id         :integer          not null, primary key
#  location   :text(65535)      not null              # 定位坐标json,比如[0.331, 0.455], 相对于room所属的floor
#  student_id :integer          not null              # 学生id
#  room_id    :integer                                # 定位所在房间
#  extra      :text(65535)                            # 其他信息(JSON)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Track < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 所属房间
  belongs_to :room

  # 所属学生
  belongs_to :student
end
