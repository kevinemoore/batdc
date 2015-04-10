

class Attendee < ActiveRecord::Base
  belongs_to :event
  belongs_to :contact
  belongs_to :sponsor_school, foreign_key: :sponsor_school_id, class_name: "School"  

  def sort_name
    if contact
      "#{contact.last}, #{contact.first}"
    else
      "CONTACT NOT FOUND"
    end
  end

end
  
