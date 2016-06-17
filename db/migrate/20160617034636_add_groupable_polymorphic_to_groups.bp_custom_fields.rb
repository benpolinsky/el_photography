# This migration comes from bp_custom_fields (originally 20160502173535)
class AddGroupablePolymorphicToGroups < ActiveRecord::Migration
  def change
    add_reference :bp_custom_fields_groups, :groupable, polymorphic: true
  end
end
