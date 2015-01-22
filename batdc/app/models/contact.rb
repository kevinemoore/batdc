

class Contact < ActiveRecord::Base
  belongs_to :school
  has_one :preferred_contact
  has_many :attendees
 
  def full_name
    fn = "#{self.first} #{self.last}"
  end

  def grade_field_label(f)
    labels = {}
    labels[:gPK] = "Pre K"
    labels[:gK] = "Kindergarden"
    labels[:g01] = "Grade 1"
    labels[:g02] = "Grade 2"
    labels[:g03] = "Grade 3"
    labels[:g04] = "Grade 4"
    labels[:g05] = "Grade 5"
    labels[:g06] = "Grade 6"
    labels[:g07] = "Grade 7"
    labels[:g08] = "Grade 8"
    labels[:g09] = "Grade 9"
    labels[:g10] = "Grade 10"
    labels[:g11] = "Grade 11"
    labels[:g12] = "Grade 12"

    labels[f]
  end

  def grades_taught
    grades = []
    grades << "Pre K" if self.gPK
    grades << "Kindergarden" if self.gK
    grades << "Grade 1" if self.g01
    grades << "Grade 2" if self.g02
    grades << "Grade 3" if self.g03
    grades << "Grade 4" if self.g04
    grades << "Grade 5" if self.g05
    grades << "Grade 6" if self.g06
    grades << "Grade 7" if self.g07
    grades << "Grade 8" if self.g08
    grades << "Grade 9" if self.g09
    grades << "Grade 10" if self.g10
    grades << "Grade 11" if self.g11
    grades << "Grade 12" if self.g12
    grades
  end
end
