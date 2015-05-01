class ListsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index]

  def index
    authorize! :index, Contact
  end

  def membership
    authorize! :membership, School
    
    @membership_years =
    MembershipYear.joins(:school).select("membership_years.year as
    year, schools.region, count(*) as
    count").group('membership_years.year, schools.region').order(year:
    :desc)
  end  


end
