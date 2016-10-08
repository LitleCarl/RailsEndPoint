class Api::TracksController < Api::ApiBaseController

  skip_before_filter :user_authenticate, only:[:create]

  # 上传轨迹
  def create
    @response = Track.create_with_options(params)
  end

end
