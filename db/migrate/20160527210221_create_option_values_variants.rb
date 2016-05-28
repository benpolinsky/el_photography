class CreateOptionValuesVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :option_values_variants, id: false do |t|
      t.belongs_to :option_value, index: true
      t.belongs_to :variant, index: true
    end
  end
end
