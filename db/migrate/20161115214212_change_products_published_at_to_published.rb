class ChangeProductsPublishedAtToPublished < ActiveRecord::Migration[5.0]
  def up
    remove_column :products, :published_at
    add_column :products, :published, :boolean, default: false
  end
  
  def down
    remove_column :products, :published 
    add_column :products, :published_at, :datetime
  end
end
