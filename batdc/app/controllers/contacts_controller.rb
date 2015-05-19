class ContactsController < ApplicationController
  load_and_authorize_resource except: [:create]
  
  before_filter :check_for_mobile, :only => [:index]

  def index
    if not params.has_key? :at_member
      @contacts = Contact.all
    elsif params[:at_member]
      @contacts = @contacts.at_member
    else
      @contacts = @contacts.at_member
    end

    @contacts = @contacts.status('Active')
    @contacts = @contacts.search(params[:search]) if params[:search]
    @contacts = @contacts.in_region(params[:in_region]) if params[:in_region]
    @contacts = @contacts.at_school(params[:at_school]) if params[:at_school]
    @contacts = @contacts.is_function(params[:is_function]) if
    params[:is_function] 
    @contacts = @contacts.role(params[:role]) if params[:role]
    @contacts = @contacts.teaches(params[:teaches]) if params[:teaches]
    @contacts = @contacts.is_preferred if params[:is_preferred]
    @contacts = @contacts.order(:last, :first)
    
    respond_to do | format |
      format.html { @contacts = @contacts.paginate(:page =>
      params[:page]) }
      format.csv { render csv: @contacts, filename: 'contacts',
      each_serializer: ContactSerializer, only: [ :last, :first,
      :role, :title, :work_phone], add_methods: [:school_name, :email,
      :subject] } 
      format.json { render json: @contacts, each_serializer:
      ContactSerializer }
    end
  end

  def create
    authorize! :create, Contact
    if params[:commit] == "Cancel"
      redirect_to Contact
    else
      @contact = Contact.create(contact_params)
      redirect_to @contact
    end
  end

  def update
    if params[:commit] == "Cancel"
      redirect_to @contact
    else
      if @contact.update(contact_params)
        redirect_to @contact
      else
        render 'edit'
      end
    end
  end

  def email
    @contacts = Contact.all
    @contacts = @contacts.status('Active')
    @contacts = @contacts.search(params[:search]) if params[:search]
    @contacts = @contacts.at_school(params[:at_school]) if
    params[:at_school]
    @contacts = @contacts.role(params[:role]) if params[:role]
    @contacts = @contacts.order(:last, :first)
  end

  def destroy
    if @contact.attendees.length > 0
      flash[:alert] = "Remove event attendance before deleting:
    #{@contact.full_name}"
      redirect_to @contact
    elsif @contact.preferred_contact
      flash[:alert] = "#{@contact.full_name} is a preferred contact at
    #{@contact.preferred_contact.school.name}"
      redirect_to @contact
    else
      @contact.destroy
      flash[:notice] = "Deleted Contact: #{@contact.full_name}"
      redirect_to Contact
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:last, :first, :title, :role, 
  :eventbrite_id, :school_id, :email_primary, :email_secondary,
  :work_phone, :subject_area, :other_subject, :gPK, :gK, :g01, :g02, :g03,
  :g04, :g05, :g06, :g07, :g08, :g09, :g10, :g11, :g12, :notes, :status)
  end

end
