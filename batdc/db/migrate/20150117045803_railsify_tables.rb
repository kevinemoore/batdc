class RailsifyTables < ActiveRecord::Migration
  def change
    tables = [:events, :membership, :preferred, :attendance]
       
    change_table :events do |t|
      t.rename :last_update, :updated_at
      t.datetime :created_at
    end

    change_table :membership do |t|
      t.rename :last_update, :updated_at
      t.datetime :created_at
    end

    change_table :preferred do |t|
      t.rename :last_update, :updated_at
      t.datetime :created_at
    end
  end
end
