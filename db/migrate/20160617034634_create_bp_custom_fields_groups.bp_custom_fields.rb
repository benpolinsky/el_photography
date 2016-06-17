# This migration comes from bp_custom_fields (originally 20160502045618)
class CreateBpCustomFieldsGroups < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_groups do |t|
      t.integer :group_template_id, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
