class ListsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index]

  def index
    authorize! :index, Contact
  end

  def head_of_school
    authorize! :head_of_school, Contact
    @contacts = Contact.role('Head of School')
  end

  def head_of_school_email
    authorize! :head_of_school, Contact
    @contacts = Contact.role('Head of School')
  end

end
