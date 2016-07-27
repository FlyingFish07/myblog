class Admin::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # remeber me https://github.com/plataformatec/devise/issues/3150
  include Devise::Controllers::Rememberable

  # this is the only spot where we allow CSRF, our openid / oauth redirect
  # will not have a CSRF token, however the payload is all validated so its safe
  # https://github.com/plataformatec/devise/issues/2432
  skip_before_filter :verify_authenticity_token

  def open_id
    if enki_config.author_open_ids.include?(URI.parse(request.env['omniauth.auth'][:uid]))
      save_auth_details(request.env['omniauth.auth'])
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        remember_me(@user)

        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Open ID") if is_navigational_format?
      else
        session["devise.openid_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    else
      show_not_authorized
    end
    
  end

  def failure
    show_not_authorized
  end

private
  def save_auth_details(auth_response)
    OmniAuthDetails.create(
      :provider =>    auth_response[:provider],
      :uid =>         auth_response[:uid],
      :info =>        auth_response[:info],
      :credentials => auth_response[:credentials],
      :extra =>       auth_response[:extra]
    )
  end

  def show_not_authorized
    flash.now[:error] = I18n.t "devise.omniauth_callbacks.failure", "Open ID"
    redirect_to root_path
  end

end