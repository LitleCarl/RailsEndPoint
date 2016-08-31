class UsersController < ApplicationController

  skip_before_filter :user_authenticate, only:[:sign_in]

  def sign_in

    if request.method_symbol == :post
      @response, @user = User.sign_in_for_api(params)

      if @response.is_successful?

        session[:user_id] = @user.id

        redirect_to me_users_path
      end
    end
  end

  def me

  end
end
