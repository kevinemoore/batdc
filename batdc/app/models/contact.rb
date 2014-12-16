

class Contact < ActiveRecord::Base
  belongs_to :school

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
