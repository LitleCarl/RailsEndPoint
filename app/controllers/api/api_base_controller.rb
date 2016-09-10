class Api::ApiBaseController < ApplicationController
  layout false

  # 用户验证
  def user_authenticate
    user_id = session['user_id']
    user = User.query_first_by_id user_id

    render :json => {status: {code: 800, message: '请先登录'}} if user.blank?

    @user = user
    params[:user] = @user

    if @user.present? && @user.teacher.present?
      @teacher = user.teacher
      params[:teacher] = @teacher
    end
  end
end