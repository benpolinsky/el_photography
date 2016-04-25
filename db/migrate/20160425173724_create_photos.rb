class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :caption
      t.string :image
      t.string :slug
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
