class OptionsProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :options_products, id: false do |t|
      t.belongs_to :option, index: true
      t.belongs_to :product, index: true
    end
  end
end
