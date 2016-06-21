class ProductDrop < Liquid::Rails::Drop
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  attributes :id, :name, :description, :slug, :shipping_base, 
  :additional_shipping_per_item, :primary_image, :price,
  :using_inventory, :available_quantity
  
  delegate :url_helpers, to: 'Rails.application.routes'
  
  has_many :variants
  has_many :options
  
  belongs_to :photo
  
  def link
    url_helpers.product_path(id)
  end
  
  def display_price
    if variants.any?
      "From #{formatted_price}"      
    else
      formatted_price
    end
  end

  def name_and_link
    link_to name, url_helpers.product_path(id), class: "product-view-name-link"
  end
  
  def image_and_link
    link_to display_image, url_helpers.product_path(id)
  end
  
  def display_image
    image_tag photo.medium, class: 'grid-item-main-image'
  end
  
  
  def display_full_image
    image_tag photo.image_url, class: 'grid-item-main-image'
  end

  def formatted_price
    price.format
  end
  
  def tester(num)
    return num
  end
  
  def display_quantity
    if using_inventory
      display_remaining_product_count
    end
  end
  
  def display_remaining_product_count
    if varaints.any?
      "Select Variant To View Quantity"
    else
      "#{number_of_products_remaining} available"
    end
  end

  def number_of_products_remaining
    product.available_quantity - cart.number_of_products_inside(product.id, "product")
  end
  

  # def name
  #   product.name
  # end
  #
  # def description
  #   product.description
  # end
  #
  # def variants
  #   # probably a VariantCollectionDrop or Collection Drop
  #   product.variants
  # end
  #
  # def variant_list
  #   product.variants.map(&:name).join(", ")
  # end
  #
  # def slug
  #   product.slug
  # end
  #
  # def price
  #   product.price
  # end
  #

  #
  # def formatted_shipping_base
  #   product.shipping_base.format
  # end
  #
  # def formatted_additional_shipping
  #   product.additional_shipping_per_item.format
  # end
  #
  # def image(size=:medium)
  #   image_tag image_url(size)
  # end
  #
  # def image_url(size=:medium)
  #   product.photo.image_url(size)
  # end
  
  
end

class VariantDrop < ProductDrop
end