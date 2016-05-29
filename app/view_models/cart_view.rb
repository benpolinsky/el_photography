class CartView
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper
  attr_accessor :output_buffer
  
  def initialize(cart)
    @cart = cart
  end
  
  def estimated_shipping(line_items)
    content_tag :div, class: 'bag-subtotal-slice' do
      concat content_tag :span, "Estimated Shipping", class: "label"
      concat content_tag :span, number_to_currency(calculate_estimated_shipping(line_items)), class: "value"
    end
  end

  # checkout
  
  def checkout_order_subtotal(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :div, class: "checkout-order-subtotal" do
      concat content_tag :p, "Subtotal: <span>#{number_to_currency(line_items_subtotal(line_items))}</span>".html_safe 
    end
  end
  
  def checkout_grand_total(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :p, "Grand total: <span class='grand-total'>#{number_to_currency line_items_grand_total(line_items)} (USD)</span>".html_safe
  end
  
  def checkout_estimated_shipping(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :div, class: "checkout-order-subtotal" do
      content_tag :p, "Estimated Shipping: <span>#{display_shipping line_items_shipping_total(line_items)/100.00}</span>".html_safe
    end
  end
  
  def checkout_final_shipping(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :div, class: "checkout-order-subtotal" do
      content_tag :p, "Shipping: <span>#{display_shipping line_items_shipping_total(line_items)/100.00}</span>".html_safe
    end
  end

  private
  def determine_total_price(line_items)
    LineItem.calculate_total(line_items)/100.00
  end

  
  def calculate_estimated_shipping(line_items)
    LineItem.calculate_shipping_total(line_items)/100.00
  end
  
  def line_items_subtotal(line_items)
    line_items.to_a.sum(&:subtotal)
  end
  
  def line_items_shipping_total(line_items)
    line_items.to_a.sum(&:shipping_total_cents)
  end
  
  def line_items_grand_total(line_items)
    line_items_subtotal(line_items).to_i + line_items_shipping_total(line_items).to_i
  end
  
  def display_shipping(price)
    price > 0 ? number_to_currency(price) : "Free"
  end
end
