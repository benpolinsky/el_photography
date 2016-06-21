class CartDrop < Liquid::Rails::Drop
  attributes :id
  has_many :line_items
  
end