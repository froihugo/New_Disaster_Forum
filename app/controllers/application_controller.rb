class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if current_user.admin?
      admin_users_path
    else
      posts_path
    end
  end

  before_action :set_locale
  def set_locale
    if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
    end

end
