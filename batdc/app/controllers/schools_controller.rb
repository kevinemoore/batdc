class SchoolsController < ApplicationController
  load_and_authorize_resource except: [:create]

  def index
    if params[:search]
      @schools = School.where("name like ? or official_name like ?",
                              "%#{params[:search]}%", "%#{params[:search]}%").order(:official_name).paginate(page: params[:page], per_page: 25)
    else
      @schools = School.order(:official_name).paginate(page: params[:page], per_page: 25)
    end
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
