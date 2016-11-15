class AddTaggedRowOrderToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :tagged_row_order, :integer
  end
end
