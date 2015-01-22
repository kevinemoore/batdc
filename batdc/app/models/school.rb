

class School < ActiveRecord::Base
  has_many :contacts
  has_many :preferred_contacts

  after_validation :geocode
  geocoded_by :full_address

  def preferred_contacts
    Contact.joins(preferred_contact: :school).where('preferred_contacts.school_id = ?', id)
  end
  
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

end
