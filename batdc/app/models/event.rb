

class Event < ActiveRecord::Base
  has_many :attendees
  has_many :contacts, through: :attendees
  belongs_to :school

  scope :search, -> (term) {
    t = "%#{term}%"
    pred = "event_name like ?"
    where(pred, t)
  }

  scope :region, -> (region) {
    joins(:school).where('schools.region' => region)
  }

  scope :in_fiscal_year, -> (year) {
    fy_start = "#{year.to_i-1}-07-01".to_date
    fy_end = "#{year}-06-30".to_date
    where("start_date > ? AND start_date <= ?", fy_start, fy_end)
  }

  def attendance
    attendees.count
  end

  def schools_participating
    attendees.select(:sponsor_school_id).uniq.count
  end
  
  def region
    return "" unless school
    abbrev = {
      'Bay Area' => 'SF',
      'Southern California' => 'LA',
      'Other' => 'Other'
    }
    school.region ? abbrev[school.region] : ""
  end
end
