class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :uid
      t.string :short_uid
      t.datetime :purchased_at
      t.integer :status, default: 0
      t.string :payment_method
      t.datetime :deleted_at
      t.string :payment_provider_key
      t.boolean :live, default: true
      t.string :payment_email
      t.string :slug
      
      # the monies

      t.string :shipping_total
      t.string :grand_total


      t.integer :subtotal_cents
      t.string :subtotal_cents_currency

      t.integer :shipping_total_cents
      t.string :shipping_total_currency

      t.integer :grand_total_cents
      t.string :grand_total_currency
      
      t.timestamps
    end
  end
end
