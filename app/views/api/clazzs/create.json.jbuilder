json.partial! 'api/common/status', response: @response
json.data do
  json.clazz do
    if @clazz.present?
      json.partial! 'api/common/clazz', clazz: @clazz
    else
      json.nil!
    end
  end
end