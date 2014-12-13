class ContactsController < ApplicationController
  
  #load_resource

  def new

  end

  def create
    @contact = Contact.new(contact_params)
    @contact.save
    redirect_to @contact
  end

  private
  def contact_params
    params.require(:contact).permit(:last, :first, :role, :title, :school, :eventbrite_id, :email_primary, :email_secondary, :notes, :subject_area)
  end

end
