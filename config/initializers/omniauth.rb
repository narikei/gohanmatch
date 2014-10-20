Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,"xxxxx","xxxxxx", scope: 'user_friends, friends_about_me'
end
