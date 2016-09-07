# encoding: UTF-8

class NodeServerSetting < Settingslogic
  source "#{Rails.root}/config/node_server.yml"
  namespace Rails.env
end