class RenameAttendance < ActiveRecord::Migration
  def change
    change_table :attendance do |t|
      t.rename :last_update, :updated_at
      t.datetime :created_at
      t.change :sponsor_school, :integer
      t.rename :sponsor_school, :sponsor_school_id
    end
    rename_table :attendance, :attendees
  end
end
