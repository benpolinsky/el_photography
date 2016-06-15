class CheckoutView
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper
  attr_accessor :output_buffer
  attr_reader :order, :line_items
  
  def initialize(order)
    @order = order
    @line_items = order.line_items
  end
  
  def estimated_shipping
    content_tag :div, class: 'checkout-order-total' do
      concat content_tag :span, "Estimated Shipping: ", class: "label"
      concat content_tag :span, number_to_currency(calculate_estimated_shipping), class: "value"
    end
  end

  # checkout
  
  def checkout_order_subtotal
    return if line_items.none? # does this imply null object ?
    content_tag :div, class: "checkout-order-subtotal" do
      concat content_tag :p, "<span>Subtotal:</span> <span>#{line_items_subtotal.format}</span>".html_safe 
    end
  end
  
  def checkout_grand_total
    return if line_items.none?
    content_tag :div, class: "checkout-order-subtotal grand-total" do
      concat content_tag :p, "<span>Grand Total: </span> <span class='grand-total'>#{line_items_grand_total.format}</span>".html_safe
    end
  end
  
  def checkout_estimated_shipping
    return if line_items.none?
    content_tag :div, class: "checkout-order-subtotal" do
      concat content_tag :p, "<span>Estimated Shipping: </span> <span>#{display_shipping line_items_shipping_total}</span>".html_safe
    end
  end
  
  def checkout_final_shipping
    return if line_items.none?
    content_tag :div, class: "checkout-order-subtotal" do
      concat content_tag :p, "Shipping: <span>#{display_shipping line_items_shipping_total}</span>".html_safe
    end
  end

  private
  
  def calculate_subtotal
    LineItem.calculate_subtotal(line_items)
  end
  
  def calculate_total_price
    LineItem.calculate_total(line_items)
  end

  
  def calculate_estimated_shipping
    LineItem.calculate_shipping_total(line_items)
  end
  
  def line_items_subtotal
    order.subtotal ? order.subtotal : calculate_subtotal
  end
  
  def line_items_shipping_total
    order.shipping_total ? order.shipping_total : calculate_estimated_shipping
  end
  
  def line_items_grand_total
    order.grand_total ? order.grand_total : calculate_total_price
  end
  
  def display_shipping(price)
    price.cents > 0 ? price.format : "Free"
  end
end
