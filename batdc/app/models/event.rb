

class Event < ActiveRecord::Base
  has_many :attendees
  has_many :contacts, through: :attendees
end
