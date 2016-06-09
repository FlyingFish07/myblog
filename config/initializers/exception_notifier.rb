require 'action_controller/metal/request_forgery_protection'

Enki::Application.config.middleware.use ExceptionNotifier,
  :ignore_exceptions    => [ActionController::InvalidAuthenticityToken],
  :email_prefix         => "[ITechLib] ",
  :sender_address       => [Enki::Config.default[:exception_mail, :email]],
  :exception_recipients => [Enki::Config.default[:exception_mail, :email]]
