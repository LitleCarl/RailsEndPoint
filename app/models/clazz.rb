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

  # mixin 班牌
  include Concerns::Board::ClazzConcern

  # 关联学生
  has_many :students

  # 属于的房间
  belongs_to :room


  #
  # 班级Index数据api
  #
  # @param options [Hash]
  #
  # @return [Response, Array] 状态，基站列表
  #
  def self.query_all_with_options_for_api(options={})
    clazzs = []
    response = Response.__rescue__ do |res|
      clazzs = Clazz.includes(:students).all
    end

    return response, clazzs
  end
end
