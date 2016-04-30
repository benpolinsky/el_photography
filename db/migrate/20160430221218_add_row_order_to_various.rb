class AddRowOrderToVarious < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :row_order, :integer
    add_column :photos, :row_order, :integer
    add_column :videos, :row_order, :integer
  end
end
