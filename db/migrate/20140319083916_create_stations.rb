class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.float :longitude
      t.float :latitude
      t.references :brand, index: true

      t.timestamps
    end
  end
end
