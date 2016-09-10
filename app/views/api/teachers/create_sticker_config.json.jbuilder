json.partial! 'api/common/status', response: @response
json.data do
  if @sticker_config
    json.sticker_config do
      json.partial! 'api/common/sticker_config', sticker_config: @sticker_config
    end
  else
    json.sticker_config do
      json.nil!
    end
  end
end
