Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_OMNIAUTH_PROVIDER_KEY'], ENV['FACEBOOK_OMNIAUTH_PROVIDER_SECRET']
end
