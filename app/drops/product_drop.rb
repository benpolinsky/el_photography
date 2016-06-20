class ProductDrop < Liquid::Rails::Drop
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  attributes :id, :name, :description, :slug, :price, :shipping_base, 
  :additional_shipping_per_item, :small_image_url, :large_image_url
  
  delegate :url_helpers, to: 'Rails.application.routes'
  
  has_many :variants
  
  
  def name_and_link
    link_to name, url_helpers.product_path(id), class: "product-view-name-link"
  end
  
  def image_and_link
    link_to display_full_image, url_helpers.product_path(id)
  end
  
  def display_full_image
    image_tag large_image_url, class: 'grid-item-main-image'
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
  def formatted_price
    price.format
  end
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