class SchoolsController < ApplicationController
  load_and_authorize_resource except: [:create]

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

    @schools = @schools.order(:official_name)
    @schools = @schools.paginate(page: params[:page], per_page: 25)
  end

  def show
    @school.geocode_if_needed
  end

  def create
    @school = School.new(school_params)
    @school.save
    redirect_to @school
  end

  def update
    if @school.update(school_params)
      redirect_to @school
    else
      render 'edit'
    end
  end

  private
  def school_params
    params.require(:school).permit(:name, :official_name, :website,
  :office_phone, :fax, :address1, :address2, :city, :state, :zip,
  :country, :notes, :region, :prek, :elementary, :middle, :highschool)
  end

end
