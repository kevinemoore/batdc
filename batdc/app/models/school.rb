

class School < ActiveRecord::Base
  has_many :contacts
  has_many :preferred_contacts

  def preferred_contacts
    Contact.joins(preferred_contact: :school)
  end
  
end
