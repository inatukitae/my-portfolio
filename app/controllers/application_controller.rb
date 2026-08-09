class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  # ログインしていない場合はログイン画面に飛ばす
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end