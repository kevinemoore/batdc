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
    params.require(:contact).permit(:last, :first, :role, :title,
  :school, :eventbrite_id, :email_primary, :email_secondary,
  :work_phone, :notes, :subject_area, :gPK, :gK, :g01, :g02, :g03,
  :g04, :g05, :g06, :g07, :g08, :g09, :g10, :g11, :g12)
  end

end
