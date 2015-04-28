class ListsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index]

  def index
    authorize! :index, Contact
  end  

end
