class ItemView
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::AssetTagHelper
  attr_accessor :output_buffer
  delegate :url_helpers, to: 'Rails.application.routes'
  
  def initialize(item)
    @item = item
  end
  
  def thumb_image
    image_tag(@item.product.primary_image.url(:thumb), class: "item-image") if @item.product.primary_image
  end
  
  def name_and_link
    content_tag :span, class: 'item-name' do
      link_to @item.product_or_variant_name, url_helpers.product_path(@item.product)
    end
  end

  
  def alert(kind, message)
    content_tag :div, message, class: "#{kind} alert"
  end
  
  
  # This could use a lil work:
  def manage_quantities
    quantity do
      if @item.product.taken_down?
        remove
        alert('taken-down', "Sorry, this product has been taken down")
      elsif @item.quantity.to_i > 0 && @item.product_solo?
        remove
      elsif @item.quantity.to_i > 0
        concat content_tag :span, '-', class: "decrement-quantity"
        concat content_tag :span, @item.quantity, id: "cart-item-#{@item.id}", class: "quantity"
        concat content_tag :span, '+', class: "increment-quantity"
        concat spinner
      else
        remove
        alert('none-left', 'Oh No!  Someone beat you to it and bought this item while you shopped.')
      end
    end
  end
  
  def quantity(&block)
    content_tag :div, class: 'quantity-manager', data: {url: url_helpers.change_item_quantity_cart_path, id: @item.id} do
      yield
    end
  end

  def display_quantity
    content_tag :span, "Quantity: #{@item.quantity}", class: "quantity"
  end
  
  def remove
    content_tag :span, "Remove", class: "decrement-quantity"
  end
  
  def subtotal
    content_tag :div, class: "item-price-total" do
      content_tag :span, 'Price', class: "label"
      content_tag :span, @item.subtotal.format, class: "value"
    end
  end
  
  def estimated_shipping
    content_tag :div, class: "item-price-total" do
      content_tag :span, 'Estimated Shipping', class: "label"
      content_tag :span, @item.shipping_base.try(:format), class: "value"
    end
  end
  
  def spinner
    content_tag :div, class: "quantity-spinner" do
      content_tag :i, '', class: "fa fa-spinner fa-spin"
    end
  end
end