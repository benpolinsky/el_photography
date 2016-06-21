class BpCustomFields::FieldDrop < Liquid::Rails::Drop
  attributes :id, :value
  
  belongs_to :group, class_name: "BpCustomFields::GroupDrop"
end