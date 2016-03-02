# Be sure to restart your server when you modify this file.

if Rails.env.development? || Rails.env.test?
  Enki::Application.config.secret_key_base = SecureRandom.hex(20)
else
  # Your secret key for verifying the integrity of signed cookies.
  # If you change this key, all old signed cookies will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  raise "Generate a secret with `rake secret` and paste it into `config/initializers/secret_token.rb`."

  # If this is an open source project, DO NOT commit your secret to source
  # control. Load it from ENV or a file that is git ignored (File.read)
  Enki::Application.config.secret_token    = 'd42dfdbfa60f8599d5c885680277a096e2385a2dcfa3550db1411d7d7517425207d5b1e9a818d7004ed8d62b1e5897d09ba963ebcd8434ec4c1b54f446af3a67' # To be removed in the next version of Enki
  Enki::Application.config.secret_key_base = 'd42dfdbfa60f8599d5c885680277a096e2385a2dcfa3550db1411d7d7517425207d5b1e9a818d7004ed8d62b1e5897d09ba963ebcd8434ec4c1b54f446af3a67'
end
