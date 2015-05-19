

class School < ActiveRecord::Base
  has_many :contacts
  has_many :preferred_contacts
  has_many :membership_years
  has_many :attendees, foreign_key: :sponsor_school_id
  has_many :events, through: :attendees
  has_many :event_venues, :class_name => 'Event', :foreign_key => 'school_id'

  after_validation :geocode
  geocoded_by :full_address

  scope :search, -> (term) { 
    t = "%#{term}%"
    pred = "name like ? "
    pred += "or official_name like ? "
    where(pred, t, t)
  }

  scope :region, -> (region) { where(region: region) }

  scope :member_in, -> (year) {
    where id: MembershipYear.in_year(year).select(:school_id)
  }
  
  scope :current_member, -> {
    where id: MembershipYear.current.select(:school_id)
  }

  scope :non_member, -> {
    where.not id: MembershipYear.current.select(:school_id)
  }

  def full_address(commas=true)
    addr = "#{address1} #{address2}, #{city}, #{state}"
  end

  def map_link
    link_base = "https://www.google.com/maps/place/"
   
    addr_comps = full_address.split
    url = "#{link_base}#{addr_comps.join('+')}"
  end
  
  def geocode_if_needed
    geocode if latitude == nil
  end

  def sent_to_events
    self.attendees.includes(:contact).includes(:event).order("contacts.last, contacts.first")
  end

end
