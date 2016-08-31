class SeedsController < ApplicationController

  skip_before_filter :user_authenticate

  def create_payload
    @response = Payload.create_with_options(params)
  end

end
