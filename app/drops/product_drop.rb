class ProductDrop < Liquid::Drop
  include ActionView::Helpers::AssetTagHelper
  attr_reader :product
  
  def initialize(product)
    @product = product
  end
  
  def name
    product.name
  end
  
  def description
    product.description
  end
  
  def variants
    # probably a VariantCollectionDrop or Collection Drop
    product.variants
  end
  
  def variant_list
    product.variants.map(&:name).join(", ")
  end
  
  def slug
    product.slug
  end
  
  def price
    product.price 
  end
  
  def formatted_price
    product.price.format
  end
  
  def formatted_shipping_base
    product.shipping_base.format
  end
  
  def formatted_additional_shipping
    product.additional_shipping_per_item.format
  end
  
  def image(size=:medium)
    image_tag image_url(size)
  end
  
  def image_url(size=:medium)
    product.photo.image_url(size)
  end
end