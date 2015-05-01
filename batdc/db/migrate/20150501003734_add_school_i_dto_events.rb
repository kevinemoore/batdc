class AddSchoolIDtoEvents < ActiveRecord::Migration
  def change
     add_column :events, :school_id, :integer
  end
end
