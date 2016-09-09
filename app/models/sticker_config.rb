# == Schema Information
#
# Table name: sticker_configs
#
#  id          :integer          not null, primary key
#  sticker_key :integer
#  value       :string(255)                            # 按键代表的评论内容
#  teacher_id  :integer                                # 关联教师
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class StickerConfig < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 关联老师
  belongs_to :teacher
end
