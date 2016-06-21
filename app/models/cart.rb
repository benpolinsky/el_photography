class Cart < ApplicationRecord
  include Liquid::Rails::Droppable
  has_many :line_items, as: :itemized, dependent: :delete_all
  enum status: [:empty, :has_items, :in_line]

  monetize :subtotal_cents
  monetize :shipping_cents
  monetize :total_cents
  
  def add_cart_item(product_id, product_type)
    if current_item = line_items.find_by(product_id: product_id, product_type: product_type)
      if current_item.able_to_increment?(self)
        current_item.quantity += 1
        self.has_items!
      end
    else
      # TODO: Dependency Injection
      product = product_type == "variant" ? Variant.find(product_id) : Product.find(product_id)  
      current_item = line_items.build({
        product_id:                                            product.id,
        name:                                                  product.name,
        product_type:                                          product_type,
        price_cents:                                           product.price_cents,
        shipping_base_cents:                                   product.shipping_base_cents,
        additional_shipping_per_item_cents:                    product.additional_shipping_per_item_cents,
        international_shipping_base_cents:                     product.international_shipping_base_cents,
        additional_international_shipping_per_item_cents:      product.additional_international_shipping_per_item_cents,
        quantity:                                              1   
        })

      self.has_items!
    end
    current_item
  end
  
  def empty_contents
    line_items.delete_all
    empty!
  end
  
  def number_of_items
    line_items.to_a.sum{|item| item.quantity.to_i}
  end
  
  def has_product(product_id, product_type="product")
    !!(line_items.find_by(product_id: product_id, product_type: product_type))
  end
  
  def number_of_products_inside(product_id, product_type="product")
    line_items.find_by(product_id: product_id, product_type: product_type).try(:quantity).to_i
  end
  
  def subtotal_cents
    line_items.to_a.sum(&:subtotal_cents)
  end

  def shipping_cents
    line_items.to_a.sum(&:shipping_total_cents)
  end

  def total_cents
    line_items.to_a.sum(&:total_cents)
  end
end
