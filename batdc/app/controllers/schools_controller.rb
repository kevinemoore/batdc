class SchoolsController < ApplicationController
  load_and_authorize_resource except: [:create]

  before_filter :check_for_mobile, :only => [:index]

  def index
    if params[:members_only] 
      @schools = School.joins(:membership_years).where('membership_years.year' => 2015)
      #@schools = School.all.merge(MembershipYear.in_year(2015))
    else
      @schools = School.all
    end

    if params[:search] and params[:search].length > 0
      @schools = @schools.search(params[:search]) 
    end

    if params[:region] and params[:region].length > 0
      @schools = @schools.region(params[:region])
    end

    @schools = @schools.order(:name)
    @schools = @schools.paginate(page: params[:page])
  end

  def show
    @school.geocode_if_needed
  end

  def new
    @school = School.new
  end
  
  def create
    authorize! :create, School
    @school = School.create(school_params)
    redirect_to @school
  end

  def update
    if @school.update(school_params)
      redirect_to @school
    else
      render 'edit'
    end
  end

  def add_preferred
    c_id = params[:preferred_contact][:contact_id]
    s_id = params[:id]
    pc = PreferredContact.create({school_id: s_id, contact_id: c_id})
    redirect_to edit_school_path(@school)
  end

  def add_membership    
    my = MembershipYear.create(school_id: params[:id], year:
    params[:year] )
    redirect_to edit_school_path(@school)
  end

  def del_membership
    MembershipYear.delete_all(["school_id = ? AND year = ?", params[:id], params[:year]])
    redirect_to edit_school_path(@school)
  end

  private
  def school_params
    params.require(:school).permit(:name, :official_name, :website,
  :office_phone, :fax, :address1, :address2, :city, :state, :zip,
  :country, :notes, :region, :prek, :elementary, :middle, :highschool,
                                   preferred_contacts_attributes: [
  :contact_id, :school_id, :year])
  end

end
