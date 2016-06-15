class CartView
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper
  attr_accessor :output_buffer
  
  def initialize(cart)
    @cart = cart
  end
  
  def estimated_shipping(line_items)
    content_tag :div, class: 'checkout-order-total' do
      concat content_tag :span, "Estimated Shipping", class: "label"
      concat content_tag :span, number_to_currency(calculate_estimated_shipping(line_items)), class: "value"
    end
  end

  # checkout
  
  def checkout_order_subtotal(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :div, class: "cart-subtotal" do
      concat content_tag :p, "<span>Subtotal: </span> <span>#{line_items_subtotal.format}</span>".html_safe 
    end
  end
  
  def checkout_grand_total(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :div, class: "cart-subtotal grand-total" do
      content_tag :p, "<span>Grand total:</span> <span class='grand-total'>#{line_items_grand_total.format}</span>".html_safe
    end
  end
  
  def checkout_estimated_shipping(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :div, class: "cart-subtotal" do
      content_tag :p, "<span>Estimated Shipping: </span> <span>#{display_shipping line_items_shipping_total}</span>".html_safe
    end
  end
  
  def checkout_final_shipping(line_items=@cart.line_items)
    return if line_items.none?
    content_tag :div, class: "cart-subtotal" do
      content_tag :p, "<span>Shipping: </span><span>#{display_shipping line_items_shipping_total}</span>".html_safe
    end
  end

  private
  def determine_total_price(line_items)
    LineItem.calculate_total(line_items)/100.00
  end

  
  def calculate_estimated_shipping(line_items)
    LineItem.calculate_shipping_total(line_items)/100.00
  end
  
  def line_items_subtotal
    @cart.subtotal
  end
  
  def line_items_shipping_total
    @cart.shipping
  end
  
  def line_items_grand_total
    @cart.total
  end
  
  def display_shipping(price)
    price.cents > 0 ? price.format : "Free"
  end
end
