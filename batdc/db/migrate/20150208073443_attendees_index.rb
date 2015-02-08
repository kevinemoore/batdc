class AttendeesIndex < ActiveRecord::Migration
  def change
    add_index :attendees, [:event_id, :contact_id], unique: true
  end
end
