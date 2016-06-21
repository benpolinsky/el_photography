class OptionValueDrop < Liquid::Rails::Drop
  attributes :id, :value
  belongs_to :option
  
  
end