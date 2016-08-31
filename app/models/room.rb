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

class Room < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 房间可能和班级关联(Optional)
  has_one :clazz

  # 所属楼层
  belongs_to :floor

  # 关联基站列表
  has_many :stations
end
