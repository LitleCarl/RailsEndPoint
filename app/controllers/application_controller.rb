class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # 页数参数补全
  include Shared::Concerns::ApplicationControllerConcern

  # 用户验证
  before_filter :user_authenticate

  # 用户验证
  def user_authenticate
    user_id = session['user_id']
    user = User.query_first_by_id user_id

    redirect_to sign_in_users_path if user.blank?

    @user = user
    params[:user] = @user

    params[:teacher] = @user.teacher
  end

end
