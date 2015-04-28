class ApplicationController < ActionController::Base
  include ActionController::Serialization

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

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end
  
  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      # Season this regexp to taste. I prefer to treat iPad as non-mobile.
      (request.user_agent =~ /Mobile|webOS/)
    end
  end
  helper_method :mobile_device?
  
  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'

    # reduce per-page for mobile devices
    WillPaginate.per_page = 10
  end
end
