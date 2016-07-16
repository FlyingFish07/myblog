class Admin::BaseController < ApplicationController
  include Pundit
  layout 'admin'

  # before_filter :require_login
  before_action :authenticate_user!
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

 

  protected

  # def require_login
  #   return redirect_to(admin_session_path) unless session[:logged_in]
  # end

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
