
response ||= @response

json.status do |json|

  json.code (response.try(:code) || Response::Code::ERROR)
  message = response.try(:message)

  json.message message if message.present?

end