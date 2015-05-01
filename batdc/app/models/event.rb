

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

end
