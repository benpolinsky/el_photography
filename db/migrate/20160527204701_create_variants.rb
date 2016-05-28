class CreateVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :variants do |t|
      t.integer :price_cents
      t.string :price_cents_currency
      t.string :sku
      t.integer :quantity
      t.integer :weight_in_oz
      t.integer :row_order
      t.string :slug
      t.boolean :published
      t.string :state
      t.string :uid
      t.datetime :deleted_at
      t.references :product
      
      t.integer :shipping_base_cents
      t.string :shipping_base_currency
      
      t.integer :additional_shipping_per_item_cents
      t.string :additional_shipping_per_item_currency
      
      t.integer :international_shipping_base_cents
      t.string :international_shipping_base_currency
      
      t.integer :additional_international_shipping_per_item_cents
      t.string :additional_international_shipping_per_item_currency      

      t.timestamps
    end
  end
end
