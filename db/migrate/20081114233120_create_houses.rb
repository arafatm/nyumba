class CreateHouses < ActiveRecord::Migration
  def self.up
    create_table :houses do |t|
      t.string :mls
      t.string :link
      t.text :address
      t.string :geocode
      t.integer :bedrooms
      t.integer :bathrooms
      t.float :acres
      t.integer :price
      t.integer :taxes
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :houses
  end
end
