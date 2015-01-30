class MembershipYear < ActiveRecord::Base
  belongs_to :schools

  scope :in_year, -> (year) { where(year: year) }
  scope :current, -> { where("year = YEAR(NOW())") }
end
