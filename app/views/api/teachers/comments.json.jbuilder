json.partial! 'api/common/status', response: @response
json.data do
  json.all_comments_count @all_comments_count
  json.comments do
    json.array! @comments do |comment|
      json.partial! 'api/common/comment', comment: comment
    end
  end
end