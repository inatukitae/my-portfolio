class ApplicationController < ActionController::Base
  allow_browser versions: :modern, unless: -> { Rails.env.test? }
  include Pundit::Authorization

  def pundit_user
    current_user
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  private

  def user_not_authorized
    if user_signed_in?
      redirect_to(request.referrer || root_path, alert: "このアクションは許可されていません。")
    else
      redirect_to new_user_session_path, alert: "ログインしてください。"
    end
  end
end
