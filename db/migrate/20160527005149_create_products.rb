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
      t.integer :shipping_cents
      t.string :shipping_currency
      t.string :slug
      t.integer :state
      t.datetime :deleted_at
      t.string :uid
      t.integer :international_shipping_cents
      t.string :international_shipping_currency

      t.timestamps
    end
  end
end
