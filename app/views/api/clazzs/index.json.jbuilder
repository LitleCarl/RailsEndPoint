json.partial! 'api/common/status', response: @response
json.data do
  json.clazzs do
    json.array! @clazzs do |clazz|
      json.partial! 'api/common/clazz', clazz: clazz
      json.student_count clazz.students.count
    end
  end
end