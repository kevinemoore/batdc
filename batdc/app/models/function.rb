# Attributes:
# +role+
class Function < ActiveRecord::Base

  def self.roles_by_function(function)
    roles_lists = {
      'middle_manager' => ['Academic Dean', 
                       'Assistant Head', 
                       'Dean of Faculty',
                       'Dean of Student Life',
                       'Dean of Community/Inclusion',
                       'Dean of Teaching and Learning',
                       'Lower School Division Head',
                       'Middle School Division Head',
                       'Upper School Division Head'
                      ],
      
      'academic_middle_manager' => ['Middle School Division Head',
                                'Upper School Division Head',
                                'Dean of Faculty',
                                'Dean of Teaching and Learning',
                                'Assistant Head']
    }
    return roles_lists[function]
  end

  scope :middle_managers, -> { where role:
    Function.roles_by_function(:middle_manager) }
  
  scope :middle_managers, -> { where role:
    Function.roles_by_function(:academic_middle_manager) }

  
end
