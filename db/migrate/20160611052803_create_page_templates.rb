class CreatePageTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :page_templates do |t|
      t.text :body
      t.boolean :active
      t.string :title
      t.string :page
      t.string :slug
      t.integer :row_order

      t.timestamps
    end
  end
end
