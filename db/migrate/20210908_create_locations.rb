class CreateLocations < ActiveRecord::Migration[6.0]
    def change
        create_table :locations do |t|
          t.integer :center_id
          t.string :name
          t.string :address
    
          t.timestamps
        end
      end
end