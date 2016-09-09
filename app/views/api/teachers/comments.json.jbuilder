json.partial! 'api/common/status', response: @response
json.data do
  json.comments do
    json.array! @comments do |comment|
      json.partial! 'api/common/comment', comment: comment
    end
  end
end