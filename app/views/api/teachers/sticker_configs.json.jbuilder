json.partial! 'api/common/status', response: @response
json.data do
  json.sticker_configs do
    json.array! @sticker_configs do |sticker_config|
      json.partial! 'api/common/sticker_config', sticker_config: sticker_config
    end
  end
end