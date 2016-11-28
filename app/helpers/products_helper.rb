module ProductsHelper
  def list_variants_by_keys(product, cart)
    options_for_select(product.variants.with_quantity.map do |variant|
      [
        variant.name, variant.id, {
        'data-unique-key' => variant.unique_key, 
        'data-quantity' => variant.available_quantity - cart.number_of_products_inside(variant.id, 'variant'),
        'data-price' => variant.price.format,
        'data-image' => "#{retina_image_tag(variant.photo.image, :main)}"
        }
      ]
    end
    )
  end
end
