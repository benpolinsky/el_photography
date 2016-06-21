class BpCustomFields::GroupDrop < Liquid::Rails::Drop
  attributes :id, :name
  
  has_many :fields
end