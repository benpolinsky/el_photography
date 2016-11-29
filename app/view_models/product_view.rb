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
  
  def name
    product.name
  end
  
  def name_and_link
    link_to product.name, url_helpers.product_path(product), class: "product-view-name-link"
  end
  
  def image_and_link(size=nil)
    link_to image(size), url_helpers.product_path(product)
  end
  
  def image(size=nil)
    size ||= :medium
    retina_image_tag product.photo.image, size, class: 'grid-item-main-image'
  end
  
  def price
    if product_has_variants?
      content_tag :span, "From #{product.least_expensive_variant.price.format}", class: "product-view-price", 
      data: {price: "From #{product.least_expensive_variant.price.format}"}     
    else
      content_tag :span, product.price.format, class: "product-view-price"
    end
  end
  
  def description
    content_tag :div, product.description.try(:html_safe), class: 'product-view-description'
  end
  
  def display_quantity
    if product.using_inventory? || product_has_variants?
      content_tag :div, class: 'item-quantity-left' do
        display_remaining_product_count
      end
    end
  end
  
  def display_remaining_product_count
    # if there are variants, we'll manage the view with js
    # when the user makes a selectionxc
    if product_has_variants?
      content_tag :span, "", class: "quantity"
    else
      concat content_tag :span, number_of_remaining_products, class: "quantity"
      concat content_tag :span, " Available", class: "left"
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
  
  def retina_image_tag(uploader, version, options={})
    options.symbolize_keys!
    options[:srcset] ||=  (2..3).map do |multiplier|
                            name = "#{version}_#{multiplier}x"
                            if uploader.try(:version_exists?, name) &&
                              source = uploader.url(name).presence
                              "#{source} #{multiplier}x"
                            else
                              nil
                            end
                          end.compact.join(', ')

    image_url = uploader.try(:url) ? uploader.url(version) : uploader
    image_tag(image_url, options)
  end
end