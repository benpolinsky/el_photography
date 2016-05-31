class ShippingCalculator
  attr_reader :final_total
  attr_accessor :source_country, :destination_country, :line_items
  
  def initialize(order, source=nil, destination=nil)
    if order
      @source_country ||= order.try(:seller).try(:shop).try(:address) ? order.shop.address.country : "US"
      @destination_country ||= order.shipping_address.present? ? order.shipping_address.country : "US"
      @line_items ||= order.line_items
    else
      @source_country = source
      @destination_country = destination
    end
  end
  
  def update(order)
    @source_country = order.shop.address.country
    @destination_country = order.shipping_address.present? ? order.shipping_address.country : "US"
    @line_items = order.line_items
  end
  
  def international?
    @source_country != @destination_country
  end
  
  def domestic?
    @source_country == @destination_country
  end
  
  def total_shipping
    @line_items.to_a.sum do |line_item|
      determine_shipping_cost(line_item)
    end
  end
  
  def determine_shipping_cost(line_item)
    if additional?(line_item)
      domestic? ? additional_shipping_cost(line_item) : international_additional_shipping_cost(line_item)
    else
      domestic? ? shipping_cost(line_item) : international_shipping_cost(line_item)
    end
  end
  
  def additional?(line_item)
    if domestic?
      line_item.quantity.to_i > 1 &&
      line_item.additional_shipping_per_item.present? &&
      line_item.additional_shipping_per_item_cents > 0
    else
      # probably default to domestic if international isn't set
      line_item.quantity.to_i > 1 &&
      line_item.additional_international_shipping.present? &&
      line_item.additional_international_shipping_per_item_cents > 0
    end
  end
  
  
  def shipping_cost(line_item)
    line_item.shipping_base.present? ? line_item.shipping_base * line_item.quantity.to_i : 0
  end
  
  def additional_shipping_cost(line_item)
    line_item.shipping_base + ((line_item.quantity.to_i - 1) * line_item.additional_shipping_per_item.to_i)
  end
  
  def international_shipping_cost(line_item)
    (line_item.international_shipping_base.present? && line_item.international_shipping_base > 0) ? line_item.international_shipping_base * line_item.quantity.to_i : shipping_cost(line_item)
  end
  
  def international_additional_shipping_cost(line_item)
    line_item.international_shipping_base + ((line_item.quantity.to_i - 1) * line_item.additional_international_shipping_per_item)    
  end
  
end
