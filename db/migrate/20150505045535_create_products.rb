class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :category
      t.string :product_name
      t.integer :price
      t.string :active

      t.timestamps
    end
  end
end
