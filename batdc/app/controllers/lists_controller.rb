class ListsController < ApplicationController
  before_filter :check_for_mobile, :only => [:index]

  def index
    authorize! :index, Contact

    @teacher_lists = { 
      'Teaches K-3' =>  ['gk', 'g01', 'g02', 'g03'],
      'Teaches 4-6' =>  ['g04', 'g05', 'g06'],
      'Teaches 6-8' =>  ['g06', 'g07', 'g08'],
      'Teaches 9-12' =>  ['g09', 'g10', 'g11', 'g12'],
    }
  end

  def csv_summary(myears)
    CSV.generate do |csv|
      table = {}
      2015.downto(2000).each do |y|
        table[y] = {}
      end
      
      myears.each do |m|
        table[m.year][m.region] = m.count
      end
      
      csv << ['Year', 'Total', 'Bay Area', 'Southern California', 'Other']
      table.each do |y, h|
        total = 0
        h.each { |r, c| total = total + c }
        csv << [y, total, h['Bay Area'], h['Southern California'],
                h['Other']]
      end
    end
  end

  def membership
    authorize! :index, School
    
    @membership_years =
    MembershipYear.joins(:school).select("membership_years.year as
    year, schools.region, count(*) as
    count").group('membership_years.year, schools.region').order(year:
    :desc)

    respond_to do | format |
      format.html {}
      format.csv {
        send_data csv_summary(@membership_years)
      }
    end
  end  


end
