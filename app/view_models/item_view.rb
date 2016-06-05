class ItemView
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::AssetTagHelper
  attr_accessor :output_buffer
  attr_reader :item
  delegate :url_helpers, to: 'Rails.application.routes'
  
  def initialize(item)
    @item = item
  end
  
  def thumb_image
    # NULL OBJECT PATTERN!
    image_tag(item.primary_image(:thumb), class: "item-image")
  end
  
  def name_and_link
    content_tag :span, class: 'item-name' do
      link_to item.product_or_variant_name, url_helpers.product_path(item.product)
    end
  end

  
  def alert(kind, message)
    content_tag :div, message, class: "#{kind} alert"
  end
  
  
  # This could use a lil work
  def manage_quantities
    quantity do
      if item.quantity.to_i > 1
        concat link_to '-', url_helpers.decrease_item_quantity_cart_path(item), {method: :PUT, class: "decrement-quantity", data: {remote: true}}
        concat content_tag :span, item.quantity, id: "cart-item-#{item.id}", class: "quantity"
        concat link_to '+', url_helpers.increase_item_quantity_cart_path(item), {method: :PUT, class: "increment-quantity", data: {remote: true}}
        concat spinner
      else
        item.quantity.to_i == 1
        remove
        alert('taken-down', "Sorry, this product has been taken down") if item.product.taken_down?
      end
    end
  end
  
  def quantity(&block)
    content_tag :div, class: 'quantity-manager', data: {url: url_helpers.change_item_quantity_cart_path, id: item.id} do
      yield
    end
  end

  def display_quantity
    content_tag :span, "Quantity: #{item.quantity}", class: "quantity"
  end
  
  def remove
    content_tag :span, "Remove", class: "decrement-quantity"
  end
  
  def subtotal
    content_tag :div, class: "item-price-total" do
      content_tag :span, 'Price', class: "label"
      content_tag :span, item.subtotal.format, class: "value"
    end
  end
  
  def estimated_shipping
    content_tag :div, class: "item-price-total" do
      content_tag :span, 'Estimated Shipping', class: "label"
      content_tag :span, item.shipping_total.format, class: "value"
    end
  end
  
  def spinner
    content_tag :div, class: "quantity-spinner" do
      content_tag :i, '', class: "fa fa-spinner fa-spin"
    end
  end
  
  private
  
  def taken_down_quantity
  end
  
  
  
end