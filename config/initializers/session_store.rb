# Be sure to restart your server when you modify this file.
Rails.application.config.session_store :cookie_store, key: '_rails_end_point_session'

Rails.application.config.session_store :redis_store, servers: { host: "localhost",
                                                                port: 6379,
                                                                db: 0,
                                                                password: 'Fy958e5mmyb7Ta4H',
                                                                namespace: "session"}, expires_in: 300.minutes

