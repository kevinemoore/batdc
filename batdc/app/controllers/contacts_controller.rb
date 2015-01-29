class ContactsController < ApplicationController
  load_and_authorize_resource except: [:create]
  
  def index
    @contacts = Contact.status('Active')
    @contacts = @contacts.search(params[:search]) if params[:search]
    @contacts = @contacts.at_school(params[:at_school])
    @contacts = @contacts.order(:last, :first)
    @contacts = @contacts.paginate(:page => params[:page], :per_page => 25)
  end

  def create
    @contact = Contact.create(contact_params)
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
    params.require(:contact).permit(:last, :first, :title, :role, 
  :eventbrite_id, :school_id, :email_primary, :email_secondary,
  :work_phone, :subject_area, :other_subject, :gPK, :gK, :g01, :g02, :g03,
  :g04, :g05, :g06, :g07, :g08, :g09, :g10, :g11, :g12, :notes)
  end

end
