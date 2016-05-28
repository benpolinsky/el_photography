class CreateOptionValues < ActiveRecord::Migration[5.0]
  def change
    create_table :option_values do |t|
      t.string :value
      t.references :option, foreign_key: true

      t.timestamps
    end
  end
end
