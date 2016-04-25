class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :caption
      t.string :address
      t.string :slug
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
