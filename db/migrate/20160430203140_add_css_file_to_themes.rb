class AddCssFileToThemes < ActiveRecord::Migration[5.0]
  def change
    add_column :themes, :css_file, :string
  end
end
