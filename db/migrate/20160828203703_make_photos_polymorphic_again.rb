class MakePhotosPolymorphicAgain < ActiveRecord::Migration[5.0]
  def up
    remove_column :products, :photo_id
    add_column :photos, :photoable_type, :string
    add_column :photos, :photoable_id, :integer
    add_index :photos, [:photoable_type, :photoable_id]
  end
  
  def down
    remove_column :photos, :photoable_id
    remove_column :photos, :photoable_type
    add_column :products, :photo_id, :integer
  end
end
