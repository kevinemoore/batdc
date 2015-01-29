class RenameMembership < ActiveRecord::Migration
  def change
    rename_table :membership, :membership_years
  end
end
