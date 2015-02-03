class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    #redirect_to new_user_session_path
    if current_user
      redirect_to :access_denied
    else
      redirect_to :new_user_session
    end
  end

  check_authorization unless: :devise_controller?

  # set per_page globally
  WillPaginate.per_page = 20

end
