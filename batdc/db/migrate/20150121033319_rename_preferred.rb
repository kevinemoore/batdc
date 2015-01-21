class RenamePreferred < ActiveRecord::Migration
  def change
    rename_table :preferred, :preferred_contacts
  end
end
