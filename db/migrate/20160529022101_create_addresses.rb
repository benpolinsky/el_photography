class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.references :order
      t.string :first_name
      t.string :last_name
      t.string :street_line_1
      t.string :street_line_2
      t.string :street_line_3
      t.string :country
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :kind
      t.string :phone_number
      t.integer :row_order

      t.timestamps
    end
  end
end
