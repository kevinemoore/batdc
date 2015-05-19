class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string 'role'
      t.timestamps null: false
    end
  end
end
