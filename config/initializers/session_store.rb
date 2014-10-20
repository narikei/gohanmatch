# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :redis_store, key: '_tellme_session', :servers => "redis://localhost:6379/10", :expire_in => 1.days, :expire_after => 1.day