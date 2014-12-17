class ContactsController < ApplicationController
  load_resource
  
  def index
    @contacts = Contact.order(:last, :first).paginate(:page => params[:page], :per_page =>
  25)
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.save
    redirect_to @contact
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact
    else
      render 'edit'
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:last, :first, :role, :title,
  :school_id, :eventbrite_id, :email_primary, :email_secondary,
  :work_phone, :notes, :subject_area, :gPK, :gK, :g01, :g02, :g03,
  :g04, :g05, :g06, :g07, :g08, :g09, :g10, :g11, :g12)
  end

end
