class StaleLineItem
  attr_reader :parent_item
  
  def initialize(args)
    @parent_item = args[:parent_item]
  end
  
  def product
    NullProduct.new
  end
  
  def variant
    NullProduct.new
  end
  
  def primary_image(size=nil)
    ActionController::Base.helpers.image_path("fallback/default.png");
  end
  
  def product_or_variant_name
    "The Product or Variant You Added to Your Cart is No Longer Available"
  end
  
  def id
    @parent_item.id || 0
  end
  
  def available_quantity
    0
  end
  
  def subtotal
    Money.new(0)
  end
  
  def shipping_total
    Money.new(0)
  end
  
  def decrement_quantity
    @parent_item.try(:destroy)
  end

end

class NullProduct
  def taken_down?
    true
  end
end