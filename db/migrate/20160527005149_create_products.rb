class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price_cents
      t.string :price_cents_currency
      t.datetime :published_at
      t.integer :quantity
      t.integer :weight_in_oz
      t.integer :row_order
      t.references :photo, foreign_key: true
      t.boolean :using_inventory, default: :false
      # money fields:
      
      t.integer :shipping_base_cents
      t.string :shipping_base_currency
      
      t.integer :additional_shipping_per_item_cents
      t.string :additional_shipping_per_item_currency
      
      t.integer :international_shipping_base_cents
      t.string :international_shipping_base_currency
      
      t.integer :additional_international_shipping_per_item_cents
      t.string :additional_international_shipping_per_item_currency      

      t.string :slug
      t.integer :state
      t.datetime :deleted_at
      t.string :uid
      
      t.boolean :taken_down

      t.timestamps
    end
  end
end