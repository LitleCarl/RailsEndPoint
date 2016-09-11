class Api::AudioMessagesController < Api::ApiBaseController

  # 语音消息已读事件
  def set_read
    @response = AudioMessage.set_readed_with_options(params)
  end

end
