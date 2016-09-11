json.partial! 'api/common/status', response: @response
json.data do
  json.teachers do
    json.array! @teachers do |teacher|
      json.partial! 'api/common/teacher', teacher: teacher
    end
  end
end