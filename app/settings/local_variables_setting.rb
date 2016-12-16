# encoding: UTF-8

class LocalVariablesSetting < Settingslogic
  source "#{Rails.root}/config/local_variables.yml"
  namespace Rails.env
end