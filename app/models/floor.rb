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

class Floor < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 关联房间/走道
  has_many :rooms
end
