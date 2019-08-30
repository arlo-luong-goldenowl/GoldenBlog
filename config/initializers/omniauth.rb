Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
    scope: 'public_profile, email',
    info_fields: 'id, first_name, middle_name, last_name, email, name, link'
end
