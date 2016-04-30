class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.text :css
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
