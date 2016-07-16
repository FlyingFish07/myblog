class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?

  OMNIAUTH_GOOGLE_OAUTH2_STRATEGY = 'google_oauth2'
  OMNIAUTH_OPEN_ID_ADMIN_STRATEGY = 'open_id_admin'
  OMNIAUTH_OPEN_ID_COMMENT_STRATEGY = 'open_id_comment'


  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    '/admin/sign_in'
  end

  protected

  def enki_config
    @@enki_config = Enki::Config.default
  end

  # Used for OmniAuth routing.
  def auth_path(provider, query_string_params = '')
    path = "/auth/#{provider.to_s}"

    if !query_string_params.blank?
      return path + "?#{query_string_params}"
    end

    path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  helper_method :enki_config
  helper_method :auth_path
end
