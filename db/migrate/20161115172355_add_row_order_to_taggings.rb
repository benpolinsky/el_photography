class AddRowOrderToTaggings < ActiveRecord::Migration[5.0]
  def change
    add_column :taggings, :row_order, :integer, default: 0
  end
end
