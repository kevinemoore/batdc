class AddSchoolIDtoEvents < ActiveRecord::Migration
  def change
    remove_column :events, :school_id, :integer
    add_reference :events, :school, index: true
  end
end
