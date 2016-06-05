class LineItem < ApplicationRecord
  attr_reader :shipping_calculator, :order
  
  belongs_to :product
  belongs_to :variant
  
  belongs_to :itemized, polymorphic: true
  
  monetize :price_cents, allow_nil: 'true'
  monetize :shipping_base_cents, allow_nil: 'true'
  monetize :international_shipping_base_cents, allow_nil: 'true'
  monetize :additional_shipping_per_item_cents, allow_nil: 'true'
  monetize :additional_international_shipping_per_item_cents, allow_nil: 'true'
  
  monetize :subtotal_cents
  monetize :total_cents
  monetize :shipping_total_cents
  # TODO: Custom validation, some of the money fields can be blank, but obviously not all of them.
  
  
  # I guess there's a good case for not calling a line item to get the shipping calculator
  # but rather to call the shipping caluclator directly.  For now, however
  # TODO: Externalize ShippingCalculator
  def shipping_calculator(destination)
    @shipping_caluclator ||= ShippingCalculator.new(order, "US", destination)
  end
  
  def order
    @order ||= nil
  end
  
  def subtotal_cents
    price_cents.to_i * quantity.to_i
  end
  
  def total_cents
    subtotal_cents.to_i + shipping_total_cents
  end

  def shipping_with_additional
    if additional_shipping_per_item == 0 || additional_shipping_per_item.nil? || quantity <= 1
      shipping_base.present? ? shipping_base * quantity.to_i : 0
    else
      shipping_base + ((quantity.to_i - 1) * additional_shipping_per_item)
    end
  end


  def shipping_total_cents
    destination = itemized.try(:shipping_address).try(:country) ? itemized.shipping_address.country : "US"
    calculator = shipping_calculator(destination)
    calculator.determine_shipping_cost(self).to_f > 0 ? calculator.determine_shipping_cost(self).cents : 0
  end
  


  def self.calculate_total(items)
    self.calculate_subtotal(items).cents + self.calculate_shipping_total(items)
  end

  def self.calculate_subtotal(items)
    items.to_a.sum(&:subtotal)
  end
  
  def self.calculate_shipping_total(items)
    items.to_a.sum(&:shipping_total_cents)
  end
  
  def able_to_increment?(cart)
    true # for now we aren't using stock... I should make this an option when I gemify
  end
  
  def available_quantity
    product_or_variant.available_quantity
  end
  
  def decrement_quantity
    if self.quantity <= 1
      self.quantity = 0
      self.destroy
    else
      self.quantity -= 1
    end
  end

  def increment_quantity
    self.quantity += 1 unless self.destroyed?
  end
  
  def variant?
    !!(product_type == 'variant')
  end

  def product?
    !!(product_type == 'product')
  end
  
  def product_or_variant
    variant? ? variant : product
  end
  
  def product_or_variant_name
    if variant?
      variant.name_with_product
    else
      product.name
    end
  end

  def product_solo?
    product_or_variant.only_one?
  end
  
  def subtotal_from(given_quantity)
    price * given_quantity
  end
  
  def store_product(product)
    self.product_id = product.id
    self.product_type = "product"
  end

  
end
