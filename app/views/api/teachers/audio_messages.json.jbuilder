json.partial! 'api/common/status', response: @response
json.data do
  json.audio_messages do
    json.array! @audio_messages do |audio_message|
      json.partial! 'api/common/audio_message', audio_message: audio_message
    end
  end
end