class LineItemDrop < Liquid::Rails::Drop
  attributes :id, :name, :price, :shipping_base, :primary_image
  belongs_to :cart
end