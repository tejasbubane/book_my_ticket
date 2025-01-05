class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def current_user
    Current.user || User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def login(user)
    reset_session
    Current.user = user
    session[:user_id] = user.id
  end

  def logout(user)
    Current.user = nil
    reset_session
  end
end
