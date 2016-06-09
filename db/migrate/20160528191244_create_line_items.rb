class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.references :itemized, polymorphic: true, index: true
      t.references :product
      t.string :product_type
      t.integer :quantity, default: 0
      t.string :name
      t.string :uid
      
      t.integer :price_cents
      t.string :price_cents_currency

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
