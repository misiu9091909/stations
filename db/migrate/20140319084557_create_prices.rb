class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :fuel_type
      t.float :price
      t.references :station, index: true

      t.timestamps
    end
  end
end
