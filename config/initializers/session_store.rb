# Be sure to restart your server when you modify this file.
Rails.application.config.session_store :cookie_store, key: '_rails_end_point_session'

redis_config = { host: RedisSetting.host,
                 port: RedisSetting.port,
                 db: RedisSetting.db,
                 namespace: "session"}

redis_config[:password] = RedisSetting.password if RedisSetting.password.present?

puts "--------------:redis_config.password #{redis_config}:----------------"

Rails.application.config.session_store :redis_store, servers: redis_config, expires_in: 300.minutes

