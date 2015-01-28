class Users::RegistrationsController < Devise::RegistrationsController
  #before_filter :check_permissions, :only => [:new, :create, :cancel]
  skip_before_filter :require_no_authentication
  skip_before_filter :require_login
  
  def check_permissions
    authorize! :create, resource
  end

  def access_denied    
  end

end
