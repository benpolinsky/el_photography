class ProductView
  attr_reader :product, :cart
  
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::AssetTagHelper
  attr_accessor :output_buffer
  delegate :url_helpers, to: 'Rails.application.routes'
    
  def initialize(args)
    @product = args[:product]
    @cart = args[:cart]
    if block_given?
      yield
    end
  end
  
  def name_and_link
    link_to product.name, url_helpers.product_path(product), class: "product-view-name-link"
  end
  
  def image_and_link(size=nil)
    link_to image(size), url_helpers.product_path(product)
  end
  
  def image(size=nil)
    if size == "full"
      image_tag product.primary_image, class: 'grid-item-main-image'
    elsif size
      image_tag product.primary_image(size.to_sym), class: 'grid-item-main-image'
    else
      image_tag product.primary_image(:medium), class: 'grid-item-main-image'
    end
  end
  
  def price
    if product_has_variants?
      content_tag :span, "From #{product.price.format}", class: "product-view-price"      
    else
      content_tag :span, product.price.format, class: "product-view-price"
    end
  end
  
  def description
    content_tag :div, product.description.html_safe, class: 'product-view-description'
  end
  
  def display_quantity
    if product.using_inventory?
      content_tag :div, class: 'item-quantity-left' do
        concat display_remaining_product_count
      end
    end
  end
  
  def display_remaining_product_count
    if product_has_variants?
      content_tag :span, "Select Variant to View Quantity", class: "quantity"
    else
      content_tag :span, number_of_remaining_products, class: "quantity"
      content_tag :span, " Available", class: "left"
    end
  end
  
  def published?
    if product.published?
      content_tag :span, "Published", class: 'published'
    else
      content_tag :span, "Unpublished", class: 'unpublished'
    end
  end
  
  private
  
  def product_has_variants?
    product.try(:variants).try(:any?)
  end
  
  def number_of_remaining_products
    product.available_quantity - cart.number_of_products_inside(product.id, "product")
  end
end