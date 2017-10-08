class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def reject_user
    redirect_to root_url
  end

  def set_locale
    if I18n.available_locales.include?(params[:locale])
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end
end
