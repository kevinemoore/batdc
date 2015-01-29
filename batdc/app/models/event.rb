

class Event < ActiveRecord::Base
  has_many :attendees
  has_many :contacts, through: :attendees

  scope :search, -> (term) {
    t = "%#{term}%"
    pred = "event_name like ?"
    where(pred, t)
  }

end
