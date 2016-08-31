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
#

class User < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  #
  # 用户登录接口
  #
  # @param options [Hash]
  # option options [user] :用户hash
  # option user [username] :用户名
  # option user [password] :密码
  #
  # @return [Response, Array] 状态，基站列表
  #
  def self.sign_in_for_api(options = {})
    user = nil
    response = Response.__rescue__ do |res|
      user = options[:user]

      res.__raise__(Response::Code::ERROR, '参数错误') if user.blank?

      username, password = user[:username], user[:password]

      res.__raise__(Response::Code::ERROR, '用户名和密码不能为空') if username.blank? || password.blank?


      user = self.query_first_by_options({username: username, password: password})

      res.__raise__(Response::Code::ERROR, '用户名或者密码错误') if user.blank?
    end

    return response, user
  end
end
